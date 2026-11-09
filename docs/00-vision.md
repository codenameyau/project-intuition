# Vision

## One sentence

A behavioral prediction engine that turns what you know about a person into calibrated forecasts of what they will feel, think, and do, and that trains your own intuition by scoring you against what actually happened.

## What it is, in plain words

Humans read each other constantly and badly: 54% on lies, near zero on who will fall for whom, confident and wrong about how long a feeling will last. Reading people is a *wicked* learning environment: feedback is slow, noisy, or never comes, so intuition never calibrates. This project builds the missing feedback loop.

- **The engine** takes a person (a structured profile built from notes, self-reports, and consented data), a situation (encoded on eight dimensions plus strength, stakes, cues, audience, and constraints), and a question. It returns a forecast: drive activations, appraisals, intensities over 211 emotional states, inner speech, the reason the person would give, a distribution over actions, and an answer that is a probability, a classification with a confidence set, or text. Every forecast states the baseline it had to beat and which row of the predictability spectrum the question belongs to.
- **Dear You** is the consumer front end: a journal addressed to the people in your life. You write, it builds the profile with provenance badges, you ask, it forecasts, you log what happened, it scores both of you. The person can be invited to see, correct, and delete what is held. Over time the user's own calibration improves, which is the product's purpose; the model's forecasts are the means.
- **The character engine** is the same model pointed at fictional people: character sheets in the person schema, game events as situations, emotions with time constants driving expression, a stated reason that may not match the felt state. First market: training simulations where emotional realism is the product. Then games.
- **Veracity** is a constrained sub-model: a Bayesian ledger over contradiction with the record, verifiable detail, motive, and the person's base rate, with an interviewer. It mostly says "probably true, weak evidence", which is what accuracy looks like in that domain.

## Why it could work when "AI that understands people" usually does not

1. **It is grounded in mechanism, not vibes.** The Intuition Stack is built from connectomics, circuit neuroscience, affective science, and decision research, with every claim tiered by evidence and the contested ones marked. The emotion target has coordinates (valence, arousal, dominance, appraisals, drives, durations), not just labels.
2. **It is honest by construction.** Baselines first (Question 0), skill scores over base rate and cohort, individual-versus-population stated on every output, a predictability spectrum that says what may be promised, contested science demoted in writing.
3. **It is idiographic.** Isogenic worms and flies have personalities; demographic personas caricature; interviews beat census categories. The engine is built to switch from population to person-specific models as observations accumulate, and the product is built to accumulate them.
4. **It generates its own ground truth.** Forecast, outcome, score. Dear You's logs and invited subjects' self-reports are the dataset no public corpus provides, collected with consent inside a loop that users want for their own sake.
5. **It is consent-first.** Sources are what you know and what the person shares. No scraping, no protected-attribute inference, no faces. This is a product position as much as an ethical one: the two-sided mode is the better product.

## Critical path

Everything depends on one thing: an engine that beats the cohort baseline on held-out individual-level data. Build that first, cheaply, and let it earn the rest.

1. **Engine v0 without fine-tuning.** A frontier model running the explain protocol with the output schema, plus a cohort engine over public panels (Global Preferences Survey, ATUS, SOEP where licensed) for baselines, plus a calibration layer. Evaluate on Twin-2K-500 against its retest ceiling. *Gate: skill over cohort baseline > 0 with calibration error under 0.05 on binary heads, or stop and rethink the person schema.*
2. **Dear You C1 on engine v0.** Twenty users, weekly notes, forecasts, outcome logs, calibration scores. *Gate: half of users still logging weekly after eight weeks and rating forecasts useful, or reposition before building more.*
3. **Ontology grounding and data conversion (B1, B2)** in parallel, because they are cheap and make the fine-tuned engine possible.
4. **Fine-tuned engine (B2 to B4)** only once C1 is generating outcomes, so that the training signal includes real idiographic data. *Gate: fine-tuned student beats engine v0 on the same holdouts.*
5. **Stage E idiographic benchmark** sized by what Dear You has already collected; the expensive participant study fills gaps rather than starting from zero.
6. **Character engine D1 to D2** after the fine-tuned engine exists to distill; training-simulation partner lined up before D2.
7. **Veracity** last among product features, shipped as "consistency check" with the ledger and no probability in the first version. *Gate: cross-domain evaluation and false-accusation rate published first.*

Legal review for third-party data and the two-sided consent flow starts at step 2, not step 5; it is on the critical path for everything the product stores about a person who is not the user.

## Kill criteria

- The engine does not beat the cohort baseline on Twin-2K-500 after two schema revisions: the person schema is wrong, not the model; stop and redesign the inputs.
- Within-demographic prediction variance collapses below real within-demographic variance in any release candidate: do not release; the model is stereotyping.
- Dear You users do not log outcomes: the feedback loop is the product; without it there is a chat wrapper, and the project should narrow to the research engine and the simulation world.
- A veracity release candidate's false-accusation rate at the default threshold exceeds what the ledger's strong channel alone would produce: the weak channels are leaking; cap them harder or drop them.

## What is deliberately not here

Scraping anyone's accounts. Inferring sexual orientation, race, ethnicity, religion, politics, or health. Face recognition or emotion from faces. Manipulation design against a subject or a player. Employment, education, legal, immigration, insurance, or security uses of veracity. Characters portraying living people. Profiles of minors beyond name and dates.

## Open decisions for the owner

- Team and budget: the 34-week plan implies five to eight people; a solo sequence takes the critical path above and roughly doubles the calendar.
- Posture (decided 2026-11-08): **non-commercial**. The project is research, education, and fun. All documents, tables, and model tiers are released under CC BY-NC-SA-compatible research terms with attribution; nothing is sold; no closed commercial tiers. This makes OpenStax and MIT OCW fully usable as training corpora (`docs/23`, `docs/24`).
- Partnerships: the appraisal corpus group (Stuttgart), the Centaur group, the Twin-2K-500 group at Columbia, and a training-simulation buyer for Track D.
- Whether Dear You is run as a small invited research community or opened to the public as a free educational tool.
