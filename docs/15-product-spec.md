# Dear You: product specification (Track C)

**Dear You** — tagline *"I have a feeling about you."* A diary addressed to a person instead of to itself: a journal about the people in your life that learns who they are, remembers what you tell it, and answers your questions about them as grounded, confidence-rated hypotheses. Human-focused by design: it works best when the person it describes is in on it.

Naming history: *Kith*, *Inkling*, and *Hunch* were proposed and set aside. The owner's own starting point was "Dear Diary," made human-focused, and words like "feeling." *Dear You* is that: the diary is written to a person. Runners-up in the same register: *Feeling*, *I Have a Feeling*, *Dear Someone*, *Dear Diary* (generic; many existing apps). "Dear You" is common English and will need a distinctive mark or stylization; a trademark search in the relevant classes is required before launch.

## 1. What it is

You keep notes about someone: a partner, a friend, a parent, a colleague. Dear You turns those notes into a living profile structured by `framework/person-schema.yaml`, with every attribute carrying its source, its confidence, and a status (proposed, accepted, rejected). You can edit anything. You can ask questions: "What gift would land?", "How will she take the news about the move?", "Does he like summer?", "What's their favorite color?", "Is she interested in me?" Dear You answers using the Intuition Stack and the Track B prediction schema: a probability or a best guess, the drivers behind it in plain language, which of your notes it leaned on, how much of the profile it is actually working from, and what would change the answer.

The person can be invited. They fill in their own profile, see what is stored about them, correct it, and can ask for it to be deleted. Their answers become the ground truth that makes Dear You better for everyone.

## 2. Design principles

- **Consent first.** The person can be invited to see, correct, add to, and delete what Dear You holds about them. Their self-reports are the ground truth the model calibrates against.
- **Your sources.** Profiles are built from notes you write, data you own (your own exports, your own conversation thread with the person), and items you clip by hand with their URL.
- **Sensitive fields are entered, not inferred.** Sexual orientation, race, ethnicity, religion, political alignment, and health are entered by you or by the person, encrypted, and kept out of model inputs unless you turn them on for that person.
- **Media are memories.** Photos and videos attach to notes and experiences; the model may write a scene description to help you record the moment.
- **Hypotheses, not verdicts.** Every answer carries its confidence, its evidence, and what would change it, as the framework requires (`07-caveats.md`, `10-ml-training-plan.md` section 8).

## 3. Users and core loop

**Primary user:** someone who wants to understand and show up better for the people they care about. Secondary: the invited person, who gets a mirror and control over their data.

Loop: *notice something → write a note → Dear You proposes attributes and experiences → you accept or edit → you ask a question before a decision or a conversation → Dear You answers with reasons and uncertainty → you act → you note what happened → the profile and Dear You's calibration improve.*

## 4. Core objects

| Object | Description |
|---|---|
| **User** | account holder; has their own full person-schema profile (needed for relational questions like "is she interested in me", which require both sides) |
| **Person** | someone the user knows; identity fields; relationship to user; sensitive fields (user- or subject-entered only) |
| **Attribute** | one value for one `person-schema` field path, with `source_type` (user, subject, note_inference, import), `source_id`, `confidence`, `status` (proposed / accepted / rejected), timestamps; many per field over time (history is kept) |
| **Note** | dated freeform text about a person; the primary input; immutable once written, with edits as new versions |
| **Experience** | structured memory extracted from notes or entered directly: description, date, valence, domain, who was present; feeds `history.formative_events`, `habits`, `cue_history`, `relations` |
| **Media** | photo or video attached to a note or experience; stored encrypted; caption by user; optional scene description by model; no face processing |
| **Import** | a file the user owns: their own chat export with the person, emails they received, calendar entries; parsed into notes with provenance; or a subject-authorized export delivered through an invite |
| **Clip** | a single public web item the user saved by hand via the browser clipper; URL, text, timestamp; becomes a note with `source_type = clip` |
| **Question** | prompt, type (binary / classification / freeform), the assembled profile snapshot used, the full `output-schema.json` answer, model version, user feedback (helpful / wrong / what happened) |
| **Invite / Consent** | a link sent to the person; states what Dear You is, what is stored, and what they can do; on acceptance creates a `Subject` link that lets them view, edit, add, and request deletion |
| **Audit log** | every read of a person's profile, every inference, every export, every deletion |

## 5. Attribute extraction from notes

1. Chunk the note; embed for retrieval.
2. Extraction prompt lists the person-schema field paths that are **inferable** (everything except `sensitive` fields and `biology`) and asks for proposals with a quoted span, a confidence, and the layer of the Intuition Stack the evidence speaks to.
3. Proposals land as `status = proposed`. The user reviews in a diff-like view; one tap accepts, edits, or rejects. A per-user setting allows auto-accept above a confidence threshold; provenance is kept either way.
4. Experiences are extracted the same way, with date normalization ("last Tuesday" resolved against the note date).
5. Conflicts (a new note contradicts an accepted attribute) are surfaced, not silently overwritten; the attribute history shows both.

## 6. Answering questions

1. Classify the question type: binary, classification (with candidate set), or freeform.
2. Assemble the profile: all accepted attributes, the N most relevant notes and experiences by retrieval, the user's own profile if the question is relational, and the `state` block if the user supplied recent context ("she just got back from a 12-hour shift").
3. Run the explain protocol (`framework/explain-protocol.md`) with the output schema. Model: a frontier API model in JSON mode at launch; the Track B fine-tuned model when it beats the API model on the evaluation suite.
4. Render: the answer (probability for binary; distribution for classification; text for freeform), top three drivers in plain language with the notes they came from, `profile_coverage`, `individual_vs_population`, and the counterfactuals ("if she had slept, this would flip").
5. Low-evidence questions ("favorite color?") answer honestly: a population prior, a low confidence, and the note that would resolve it ("ask her, or notice what she wears when she chooses").
6. Relational questions ("interested in me?") always show the uncertainty band, always list the alternative readings, and never return a bare yes or no. If a user asks repeated interest-questions about one person across sessions without reciprocal signals in the notes, Dear You shows a reflection prompt rather than another probability. This is a design choice about wellbeing, not a block.

## 7. Screens

- **Home**: people, upcoming dates (birthdays, anniversaries from experiences), "before you see them" cards.
- **Person**: header with relationship and coverage meter; tabs: Notes (timeline), Profile (schema blocks, accepted vs proposed, sensitive section collapsed and locked), Experiences, Memories (media), Ask (chat-like, with answer cards), Sharing (invite status, what they can see).
- **Note composer**: text, attach media, date; after save, the proposals drawer.
- **Ask**: question box with type auto-detected; answer card; "what happened?" follow-up to log outcomes.
- **Me**: the user's own profile, same schema, with the self-report instruments (short Big Five, values, ideal affect, food preferences).
- **Invite view** (subject side): what Dear You is, what is stored about you, edit, add, download, delete.
- **Settings**: auto-accept threshold, sensitive-field inference toggle per person (default off), data export, delete account.
- **Clipper** (browser extension): one button on any page; saves selection or main content with URL into a chosen person's notes. No background activity, no crawling, no login to third-party sites.

## 8. Architecture

```
Next.js (React, TypeScript)  ──REST/JSON──▶  FastAPI (Python)  ──▶  Postgres 16 + pgvector
        │                                           │                       │
   browser clipper                           Redis queue ──▶ inference workers (LLM API now; Track B model later)
        │                                           │
   managed auth (passkeys + email; OAuth)     S3-compatible object store (media, imports), encrypted
```

- **Why Python backend**: the framework's artifacts (ontology CSV, schemas, protocol) are Python-validated already; the Track B model serving will be Python.
- **Tenancy**: Postgres row-level security keyed on `user_id`; subjects get scoped read/write through `subject_links`.
- **Encryption**: at rest for all tables holding notes, attributes, media keys; TLS in transit; media keys per user.
- **Model layer**: a provider interface with `extract(note, schema) → proposals` and `answer(question, profile) → output_schema`; implementations: API model with JSON schema enforcement; local Track B model.
- **Observability**: every inference logged with model version and prompt hash; user feedback joined for calibration tracking (Brier score over time per question type).

The SQL sketch is in `product/schema.sql`. The API surface is in `product/api.md`.

## 9. Privacy, legal, safety

- **Lawful basis**: users process notes about people they know; for a hosted service this is the controller's legitimate interest plus the subject-rights portal (view, correct, erase) that the invite provides. Legal review required before launch in EU/UK; CCPA for California.
- **Special categories**: never inferred; entered values encrypted; excluded from model inputs by default; excluded from any analytics.
- **Subject rights without an account**: a person who learns they are in someone's Dear You can request a summary and erasure through a public form; verified by the account holder confirming identity or by the subject supplying the invite code.
- **Minors**: people under 16 cannot be subjects beyond name, relationship, and dates.
- **No third-party sharing** of profiles. No ads. No training on user data without explicit opt-in; invited subjects' self-reports can be used for calibration only under a separate opt-in.
- **Abuse patterns**: rate limits on person creation; detection of many profiles with no reciprocal signals; the reflection prompt described above; a clear report path for subjects.
- **Deletion**: hard delete of notes, attributes, media, embeddings, and inference logs within 30 days; audit log retains only the fact of deletion.

## 10. Roadmap

| Phase | Scope | Done when |
|---|---|---|
| **C0** (done 2026-11-08) | this spec, data model, API sketch, name | docs merged |
| **C1 MVP** (6 weeks) | auth; Me profile; People with manual attributes; Notes; Ask via API model with output schema; answer cards with drivers and coverage | 20 users keep weekly notes and rate answers |
| **C2 Extraction** (4 weeks) | note → proposals → review; experiences; conflicts; media as memories with scene captions; attribute history | ≥ 70% of proposals accepted; calibration dashboard live |
| **C3 Consent and import** (6 weeks) | invites and subject portal; user-owned imports (chat exports, mail); web clipper; subject-rights form | first invited subjects correct their profiles; legal review passed |
| **C4 Model** (overlaps B4–B6) | swap in Track B model where it beats the API model on the question evaluation; subject self-reports feed Stage E with consent | normalized accuracy reported per question type |
| **C5** | mobile apps; reminders; shared profiles between two consenting users ("our Dear You") | retention target |

## 11. Open decisions

- Pricing: none. The project is non-commercial (research, education, fun); Dear You is a free research and education instrument. No ads under any circumstance.
- Whether freeform notes are end-to-end encrypted (limits server-side inference) or encrypted at rest (allows it). Default: at rest, with an E2E "private notes" tier that is excluded from inference.
- Default auto-accept threshold.
- Whether the clipper ships in C3 or waits for legal review of its own.

## 12. Person summary panel (added 2026-11-08)

At the top of every Person page, above the tabs, a summary card answers "who is this person?" in three blocks. Every value in the card carries a **provenance badge**, and anything the model filled in without direct evidence is marked **Predicted**.

### 12.1 Blocks

**Personality.** Big Five as five horizontal bands (low / mid / high with a position marker), two or three facet highlights, attachment style if known, emotion-regulation style if known, ideal affect. A one-paragraph plain-language summary generated from the accepted and predicted attributes ("Steady and conscientious; warms slowly; takes criticism hard and goes quiet rather than argues").

**Aptitudes.** Shown as *bands*, never as a single number. Fields: general cognitive aptitude (band: below average / average / above average / well above, with an optional range such as 105–120 behind a disclosure), verbal, quantitative, spatial, social and emotional, creative, practical and mechanical, plus a free-text "notable skills" list (languages, instruments, sports, crafts). A **Predicted** aptitude band is always drawn with a wide uncertainty bar and a "weak evidence" tooltip: text-based estimates of intelligence from informal writing or behavior have validity on the order of r ≈ 0.3–0.4 in the best published work, which is enough to say "probably above average" and not enough to say a number. The IQ-style range is available behind a disclosure, defaults to hidden, and is never shown for an invited subject's own view unless they turn it on.

**Profession and situation.** Current occupation and employer type, field, seniority, career stage, education, side pursuits, and "what they are working toward" drawn from `goals`. Predicted entries here are common and usually medium confidence ("likely a mid-level engineer: talks about sprints and code review, no reports").

### 12.2 Badge semantics

| Badge | Meaning | `source_type` | Appearance |
|---|---|---|---|
| **You said** | you entered or confirmed it | `user` | solid |
| **They said** | the invited person entered it | `subject` | solid, different hue |
| **From note** | extracted from a specific note; tap to see the quoted span | `note_inference` | outlined, with note date |
| **Predicted** | the model inferred it to fill a gap, with no direct evidence; confidence dot high / medium / low | `model_prediction` | dashed outline, sparkle glyph |
| **Conflict** | two accepted values disagree | any | amber |

Predictions appear in the summary without waiting for acceptance so the card is always complete, but they are visually unmistakable. Each prediction has two actions: **Confirm** (becomes *You said*, provenance kept in history) and **Dismiss** (status rejected; the model will not re-propose the same value for 90 days). The card header shows `profile_coverage` and the count of predicted fields ("7 of 23 shown are predicted").

### 12.3 How predictions are made

- Run the explain protocol in *profile mode*: given accepted attributes, notes, and experiences, fill the summary fields of `person-schema.yaml` (`personality.*`, `aptitudes.*`, `identity.occupation`, `identity.socioeconomic.education`, `goals.*`) with a value, a confidence, and the Intuition Stack layer the evidence speaks to.
- Confidence calibration: predictions are scored against later confirmations and subject self-reports; the Brier score per field feeds the dot thresholds, so "high" means high for *this* field type on *this* model version.
- Sensitive fields are never in the prediction set regardless of block (see section 2). Mental-health fields are never predicted; they can be entered.
- Personality predictions from the user's notes have a known validity envelope: computer judgments from behavioral residue reach r ≈ 0.56 with self-report, better than the person's friends (Youyou, Kosinski & Stillwell, PNAS 2015), and language-based estimates sit around r ≈ 0.3–0.4 per trait. Dear You's notes are a third party's observations, so expect the lower end until subject self-reports exist for calibration.
- Low-coverage profiles (under about 30%) suppress aptitude predictions entirely and show "not enough to go on" with the two or three note prompts that would help most.

### 12.4 Predict button

A **Make predictions** action on the card re-runs profile mode and refreshes predicted fields; it never touches *You said* or *They said* values and never un-dismisses a rejected prediction. The audit log records each run.

## 13. Conversations: importing your own messages with the person (added 2026-11-08)

Your direct-message history with someone is some of the best evidence Dear You can have: it shows how they write, what they bring up, how fast they reply, what makes them laugh. Dear You supports it in two ways, both limited to **conversations you are a party to, in your own account**.

### 13.1 Recommended: import your Instagram data export

Instagram's Accounts Center lets you download your information, including messages, as JSON. Dear You accepts the zip, finds the thread with the selected person (matched by their Instagram handle on the Person record), and imports that one thread as dated notes with `source_type = import` and `source_ref = instagram_export`. Threads with other people are discarded unread. The same path exists for WhatsApp exports, iMessage exports, Messenger, and mail. This is the only bulk path, and it runs through Meta's own export, so it does not touch their anti-automation rules.

### 13.2 Extension: save this conversation

The browser extension gains a second button beside the clipper: **Save this conversation to Dear You**. It works only when you are on a direct-message thread in your own logged-in Instagram, Messenger, or WhatsApp Web, you press the button, and you pick which Person the thread belongs to. It reads the messages visible in that one thread (scrolling back as far as you let it, with a visible progress indicator you can stop), and sends them to Dear You as dated notes with `source_type = capture`. Constraints:

- Only the thread currently open, only in an account you are logged into yourself.
- Never runs in the background, never on page load, never across threads, never on profile or feed pages.
- Stores the other party's handle for matching and nothing else about their account.
- Reads the DOM you can already see; it does not call Instagram's private APIs or bypass any access control.
- Shows a one-time notice that Meta's terms restrict automated collection and that the data export in 13.1 is the fully supported route.

### 13.3 What the model does with conversations

Messages from the person are the richest input for `self_report_style`, `personality` (language-based estimates), `relations.actors` (reciprocity signals, response latency, who initiates), `history.habits` (times of day, recurring topics), and `goals`. Messages from *you* are used only to compute relational features (who initiates, reply latency, tone matching); they are not attributed to the person. Extracted attributes carry the **From note** badge pointing at the message date. The invited subject sees that imported conversations exist, with counts and date ranges, and can request their removal like any other data.
