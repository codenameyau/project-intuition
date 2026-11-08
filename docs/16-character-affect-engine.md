# Track D: the character affect engine (NPCs and interactive characters)

The same model that predicts what a real person will feel can *generate* what a fictional one feels. Give it a character sheet in the person schema, a stream of game events as situations, and it returns the full output schema every time something happens: drive activations, appraisals, an emotion vector over 211 states, inner speech, the stated reason the character would give, and a distribution over actions. That is an NPC's emotional life, produced by the same machinery and the same evidence base as the human predictions, and exportable as a model that runs inside the game.

## 1. Why this is a natural second use

- The person schema already is a character sheet: identity, personality, values and moral foundations, history, current state, knowledge, goals, relations. Writers fill in the same fields a researcher would.
- The Intuition Stack already is a behavior model: body state biases drives, drives bias valuation, cues trigger wanting, social evaluators judge the player, a predictive model carries priors, feelings get labeled, the narrator produces dialogue that may not match the mechanism. An NPC who says "I'm fine" while the drive vector says PANIC/GRIEF 0.8 is a better character than one who reports its state.
- The output schema already separates felt from expressed (`action.expressed_vs_felt`), which is the difference between a character and a status bar.
- Prior art validates the shape. FAtiMA Toolkit gives Unity agents OCC appraisal, autobiographical memory, and dialogue; studios have shipped serious games with it, and its authors found game writers understood the model but struggled with the emotion concepts, which argues for better authoring tools. EMA (Marsella & Gratch) modeled appraisal dynamics and coping and was validated against human coping instruments. Park et al.'s generative agents produced believable daily behavior from memory, reflection, and planning. This project adds the quantitative emotion target, the drive layer, and the evidence tiers those systems lacked.

## 2. Architecture: two loops

```
                 game events, player actions, world state
                                 │
   ┌─────────────────────────────▼────────────────────────────┐
   │  FAST LOOP (every tick, on device, milliseconds)          │
   │  affect state integrator                                  │
   │   • drives[8] with per-drive time constants and decay     │
   │   • core affect (valence, arousal) as leaky integrators   │
   │   • body budget (fatigue, hunger, pain) from game clock   │
   │   • cue table: stimulus → wanting bump (Pavlovian)        │
   │   • expression mapper: state → face, posture, gait, voice │
   └─────────────────────────────┬────────────────────────────┘
                                 │ on salient event or dialogue request
   ┌─────────────────────────────▼────────────────────────────┐
   │  SLOW LOOP (on event, 100 ms to seconds)                  │
   │  appraisal and cognition model (distilled LM)             │
   │   • runs the seven-question protocol on the event         │
   │   • returns output schema: appraisals, emotion vector,    │
   │     inner speech, stated reason, action distribution,     │
   │     drive impulses with time constants                    │
   │   • writes a memory (experience) with valence and cue tags│
   └─────────────────────────────┬────────────────────────────┘
                                 │
                 behavior tree / utility AI / dialogue system
```

**The fast loop** is a few hundred floats and a handful of difference equations. Each drive `d` evolves as `d(t+1) = d(t) + impulse − (d(t) − baseline) / τ_d`, with `τ_d` from the schema's `drives_dynamics` (FEAR decays in seconds, PANIC/GRIEF in hours, RAGE in minutes unless re-triggered). Core affect is a weighted sum of the drives through the ontology's prototype table. Body budget comes from the game clock and the character's schedule. This loop needs no neural network and runs for every character in a crowd.

**The slow loop** is the Track B model, distilled, fired only on salient events: the player speaks, a goal is blocked, an ally dies, a cue with a learned association appears. It appraises the event *for this character* (goal conduciveness depends on the character's goals; norm compatibility on its moral foundations; agency on who it blames), emits the emotion vector and the cognition fields, and injects drive impulses into the fast loop. Dialogue is generated from `inner_speech`, `stated_reason_likely`, the character's register, and the gap between them.

**Memory.** Each slow-loop output writes an experience record (description, valence, domain, who was present) and updates the cue table: the player's face after a betrayal becomes a FEAR and RAGE cue. Retrieval for the next appraisal uses the same recency, importance, and relevance weighting as generative agents, with the experience's valence as importance.

## 3. What the character sheet needs

The minimum viable profile from `person-schema.yaml` holds: age and culture, Big Five, two or three formative events, active goals, what the character knows and does not know, and its relation to each other actor. Writers add moral foundations and values for antagonists (so their indignation is coherent), disgust sensitivity for horror and survival games, attachment style for companions, and `self_report_style` so characters lie in character. `drives_dynamics` baselines and time constants are the personality knobs that make one character slow to anger and another quick to forgive.

Sensitive fields are ordinary authoring choices for fictional characters; the product-side rules about inference do not apply to invented people. Characters portraying real living individuals are out of scope for this track.

## 4. Expression mapping

The emotion vector drives presentation through the ontology's coordinates, not through hand-made per-emotion animations:

- **Face and body**: valence and arousal select a region of an animation blend space; dominance sets posture openness; the top ontology id adds a signature (the CK27 facial categories map one-to-one to tier-1 ids). Expression is attenuated by the character's `emotion_regulation.suppression` and by audience: the `expressed_vs_felt` field decides how much leaks.
- **Voice**: arousal → rate and pitch variance; valence → brightness; dominance → volume and declarative endings.
- **Gaze and proximity**: `approach` from the ontology sets approach or avoidance of the player; FEAR shortens gaze, LUST and CARE lengthen it.
- **Behavior selection**: the action distribution becomes utility scores in the game's existing utility AI or behavior tree; the engine never bypasses the game's own action set.

## 5. Authoring tools

- **Sheet editor**: the person schema as a form, with the same provenance badges as the product so writers see which fields are set and which are defaults.
- **Scenario tester**: feed an event, see the seven-question trace, the emotion vector, and the dialogue; tweak a field; rerun. This is the explain protocol as a design tool.
- **Consistency linter**: flags characters whose values and history contradict (high loyalty foundation, no attachments) and drive baselines that will never trigger a scripted beat.
- **Narrative gap dial**: how honest the character's stated reasons are, per character, from "says what it feels" to "always deflects".

## 6. Evaluation

| Property | Measure | Reference |
|---|---|---|
| Believability | SOTOPIA-Eval style ratings by players and by a calibrated judge model | Zhou et al. 2024 |
| Consistency over time | believability and goal pursuit across long sessions; LIFELONG-SOTOPIA found both decline for current models | 2025 |
| Emotional coherence | emotion vector agrees with appraisals and drives (the ontology consistency losses, applied at runtime) | this project |
| Reactivity | latency from event to expression change under budget (fast loop under 1 ms per character; slow loop under 300 ms on target hardware) | engineering |
| Authorability | time for a writer to produce a character that passes a blind "is this a person" test | FAtiMA user study as baseline |
| Distinguishability | two characters with different sheets produce measurably different responses to the same event; collapse is a failure | counterfactual test from Track B |

## 7. Relationship to the other tracks

- Uses Track A as the appraisal procedure and the drive theory.
- Uses Track B as the model and the schema; characters are a second domain for the same output.
- Shares the distilled, exportable models described in `17-model-export-and-deployment.md`.
- Feeds back: characters are a sandbox where the full counterfactual sensitivity of the model can be exercised without consent constraints, so they are the cheapest place to find failure modes before the model touches real-person predictions.

## 8. Not in scope for this track

Characters that impersonate real, living people. Companion products that encourage dependence (the PANIC/GRIEF system is a real lever; a character designed to pull it to drive engagement is the manipulation design the standing rules refuse, applied to the player instead of a subject). Emotion generation that bypasses a game's own content and age ratings.
