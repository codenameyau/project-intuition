# Literature that improves prediction: findings, effect sizes, and where each enters the engine

Organized by what each finding changes. Tiers: A replicated or large-scale; B solid but single-study, contested in part, or secondary-only; C weak or failed. *(verify)* marks figures taken from abstracts or press rather than the paper.

## 1. Behavioral consistency, habits, intentions

| Finding | Size | Tier | Enters as |
|---|---|---|---|
| Past behavior in the same context is the strongest predictor of future behavior; habits run independent of intentions when context is stable (Ouellette & Wood 1998; Wood & Neal) | large | A | Question 0; `situation.history_in_context`; habit strength in L2 |
| Changing intentions changes behavior less than it changes intentions: d 0.66 → d 0.36; weaker when control is low (Webb & Sheeran 2006, 47 experiments) | medium→small | A | discount on stated plans; `constraints.capability` |
| Mobility has a 93% theoretical predictability ceiling from trajectory entropy, nearly independent of travel distance (Song et al., Science 2010) | very high | A | top row of the predictability spectrum; location as a base-rate anchor |
| Time-use base rates by demographic and hour (American Time Use Survey, annual) | population | A | cohort engine prior for "what are they doing now" |

## 2. Situations

| Finding | Size | Tier | Enters as |
|---|---|---|---|
| Situation strength (constraints, consequences, clarity, consistency) restricts expression of individual differences (Meyer, Dalal & Hermida 2010) | moderator | A | `situation.strength`; trait weights scaled down in strong situations |
| Eight dimensions describe situations reliably: Duty, Intellect, Adversity, Mating, pOsitivity, Negativity, Deception, Sociality (Rauthmann et al. 2014; Situation Six as an alternative) | structure | A | `situation.diamonds` |
| Traits are density distributions of states; the mean is the trait, the variance is a second trait (Fleeson 2001) *(verify)* | structure | B | trait `{mean, sd}` representation |
| Between-person variance up to four times within-person; group models misdescribe individuals unless ergodic (Fisher, Medaglia & Jeronimus, PNAS 2018); best predictors vary across people (Beck & Jackson 2021) | structural | A | the idiographic switch at ~30 observations; person-specific models |

## 3. Person-level predictive validity

| Finding | Size | Tier | Enters as |
|---|---|---|---|
| 78 Big Five–outcome associations: 87% replicated at ~77% of original size, median N 1,504 (Soto 2019) | small–moderate | A | trust in trait fields with a 0.77 shrinkage prior |
| Neuroticism is the main Big Five correlate of life satisfaction in SOEP (r ≈ −.26 to −.29) *(blog reanalysis)*; personality both predicts and changes after major life events (N = 14,718) | moderate | B | baseline affect; event-reactive trait updates |
| Smartphone behavior predicts Big Five at median r 0.37 (domains) to 0.40 (facets); communication behavior most predictive (Stachl et al., PNAS 2020, N 624) | moderate | A | ceiling for behavior-based trait inference; conversation imports |
| Facebook Likes predict Big Five at r 0.56, above friends (0.49) (Youyou et al. 2015) | moderate | A | ceiling for Predicted badges |
| General mental ability predicts job performance ~.51; interest congruence ~.32 (Schmidt & Hunter 1998; Nye et al. 2017, 92 studies) | moderate | A | aptitude and profession blocks; RIASEC interests field |
| Childhood self-control gradient predicts adult health, wealth, crime (Moffitt et al. 2011, Dunedin); marshmallow effects shrink by about half with controls (Watts et al. 2018), reanalysis contested | small–moderate | B | childhood fields as moderate priors |
| Emotional inertia (autocorrelation of affect) marks and prospectively predicts depression (Kuppens et al. 2010, 2012) | moderate | A | per-person inertia parameter; mood carryover in state |

## 4. Relationships and social judgment

| Finding | Size | Tier | Enters as |
|---|---|---|---|
| Random forests on 100+ traits predict desirability and tendency to desire, but not unique desire for a specific partner (Joel, Eastwick & Finkel 2017) | ≈ 0 for the dyad | A | hard ceiling on "interested in me" from profiles; dyadic signals only |
| Relationship quality predicted mostly by the person's own perceptions of the relationship; partner reports add little (Joel et al., PNAS 2020, 43 datasets) *(verify)* | ~45% own, ~5% partner *(verify)* | B | two-sided mode design; weight own-report fields |
| Deception detection 54% vs 50% chance across 206 documents, 24,483 judges (Bond & DePaulo 2006) | near chance | A | the engine never claims to detect lying |
| Facial configurations do not reliably signal specific emotions; context dominates (Barrett et al. 2019) | structural | A | no face-based inference, on evidence as well as policy |
| Self, partner, and external observers disagree on moment-to-moment emotion in conversation (K-EmoCon, 2020) | structural | A | three-perspective labels; soft targets |

## 5. Time: duration, adaptation, rhythm

| Finding | Size | Tier | Enters as |
|---|---|---|---|
| Of 27 emotions, sadness lasts longest; shame, surprise, fear, disgust, boredom, being touched, irritation, relief are shortest; rumination and event importance mediate (Verduyn & Lavrijsen 2015, N 233; hour figures are press-reported) | ordering A, hours C | A/C | `typical_duration` ordering in ontology; `rumination` in person schema |
| Adaptation to life events differs by event and by component: cognitive well-being shifts more than affect; effects do not track desirability (Luhmann et al. 2012; 188 publications, ~65,900 people) | event-specific | A | trajectory predictions after marriage, divorce, bereavement, childbirth, job loss |
| Mood peaks early morning and near midnight; seasonal mood tracks change in day length (Golder & Macy, Science 2011; 509M tweets, 2.4M users) | small, robust | A | `situation.time` priors; chronotype interaction |
| Weather effects on daily mood are small on average with large individual differences not explained by Big Five (Denissen et al. 2008, N 1,233) | small | A | per-person learned sensitivity only |
| One night of sleep deprivation amplifies amygdala reactivity (~60%, press-reported) and cuts prefrontal coupling (Yoo et al. 2007); sleep loss raises negative mood g ≈ 0.45 (Tomaso et al. 2021) | moderate | A | `state.sleep_hours` weight |

## 6. State and biology

| Finding | Size | Tier | Enters as |
|---|---|---|---|
| Hunger shifts to negative affect and hostile attribution in negative contexts ("hangry", MacCormack & Lindquist 2019) *(not retrieved)* | small–moderate | B | `state.hours_since_meal` interaction with context valence |
| Nucleus accumbens activity in ~30 scanned people forecasts crowdfunding market outcomes weeks later; behavioral measures from the same people do not (Genevsky, Yoon & Knutson 2017) | aggregate | A | research angle: neural priors for population reactions |
| Ego depletion near zero in a 23-lab registered replication (Hagger et al. 2016, N 2,141) | ≈ 0 | C | removed as a mechanism |
| Animal personality is repeatable at mean r ≈ 0.37 across 114 studies, higher in the field (Bell et al. 2009); behavioral syndromes correlate at r ≈ 0.20 | moderate | A | cross-species support for stable drive gains; caution on long-run stability |

## 7. Culture and preferences

| Finding | Size | Tier | Enters as |
|---|---|---|---|
| Patience, risk, reciprocity, altruism, trust measured in 80,000 people across 76 countries with experimentally validated items; within-country heterogeneity exceeds between-country; preferences vary with age, gender, cognitive ability (Falk et al., QJE 2018) | population | A | cohort engine; culture- and age-conditioned preference priors; public dataset |
| Tightness–looseness of norms varies across 33 nations (Gelfand et al. 2011) *(not retrieved)* | population | B | norm_compat weighting by culture |
| Psychology samples are WEIRD and unrepresentative (Henrich et al. 2010) *(not retrieved)* | structural | A | every effect size above is suspect outside its sample |

## 8. Choice architecture and social influence

| Finding | Size | Tier | Enters as |
|---|---|---|---|
| Nudges at scale: 1.4 percentage points (8%) across 126 Nudge Unit trials; publication bias explains most of the gap to academic estimates (DellaVigna & Linos 2022); bias-adjusted meta-analytic d ranges 0.03–0.31 | small | A | defaults and framing as small drivers |
| Visual fixation biases value accumulation toward the fixated option (attentional drift-diffusion model; Krajbich, Armel & Rangel 2010; 2011) | process | A | attention as a predictor when gaze or dwell data exist; decision latency modeling |

## 9. Datasets newly identified for the engine

| Dataset | What it holds | Access |
|---|---|---|
| SOEP | Big Five (2005, 2009, 2013, 2017), life events, satisfaction, affect, tens of thousands over decades | research contract |
| Understanding Society (UKHLS), HILDA | similar panel structure, UK and Australia | research contract |
| Global Preferences Survey | 80k people × 6 preferences × 76 countries | public |
| American Time Use Survey | activity diaries by demographic | public |
| K-EmoCon | multimodal conversation emotion, three perspectives | public |
| LiveJournal mood corpus (Mishne 2005) | 815k posts, 132 moods | via authors |
| Dear Abby corpus (The Pudding 2018) | ~20k letters, codebook | public |
| Reddit relationship/AITA with UPDATE posts | prediction-then-outcome narratives | check Reddit terms |
| Joel et al. speed-dating data | 100+ traits, dyadic desire | UK Data Service |
| Mass Observation | diaries since 1937 | licensed |
| Public-domain diaries, letters, biographies | decades of idiographic text with known outcomes | public |
| Verduyn durations; Luhmann adaptation curves | emotion and event time courses | papers |

## 10. Not retrieved, cited from memory, verify before use
Ouellette & Wood 1998 figures; Fleeson 2001; Joel et al. 2020 PNAS percentages; MacCormack & Lindquist 2019; Gelfand 2011; Henrich 2010; Roberts et al. 2007 comparative validity; Eichstaedt 2018 (Facebook language predicts depression, AUC ≈ 0.69); Tinbergen 1963; GLOBEM and StudentLife access terms; Gallup World Poll affect items; Good Judgment Project superforecaster Brier scores.
