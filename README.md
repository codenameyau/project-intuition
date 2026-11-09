# Dear You (Project Intuition)

**Dear You** is the product: a journal about the people in your life that learns who they are from what you write, lets them see and correct what it holds, and answers your questions about them as grounded, confidence-rated hypotheses. Underneath it are two research tracks described below.

A framework for explaining what people do, buy, eat, like, and feel by modeling the fast, body-anchored systems that actually produce those behaviors, rather than the reasons people give afterwards.

Built from a sweep of connectomics (FlyWire, MICrONS, H01, C. elegans, the Allen cell atlas), single-neuron and circuit neuroscience (dopamine prediction error, wanting vs. liking, orbitofrontal value, hypothalamic hunger, insular interoception), affective and social neuroscience, evolutionary psychology, and judgment and decision research. Every claim carries an evidence tier.

## What this is, after review

A **behavioral prediction engine**: `P(feeling, cognition, action | person, situation, state, history)` with calibrated uncertainty and a stated baseline it had to beat. The Intuition Stack is the mechanism model inside it; the 211-state emotion ontology is one of its outputs; Dear You and the character engine are two front ends. Every prediction starts with Question 0, the base rate: what this person did in this context before, what people like them do, how strong the situation is. See `docs/18-critique-and-redesign.md` for the predictability spectrum that says what the engine may promise, from mobility (very high) to unique romantic desire (near zero from profiles).

## The idea in three sentences

The brain's first job is regulating the body; its ancient drive systems bias what looks good; dopamine attaches wanting to cues; social evaluators judge faces in 100 ms; a predictive model turns experience into priors. All of that arrives in awareness as a *feeling*, which the person then labels with a culturally supplied word. A separate narrating system explains the feeling afterwards, fluently and often wrongly.

## Layout

```
README.md                         this file
PLAN.md                           phased roadmap and standing rules
docs/
  00-vision.md                    one sentence, what it does, critical path, gates, kill criteria, open decisions
  01-thesis.md                    the claim in one page
  02-biological-substrate.md      what is mapped vs. inferred: connectomes, neurons, circuits
  03-framework.md                 the seven-layer Intuition Stack and the seven-question protocol
  04-domain-playbooks.md          buying, eating, liking someone, describing feelings, "why did they"
  05-worked-examples.md           five full runs of the protocol
  06-evidence-and-sources.md      annotated bibliography with A/B/C evidence tiers and known gaps
  07-caveats.md                   scientific, ethical, and open-question caveats
  08-emotion-ontology.md          the 211-state quantitative emotion map and how to train on it
  09-person-model.md              how age, culture, personality, values, history change predictions
  10-ml-training-plan.md          model architecture, datasets, curriculum, evaluation, ethics
  11-ml-sources.md                bibliography for the ontology and the predictive model
  12-comparative-connectomes.md   every mapped nervous system and what each teaches (individuality, sex, development, drives)
  13-genomic-prediction.md        gene expression as circuit index; polygenic and variant prediction in people, with limits
  14-sources-comparative-genomics.md  bibliography for 12 and 13
  15-product-spec.md              Dear You: product, design principles, objects, screens, architecture, privacy, roadmap
  16-character-affect-engine.md   Track D: emotions for NPCs and interactive characters from the same model and schema
  17-model-export-and-deployment.md  export tiers (70B teacher to 1 ms affect head), GGUF/ONNX/WASM, open vs closed weights, consent
  18-critique-and-redesign.md     five rounds of critique; the behavioral-prediction-engine reframing; predictability spectrum; new ideas
  19-prediction-literature.md     findings with effect sizes that improve prediction, and the datasets they point to
  20-veracity-model.md            truth-versus-lie estimation as a Bayesian evidence ledger plus interviewer; what the science allows
  21-simulation-world.md          Track E: 2D world of your people driven by the engine; consent-first social network; claimed identity
framework/
  intuition-stack.yaml            machine-readable spec of layers, drivers, evidence
  explain-protocol.md             prompt template to run the protocol on any situation
  emotion-ontology.csv            211 emotional states × VAD × appraisals × drives × taxonomies
  person-schema.yaml              the conditioning input: 11 blocks, 88 fields, evidence-tagged (incl. aptitudes, biology)
  situation-schema.yaml           the other half of every record: DIAMONDS, situation strength, cues, audience, stakes, constraints, base rate
  relationship-schema.yaml        pair state and evidence-tiered drivers for friendship, work, and (capped) romance
  output-schema.json              the prediction target: emotions, VAD, drives, appraisals, cognition, action, answer
examples/
  template.md                     blank case file for the explanation protocol
  prediction-example.json         one full (situation, person, question) → prediction record
product/
  schema.sql                      Postgres data model sketch for Dear You
  api.md                          REST surface for Dear You
```

## The product (Track C): Dear You

Accounts, your own profile, People you know, dated notes, extracted attributes with provenance and accept/reject, experiences and media as memories, questions answered with the Intuition Stack and the Track B output schema, and an invite that lets the person see, correct, and delete what is held about them. Full spec in `docs/15-product-spec.md`.

## The stack

```
L6  NARRATOR        the story told afterwards                 slow, verbal, post hoc
L5  FEELING         body state + concept + context            the readable signal
L4  PREDICTOR       priors, expertise, familiarity            expectation edits experience
L3  SOCIAL          face read, similarity, status, mentalizing
L2  VALUATION       wanting vs liking, cues, habits, prediction error
L1  DRIVES          SEEKING FEAR RAGE LUST CARE PANIC PLAY DISGUST
L0  BODY BUDGET     hunger, fatigue, arousal, hormones, pain
```

## The predictive model (Track B)

Track B turns the framework into a trainable target. A single fine-tuned language model takes a situation, a person profile, and a question and returns the full `output-schema.json`: inferred body state, drive activations, appraisals, intensities over 211 emotions, valence-arousal-dominance, inner speech and likely stated reason, a distribution over actions with counterfactuals, and a task answer that is binary with a probability, a classification with a conformal set, or free text.

```
situation + person profile + question
        → [LM fine-tuned on five data stages, Intuition Stack reasoning trace]
        → emotions[211] · VAD · drives[8] · appraisals · cognition · action distribution · answer
```

Design is in `docs/10-ml-training-plan.md`; the emotion target in `docs/08-emotion-ontology.md`; the conditioning input in `docs/09-person-model.md`. The honest limits (individual-level prediction is hard; demographic personas caricature) are built into the output as `individual_vs_population` and `stereotype_risk` fields.

## Veracity (Track B-V)

Given a person's record and a statement, estimate the probability it is deceptive. The design follows the evidence: cues to lying are weak or absent, humans reach 54%, and text classifiers fall to chance across domains, so the model is a Bayesian ledger over contradiction with the record (strong), verifiable-detail density (medium), motive and stakes, and the person's base rate, plus an interviewer that proposes the questions most likely to resolve the uncertainty. Never a verdict; text and records only; refused for employment, education, legal, immigration, insurance, and security uses. See `docs/20`.

## Characters and export (Track D)

The same model that predicts a real person's feelings generates a fictional one's. A character sheet is a person-schema profile; game events are situations; the output schema gives drives with time constants, appraisals, emotions, inner speech, a stated reason that may not match, and an action distribution. A fast loop integrates drives every tick on device; a slow loop runs the distilled model on salient events. Export tiers run from the closed 70B teacher through open 1–4B GGUF/ONNX students to a 1 ms affect head and plain tables. See `docs/16` and `docs/17`.

## The world (Track E)

A top-down 2D world where the people from your profiles live, keep routines, meet, talk, and form relationships, driven by the same engine. Walk as yourself or as anyone whose consent tier allows it; talk to characters and see their appraisals and inner speech; run scenarios and get friendship and work dynamics as predictions with intervals, and romance as explorations with the ceiling printed (profiles do not predict who desires whom). Growth is a consent-first social network: sketches stay private to the writer, identities unify only when the person accepts invitations and claims their profile, and multi-perspective profiles are held separately rather than merged. See `docs/21`.

## Using it

1. Read `docs/03-framework.md` once.
2. For a situation, open `framework/explain-protocol.md`, paste the situation at the bottom, and run it through a model or answer the seven questions by hand.
3. Check the domain playbook in `docs/04-domain-playbooks.md` for the drivers that usually dominate.
4. Tag every driver with an evidence tier from `docs/06-evidence-and-sources.md`. Never present tier C as settled.
5. End with a prediction: what change would alter the behavior. If you cannot name one, the explanation is a story, not a mechanism.

## Status

Track A (explanation framework): Phase 0 complete 2026-11-08, comparative connectomes and genomics added 2026-11-08. Track B (predictive model): design complete 2026-11-08, ontology v0.1 with 211 states, person schema with 10 blocks incl. biology, schemas validated, no training run yet. Track C (Dear You product): spec, data model sketch, and API sketch complete 2026-11-08; documents only by owner's instruction, no code until told. Track D (characters and export): design complete 2026-11-08. Redesign pass (v0.2) complete 2026-11-08. Track E (simulation world and consent-first network) designed 2026-11-08. See `PLAN.md`.
