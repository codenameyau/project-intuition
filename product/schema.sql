-- Dear You data model sketch (Postgres 16 + pgvector). Row-level security on user_id for every tenant table.

create extension if not exists vector;
create extension if not exists pgcrypto;

create table users (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  display_name text,
  created_at timestamptz not null default now(),
  settings jsonb not null default '{}'   -- auto_accept_threshold, locale, etc.
);

create table people (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  full_name text not null,
  relationship text,                     -- partner, friend, parent, colleague...
  how_met text,
  date_of_birth date,
  is_self boolean not null default false, -- the user's own profile row
  is_minor boolean not null default false,
  sensitive_inference_enabled boolean not null default false,
  created_at timestamptz not null default now(),
  deleted_at timestamptz
);

-- One row per (person, field_path, version). field_path mirrors framework/person-schema.yaml, e.g. 'personality.big_five.neuroticism'.
create table attributes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  person_id uuid not null references people(id) on delete cascade,
  field_path text not null,
  value jsonb not null,
  confidence real check (confidence between 0 and 1),
  source_type text not null check (source_type in ('user','subject','note_inference','import','clip','capture','model_prediction')),
  source_id uuid,
  status text not null check (status in ('proposed','accepted','rejected')) default 'proposed',
  is_sensitive boolean not null default false,   -- orientation, politics, religion, race/ethnicity, health; never model-inferred
  evidence_span text,
  layer text check (layer in ('L0','L1','L2','L3','L4','L5','L6')),
  created_at timestamptz not null default now(),
  decided_at timestamptz
);
create index on attributes (person_id, field_path, status, created_at desc);

create table notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  person_id uuid not null references people(id) on delete cascade,
  body text not null,
  noted_on date not null,
  source_type text not null check (source_type in ('user','import','clip','capture','subject')) default 'user',
  author_is_person boolean,              -- for conversation messages: true if the Person wrote it, false if the user did
  source_ref text,                        -- import file id or clipped URL
  version_of uuid references notes(id),
  created_at timestamptz not null default now()
);

create table note_chunks (
  id uuid primary key default gen_random_uuid(),
  note_id uuid not null references notes(id) on delete cascade,
  user_id uuid not null references users(id) on delete cascade,
  person_id uuid not null references people(id) on delete cascade,
  chunk_index int not null,
  text text not null,
  embedding vector(1024)
);
create index on note_chunks using hnsw (embedding vector_cosine_ops);

create table experiences (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  person_id uuid not null references people(id) on delete cascade,
  description text not null,
  occurred_on date,
  valence real check (valence between -1 and 1),
  domain text,                            -- family, work, health, relationship, food, travel...
  schema_target text,                     -- history.formative_events | history.habits | history.cue_history | relations.actors
  present_people uuid[],
  source_note_id uuid references notes(id),
  status text not null check (status in ('proposed','accepted','rejected')) default 'proposed',
  created_at timestamptz not null default now()
);

create table media (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  person_id uuid not null references people(id) on delete cascade,
  note_id uuid references notes(id) on delete set null,
  experience_id uuid references experiences(id) on delete set null,
  object_key text not null,               -- encrypted blob in object storage
  mime text not null,
  caption text,
  scene_description text,                 -- model-written, scene only; no face processing
  taken_on date,
  created_at timestamptz not null default now()
);

create table imports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  person_id uuid references people(id) on delete cascade,
  kind text not null check (kind in ('chat_export','instagram_export','whatsapp_export','messenger_export','email_mbox','calendar_ics','subject_export')),
  person_handle text,                     -- handle used to select the one thread with this Person; other threads discarded unread
  object_key text not null,
  status text not null default 'queued',
  created_at timestamptz not null default now()
);

-- Cached summary card per person; regenerated by 'Make predictions'. Each field records its provenance badge.
create table summaries (
  person_id uuid primary key references people(id) on delete cascade,
  user_id uuid not null references users(id) on delete cascade,
  personality jsonb not null default '{}',   -- {field_path: {value, badge, confidence, source_id}}
  aptitudes jsonb not null default '{}',
  profession jsonb not null default '{}',
  narrative text,
  predicted_count int not null default 0,
  shown_count int not null default 0,
  profile_coverage real,
  model_version text,
  generated_at timestamptz not null default now()
);

-- Dismissed predictions are not re-proposed for 90 days.
create table prediction_dismissals (
  user_id uuid not null references users(id) on delete cascade,
  person_id uuid not null references people(id) on delete cascade,
  field_path text not null,
  value_hash text not null,
  dismissed_at timestamptz not null default now(),
  primary key (person_id, field_path, value_hash)
);

create table questions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  person_id uuid not null references people(id) on delete cascade,
  prompt text not null,
  qtype text not null check (qtype in ('binary','classification','freeform')),
  profile_snapshot jsonb not null,        -- what the model actually saw
  answer jsonb not null,                  -- framework/output-schema.json instance
  model_version text not null,
  prompt_hash text not null,
  feedback text check (feedback in ('helpful','wrong','unsure')),
  outcome_note_id uuid references notes(id),
  created_at timestamptz not null default now()
);

create table invites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  person_id uuid not null references people(id) on delete cascade,
  code text unique not null,
  status text not null check (status in ('sent','accepted','declined','revoked')) default 'sent',
  sent_at timestamptz not null default now(),
  responded_at timestamptz
);

-- When an invited person accepts, they get a scoped login bound to this row.
create table subject_links (
  id uuid primary key default gen_random_uuid(),
  person_id uuid not null references people(id) on delete cascade,
  subject_user_id uuid not null references users(id) on delete cascade,
  can_view boolean not null default true,
  can_edit boolean not null default true,
  can_request_erasure boolean not null default true,
  consented_to_calibration boolean not null default false,
  created_at timestamptz not null default now(),
  unique (person_id, subject_user_id)
);

create table audit_log (
  id bigserial primary key,
  user_id uuid,
  actor_user_id uuid,
  person_id uuid,
  action text not null,                   -- read_profile, infer, answer, export, delete, invite, subject_edit
  detail jsonb,
  at timestamptz not null default now()
);

-- Row-level security pattern (repeat per tenant table)
alter table people enable row level security;
create policy people_owner on people using (user_id = current_setting('app.user_id')::uuid);
create policy people_subject on people for select using (
  id in (select person_id from subject_links where subject_user_id = current_setting('app.user_id')::uuid)
);
