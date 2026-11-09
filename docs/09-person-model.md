# The person model: how background changes what someone feels and does

`framework/person-schema.yaml` defines the conditioning input. This document says what the evidence supports about each block, how large the effects are, and the two failure modes any person-conditioned model must be built to avoid.

## The central finding: idiographic beats demographic

Three results set the design:

1. **Park et al. (2024), 1,052 generative agents.** Agents built from two-hour qualitative interviews reproduced each person's General Social Survey answers at 85% of the person's own two-week test-retest consistency, and reduced accuracy gaps across racial and ideological groups compared with agents built from demographic descriptions.
2. **Santurkar et al. (2023), OpinionQA.** Default LLM opinions are misaligned with every US demographic group, "on par with the Democrat-Republican divide on climate change", and steering by demographic label does not fix it. People over 65, widowed people, and frequent religious attenders are the worst served.
3. **Persona studies of individual variance.** A 2025 large persona study found LLMs captured about 3% of individual variation against a 54% human retest ceiling (secondary report; verify). Hewitt et al. (2024) found GPT-4 predicts *aggregate* treatment effects of survey experiments at r ≈ 0.85 while systematically overestimating effect sizes. The pattern: LLMs are good at populations, poor at persons, unless given the person's own data.

Therefore the schema's `history.formative_events`, `knowledge`, `goals`, and `relations` blocks carry most of the predictive weight. Demographic fields set priors; they must never be allowed to dominate when idiographic data is present. The output's `individual_vs_population` field exists to state honestly which kind of prediction was made.

## Block by block

### Identity

| Field | What the evidence says | Size |
|---|---|---|
| Age | Older adults attend to and remember positive over negative information (positivity effect; Reed, Chan & Mikels 2014, 100 studies, N = 7,129). Driven by perceived limited time rather than years. Emotional empathy higher in older adults. | moderate |
| Sex | Self-conscious emotions: guilt d ≈ −0.27, shame d ≈ −0.29 (women higher), embarrassment and pride near zero (Else-Quest 2012). Emotion recognition female advantage d ≈ 0.19. Children's expression differences "significant but very small" (Chaplin & Aldao 2013). | small |
| Culture | Shapes *ideal* affect more than actual affect (Tsai; meta-analysis). East Asian samples value low-arousal positive states; US samples value high-arousal positive states. Cultural differences in emotion arise largely through which situations and appraisals are promoted (Mesquita), not only display rules. Emotion vocabularies share a valence × arousal core and differ in finer groupings (Jackson 2019). | moderate |
| Religion / religiosity | Tsai, Miao & Seppala (2007): Christians value high-arousal positive states more, Buddhists low-arousal. Religiosity raises weight on purity/sanctity in moral judgment and increases moral-disgust reactivity. Default LLMs model high-attendance groups badly. | moderate |
| Socioeconomic | Scarcity shortens time horizon and raises stress baseline; education changes vocabulary and stated reasons more than felt states. | moderate |
| Parental status | Activates CARE strongly; predicts protective anger and overspending on dependents. | moderate |

### Personality

| Field | Evidence | Size |
|---|---|---|
| Neuroticism | r ≈ .41 with negative affect (Hengartner 2017); maps to high FEAR, SADNESS, ANGER systems (Marengo 2021 meta-analysis of primary emotional systems) | strong |
| Extraversion | Positive affect, joy, PLAY (Marengo 2021; 2025 lab study: extraversion predicted joy to videos) | strong |
| Agreeableness | Stronger negative reactions to others' harm; CARE | moderate |
| Conscientiousness | Well-being correlate (Anglim & Horwood 2020); raises weight on achievement loss and guilt | moderate |
| Openness | Aesthetic emotions, awe, interest | moderate |
| Disgust sensitivity (3 domains) | Predicts food neophobia, moral purity judgments, out-group attitudes; three-domain structure replicates (Tybur) | strong |
| Attachment anxiety/avoidance | PANIC/GRIEF reactivity, jealousy, reassurance seeking | moderate |
| Emotion regulation habits | Suppression splits felt from expressed; reappraisal lowers intensity; culture moderates which strategy is chosen given ideal affect | moderate |
| Need for cognition | Probability that deliberation intervenes (Type 2) | moderate |

Note on LLM personality: Serapio-García et al. (2023) showed large instruction-tuned models can produce reliable, valid Big Five profiles under structured prompting and can be steered on single traits across nine levels, but steering several traits at once is hard. This is relevant to synthetic data generation (below), not to predicting real people.

### Values and morals

Schwartz's 19 refined values (PVQ-RR) predict value-relevant choices strongly and are measured in the World Values Survey. The MFQ-2 (Atari et al. 2023) has a replicable six-foundation first-order structure (care, equality, proportionality, loyalty, authority, purity; ω .79–.92 across 19 nations), while the "individualizing vs binding" second-order split replicates weakly. Use the six foundations as conditioning features and do not assume the two-cluster structure. Moral emotions in the ontology (indignation, moral disgust, guilt, elevation, contempt) should be gated by which foundation a situation violates and how much the person weights it.

### History

- **Formative events in the person's own words** are the single most useful field (Park 2024).
- **Expertise domains tagged kind/wicked** determine whether the person's gut call in a domain should be predicted as accurate (Kahneman & Klein 2009; Hogarth 2001).
- **Cue history and habits** are the L2 drivers; a model that knows "coffee-shop smell → bought pastry 40 times" predicts the 41st better than any trait.
- **Adverse childhood experiences** shift threat sensitivity and attachment; birth order effects are weak and should be given near-zero weight.

### State

Usually missing, always matters. Hours since eating, sleep, substances, illness, stress load, and any recent arousal source change irritability, risk tolerance, and attribution. The model must output an *inferred* state when none is given and flag it.

### Knowledge and goals

These are the theory-of-mind block. Appraisal of goal conduciveness is undefined without goals; prediction error is undefined without expectations; false-belief reasoning is impossible without knowing what the person does not know. Benchmarks show this is where models fail: FANToM belief tasks near 50% for GPT-4-turbo on short stories; OpenToM psychological-state (attitude, preference) questions remain hard while physical-state questions approach human level; Hi-ToM shows steep decline with each order of recursion.

### Relations

The L3 drivers per actor: closeness, trust, relative status, perceived similarity (r ≈ .39 with liking), exposure count (mere exposure r ≈ .26), reciprocity signals, history valence. Plus the **audience**: who can see the behavior changes status, shame, and display computations more than almost any trait.

### Self-report style

Lets the model predict the *stated reason* as a separate output from the mechanism, which the Intuition Stack treats as the L6 narrative. Alexithymia and verbal fluency about feelings determine how informative a person's own label is.

## Two failure modes to design against

### Stereotyping (caricature)

Persona prompting of LLMs produces caricatures: exaggerated, homogenized group portraits (CoMPosT, Cheng et al. 2023; Durmus et al. 2023 found country prompting "can reflect harmful cultural stereotypes"). Mitigations built into this design:

- Demographic fields carry explicit `evidence: weak` or `moderate` tags and population-marginal priors, never point estimates.
- Idiographic blocks are required in the minimum viable profile.
- An evaluation suite (see `10-ml-training-plan.md`) measures within-group variance of predictions; a model whose predictions for two people sharing demographics but differing in history collapse together fails.
- Output carries `stereotype_risk` and `sensitive_attribution` flags.

### Overclaiming individual predictability

The Fragile Families Challenge (Salganik et al. 2020, PNAS): 160 teams, thousands of variables, 15 years of data, and the best models predicted six life outcomes poorly; simple models often matched complex ones. Whether this reflects missing variables or irreducible unpredictability is unknown. Design consequences:

- Report `individual_vs_population` honestly.
- Calibrate against test-retest ceilings (Park's normalized accuracy; Twin-2K-500's repeat wave), not against 100%.
- Prefer predicting *distributions over actions* to predicting *the* action.
- Treat emotion prediction (minutes) as a different problem from life-outcome prediction (years); the former has far better evidence of feasibility.

## Identity, sensitive fields, rhythms, and the body (schema v0.2, 2026-11-08)

**Identity** now holds full name, preferred name, pronouns, and date of birth (age is derived from it), plus sexual orientation, race, and ethnicity. The name is for display and for matching the user's own records; it is never a predictor and never used to infer ancestry, gender, or anything else. Orientation is free text with no enum, so it cannot become a classification target.

**Sensitive fields** are listed in one place at the top of the schema: orientation, race, ethnicity, religion, religiosity, politics, trauma, mental health, chronic illness, medications, hormonal context, weight, disability, sensory impairments, visible differences, and the biology block. They are entered by the user or the subject, never inferred, stored encrypted, kept out of model inputs unless the user enables them for that person, and never produced as outputs.

**Constraints and rhythms** adds chronotype (mood and performance peak at the preferred time), personal sleep need, usual schedule (the base rate for what someone is doing at a given hour), medications, hormonal context, chronic pain, mental accounts (people judge a purchase against its labeled budget, not total wealth), typical time slack, decision style (maximizing, intuitive, rational, dependent, avoidant, spontaneous), conflict style (Thomas-Kilmann), and RIASEC vocational interests.

**Physical** holds the body attributes that predict feeling or behavior: height (status judgments), weight band (through weight stigma and health, subject-entered only), body image (appearance satisfaction and anxiety, which predict shame and avoidance better than any measurement), disability and mobility, sensory impairments, visible differences the person is self-conscious about, and physical fitness. All are entered, none inferred from media. Excluded: inference of any body, face, or skin attribute from photos or video; skin color as a person attribute (a race proxy); breast, chest, waist, hip, and other measurements including cup size; attractiveness ratings; and body-shape categories. How a character *looks* in the simulation is a separate, user-chosen avatar that never enters the model (`docs/21` section 6a).
