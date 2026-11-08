# Training plan: a model that predicts what a person feels, thinks, and does

## 1. Problem statement

Learn

    f(situation, person_profile, question) → (state, drives, appraisals, emotions[211], VAD, cognition, action distribution, answer)

where `answer` is a binary decision with probability, a classification with a distribution and conformal set, or free text, chosen by `question.type`. Output format is `framework/output-schema.json`. Input format is `framework/person-schema.yaml` plus a free-text situation.

The model is **one generative language model** fine-tuned to emit the structured output, with auxiliary numeric losses on the quantitative fields. This follows what has worked: Centaur (Binz et al., Nature 2025) fine-tuned Llama 3.1 70B with QLoRA on Psych-101 (160 experiments, 60,092 participants, 10.7M choices) and out-predicted domain-specific cognitive models on held-out experiments. EmoLLMs (Liu et al. 2024) instruction-tuned on 234K affective samples covering classification *and* regression and beat GPT-4 on most affective tasks. A generative backbone handles the text head natively; the numeric heads are the design problem, solved below.

## 2. Why not a classifier

Three reasons. First, the target is heterogeneous (211 intensities, 3 VAD values, 8 drives, 6 appraisals, action text, free text) and a single decoder with a schema handles that where a stack of heads does not. Second, the inputs are open-ended text (situations, formative events, beliefs) and the only architecture that reads them well is a pretrained LM. Third, reasoning matters: Tak & Gratch (2023) found GPT-4 inconsistent on emotion *intensity* and coping unless prompted carefully; Broekens et al. (2023) found ChatGPT could run an OCC appraisal pipeline from a prompt. Intermediate appraisal reasoning improves emotion prediction, so the training data includes it as a chain of thought.

## 3. Architecture

```
[system prompt: Intuition Stack protocol + output schema]
[person profile: YAML → canonical text, missing fields marked]
[situation]
[question]
        ↓
  backbone LM (open weights, 8B for iteration, 70B for final; QLoRA)
        ↓
  reasoning trace (optional, trained): seven questions L0 → L6, appraisal first
        ↓
  JSON output per schema
```

**Numeric fields.** Two options, used together:

- *Number Token Loss* (Zausinger et al., ICML 2025, "Regress, Don't Guess"): add a regression-like loss on the number tokens of the generated JSON so that predicting 0.7 when the truth is 0.8 is penalized less than predicting 0.1. Keeps a single head; matched a dedicated regression head in their experiments.
- *Auxiliary regression heads* on the final hidden state for the dense blocks (211 emotion intensities, VAD, drives, appraisals), trained jointly with the LM loss. Used for fast scoring when text is not needed, and as a consistency check against the generated JSON.

**Calibration.** Binary and classification heads get temperature scaling on a held-out set and conformal prediction sets at a configured coverage (Kumar et al. 2023 showed conformal sets on LLM multiple-choice track accuracy well; note that standard calibration can enlarge conformal sets, so calibrate for the use, not both at once).

**Distributional targets.** Emotion labels disagree across annotators; treat disagreement as signal, not noise. Train on soft label distributions (label distribution learning; SeedBERT-style multi-task prediction of label plus disagreement), and evaluate with Jensen-Shannon divergence against the annotator distribution, not accuracy against a majority vote.

**Consistency losses** (from `08-emotion-ontology.md`): emotion vector × prototype VAD table ≈ predicted VAD; emotion vector × prototype appraisal table ≈ predicted appraisals. Weighted low early, raised as prototypes are replaced with measured values.

## 4. Data: five stages, one schema

Every source is converted to the same (situation, profile, question → output) record. Missing output fields are masked, not zero-filled. Missing profile fields are left absent so the model learns to work from partial profiles.

### Stage A: emotion understanding (no person)

| Dataset | Size | Supplies | Notes |
|---|---|---|---|
| GoEmotions (Demszky 2020) | 58k Reddit comments, 27 + neutral | category intensities (multi-label), annotator counts → soft labels | BERT baseline F1 .46; map via ontology |
| crowd-enVent (Troiano & Klinger 2023) | 6,600 event texts × 21 appraisals × 13 emotions | **appraisal vector**, categories | the key appraisal supervision |
| GRID (Fontaine, Scherer, Soriano) | 24 emotions × 142 features × 27 countries | appraisal and action-tendency prototypes per emotion word per culture | prototype tables, not instances |
| ISEAR (Scherer & Wallbott) | ~7,600 situations × 7 emotions | situation → category | classic |
| SemEval-2018 Task 1 (Mohammad) | tweets, 4 emotions × intensity, valence 7-class | **intensity regression**, ordinal valence | Pearson metric |
| EmoBank / NRC VAD / Warriner | sentence and word VAD | VAD regression | lexicons replace ontology prototypes |
| EmpatheticDialogues (Rashkin 2019) | 25k dialogues, 32 situation emotions | situation → category, listener response | text head |
| MELD, IEMOCAP, RECCON | conversational, 7 emotions; cause spans | category + **cause** | cause spans train the evidence field |
| EmoBench (Sabour 2024) | 400 hand-written EU/EA items | **held-out evaluation only** | GPT-4 below human average |

### Stage B: commonsense reactions and norms (generic person)

| Dataset | Supplies |
|---|---|
| ATOMIC 2020 / COMET (xReact, oReact, xIntent, xWant, xNeed, xEffect) | event → feeling of actor and others, intent, next action; the backbone of the `action` and `cognition` heads at population level |
| SocialIQA | situation → motivation, reaction, next step (multiple choice) |
| Social Chemistry 101 (292k rules of thumb) + Moral Stories (12k branching narratives) | norm_compat appraisal; moral emotions; action consequences |
| Scruples (32k AITA anecdotes, 625k judgments, distributional) | **distributional** normative judgment; trains the classification head to output distributions |
| ValuePrism / Kaleido (218k values, rights, duties over 31k situations) | which values a situation touches → gates moral emotions |
| SOTOPIA scenarios | multi-turn social goals; action prediction in interaction |

### Stage C: person conditioning (the hard part)

| Dataset | Profile fields available | Target |
|---|---|---|
| WASSA 2021–2024 empathy/distress | age, gender, ethnicity, income, education, **Big Five**, IRI | essay empathy and distress scores, emotion; the only public corpus with personality + demographics + affective response to a stimulus |
| PANDORA (Gjurković 2021) | Big Five, MBTI, Enneagram, age, gender, location for 10k+ Reddit users, 17M comments | text → traits; traits → reaction style |
| Twin-2K-500 (Toubia 2025) | 2,058 US adults, 500 questions: demographics, personality, cognitive, economic measures, behavioral economics replications, pricing choices for 40 products; test-retest wave | **individual-level choice prediction with a retest ceiling**; the pricing block directly tests the purchase playbook |
| Psych-101 / Centaur | minimal; trial-by-trial behavior across 160 tasks | choice prediction; shows fine-tuning transfers across tasks |
| choices13k (Peterson 2021) | none | risky choice rates for 13k problems (note 2023 critique of dataset noise) |
| OpinionQA (Pew, 60 groups, 1,498 Qs) + GlobalOpinionQA | demographic group | **group-level** attitude distributions; used to audit, not to train personas |
| PRISM (Kirk 2024) | 1,500 people, 75 birth countries, stated values and demographics | preference ratings over 8k conversations; text-head preferences by profile |
| Park et al. 2024 protocol | two-hour interview transcripts (not public; protocol is) | the template for collecting idiographic profiles in Stage E |

### Stage D: theory of mind and behavior

FANToM, OpenToM, BigToM, Hi-ToM, ToMBench for belief tracking (train on some, hold out others); SOTOPIA and LIFELONG-SOTOPIA for interactive goal pursuit. These train the `knowledge` block to matter.

### Stage E: synthetic idiographic data, human-verified

No public dataset has rich individual profiles plus situations plus measured feelings plus observed actions. Build one:

1. **Profile generation.** Sample profiles from population marginals (World Values Survey, census, MFQ-2 and Big Five norms), then write formative events, habits, cue histories, and goals as text. Use Serapio-García-style trait steering to make the text consistent with the sampled traits. Check for caricature: within-demographic diversity must match real within-demographic variance from PANDORA and Twin-2K-500.
2. **Situation generation.** Sample from the five domains (buying, eating, liking, feeling description, why-did-they) and from ATOMIC/SocialIQA event templates; vary audience, state, cues, expectations systematically so counterfactuals exist in the data.
3. **Target generation.** Run the Intuition Stack protocol as the reasoning trace (L0 → L6, appraisal first) with a strong model, producing the full schema. Keep the trace as training data.
4. **Human verification.** Two layers. (a) Plausibility rating by crowd workers who see profile + situation + predicted output; keep items with agreement. (b) **Ground truth where possible:** recruit real participants (Prolific, as crowd-enVent and PRISM did), collect a Park-style interview, then present situations (vignettes, real purchase choices with real money like Knutson, real food choices) and record felt emotions on the tier-1 set, VAD, free-text thoughts, and choices. Target 2,000 participants × 25 situations as the first idiographic benchmark, with a retest wave for the ceiling.
5. **Hard negatives.** For every item, generate the same situation for a second profile differing in one block (state only; history only; audience only) with the model's predicted change; verify that humans agree the change is in the right direction. This trains counterfactual sensitivity and is the anti-stereotype signal.

## 5. Curriculum

1. Stage A + B jointly, auxiliary heads on, LM loss on JSON, number token loss on numerics. Goal: match or beat EmoLLMs on affective benchmarks and COMET on ATOMIC.
2. Add Stage D. Goal: hold-out ToM benchmark gains without Stage A regression.
3. Add Stage C and E. Goal: individual-level gains on Twin-2K-500 holdout and the idiographic benchmark, measured against the retest ceiling.
4. Reasoning-trace distillation: train the model to produce the seven-question trace before the JSON; evaluate whether traces improve numeric accuracy (Tak & Gratch suggest they will for intensity).
5. Preference optimization on the text head only (DPO on human-rated inner-speech and stated-reason quality), with the numeric heads frozen so text polish cannot drift the predictions.

## 6. Evaluation

| Output | Metric | Ceiling / baseline |
|---|---|---|
| Emotion intensities | Concordance correlation coefficient and Pearson per id; Jensen-Shannon vs annotator distribution | human inter-annotator agreement per dataset |
| VAD | Pearson, as SemEval 2018 | SemEval leaderboards |
| Appraisals | RMSE on 1–5 Likert (crowd-enVent) | crowd-enVent human-reader annotators |
| Drives | no ground truth; evaluate by downstream action prediction and by consistency with emotion vector | theoretical |
| Action distribution | log-likelihood of the observed action; Brier for binary; expected calibration error | Twin-2K-500 retest, Park-style normalized accuracy |
| Binary / classification answers | accuracy, Brier, ECE, conformal coverage and set size | human forecasters where available (Hewitt 2024) |
| Text (inner speech, stated reason) | human ratings for plausibility and voice; LLM-judge with human calibration (SOTOPIA-Eval showed GPT-4 judgments correlate with humans on several dimensions) | inter-rater |
| Theory of mind | accuracy on held-out FANToM / OpenToM / Hi-ToM splits | published human scores |
| **Individual variance captured** | R² of per-person deviation from the group mean | human retest (Park: normalize to self-replication) |
| **Counterfactual sensitivity** | direction agreement with human judgments on single-block perturbations | ≥ 90% direction agreement target |
| **Stereotype audit** | within-group prediction variance vs real within-group variance; CoMPosT-style caricature score; OpinionQA/GlobalOpinionQA alignment by group | real variance; no group below parity |
| Narrative gap | does predicted `stated_reason_likely` match what participants actually say, and does it diverge from the mechanism in the way choice-blindness data predicts | Johansson et al. content analyses |

Hard rules: report normalized accuracy against retest ceilings, never raw; report population-level and individual-level numbers separately; publish the stereotype audit with every model release.

## 7. Known limits, stated up front

- Individual-level life-outcome prediction may be near a hard ceiling (Fragile Families). This plan predicts *reactions over minutes to days*, where evidence of feasibility is far better. Do not extrapolate.
- Prior high accuracy of LLM social prediction often came from shortcut features (party ID predicts the vote); audits must remove shortcut cues and re-test.
- Emotion labels are culture-and-language bound. The ontology's culture-specific layer is thin and English-centric.
- Appraisal supervision exists for 13 emotions (crowd-enVent) and 24 words (GRID); the other ~180 ontology ids inherit prototype appraisals until Stage E data fills them.
- A model that predicts people well is dual-use. Section 8 is not optional.

## 8. Ethics and refusals

- **No manipulation design.** The model refuses requests to design cues, prices, messages, or environments intended to induce a target's behavior against their interest. It will explain a behavior; it will not optimize one. Enforce in the system prompt and with a classifier on requests; log refusals.
- **Consent for idiographic profiles.** Stage E participants consent to prediction of their reactions; profiles are stored pseudonymously; no profile is built from scraped text about a named private individual.
- **No protected-attribute inference.** The model does not infer religion, sexuality, health, or ethnicity from text and then use it; those fields are supplied or absent.
- **Hypotheses, not verdicts.** Every output carries confidence, evidence tiers, and `individual_vs_population`. UI copy must present predictions as what the model expects, with the counterfactuals that would change it.
- **Clinical flags, not diagnoses.** `clinical_risk` triggers a resource message, never a label.

## 9. Compute and timeline (first pass)

| Milestone | Work | Compute |
|---|---|---|
| M1 (weeks 1–4) | Convert Stage A+B to schema; replace ontology prototypes with lexicon values; 8B QLoRA baseline; number token loss | 1× 80GB GPU |
| M2 (weeks 5–8) | Stage D; ToM eval harness; reasoning-trace generation for Stage A+B | 1–2× 80GB |
| M3 (weeks 9–16) | Stage C integration; Twin-2K-500 holdout; idiographic benchmark design and IRB/ethics review; Stage E pilot (200 participants) | 2–4× 80GB |
| M4 (weeks 17–28) | Stage E full collection (2,000 × 25); 70B fine-tune; calibration; stereotype audit; counterfactual eval | 8× 80GB for the 70B run |
| M5 | Release model card with normalized accuracies, audits, and refusal policy | |

Budget drivers are participant payments for Stage E (the one irreplaceable cost) and the 70B run. Everything else is engineering time.
