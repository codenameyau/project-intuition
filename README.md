# Dear You (Project Intuition)

*"I have a feeling about you."*

A behavioral prediction engine that turns what you know about a person into calibrated forecasts of what they will feel, think, and do, and that trains your own intuition by scoring you against what actually happened.

Humans read each other constantly and badly: 54% on lies, near zero on who will fall for whom, confident and wrong about how long a feeling will last. Reading people is a *wicked* learning environment, where feedback is slow, noisy, or never comes, so intuition never calibrates. This project builds the missing feedback loop, grounded in neuroscience, psychology, biology, and sociology, with every claim graded by evidence.

**Status: documents only.** Nothing is built. The owner has asked that no code be written until told.

**Posture: non-commercial.** Research, education, and fun. Everything is released under CC BY-NC-SA-compatible research terms with attribution. No pricing, closed tiers, or licensing business.

---

## What it does

| Part | What it is | Docs |
|---|---|---|
| **Intuition Stack** (Track A) | A seven-layer mechanism model of how a situation becomes a feeling, an action, and a story, and a protocol for explaining why someone did, bought, ate, liked, or felt something | `docs/01`–`07`, `12`, `13`, `19` |
| **Prediction engine** (Track B) | Person + situation + question → drives, appraisals, 211 emotion intensities, inner speech, the reason they'd give, an action distribution, and an answer (yes/no with probability, a category with a confidence set, or text), always with the baseline it beat | `docs/08`–`11`, `18` |
| **Veracity** (Track B-V) | Whether a statement is likely true, as an evidence ledger plus an interviewer that suggests resolving questions; never a verdict | `docs/20` |
| **Dear You** (Track C) | A journal addressed to the people in your life: notes, profiles with provenance badges, forecasts, outcome logging, and an invite so the person can see, correct, and delete what is held | `docs/15`, `product/` |
| **Characters** (Track D) | The same engine giving NPCs and training-simulation characters an emotional life, plus export from a hosted teacher model down to on-device models and a 1 ms affect head | `docs/16`, `17` |
| **The world** (Track E) | A 2D simulation where the people in your life live, meet, talk, and form relationships under the engine; grows into a consent-first social network | `docs/21` |

## How it works

### The Intuition Stack

```
L6  NARRATOR        the story told afterwards                     slow, verbal, often wrong about causes
L5  FEELING         body state + concept + context                the readable signal
L4  PREDICTOR       priors, expertise, familiarity                expectation edits experience
L3  SOCIAL          face read, similarity, status, mentalizing    100 ms judgments
L2  VALUATION       wanting vs liking, cues, habits, prediction error
L1  DRIVES          SEEKING FEAR RAGE LUST CARE PANIC/GRIEF PLAY DISGUST
L0  BODY BUDGET     hunger, sleep, arousal, hormones, pain, chronic strain
```

The brain's first job is regulating the body. Ancient drive systems bias what looks good; dopamine attaches wanting to cues; social evaluators judge faces in a tenth of a second; a predictive model turns experience into priors. All of that arrives as a feeling, which the person labels with a word their culture supplies. A separate narrator explains it afterwards, fluently and often wrongly.

### The protocol: Question 0, then seven

0. **Base rate and constraints.** What did this person do in this exact context before? What do people like them do? Can they, may they? How strong is the situation? Past behavior in a matching context is the strongest single predictor, and personality matters less as situations get stronger. Every prediction states the baseline it had to beat.
1. **State** (L0) · 2. **Drive** (L1) · 3. **Cues** (L2) · 4. **Priors** (L4) · 5. **Social** (L3) · 6. **Asymmetry** (which error was evolutionarily costlier) · 7. **Narrative** (L6: what they said, and what the story leaves out).

The output is a mechanistic, confidence-rated, falsifiable explanation that ends in a prediction: what change would alter the behavior.

### The engine's inputs and outputs

| Schema | Holds |
|---|---|
| **Person** (`framework/person-schema.yaml`, v0.2) | 14 blocks, 125 fields: identity (name, pronouns, birth date, culture, religion, orientation, race, ethnicity), personality, aptitudes, values and moral foundations, history (formative events, habits, cue history), current state, knowledge and false beliefs, goals, relations, social context (strain, support, self-control, peer norms), constraints and rhythms (chronotype, schedule, medications, budgets, decision and conflict style, vocational interests), physical (height, body image, disability, sensory; entered only), self-report style, and biology |
| **Situation** (`framework/situation-schema.yaml`) | The eight DIAMONDS dimensions, situation strength, cues, audience, stakes, novelty, choice set, capability and opportunity, opportunity structure for rule-breaking, history in this context, time, physical setting, ongoing life events |
| **Relationship** (`framework/relationship-schema.yaml`) | Pair state (closeness, trust, liking, conflict, status gap, disclosure, Dunbar layer) and evidence-tiered drivers for friendship, work, and capped romance |
| **Emotion ontology** (`framework/emotion-ontology.csv`) | 211 states, each with valence, arousal, dominance, approach, six appraisals, primary and secondary drive, and membership in the major taxonomies |
| **Output** (`framework/output-schema.json`) | State, drives with dynamics, appraisals, emotions with durations, VAD, felt label, inner speech, stated reason and narrative gap, action distribution with counterfactuals, the answer head, baseline, confidence including individual-versus-population, evidence ledger, veracity block, flags |

The engine is a layered system: a language model extracts features and writes narrative, a calibrated probabilistic layer produces the numbers, and a cohort engine over public panel data supplies the outside-view baseline. It switches from population models to person-specific ones as observations accumulate.

## What the science lets it promise

| Question | Predictability |
|---|---|
| Where someone will be next hour | very high (93% theoretical ceiling from mobility data) |
| Routine actions in a familiar context | high (habit and base rate dominate) |
| Personality from behavior | moderate (r ≈ 0.37–0.56) |
| Emotional reaction to a known event | moderate (appraisal and state explain much) |
| Whether someone acts on an intention | low to moderate |
| Whether a specific person will desire a specific other | near zero from profiles |
| Whether someone is lying, from their words alone | 54% against 50% chance |
| Life outcomes years ahead | low, even with thousands of variables |

Every answer says which row it belongs to. Friendship and work dynamics are predictions with intervals; romance and long horizons are explorations with the ceiling printed.

## Design rules

- **Consent first.** Sources are your own notes, your own exports, your own conversation thread with the person, items you clip by hand, and what the person chooses to share through an invite.
- **Sensitive fields are entered, never inferred.** Sixteen paths, listed once in the person schema, covering orientation, race, ethnicity, religion, politics, health, medications, weight, disability, and more. They are encrypted and kept out of model inputs unless you turn that on for a given person.
- **No inference from photos or video.** Media are memories with scene descriptions. Avatars in the world are chosen, never derived from photos, and never model inputs.
- **Claimed identity, not shadow profiles.** Notes about someone stay in your account. A person unifies across accounts only by accepting invitations, and their self-report outranks every observer.
- **Hypotheses, not verdicts.** Every output carries confidence, evidence tiers, the baseline beaten, and what would change it.
- **No manipulation design.** The engine explains behavior; it does not optimize it against the person or a player.
- **Veracity is refused** for employment, education, legal, immigration, insurance, and security uses.
- **Minors** appear by name and dates only.

## Evidence, curriculum, and corpora

- **Evidence base.** Connectomes from worm, fly, larval fly, Ciona, Platynereis, zebrafish, mouse, and human cortex; circuit and single-neuron work on dopamine, hunger, aggression, and isolation; affective, social, and evolutionary psychology; behavioral economics; behavioral genetics; and the replication literature that demoted nudges, ego depletion, and candidate genes. Tiers A/B/C throughout (`docs/06`, `11`, `14`, `19`).
- **Curriculum** (`docs/22`). Eight core textbooks (Kandel, Aronson, Buss, Gazzaniga, Wilkinson & Klaes, Plomin, Cockerham, Siegel) and their extensions, mapped to layers and schema fields. These are design sources and the syllabus for a textbook exam; their text is not ingested.
- **Training corpora** (`docs/23`, `24`, `data/`). OpenStax (14 relevant titles) and MIT OpenCourseWare (11 verified courses) are CC BY-NC-SA and usable for the project's models under its non-commercial posture. Harvard's free courses are syllabus-only under edX terms.

## Repository map

```
README.md                           this file
PLAN.md                             tracks, phases, critical path, gates, standing rules, posture
docs/
  00-vision.md                      one sentence, what it does, critical path, gates, kill criteria, open decisions
  01-thesis.md                      the claim in one page
  02-biological-substrate.md        what is mapped vs inferred: connectomes, neurons, circuits
  03-framework.md                   the Intuition Stack and the protocol (Question 0 plus seven)
  04-domain-playbooks.md            buying, eating, liking someone, describing feelings, "why did they"
  05-worked-examples.md             five full runs of the protocol
  06-evidence-and-sources.md        annotated bibliography with evidence tiers
  07-caveats.md                     scientific, ethical, and open-question caveats
  08-emotion-ontology.md            the 211-state emotion map and how to train on it
  09-person-model.md                how each background factor changes predictions; schema v0.2 notes
  10-ml-training-plan.md            architecture, datasets, curriculum, evaluation, ethics
  11-ml-sources.md                  bibliography for the ontology and the model
  12-comparative-connectomes.md     every mapped nervous system and what it teaches
  13-genomic-prediction.md          gene expression as circuit index; genomic prediction in people, with limits
  14-sources-comparative-genomics.md  bibliography for 12 and 13
  15-product-spec.md                Dear You: principles, objects, screens, summary card, conversation import, privacy
  16-character-affect-engine.md     characters and NPCs from the same engine
  17-model-export-and-deployment.md export tiers, formats, licensing, training-data consent
  18-critique-and-redesign.md       five rounds of critique; prediction-engine framing; predictability spectrum
  19-prediction-literature.md       findings with effect sizes, and the datasets they point to
  20-veracity-model.md              truth-versus-lie estimation as an evidence ledger plus interviewer
  21-simulation-world.md            the 2D world, consent tiers, claimed identity, avatars
  22-curriculum.md                  the textbooks behind the engine and how they become training signal
  23-openstax-corpus.md             the OpenStax library: license finding, relevant titles, ingestion plan
  24-open-courseware-corpus.md      MIT OCW and Harvard free courses; the non-commercial posture
framework/
  intuition-stack.yaml              machine-readable layers, drivers, evidence, protocol
  explain-protocol.md               prompt template to run the protocol on any situation
  emotion-ontology.csv              211 states × VAD × appraisals × drives × taxonomies
  person-schema.yaml                14 blocks, 125 fields, sensitive-field list
  situation-schema.yaml             DIAMONDS, strength, cues, audience, stakes, constraints, base rate
  relationship-schema.yaml          pair state and drivers for friendship, work, capped romance
  output-schema.json                the prediction target, including baseline and veracity blocks
examples/
  template.md                       blank case file for the protocol
  prediction-example.json           one full (situation, person, question) → prediction record
product/
  schema.sql                        Postgres data model sketch for Dear You
  api.md                            REST surface sketch for Dear You
data/
  openstax-manifest.yaml            OpenStax books, repositories, licenses, chapter mappings
  open-courseware-manifest.yaml     MIT OCW courses and Harvard syllabus entries
```

## Where to start

- **The whole idea:** `docs/00-vision.md`, then `PLAN.md`.
- **The science:** `docs/01-thesis.md`, `docs/03-framework.md`, `docs/02-biological-substrate.md`.
- **The engine:** `docs/18-critique-and-redesign.md`, then `docs/10-ml-training-plan.md` and the schemas in `framework/`.
- **The products:** `docs/15-product-spec.md` and `docs/21-simulation-world.md`.
- **To try the protocol by hand:** open `framework/explain-protocol.md`, paste a situation, answer Question 0 and the seven questions, tag each driver with an evidence tier, and end with what would change the behavior. If you cannot name that, the explanation is a story, not a mechanism.

## Status

| Track | State (2026-11-08) |
|---|---|
| A, Intuition Stack | framework, protocol with Question 0, playbooks, comparative connectomes, genomics |
| B, Engine | ontology v0.1 (211 states), person schema v0.2, situation and relationship schemas, output schema, training plan, v0.2 redesign; no training run |
| B-V, Veracity | design |
| C, Dear You | spec, data model and API sketches |
| D, Characters | design and export tiers |
| E, World | design, consent tiers, avatars |
| Corpora | curriculum, OpenStax and OCW manifests; nothing ingested |

The critical path in `docs/00-vision.md` starts with the cheapest engine (a prompted model, a cohort baseline, and a calibration layer) and gates everything else on it beating the baseline on held-out individual data.
