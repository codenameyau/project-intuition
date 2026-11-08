# Dear You API sketch (REST, JSON, bearer auth)

All routes are scoped to the authenticated user. Subject-scoped routes are marked (S).

## Auth and self
- `POST /auth/signup`, `POST /auth/login`, `POST /auth/passkey/*`
- `GET /me` · `PATCH /me` · `GET /me/profile` · `PUT /me/profile/{field_path}` · `POST /me/instruments/{bfi2|pvq-rr|avi|food}` (self-report questionnaires)
- `GET /me/export` · `DELETE /me`

## People
- `GET /people` · `POST /people` · `GET /people/{id}` · `PATCH /people/{id}` · `DELETE /people/{id}`
- `GET /people/{id}/profile` → accepted attributes grouped by schema block, plus `coverage` and `proposed_count`
- `GET /people/{id}/attributes?field_path=&status=` · `POST /people/{id}/attributes` (user-entered; `is_sensitive` allowed)
- `POST /attributes/{id}/accept` · `POST /attributes/{id}/reject` · `PATCH /attributes/{id}`
- `PATCH /people/{id}/settings` → `{sensitive_inference_enabled}`

## Summary and predictions
- `GET /people/{id}/summary` → personality, aptitudes, profession blocks; each field `{value, badge: you_said|they_said|from_note|predicted|conflict, confidence, source_id}`; plus `narrative`, `profile_coverage`, `predicted_count`, `shown_count`
- `POST /people/{id}/summary/predict` → re-runs profile mode; returns the refreshed summary; never overwrites `you_said` or `they_said`; skips dismissed values
- `POST /attributes/{id}/confirm` → prediction becomes `source_type = user` with history kept
- `POST /attributes/{id}/dismiss` → status rejected and a 90-day dismissal record
- `PATCH /people/{id}/settings` → `{show_aptitude_range: bool}` (default false)

## Notes, experiences, media
- `GET /people/{id}/notes` · `POST /people/{id}/notes` → returns note plus `job_id` for extraction
- `GET /jobs/{id}` → extraction status and proposals
- `GET /people/{id}/experiences` · `POST /people/{id}/experiences` · `POST /experiences/{id}/accept|reject`
- `POST /people/{id}/media` (multipart) · `GET /media/{id}` (signed URL) · `DELETE /media/{id}`

## Imports and clips
- `POST /people/{id}/imports` (chat_export | email_mbox | calendar_ics) → parsed into notes with `source_type = import`
- `POST /people/{id}/clips` → `{url, selected_text, page_title}` → one note with `source_type = clip`. One item per call; no crawling endpoints exist.
- `POST /people/{id}/imports` with `kind = instagram_export | whatsapp_export | messenger_export` and `person_handle` → imports only the thread with that handle; other threads are discarded unread
- `POST /people/{id}/conversations/capture` → `{platform, other_party_handle, messages: [{at, author_is_person, text}]}` from the extension's "Save this conversation" on a thread in the user's own account; one thread per call; rejected if `other_party_handle` does not match the Person's recorded handle

## Ask
- `POST /people/{id}/ask` → `{prompt, qtype?, candidates?, state?: {...}}` → `output-schema.json` instance plus `evidence_notes[]`, `profile_coverage`, `individual_vs_population`, `counterfactuals[]`
- `GET /people/{id}/questions` · `POST /questions/{id}/feedback` → `{feedback, outcome_note_id?}`

## Invites and subjects
- `POST /people/{id}/invites` · `GET /invites/{code}` (public: what Dear You is, what is stored) · `POST /invites/{code}/accept|decline`
- (S) `GET /subject/people/{id}/profile` · (S) `PUT /subject/people/{id}/attributes/{field_path}` (`source_type = subject`) · (S) `POST /subject/people/{id}/notes`
- (S) `POST /subject/people/{id}/erasure-request` · (S) `GET /subject/people/{id}/export`
- `POST /subject-rights/request` (public form for people without an invite)

## Admin and audit
- `GET /audit?person_id=` · `GET /calibration` → Brier and coverage by question type and model version
