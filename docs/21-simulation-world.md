# Track E: the world, a 2D simulation of the people in your life

A top-down 2D world where the people from your Dear You profiles live, keep routines, run into each other, talk, and form or lose relationships, all driven by the behavioral prediction engine. You walk around as yourself by default, or as any character whose profile you hold, and you can talk to anyone. Over time it becomes something new: a social network whose content is not posts but *simulations* of how consented people would act together, grounded in the same evidence-tiered science as the rest of the project.

## 1. Precedent and what this adds

Stanford's generative agents (Park et al. 2023) put 25 agents with one-paragraph identities in the Smallville sandbox, gave them memory streams, reflection, and planning, and got believable emergent behavior: a party got organized, relationships formed. The a16z AI Town port is MIT-licensed and runs on a web stack. That is the shell. What this project adds is the inside: agents whose profiles are 88-field person schemas with provenance; drives with time constants; appraisals computed per event; emotions as a quantified vector that drives face and movement; relationships as explicit state with evidence-based drivers; and honest uncertainty on everything, including which predictions are near-chance.

## 2. What you can do

- **Walk as anyone.** Default: yourself (your Dear You self-profile). Switch to any character whose profile you hold and whose consent tier allows it (section 6). Playing as someone else uses their profile to drive your options and the engine's reactions to you.
- **Talk.** Conversation runs through the engine's slow loop: the character appraises what you said given their profile, state, relationship with you, and the situation schema, returns the full output (emotion vector, inner speech, stated reply, action distribution), and the game renders the reply, face, and body. You can peek at the inner-speech layer or keep it hidden for immersion.
- **Watch.** Time runs; characters follow routines from their schedules and time-use base rates; they meet because they share places (proximity), stay in contact because interactions went well (reciprocity), and grow close through repeated exposure and escalating self-disclosure (Aron et al. 1997 shows closeness can be generated quickly through reciprocal disclosure). Relationships are state variables you can inspect: closeness, trust, liking, conflict, status gap, exposure count.
- **Run scenarios.** "What if Maya and Dev worked on the same team for a month?" The engine simulates and returns distributions, not a story: friendship probability with an interval, the drivers that moved it, and what would change it. Romance scenarios are available only in the tier where both people allowed them, and are shown as *explorations* with the predictability ceiling printed beside them (section 4).
- **Compare to reality.** When something the world predicted later happens or does not, you log it. Both the world's calibration and yours improve, as in Dear You.

## 3. Architecture

```
world state (tilemap, places, schedules, time)
        │
agents  ├─ fast loop (every tick, client): drives with time constants, core affect,
        │     body budget, routine execution, pathing, expression mapping
        ├─ slow loop (on event, server, T2 model): appraisal of the event for this agent,
        │     emotion vector, inner speech, reply, action distribution, memory write
        └─ memory: experiences with valence, importance, recency; relationship state per pair
        │
relationship engine (per pair, per tick/day): updates closeness, trust, liking, conflict
        from interaction outcomes using framework/relationship-schema.yaml drivers
        │
director (optional): bounds on drives and actions per scene; scenario setup; time compression
        │
renderer: 2D sprites; face and posture from valence/arousal/dominance; speech bubbles;
        inspect panels (emotion vector, drivers, relationship state, uncertainty)
```

- **Engine tiers**: T3 affect head and T4 tables in the client for every agent every tick; T2 edge model on the server for events and dialogue, batched; T1 for scenario summaries. A town of fifty agents costs one slow-loop call per salient event, not per tick.
- **Memory and retrieval** follow the generative-agents recipe (recency × importance × relevance), with the experience's valence as importance and the person schema's `cue_history` updated as cues get paired with outcomes.
- **Routines** come from the profile's `history.habits` and, where absent, from time-use base rates for the person's demographic and day type. Question 0 applies to agents too: an agent's most likely next action is what it did last time in this context.
- **Situations** are instances of `framework/situation-schema.yaml`: a bar at night with five people present has different DIAMONDS values and strength than a one-on-one lunch, and the engine's appraisals use them.

## 4. What the science allows the world to claim

| Dynamic | Drivers in the relationship engine | Evidence | What the UI shows |
|---|---|---|---|
| Friendship forms | proximity and repeated exposure (Festinger; mere exposure r ≈ .26), perceived similarity (r ≈ .39), reciprocity, reciprocal self-disclosure (Aron 1997), shared positive affect | A | probability with interval; drivers ranked |
| Friendship persists or dissolves | homophily on race, age, religion, education, occupation (McPherson 2001; dissimilar ties dissolve faster), conflict frequency, support exchange, network layer capacity (Dunbar: ~5 intimates, ~15 close, ~50, ~150) | A/B | layer the pair sits in; dissolution risk |
| Coworker and team dynamics | status gap, duty-heavy situations, interdependence, fairness and proportionality values, conflict style | B | role-fit and friction estimates |
| Romantic attraction | **not predictable from profiles**: random forests on 100+ traits could not predict unique desire (Joel et al. 2017); matching algorithms' compatibility claims are unsubstantiated (Finkel et al. 2012); ideal-preference matching effects worldwide are very small (β ≈ .04, Eastwick et al. 2025); stated preferences do not match revealed choices (Eastwick & Finkel 2008) | A, negative | scenario marked **exploration**; the ceiling printed; no single-pair "will they" number without the interval covering most of the range |
| Relationship quality once together | mostly the person's own perceptions of the relationship (Joel et al. 2020, 43 datasets, *verify figures*); attachment styles; conflict handling | B | quality trajectory with wide band |
| Marriage, breakup, long horizons | life-outcome prediction is weak (Fragile Families); adaptation curves after events are known in shape (Luhmann 2012) | A for limits | shown as narrative exploration, not forecast |

The world never shows a romantic or long-horizon outcome as a prediction. It shows friendship and working relationships as predictions with intervals, and everything else as exploration with the ceiling stated. A simulation that pairs off two real people is entertainment unless they both asked for it, and the UI says so.

## 5. The social network: consent-first, claim-based identity

The long-term idea is right and the usual way of building it is wrong. The usual way is shadow profiles: the system aggregates what different users have written about a third party, probabilistically decides those sketches are the same person, and merges them. That is a dossier on someone who never signed up, with no lawful basis, no access rights, and the specific failure mode that an abuser's notes and a victim's friend's notes end up in one record. It is excluded.

The consent-first way gives the same unification with the subject in control:

1. **Sketches stay private.** What you write about Maya lives in your account. No other user's notes about anyone are ever matched against yours by the system.
2. **Claimed identity.** When you invite Maya and she accepts, she gets an account and her profile becomes a **claimed identity hub**. If Dev also invited her and she accepted his invite, the two invitations resolve to the same verified person because *she* accepted both; unification happens at acceptance, by her action, not by inference.
3. **She controls the merge.** Maya sees that two people hold sketches of her. She can view each (with the writer's consent setting), accept or reject attributes into her own profile, keep the sketches separate, or ask for either to be deleted. Her self-report outranks every observer field.
4. **Multi-perspective accuracy, honestly.** Self, partner, and observer ratings of the same moments disagree (K-EmoCon). Profiles get more accurate not by averaging hearsay but by holding the perspectives separately: Maya as she sees herself, as her partner sees her, as her colleague sees her, each labeled. The engine can use all three and the world can show how differently she appears to different people, which is itself a feature.
5. **The graph is consented edges.** Two people appear together in a simulation only if both have accounts and both have allowed it for each other. Tiers: *none* (I appear only in my own simulations), *friends* (people I have accepted may simulate me in non-romantic scenarios), *open* (romantic and conflict scenarios allowed), with a per-person override. Subjects see who simulated them and how often, at a category level.
6. **Growth.** The network grows the way invitations spread, and every profile in it is self-claimed. That is slower than scraping and it is the only version that is a social network rather than a surveillance product. It also produces the dataset nothing else does: consented, multi-perspective, longitudinal profiles with logged outcomes.

## 6. Consent tiers for characters

| Tier | Who | What the world can do |
|---|---|---|
| **Self** | your own profile | everything, including romance and conflict scenarios |
| **Sketch** | a person you hold notes on who has not accepted an invite | appears in *your* world only; conversation and friendship dynamics; no romance, sexual, or humiliation scenarios; no visibility to any other user; not playable as a character |
| **Friends** | accepted invite, default tier | conversation, friendship, work dynamics in the worlds of people they accepted; playable with their permission |
| **Open** | accepted invite, opted in | all scenario types with the people they chose |
| **Minor** | under 16 | not simulated beyond presence by name |

## 7. Evaluation

- Believability and consistency over long sessions, as in SOTOPIA and its lifelong extension.
- **Calibration of relationship predictions** against logged real outcomes: did the friendships the world rated likely actually form? Brier and skill over the base rate for the pair's layer.
- **Distinguishability**: two characters with different profiles must behave measurably differently in the same scene; collapse is a release blocker, as for Track D.
- **Perspective fidelity**: when a self-profile and an observer sketch both exist, the agent built from each should differ in the ways the observer data predicts, and users should be able to tell which is which.
- **Harm audit**: scenario logs are checked for sexual or humiliating content involving sketch-tier characters (must be zero) and for repeated romance queries about one person (reflection prompt).

## 8. Open questions

- Art and tone: a warm, slightly abstract pixel style keeps characters clearly representations rather than likenesses; no uploaded photos as sprites.
- Whether sketch-tier characters should speak at all, or only act; speaking in a real person's voice without their consent is the hardest case. Current answer: they speak, in the engine's rendering of their register, with an "unverified sketch" marker, and only to the user who wrote the notes.
- Economics: slow-loop calls per event with fifty agents; T2 on device for single-player worlds.
- Whether the world is a mode inside Dear You or a separate app sharing the engine and accounts. Current answer: separate client, shared backend.
