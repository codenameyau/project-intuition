# Critique and redesign: five rounds

Everything written so far, read back as a hostile reviewer would, then repaired. Each round names the weakness, the evidence that exposes it, and the change. The changes are applied in this commit where they are small (protocol, schemas, plan) and scheduled where they are large.

The reframing that survives all five rounds: this is a **behavioral prediction engine**. The Intuition Stack is the mechanism model inside it; the emotion ontology is one of its outputs; Dear You and the character engine are two front ends. The engine's job is `P(feeling, cognition, action | person, situation, state, history)` with calibrated uncertainty and a stated baseline it had to beat.

---

## Round 1: the foundations are a synthesis, not a theory

**Weakness.** The Intuition Stack can explain any behavior after the fact by picking a layer. A framework that cannot be wrong cannot improve prediction. The evolutionary "asymmetry" question is the worst offender: cheap to tell, hard to test.

**Weakness.** It is a snapshot. Nothing in the protocol says how long a state lasts, how fast it decays, or how yesterday's mood carries into today. Emotional inertia (Kuppens 2010) predicts depression; hedonic adaptation differs sharply by event (Luhmann et al. 2012, 188 publications, ~65,900 people: cognitive well-being shifts more and longer than affect; event effects do not follow desirability); sadness lasts longest of 27 emotions and shame, disgust, fear, surprise are among the shortest, with rumination the mediator (Verduyn & Lavrijsen 2015). None of this was in the framework.

**Weakness.** It has no account of the situation. Behavior is person × situation, and the situation side had no structure beyond "cues" and "audience". Situation strength (Meyer, Dalal & Hermida 2010: constraints, consequences, clarity, consistency) governs how much personality shows at all; the DIAMONDS taxonomy (Rauthmann et al. 2014: Duty, Intellect, Adversity, Mating, pOsitivity, Negativity, Deception, Sociality) gives eight dimensions people reliably use to describe situations.

**Weakness.** It predicts wanting, not doing. The single best predictor of behavior is past behavior in the same context (habit literature; Ouellette & Wood 1998), and intentions translate to behavior weakly: a medium-to-large change in intention (d = 0.66) yields a small-to-medium change in behavior (d = 0.36), less when the person lacks control (Webb & Sheeran 2006). The protocol never asked "what did they do last time" or "can they actually do it".

**Fixes applied.**
1. **Question 0** added to the protocol, before the layers: *base rate and constraints*. What has this person done in this exact context before? What does the population do (time-use and panel data)? Can they, may they, and how strong is the situation? A prediction must state the baseline it beats.
2. **Situation schema** added (`framework/situation-schema.yaml`): DIAMONDS, four strength facets, cues, audience, stakes, time pressure, novelty, choice set, constraints, the person's history in this context, and physical conditions.
3. **Time** enters in three places: `drives_dynamics` (already added), emotion duration priors in the ontology (Phase B1 task: a `typical_duration` column seeded from Verduyn's ordering), and adaptation curves per life event (Luhmann) in the person model for predicting trajectories after marriage, bereavement, unemployment, childbirth.
4. **Falsifiable commitments**, written down so they can lose:
   - For reactions within hours, state variables (sleep, hunger, stress, recent arousal) explain more variance than the Big Five.
   - For actions, past behavior in a matching context beats every trait and state predictor combined.
   - Stated reasons predict a person's next action worse than the cue-and-state reconstruction does. Dear You's outcome logs test this directly.
   - Trait effects shrink as situation strength rises; in strong situations, person features add little.
   - Once a person has about thirty logged observations, a person-specific model beats the population model for that person (Fisher et al. 2018 found between-person variance up to four times within-person variance; Beck & Jackson 2021 found the best predictors vary widely across people).
5. **Ethology framing.** Tinbergen's four questions (mechanism, ontogeny, function, phylogeny) are the honest scaffold for the protocol: L0 to L5 are mechanism, history and development are ontogeny, the asymmetry question is function and phylogeny. Function-level answers are kept but labeled as such and never counted as evidence on their own.

---

## Round 2: the ontology and schemas are expert priors dressed as data

**Weakness.** 211 hand-assigned coordinates with a few near-duplicates (dejection, discouragement, melancholy) and an English-centric culture layer. Too many ids for human annotation; the consistency losses assume linear mappings; no durations; no action tendencies beyond approach or avoid.

**Weakness.** The person schema treats traits as points. Fleeson's density-distribution view: a trait is a *distribution* of states a person shows across situations; the mean is the trait, the variance is a trait too. Two people with the same mean extraversion differ in how often they are quiet. The schema also lacked fields the prediction literature says matter: chronotype, medications (SSRIs, beta blockers, hormonal contraception shift affect), pain, financial and time slack, decision style, conflict style, vocational interests (interest congruence correlates ~0.32 with performance, Nye et al. 2017), routine and schedule, social network size.

**Fixes.**
1. Ontology: mark canonical ids and variants (Phase B1); annotate hierarchically (tier-1 first, refine second); add `typical_duration_hours` and `rumination_prone` columns from Verduyn; add `action_tendency` beyond approach or avoid (confront, withdraw, seek comfort, display, repair, inform).
2. Person schema: traits as `{mean, sd}` where ESM-style data exists; new fields listed above added as a `constraints_and_rhythms` block in B1; elicitation ordered by expected information gain so a profile reaches the minimum viable set in the fewest questions.
3. Situation schema is the missing half of every record; from now on every training example and every product question carries one.

---

## Round 3: the ML plan is one big model where a layered system would be more honest

**Weakness.** A single fine-tuned LM produces all heads. Centaur shows this works for choice prediction, and EmoLLMs for affect, but monolithic LMs calibrate poorly, cannot say which baseline they beat, and hide the base rate.

**Weakness.** Stage E (2,000 people × 25 situations) is the only idiographic ground truth, is expensive, and does not exist yet. Meanwhile there are large, public, longitudinal datasets with exactly the (person, event, affect) structure the model needs, and the plan ignored them.

**Weakness.** The "interested in me" question is treated as predictable from profiles. It is not. Random forests on more than 100 traits and preferences could predict how desirable a person is and how desiring, but **not unique desire for a specific partner** (Joel, Eastwick & Finkel 2017). Unique attraction lives in dyadic behavioral signals, not in either profile.

**Fixes.**
1. **Layered engine.** The LM extracts structured person and situation features and writes narrative; a calibrated probabilistic layer (hierarchical Bayesian or gradient-boosted models over schema features) produces the numeric heads and the probabilities; a **cohort engine** (nearest neighbors over panel and survey respondents) supplies the outside-view baseline ("people like this, in situations like this, did…"); the LM then explains the gap between baseline and prediction. Every answer reports baseline, person-specific adjustment, and skill over baseline.
2. **New ground truth, mostly free.**
   - Panels with personality, life events, and affect over years: SOEP (Big Five in 2005, 2009, 2013, 2017; ~14,700 people in the personality-and-life-events analyses), Understanding Society, HILDA, GSS panels. These are adaptation curves and trait-by-event interactions at scale.
   - Global Preferences Survey (Falk et al. 2018): 80,000 people, 76 countries, validated measures of patience, risk, reciprocity, altruism, trust; public. Within-country heterogeneity exceeds between-country. This is the values-and-preferences prior per culture and age.
   - American Time Use Survey: activity base rates by demographic and hour; the Question 0 population prior for "what are they doing right now".
   - Experience sampling: K-EmoCon (self, partner, and observer labels every five seconds; shows how far the three disagree), plus longitudinal passive-sensing datasets (verify StudentLife and GLOBEM access terms).
   - Text with affect labels and outcomes: LiveJournal mood corpus (815k posts, 132 self-chosen moods), the 20,000-letter Dear Abby corpus (situation, question, expert reply), Reddit relationship and AITA threads with UPDATE posts (prediction then outcome; licensing to check), the Joel speed-dating data on the UK Data Service.
   - Decision datasets already listed: Twin-2K-500, Psych-101, choices13k.
3. **Biography benchmark.** Public-domain diaries, letters, and biographies of well-documented historical figures give decades of idiographic text with known later decisions. Train on the first half of a life, predict the documented choices in the second half. No consent problem, rich individual data, hard hindsight ground truth, and a natural authoring source for Track D characters. Mass Observation diaries are the licensed extension.
4. **Baselines and skill scores.** Every metric is reported against (a) the population base rate, (b) the cohort engine, (c) the person's own past behavior. Forecasting-tournament discipline: Brier and log scores, outcomes logged over time, calibration curves per question type.
5. **Relational questions** use dyadic signals (who initiates, response latency, reciprocity, shared activities) and are capped at the ceiling the speed-dating result implies; profiles set only the base rate.

---

## Round 4: the product's value was asserted, not argued

**Weakness.** A user could paste notes into any chat model and ask the same questions. The spec listed features, not the reason to come back.

**Weakness.** One-sided profiling of people who have not been told is the uncomfortable default; the invite was optional.

**Fixes: three sharper value propositions.**
1. **A kind learning environment for reading people.** Hogarth's distinction: intuition improves only where feedback is fast and clear, and social judgment is the archetypal wicked domain. Dear You turns it kind: you forecast, you log what happened, you get scored. The product keeps a **calibration profile of the user** ("you overestimate others' anger by about 20%; your read on who will cancel plans is well calibrated"). The engine's predictions are a means; the user's trained intuition is the end. This is the thesis of Track A delivered as a product.
2. **Message rehearsal.** Paste a draft message; see the predicted reaction (emotion vector, likely reply, action distribution) for this person given their state, with counterfactual edits ("remove the second sentence and predicted defensiveness drops"). High frequency, high stakes, clearly beyond a generic chat model because it uses the longitudinal profile and the situation schema.
3. **Two-sided by default.** Couples, close friends, co-founders, parent and adult child: both fill their own profiles, both can ask about the other, both see what the other asked at a category level. "Dear Me" is the single-player version: a profile of yourself, forecasts of your own reactions, and a running correction for your impact bias (people overestimate the intensity and duration of future feelings). One-sided notes remain possible but become the secondary mode, with the invite surfaced from the first note.

Supporting changes: "what would help most to know" suggestions ordered by information gain; forecast reminders tied to upcoming interactions; low-friction voice notes; a weekly calibration summary as the retention hook. The product is a relationship instrument, and that is the positioning.

---

## Round 5: characters and export need bounded emergence and a buyer

**Weakness.** Studios do not want emergent emotion that breaks scripted beats. Players want believability, directors want control.

**Weakness.** Open 1 to 4B weights with a person-schema interface are dual-use for real-person profiling. The license helps little once weights are out.

**Fixes.**
1. **Director constraints**: per-scene bounds on drive ranges and on the action distribution; the engine proposes within bounds; a "beat lock" pins an emotion trajectory while the fast loop still animates variation around it.
2. **Social situations for NPCs** use the same situation schema; DIAMONDS and strength apply to a tavern or a battlefield as much as to an office.
3. **Training simulations as the first educational use**: de-escalation training, clinical and nursing empathy, difficult-conversation practice. Evaluation is clear (learner outcomes) and the emotional realism is the point. Games follow.
4. **Historical characters** authored from the biography benchmark give studios and educators deeply grounded personas.
5. **Export realism**: open T2 and T3 ship without any person-profile ingestion tooling; the released synthetic corpus is character-only; the model card states plainly that misuse for real-person profiling is possible and prohibited. That is the honest limit of what weights can enforce.

---

## The predictability spectrum (what to promise)

| Target | Predictability | Evidence |
|---|---|---|
| Where someone will be next hour | very high; 93% theoretical upper bound from mobility entropy | Song et al. 2010 |
| Routine actions in a stable context | high; habit and base rate dominate | Ouellette & Wood; Wood & Neal |
| Activity by time of day for a demographic | high at population level | ATUS |
| Personality from behavioral residue | moderate; r ≈ 0.37 to 0.56 | Stachl 2020; Youyou 2015 |
| Emotional reaction to a known event | moderate; appraisal and state explain much, inertia and duration add | crowd-enVent, Kuppens, Verduyn |
| Aggregate choices of a crowd | moderate; neural signals in 30 people forecast market outcomes behavioral self-reports miss | Genevsky, Yoon & Knutson 2017 |
| Whether a person will act on an intention | low to moderate; d = 0.36 behavior change per d = 0.66 intention change | Webb & Sheeran 2006 |
| Whether a specific person will desire a specific other | near zero from profiles | Joel, Eastwick & Finkel 2017 |
| Whether someone is lying, from their face or voice | 54% against 50% chance | Bond & DePaulo 2006 |
| Life outcomes years ahead | low even with thousands of variables | Salganik et al. 2020 |

The engine promises accuracy in proportion to this table and says which row a question belongs to.

---

## New ideas, ranked by value over cost

1. Question 0 and the situation schema (done; cheap; changes every prediction).
2. Cohort engine over public panels and the Global Preferences Survey (cheap; gives baselines and explanations).
3. User calibration profile and forecast-outcome loop (the product's reason to exist).
4. Message rehearsal (the daily-use feature).
5. Biography benchmark (novel; consent-free idiographic ground truth; feeds characters).
6. Two-sided mode as default (resolves the ethics and improves data).
7. Emotion duration and adaptation curves in the ontology and person model (small, high leverage for "how long will they feel this").
8. Training simulations as Track D's first educational use.
9. Traits as state distributions (Fleeson) once ESM-style data exists.
10. Neuroforecasting as a research collaboration: small-sample neural signals forecasting aggregate reactions to content, for calibrating population priors.

## What was dropped or demoted

- Nudge and choice-architecture effect sizes: after publication-bias correction the average nudge effect ranges from about d = 0.03 to 0.31 (Gelman and colleagues' letter; Maier et al.), and field trials at scale show 1.4 percentage points (DellaVigna & Linos 2022). Kept as small, context-dependent drivers; removed as a headline lever.
- Ego depletion as a mechanism: multi-lab registered replication near zero (Hagger et al. 2016). Fatigue effects on judgment are kept through sleep and glucose state, not "willpower reserves".
- Childhood self-control as destiny: the Dunedin gradient is real (Moffitt 2011) but the marshmallow effect roughly halves with controls (Watts, Duncan & Quan 2018; re-reanalysis contested). Childhood fields stay moderate-evidence priors.
- Weather as a mood driver: small on average with large individual differences (Denissen 2008); kept in state only as a per-person learned sensitivity.
- Face-based emotion inference: confirmed excluded on scientific grounds (Barrett et al. 2019) as well as policy.
