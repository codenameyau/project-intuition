# Veracity model: estimating whether a statement is true

**Task.** Given a person's record and a text input (a conversation turn, a message, or a described situation), output a calibrated probability that the statement is deceptive, with the evidence that moved the estimate and the questions that would resolve it.

**Design rule.** The most accurate deception model is the one that refuses to be a cue detector. Decades of work show that behavioral and linguistic cues to lying are weak or absent, that human judges reach 54% against a 50% chance floor, and that text classifiers trained on one domain fall to chance on the next. Accuracy comes from four other places: contradiction with what is already known, the density of checkable detail, the motive and stakes of the moment, and the person's own base rate. The model is a Bayesian evidence ledger over those channels, plus an interviewer that proposes the questions most likely to separate truth from lie. Everything else is noise it must be prevented from fitting.

## 1. What the science allows

| Finding | Number | Consequence for the design |
|---|---|---|
| Human lie detection across 206 documents and 24,483 judges (Bond & DePaulo 2006) | 54% | the floor the model must beat and the baseline shown to every user |
| 158 behavioral cues, most near zero (DePaulo et al. 2003); 79 computerized linguistic cues, overall effect small (Hauch et al. 2015); the cue literature is indistinguishable from one with no true cues once publication bias is modeled (Luke 2019) | small to nil | linguistic features are capped, in-domain only, and shrunk toward zero |
| Judges fail because the cues are weak, not because they pick the wrong ones; accuracy improves by making liars and truth tellers behave differently (Hartwig & Bond 2011) | structural | the model is an interviewer first, a classifier second |
| Truth tellers give more verifiable details than liars, g = 0.42 over 20 studies, ratio of verifiable to total details g = 0.49; unverifiable detail counts do not separate the groups (Palena et al. 2021); telling people details will be checked raises truth tellers' detail and not liars' | medium | verifiability channel; the model instructs the user to say details may be checked |
| Strategic Use of Evidence: late disclosure of evidence lifts observer accuracy to 61.7% from 42.9% with early disclosure (Hartwig et al. 2005); unanticipated questions separate rehearsed liars | medium | question-planning channel |
| Content in context improves accuracy (Blair, Levine & Shaw 2010); people default to believing (Levine's truth-default theory) | structural | the situation schema is an input; the model never judges a statement without its context |
| Between-statement consistency barely differs between liars and truth tellers; liars rehearse and repeat; inconsistency becomes diagnostic only under strategic interviewing (Vredeveldt et al. 2014; Masip et al.) | weak | consistency across retellings is *not* a lie cue; contradiction with external facts is a different thing and is used |
| About 60% of people report no lies in a day; roughly 5% of people tell half of all lies (Serota, Levine & Boster 2010; Daiku et al. 2021 replication); Machiavellianism and psychopathy raise lying mainly by lowering guilt | skewed | the person-level base rate matters more than any feature of the statement |
| 81% of online daters misstate something; the average height lie is 2% (Toma, Hancock & Ellison 2008) | frequent, small | lie magnitude is predicted separately from lie presence; most lies are small and self-presentational |
| Diplomacy game dataset: 17,289 messages with sender-labeled actual lies and receiver-labeled suspected lies; the best model, using conversational context and power asymmetry, matches human F1 (Peskov et al. 2020) | ≈ human | context and relationship features are the ones that worked |
| FLAN-T5 trained on two deception domains and tested on a third performs at chance; text models that do well on standard sets fall to chance on DeFaBel, pointing to dataset artifacts (2023–2025) | chance cross-domain | cross-domain evaluation is mandatory; artifact probes are part of the test suite |

## 2. Architecture: an evidence ledger, not a classifier

```
statement + context  ─┐
person record        ─┼─▶ 1. CLAIM EXTRACTION      → list of checkable propositions
situation schema     ─┘           │
                                  ▼
                       2. EVIDENCE CHANNELS (each returns a likelihood ratio with an interval)
                          a. statement–record contradiction      (strong)
                          b. verifiable-detail density and ratio  (medium)
                          c. motive, stakes, opportunity          (medium prior shift)
                          d. person base rate and lie history     (prior)
                          e. dyadic behavioral deviation          (weak, idiographic)
                          f. in-domain linguistic model           (weak, capped)
                                  │
                                  ▼
                       3. BAYESIAN COMBINATION  → P(deceptive), interval, ledger
                                  │
                                  ▼
                       4. INTERVIEWER → questions ranked by expected information gain
                                  │
                                  ▼
                       5. OUTPUT per output-schema.json `veracity` block
```

### 2.1 Claim extraction
The language model decomposes the statement into atomic propositions ("I was at the office until 7", "I didn't see the message", "I've never met her") and tags each as checkable against the record, checkable in principle by the user, or uncheckable (feelings, intentions, private events). Only checkable claims can move the estimate far; uncheckable claims are reported as such.

### 2.2 Channel a: statement–record contradiction (strong)
Each checkable proposition is tested against the person's record in Dear You (accepted attributes, experiences, imported conversations, calendar if shared) and against facts the user supplies. A direct contradiction with a well-sourced fact is the only evidence in the system that can produce a high deception probability. Contradictions are graded by the reliability of the contradicting source and by whether honest error could explain them (memory for dates and times is poor; memory for whether an event happened is good). The ledger shows the contradiction and its source, so the user judges the evidence rather than trusting a number.

### 2.3 Channel b: verifiability (medium)
Counts of verifiable details (named people, places, times, documents, things a third party could confirm) and the ratio of verifiable to total details, compared with the person's own baseline for similar statements. The channel strengthens when the user has told the person that details may be checked; the interviewer suggests saying so. Effect size is medium at best, so the likelihood ratio is bounded.

### 2.4 Channel c: motive, stakes, opportunity (prior shift)
From the situation schema: would the truth be costly (adversity, consequences, audience, reputational or relational stakes)? Is this a politeness context where small lies are the norm? Does the person have the information to be lying about at all? Lies cluster where the truth is a problem; the channel raises or lowers the prior accordingly and never acts alone.

### 2.5 Channel d: person base rate (prior)
Start from the population distribution (most people, most statements, truthful; a small tail of prolific liars). Update with the person's record: confirmed past lies and confirmed truths logged by the user, self-report style, and trait fields that shift the base rate modestly (Machiavellianism, psychopathy facets if present in the profile). A person with no logged history gets the population prior and a wide interval.

### 2.6 Channel e: dyadic behavioral deviation (weak, idiographic)
In imported or captured conversations only: response latency, message length, topic avoidance, and question-dodging *relative to this person's own baseline with this user*. Nomothetic versions of these cues are near zero; the idiographic version is kept small and reported as weak.

### 2.7 Channel f: linguistic model (weak, capped)
A text classifier fine-tuned per domain (negotiation, personal conversation, factual claims), trained with the artifact-robustness suite below, whose likelihood ratio is capped so that it can never move the posterior past about 0.65 on its own. It exists to catch domain-specific regularities, not to detect lies.

### 2.8 Combination
Channels contribute log-likelihood ratios with uncertainty; the posterior and its interval come from a calibrated combination (isotonic or Platt calibration per domain, conformal intervals). The combination is trained to be honest about dependence between channels (verifiability and linguistic features overlap). The output always includes the prior used and the skill over the 54% human baseline.

### 2.9 The interviewer
Given the ledger, rank candidate questions by expected information gain: unanticipated questions about peripheral details of the claimed event; requests for verifiable specifics; strategic use of what the user already knows (ask about it before revealing it); a statement that details may be checked. The interviewer never recommends confrontation and labels every question as a way to resolve uncertainty, not to catch someone.

## 3. Training data

| Source | Use |
|---|---|
| Diplomacy deception corpus (Peskov et al. 2020; sender and receiver labels, 17,289 messages, relationship and power context) | primary conversational training set; teaches context and relationship features |
| Mafiascum and other social-deduction transcripts *(access to verify)* | conversational lies with known roles |
| UNIDECOR unified deception corpus (2023) | cross-corpus training and the mandatory cross-domain evaluation |
| DeFaBel and similar artifact probes (2025) | the test that the model has not learned dataset artifacts |
| Real-life trial clips (121; Pérez-Rosas et al. 2015) | text transcripts only; small; evaluation, not training; prior high-accuracy claims on it are methodologically flawed |
| LIAR political claims | factual-claim domain only; not interpersonal |
| Verifiability-approach stimulus sets (Nahari, Vrij and colleagues) | supervision for the verifiable-detail counter |
| **Synthetic contradictions from records** | self-supervised: take a person's record, generate statements consistent with it and statements that contradict one fact, train the claim-extraction and contradiction channels at scale with no human lie labels |
| **Dear You outcome logs** | the only real-world idiographic ground truth: statements the user later confirmed true or false, with the full context; consented, pseudonymized, calibration only unless release opt-in |

## 4. Evaluation

- AUC and Brier per domain, and cross-domain (train on all but one corpus, test on the held-out one); the cross-domain number is the one that matters.
- Calibration curves; a model that says 0.8 must be wrong about 20% of the time.
- Artifact probes: performance on DeFaBel-style sets must not exceed what the ledger channels justify.
- Skill over baselines: population base rate, the 54% human rate, and a verifiability-count-only model.
- **False accusation rate** at every operating point, reported first. The cost of calling a truth a lie in a relationship is higher than the reverse, and the default threshold reflects that.
- Channel ablations published, so users and reviewers can see that the strong channel is contradiction and the weak ones are weak.

Expected performance, stated in advance: with a contradiction against a reliable record, high accuracy on that claim; with verifiable-detail and motive evidence only, modest skill over base rate, on the order of what strategic interviewing achieves in the literature (roughly 60 to 70% in favorable conditions); with text alone and no record, near the human baseline and reported as such. Any result far above these in testing is treated as an artifact until it survives the cross-domain and probe suites.

## 5. Output

The `veracity` block in `framework/output-schema.json`: `p_deceptive`, interval, prior used, per-claim table (claim, checkability, verdict channel, contradiction source), channel ledger with likelihood ratios, interviewer questions ranked, skill over baseline, `individual_vs_population`, and a `confidence_statement` written in words ("No checkable claim contradicts what you've recorded. The statement has few verifiable details, which is weak evidence. Base rate for this person and context: mostly truthful.").

## 6. Limits and rules

- **No audio, video, face, voice, or physiology.** Facial configurations do not reliably signal emotion (Barrett et al. 2019) and polygraph-type inference is both scientifically weak and, under the EU AI Act, high-risk in law enforcement and migration contexts; emotion inference is prohibited in workplaces and education. Text and records only.
- **Not for employment, education, legal, immigration, insurance, or security screening.** The model exists for personal understanding and for the research track. These uses are refused in the product and prohibited in the model license.
- **Never a verdict.** The product never shows "lying" or "truthful". It shows the ledger, the probability with its interval, the human baseline, and the questions that would resolve it.
- **Contradiction is shown, not asserted.** When the strong channel fires, the user sees the record entry that conflicts and decides whether it is reliable and whether honest error explains it.
- **Relationship guardrail.** Repeated veracity queries about one person without logged outcomes trigger the same reflection prompt as repeated interest queries. Suspicion is the product's most dangerous failure mode, and a well-calibrated model mostly answers "probably true, weak evidence", which is the correct and least satisfying answer.
- **Subjects can see it.** An invited subject sees that consistency checks exist and how many have been run, at a category level.
- **Minors** are excluded from veracity assessment entirely.

## 7. Why this is the accurate design

A lie detector that reads words and faces is competing against an effect that may not exist. A model that asks "does this contradict what we know, is it checkable, did they have a reason, and does this person lie much" is competing against nothing harder than careful thinking, and it can be calibrated. It will say "I don't know" often. That is what accuracy looks like in this domain, and it is the only version of this feature that will not harm the people it is used on.
