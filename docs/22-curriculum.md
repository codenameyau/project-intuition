# Curriculum: the textbooks behind the engine, and how they become training signal

The owner's starting list of eight textbooks, extended to a full curriculum, with each book mapped to the layers of the Intuition Stack, the fields of the person and situation schemas, and the gaps it exposes. The last section says how textbook knowledge legitimately enters a model, because the obvious route is closed.

## 0. How textbooks become training signal

**Textbooks are copyrighted and cannot be ingested as training data without a license.** A 2025 US ruling held that training on lawfully acquired books is fair use while a library of pirated copies is not; Anthropic settled the piracy claims for $1.5 billion, and over a hundred suits against AI developers remain open. The direction of travel is direct licensing. For this project that means four legitimate channels:

1. **Design source.** Textbooks tell us which constructs exist, how they are measured, and what effect sizes to expect. That knowledge is already in this repo as schema fields, drivers, and evidence tiers, and in the heads of the frontier models used to generate synthetic data. No text is copied; concepts are not copyrightable.
2. **Evaluation ground truth.** A "textbook exam" test set: constructs, mechanisms, and classic findings turned into questions and vignettes the engine must answer correctly before it is trusted to appraise a real situation. Questions are written fresh from the concept inventory, not copied.
3. **Open-licensed text for retrieval or fine-tuning.** OpenStax Psychology 2e and Introduction to Sociology 3e are CC BY 4.0 and may be used commercially with attribution. Noba Project and Stangor's Principles of Social Psychology are CC BY-NC-SA, so they are usable for research and evaluation but not inside a commercial model. Open-access primary papers (PMC, arXiv, PsyArXiv) are the deepest free source.
4. **Licensed retrieval.** For the eight core textbooks, a retrieval license from the publisher (McGraw Hill, Pearson, Routledge, Cengage, Wiley, Elsevier) lets the engine quote and cite at inference time without training on the text. This is a Phase B1 business task; until it closes, the books are read by humans and encoded as schema.

## 1. The core eight

| # | Book | Edition in use | Bridge |
|---|---|---|---|
| 1 | Kandel, Koester, Mack, Siegelbaum (eds.), *Principles of Neural Science* | 6th, 2021, 60 chapters | biology + psychology |
| 2 | Aronson, Wilson, Sommers, Page-Gould, Lewis, *Social Psychology* | 11th, 2023 | psychology + sociology |
| 3 | Buss, *Evolutionary Psychology: The New Science of the Mind* | 6th/7th | biology + psychology + sociology |
| 4 | Gazzaniga, Ivry, Mangun, *Cognitive Neuroscience: The Biology of the Mind* | 5th | psychology + biology + computation |
| 5 | Wilkinson & Klaes, *An Introduction to Behavioral Economics* | 3rd | psychology + sociology + economics |
| 6 | Knopik, Neiderhiser, DeFries, Plomin, *Behavioral Genetics* | 7th | biology + psychology |
| 7 | Cockerham, *Medical Sociology* | 15th, 2021 (16th 2025) | sociology + biology |
| 8 | Siegel, *Criminology: Theories, Patterns, and Typologies* | 13th or later | sociology + psychology |

### 1. Principles of Neural Science (Kandel et al.)
**What it gives the engine.** The mechanism floor under L0 to L2: synaptic transmission and plasticity (how cues acquire value), the hypothalamus and homeostasis (body budget), the amygdala and emotion circuits, the basal ganglia and habit, dopamine and reinforcement, the new chapters on decision-making and consciousness and on computational circuits, and Part IX on disorders (what changes in anxiety, depression, addiction, schizophrenia).
**Maps to.** `02-biological-substrate.md` throughout; L0 state fields; L2 wanting, liking, and habit; `biology` block rationale; `mental_health` field semantics.
**Chapters to read first.** Emotion and homeostasis, the basal ganglia, reward and motivation, learning and memory, decision-making.
**Gap exposed.** The framework underuses learning rules: synaptic plasticity timescales (seconds to days) should inform how fast `cue_history` updates and how fast habits form (Lally's ~66 days has a mechanism).

### 2. Social Psychology (Aronson et al.)
**What it gives.** The L3 and L6 playbook: social cognition and heuristics, attribution and the fundamental attribution error, self-justification and cognitive dissonance, attitudes and persuasion, conformity and obedience, group processes, interpersonal attraction, prosocial behavior, aggression, prejudice.
**Maps to.** Domain playbooks C and E; `relations.actors`; `self_report_style`; narrator layer; relationship schema drivers; situation `audience`.
**Gap exposed.** Dissonance reduction is a *dynamic*: after a hard choice, people revalue the chosen option upward. The engine should predict post-decision attitude shift, which Dear You can test after a logged choice.

### 3. Evolutionary Psychology (Buss)
**What it gives.** The function layer: survival problems (food, danger, disgust), mating (strategies, jealousy, preferences stated vs revealed), parenting and kinship (CARE), cooperation and reciprocity, aggression and status, conflict between the sexes. The ASYMMETRY question's source literature.
**Maps to.** L1 drives; `identity.parental_status` weight; the DISGUST domains; relationship schema romantic drivers (with the Joel/Finkel ceiling applied over Buss's preference findings).
**Gap exposed.** Life-history strategy (fast vs slow) as a person-level variable predicting time preference, risk, and mating effort; add as a candidate field once a validated instrument is chosen.

### 4. Cognitive Neuroscience (Gazzaniga, Ivry, Mangun)
**What it gives.** Methods and their limits (what fMRI can and cannot say), attention, memory systems, emotion, social cognition and theory of mind, cognitive control and the interpreter, consciousness. The source for L4 and L6 and for the methods caveats in `07`.
**Maps to.** L4 predictor; L6 narrator; `knowledge` block (false belief, mentalizing); the "fMRI says where, not how" caveat.
**Gap exposed.** Cognitive control chapters give a cleaner model of *when* Type 2 intervenes (conflict monitoring, error signals) than the framework's current prose; use it to specify `deliberation_probability`.

### 5. Introduction to Behavioral Economics (Wilkinson & Klaes)
**What it gives.** Prospect theory and reference dependence, mental accounting, intertemporal choice and hyperbolic discounting, social preferences (fairness, reciprocity, inequity aversion), behavioral game theory, nudges with their caveats, and the methodological debate about lab-to-field validity.
**Maps to.** Playbook A (buying); `time_preference`, `risk_tolerance`; Global Preferences Survey fields; the nudge demotion in `18`.
**Gap exposed.** Mental accounting (budgets labeled by category) is missing from the purchase playbook and is a strong, replicated driver of spending; add `money_slack` by category to the constraints block.

### 6. Behavioral Genetics (Knopik, Neiderhiser, DeFries, Plomin)
**What it gives.** Twin and adoption methods, heritability of personality, cognition, psychopathology, and attitudes; gene–environment correlation and interaction; the shared-environment finding (siblings differ mostly for non-shared reasons); polygenic scores and their limits.
**Maps to.** `13-genomic-prediction.md`; `biology` block; the within-family deflation rule.
**Gap exposed.** Gene–environment correlation means a "formative event" is partly chosen by the person; the model should treat history fields as caused as well as causal when it infers traits from them.

### 7. Medical Sociology (Cockerham)
**What it gives.** Social epidemiology; the social demography of health by class, gender, age, race; the **stress process** (Pearlin: stressors, mediators such as coping and social support, outcomes); **health lifestyles** (Cockerham's own theory: class position shapes habitual health behavior); the sick role and illness behavior; doctor–patient interaction; social capital and health.
**Maps to.** `state` block (chronic strain as a standing load on the body budget); `identity.socioeconomic`; new `social_context` fields added in this commit (chronic strains, coping resources, social support, health lifestyle, sick-role status).
**Gap exposed.** The framework treated L0 as acute (hunger, sleep). Chronic strain and social position set the *baseline* of L0 and the person's allostatic load; this is where the CTRA biology and the sociology meet, and it was missing.

### 8. Criminology (Siegel)
**What it gives.** Rational choice and routine activity theory (motivated offender, suitable target, absent guardian), trait theories, social structure theories (strain, cultural deviance), social process theories (differential association, social learning, labeling, neutralization), social conflict theories, developmental and life-course theories (age–crime curve, Gottfredson and Hirschi's self-control, Sampson and Laub's turning points), and typologies.
**Maps to.** Situation schema `opportunity_structure` (added: guardianship, target suitability, detection probability); person `social_context` fields (strain, peer association, labeling history, neutralization scripts, self-control); Question 0 base rates by age (the age–crime curve is one of the strongest base rates in social science).
**Gap exposed.** Norm violation in the framework was moral-emotional only; criminology supplies the opportunity and social-learning account of *rule-breaking behavior* generally (cheating, cutting corners, infidelity), which is a prediction target Dear You users will ask about.

## 2. Extensions by field

### Neuroscience and biology
- Bear, Connors, Paradiso, *Neuroscience: Exploring the Brain* (gentler than Kandel; teaching).
- Panksepp, *Affective Neuroscience*; Panksepp & Biven, *The Archaeology of Mind* (the L1 drive systems).
- Barrett, *How Emotions Are Made* (the L5 construction account); Barrett, Lewis, Haviland-Jones (eds.), *Handbook of Emotions*, 4th ed.
- Rolls, *Emotion and Decision-Making Explained* (OFC value).
- Sapolsky, *Behave* (2017): the single best integrative text, organized from one second before a behavior back through hormones, development, genes, culture, and evolution; it is the Intuition Stack as a narrative and should be the first read for anyone joining.
- Glimcher & Fehr (eds.), *Neuroeconomics: Decision Making and the Brain*, 2nd ed.; Dayan & Abbott, *Theoretical Neuroscience*; Sutton & Barto, *Reinforcement Learning* (model-free vs model-based).

### Psychology
- John & Robins (eds.), *Handbook of Personality*; Fleeson on states; Roberts on trait development.
- Cassidy & Shaver (eds.), *Handbook of Attachment*.
- Gross (ed.), *Handbook of Emotion Regulation*.
- Scherer, Schorr, Johnstone (eds.), *Appraisal Processes in Emotion*; Fontaine, Scherer, Soriano, *Components of Emotional Meaning*.
- Kahneman, *Thinking, Fast and Slow*; Gigerenzer, *Simple Heuristics That Make Us Smart*; Tetlock & Gardner, *Superforecasting* (the calibration loop).
- Haidt, *The Righteous Mind*; Greene, *Moral Tribes*.
- Pennebaker, *The Secret Life of Pronouns* (function words as signal, with its limits).

### Sociology and anthropology
- Goffman, *The Presentation of Self in Everyday Life*: the expressed-versus-felt distinction is Goffman's front stage and back stage; essential for the narrator layer and for the simulation's display rules.
- Bourdieu, *Distinction*: taste as class position; the status and identity drivers in the purchase playbook.
- Veblen, *The Theory of the Leisure Class*: conspicuous consumption.
- Granovetter, "The Strength of Weak Ties"; Christakis & Fowler, *Connected* (contested); McPherson et al. on homophily.
- Fiske, *Structures of Social Life* (relational models: communal sharing, authority ranking, equality matching, market pricing) as the grammar of `relations`.
- Henrich, *The WEIRDest People in the World*; Markus & Kitayama on culture and self; Nisbett & Cohen, *Culture of Honor*; Gelfand, *Rule Makers, Rule Breakers*.
- Brown, *Human Universals*.
- Macionis, *Sociology*, or Giddens & Sutton, *Sociology*, as the general text.

### Economics and decision science
- Thaler, *Misbehaving*; Camerer, *Behavioral Game Theory*; Kahneman, Sibony, Sunstein, *Noise*.

### Relationships and development
- Vangelisti & Perlman (eds.), *Cambridge Handbook of Personal Relationships*; Finkel, *The All-or-Nothing Marriage*; Berk, *Development Through the Lifespan*.

### Clinical and health
- Barlow (ed.), *Clinical Handbook of Psychological Disorders*; Taylor, *Health Psychology*; the DSM-5-TR as a vocabulary, not a target.

### Open-licensed (CC BY, usable commercially with attribution)
- OpenStax *Psychology 2e*; OpenStax *Introduction to Sociology 3e*; OpenStax *Biology 2e*; OpenStax *Anatomy and Physiology*.
- CC BY-NC-SA, research and evaluation only: Noba Project modules; Stangor, *Principles of Social Psychology*.

## 3. Concept inventory to schema: what this commit adds

From Cockerham and Siegel, fields the person and situation schemas lacked:

**Person schema, new block `social_context`:** chronic strains (role strain, financial strain, caregiving), coping resources (mastery, self-esteem), social support (perceived and received), health lifestyle (exercise, diet, smoking, drinking, checkups as a class-patterned bundle), sick-role status, chronic illness burden, trait self-control, general strain (blocked goals, loss of positive stimuli, presence of negative stimuli), peer and reference-group norms, labeling history, neutralization scripts, life-course turning points.

**Situation schema, new block `opportunity_structure`:** guardianship (is anyone watching or able to intervene), target suitability (value, accessibility, concealability), detection probability, sanction severity, normative ambiguity.

From Wilkinson & Klaes: `constraints.money_slack` becomes per-category mental accounts in B1.

## 4. The textbook exam

Phase B1 builds an evaluation set of about 2,000 items from this curriculum: definitions, mechanism questions, classic findings with their effect sizes and replication status, and vignettes requiring the construct to be applied. Items are written from the concept inventory; none reproduce textbook text. The engine's score on this set is a release gate: a model that cannot state that cues to deception are weak, that similarity predicts friendship but not unique desire, or that the age–crime curve peaks in late adolescence, should not be appraising anyone's situation.

## 5. Reading order for a new team member

1. Sapolsky, *Behave* (the whole shape).
2. Aronson et al., *Social Psychology* (L3, L6, and the playbooks).
3. Kandel, selected chapters: emotion, hypothalamus, basal ganglia, reward, decision-making.
4. Barrett, *How Emotions Are Made*, then Panksepp & Biven, and hold both.
5. Wilkinson & Klaes (buying, time, risk).
6. Knopik et al. (what genes can and cannot predict).
7. Cockerham, chapters on stress and health lifestyles; Siegel, theory chapters.
8. Tetlock & Gardner (how to be scored).
