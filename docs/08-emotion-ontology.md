# The quantitative emotion ontology

`framework/emotion-ontology.csv` is a machine-readable map of 211 human emotional states. It is designed as a **prediction target** for machine learning, not as a philosophical taxonomy. Every state is located in several coordinate systems at once so a model can be trained on whichever one a dataset supplies and still produce a unified output.

## Why several coordinate systems

No single scheme survives the evidence:

- **Discrete categories** (Ekman's 6, Plutchik's 8, Cowen & Keltner's 27, GoEmotions' 27) capture how people *label* states and are what most datasets annotate. But categories have fuzzy boundaries bridged by continuous gradients (Cowen & Keltner 2017), and Barrett's critique holds: they are conceptual categories, not natural kinds.
- **Dimensions** (valence, arousal, dominance) are universal. Across 2,474 languages, emotion vocabularies are organized first by valence and arousal (Jackson et al., Science 2019). Word-level norms exist for ~14,000 lemmas (Warriner 2013) and ~20,000 words (NRC VAD, Mohammad 2018, split-half reliability .95/.90/.90). But dimensions alone cannot distinguish fear from anger.
- **Appraisals** (Scherer's component process model; the GRID project's 24 emotions × 142 features across 27 countries; the OCC model's 22 types) explain *why* a situation produces a state. Seven appraisal factors classify 57% of GRID emotion words correctly. Appraisal is the only layer that connects the situation to the emotion causally, and it is what the crowd-enVent corpus (6,600 texts × 21 appraisal dimensions) annotates.
- **Drives** (the Intuition Stack's L1) connect states to motivation and therefore to action. "Loneliness" predicts reaching out and comfort eating because it is a PANIC/GRIEF signal, not because of its valence.

The ontology stores all four, plus metadata, so that any one can be predicted from the others and all can be predicted from a situation.

## Columns

| Column | Type | Meaning |
|---|---|---|
| `id` | string | stable key, snake_case |
| `label` | string | human-readable name |
| `family` | enum | joy, sadness, fear, anger, disgust, surprise, social, self_conscious, cognitive, aesthetic, drive_state, body_state, core_affect, mixed, culture_specific |
| `tier` | 0/1/2 | 0 = body or core-affect state (not an emotion but reported as one); 1 = primary category present in two or more major taxonomies; 2 = secondary or fine-grained |
| `valence` | 0–1 | prototype pleasantness (NRC VAD scale) |
| `arousal` | 0–1 | prototype activation |
| `dominance` | 0–1 | prototype sense of control/power |
| `approach` | −1..1 | action tendency: avoid (−1) to approach (+1) |
| `drive1`, `drive2` | enum | primary and secondary Intuition Stack L1 systems: SEEKING, FEAR, RAGE, LUST, CARE, PANIC_GRIEF, PLAY, DISGUST |
| `novelty` | 0–1 | appraisal: how unexpected the eliciting event is |
| `pleasantness` | −1..1 | appraisal: intrinsic pleasantness of the event |
| `goal_conducive` | −1..1 | appraisal: does the event help or block the person's goals |
| `agency` | enum | appraisal: who caused it (self, other, circumstance, mixed, na) |
| `control` | −1..1 | appraisal: how much the person can change the outcome |
| `norm_compat` | −1..1 | appraisal: compatibility with social/moral norms (−1 = violation) |
| `time_focus` | enum | past, present, future |
| `social` | 0/1 | requires another person as object or audience |
| `self_conscious` | 0/1 | requires self-evaluation |
| `taxonomies` | list | which published taxonomies contain this state |
| `notes` | text | mechanism and caveats |

## Status of the numbers

The VAD and appraisal values are **expert prototype priors**, not measured data. They were set by hand to be internally consistent and to match the direction of published norms. Phase 1 of the ML plan replaces them:

1. VAD columns → pull the lemma from Warriner et al. (2013) and NRC VAD (Mohammad 2018); where both exist, average; store the source and the two raw values alongside.
2. Appraisal columns → fit from crowd-enVent (21 appraisal dims × 13 emotions) and GRID (24 emotions × appraisal features), mapping onto the six appraisal columns here.
3. Drive columns → remain theoretical (Panksepp), tagged tier B.

Until then, treat every number as a tier-C prior that a model should be allowed to move.

## How a model should use it

Train against **three heads simultaneously** and let them regularize each other:

1. **Category intensities**: a 211-dimensional vector in [0,1], multi-label, allowing co-activation (people feel grateful and embarrassed at once). For datasets that only have one of the smaller taxonomies, map their labels onto the ontology ids using the `taxonomies` column and treat unlabeled ids as *unknown*, not zero.
2. **VAD regression**: three continuous outputs. Every dataset with any emotion label can supply weak VAD supervision via the prototype values; lexicon-annotated and SemEval-style intensity data supply strong supervision.
3. **Appraisal vector**: six outputs matching the appraisal columns (plus agency as a 4-way softmax). Supervised directly by crowd-enVent and GRID; weakly supervised elsewhere via prototypes.

Consistency losses: the predicted category vector, weighted by the prototype VAD table, should approximate the predicted VAD; the predicted appraisal vector should be close to the intensity-weighted prototype appraisals. These ties let a model trained mostly on GoEmotions still produce sensible appraisals, and they are the mechanism by which the ontology turns heterogeneous datasets into one target.

## Label-set tiers for practical use

- **Tier-1 set (62 ids)**: the states with `tier = 1`. Use for human annotation and for headline reporting; coverage of all major taxonomies.
- **Full set (211 ids)**: use as the model's output head. Fine-grained ids inherit supervision from their tier-1 parents via the `family` column when a dataset is coarse.
- **Culture-specific set (15 ids)**: predicted only when the person profile's culture or language makes the concept available. They exist to test whether the model represents culture as a *labeling* layer (Barrett) rather than as a different physiology.

## Mapping tables to existing taxonomies

| Source taxonomy | Size | Mapping rule |
|---|---|---|
| Ekman | 6 (+contempt) | one-to-one onto tier-1 ids |
| Plutchik | 8 primary + 24 dyads | primary one-to-one; dyads to the listed blend (e.g., love → love_romantic; optimism → optimism; awe → awe; contempt → contempt; remorse → remorse; aggressiveness → hostility; submission → security/trust; disapproval → disapproval) |
| Cowen & Keltner 27 | 27 | one-to-one; "craving" → craving, "entrancement" → entrancement, "sexual desire" → lust, "sympathy" → compassion, "romance" → love_romantic |
| GoEmotions | 27 + neutral | one-to-one; "caring" → caring, "realization" → realization, "desire" → desire, "remorse" → remorse |
| OCC | 22 | by eliciting condition: hope/fear (prospect), satisfaction/relief/disappointment/fears-confirmed (confirmation), happy-for/pity/gloating/resentment (fortunes of others), pride/shame/admiration/reproach (attribution), gratitude/anger/gratification/remorse (compound), love/hate (attraction) |
| GRID 24 | 24 | one-to-one onto tier-1 ids |
| Parrott tree | ~135 | tertiary terms map to the nearest id; the `taxonomies` column marks which ids Parrott lists |
| ISEAR | 7 | joy, fear, anger, sadness, disgust, shame, guilt → tier-1 ids |
| EmpatheticDialogues | 32 | one-to-one, with "sentimental" → nostalgia and "prepared" → confidence |

## What is deliberately excluded

- Personality traits and moods lasting days (these belong in the person schema and the state block, not the emotion vector).
- Evaluative words that are judgments rather than feelings ("good", "bad", "important").
- Clinical syndromes (depression, PTSD); the ontology has their constituent states (worthlessness, dread, numbness) and the person schema has a mental-health field.

## Known weaknesses

- English-centric labels with a thin culture-specific layer. Expanding beyond 15 culture-specific ids needs native-speaker review per language.
- Dominance values are the least reliable column; dominance norms have the lowest inter-rater agreement in every lexicon.
- Body states (tier 0) are included because people report them as emotions; a model must learn that "tired" is often the true cause of "irritated", which the Intuition Stack's L0 question is for.
