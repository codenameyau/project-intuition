# Comparative connectomes: what every mapped nervous system teaches about intuition

`02-biological-substrate.md` covered the four headline datasets (C. elegans, FlyWire, MICrONS, H01). This document widens the view to every nervous system with a complete or substantial wiring diagram, plus the whole-brain activity recordings that go with them, and extracts the lessons that change how the Intuition Stack and the predictive model should be built.

## 1. The census

| Organism | Neurons mapped | Type | Year | What is special |
|---|---|---|---|---|
| **C. elegans hermaphrodite** | 302 (460 nodes incl. muscles) | whole animal, EM | 1986, corrected 2019 | first connectome; both sexes now |
| **C. elegans male** | 385 (579 nodes) | whole animal, EM | 2019 | sex-shared neurons differ in connection strength |
| **C. elegans across development** | 8 isogenic individuals, L1 to adult | whole brain, EM | 2021 | the only developmental connectome series |
| **Pristionchus pacificus** (predatory nematode) | pharynx (homologous to C. elegans) and brain | EM | 2013, 2019, 2024 preprint | same neurons, rewired for predation |
| **Ciona intestinalis larva** (chordate) | 177 CNS neurons, 6,618 synapses | whole CNS, EM | 2016 | smallest chordate brain; 2.7-step average path; left-right asymmetric |
| **Platynereis dumerilii larva** (annelid) | >9,000 cells incl. neurons | whole body, EM | 2024 | third whole-body connectome; no gap junctions found |
| **Drosophila larva** (first instar) | 3,016 neurons, 548,000 synapses | whole brain, EM | 2023 | recurrent, multisensory, "deep-learning-like" shortcuts |
| **Drosophila adult (FlyWire)** | ~140,000 neurons, ~54.5M synapses | whole brain, EM | 2024 | first complete adult brain; simulated to predict behavior |
| **Hydra** | few thousand neurons | whole-animal calcium imaging | 2017, 2020 | no brain; separate circuits per behavior in two nerve nets |
| **Larval zebrafish** | ~100,000 neurons | whole-brain light-sheet imaging; whole-brain EM (projectome) | 2013–2018 | activity of a whole vertebrate brain during behavior |
| **Zebra finch HVC** | local EM volume | partial | 2017 | sequence generation by chained excitation within local inhibition |
| **Mouse visual cortex (MICrONS)** | ~75,000 neurons with activity, 523M synapses | 1 mm³, EM + function | 2025 | like-to-like wiring rule; transcriptomic types predict connectivity |
| **Mouse whole brain (mesoscale)** | 213 regions, projection-level | tracer, not synaptic | 2014 | small-world, hierarchical modules |
| **Mouse whole brain (cell atlas)** | 5,322 transcriptomic clusters | spatial transcriptomics | 2023 | the index from gene expression to cell type |
| **Human temporal cortex (H01)** | 57,000 cells, 150M synapses | 1 mm³, EM | 2024 | multi-synapse axons; only human nanoscale fragment |
| **Human whole brain (HCP)** | ~400 regions, functional connectivity | MRI | 2015 on | individual connectome fingerprints predict cognition modestly |
| **Octopus** | ~500M neurons, two thirds in arms | partial imaging, vertical lobe ~25M neurons | ongoing | distributed control without a single center |

Every entry is tier A as a dataset. What follows are the inferences, tiered individually.

## 2. Lessons, and where they land in the framework

### Lesson 1. Individuality exists without genetic difference (tier A)

- Isogenic flies raised identically show persistent individual differences in turning bias, light preference, temperature preference, odor preference, and learning ability; silencing specific central-complex neurons *increases* the variability, so the brain actively regulates how individual an animal is (de Bivort lab; Buchanan et al. PNAS 2015; Smith et al. 2022).
- Isogenic C. elegans tracked for their whole 50-hour development show stable individual foraging styles; serotonin removal collapses individuality, dopamine, NPR-1, and DAF-7 shift it at specific stages (Stern, Kirst & Bargmann, Cell 2017).
- Eight isogenic C. elegans connectomes differ substantially in connectivity; synapses are rarely deleted, instead other connections are strengthened around them (Witvliet et al., Nature 2021).

**Consequence for the person model.** "Personality" is present at 302 neurons and is partly developmental noise plus neuromodulatory tone. No amount of demographic or even genomic data will recover it; it has to be observed. This is the mechanistic reason the person schema requires idiographic blocks and why the output states `individual_vs_population`.

### Lesson 2. Sex differences are real at the synapse and small in behavior (tier A for the worm, B for the inference)

- C. elegans sexes share most neurons, but a substantial number of connections in shared central pathways differ in strength, and some shared neurons differ in structure (Cook et al., Nature 2019).
- Mouse VMHvl has 17 transcriptomic cell types, several sexually dimorphic or sex-specific, yet few map cleanly onto behavior (Kim et al., Cell 2019). Esr1+ VMHvl stimulation drives attack in males and mostly investigation in females (Lee et al., Nature 2014).

**Consequence.** Keep `sex` as a weak prior with small effect sizes (matching the human meta-analyses: d mostly under 0.3). Expect sex to modulate specific drive circuits (LUST, RAGE, CARE gain) rather than general affect.

### Lesson 3. Development stabilizes the decision core and remodels the periphery (tier A)

Across C. elegans development the central decision circuitry stays intact while sensory and motor pathways are heavily remodeled, and the network becomes more feedforward and more modular (Witvliet 2021). Human adolescence shows the same shape at the regional scale.

**Consequence.** Model `age` as changing *which inputs reach the core and how reflexive the path has become*, not the core valuations. This matches the positivity effect being driven by attention and time horizon rather than by different feelings.

### Lesson 4. Evolution rewires homologous neurons to produce new instincts (tier A)

Pristionchus pacificus has the same identified pharyngeal neurons as C. elegans, but massively rewired, and it hunts other nematodes (Bumbarger et al., Cell 2013; Hong et al., eLife 2019). The whole-brain comparison finds a conserved nematode core connectome with wide-ranging changes around it.

**Consequence.** Species-level intuitions (what counts as food, as threat, as disgusting) are wiring, not learning. In humans this is the evolutionary ASYMMETRY question in the protocol and the DISGUST drive's three domains. It also warns against assuming "same neurons, same function" across species, which limits how far mouse circuits transfer to people.

### Lesson 5. Internal states are scalable, persistent, genetically indexed populations (tier A in mouse and fly)

- Esr1+ VMHvl neurons: weak stimulation gives sniffing and mounting, strong gives attack, within one encounter (Lee et al. 2014). Aggression training produces LTP in these cells and 75% of mice stay aggressive 90 days later.
- Fly P1 neurons promote both courtship and aggression in a threshold-dependent inverse manner, and their activation creates a minutes-long internal state carried by downstream pCd neurons, not by P1 itself (Hoopfer et al. eLife 2015; Jung et al.).
- Two weeks of social isolation, but not 24 hours, up-regulates the neuropeptide Tac2 brain-wide; it produces aggression via hypothalamus and persistent fear via amygdala, separably; blocking its receptor reverses both (Zelikowsky et al., Cell 2018).
- Preoptic hypothalamus: ~70 neuronal types; parenting, aggression, and mating each activate discrete populations, differently in mothers and fathers (Moffitt et al., Science 2018).

**Consequence.** The L1 drive layer is not a metaphor. Drives are graded (intensity scales output), persistent (a state outlasts its trigger via a separate holding population), separable (one neuropeptide, two behaviors, two regions), and gated by social history (isolation duration). The output schema's drive vector should be read as graded activations, and the next schema revision should add per-drive time constants. The isolation result is direct biological grounding for the PANIC/GRIEF → RAGE and FEAR coupling in the playbooks.

### Lesson 6. Recurrence and shortcuts, not pure feed-forward (tier A)

The larval fly brain is highly recurrent; the most recurrent circuits are the inputs and outputs of the learning center; there are multilayer shortcuts and nested loops that resemble modern deep-network motifs (Winding et al., Science 2023). The adult fly model that predicted taste-to-feeding was feed-forward enough to work without learning, but that is the simplest reflex arc.

**Consequence.** Fast intuitions are recurrent integration that has converged, not a lookup. Shortcuts in the wiring are the structural version of heuristics: direct paths from sensory to motor that bypass the learning center. For the ML plan, this supports giving the model a reasoning trace (recurrence) even for fast judgments, and training it to know when the shortcut answer suffices.

### Lesson 7. State modulates behavior even without a brain (tier A)

Hydra has no central brain and runs behaviors on anatomically separate circuits in two nerve nets; osmolarity reflexively and bidirectionally changes its contraction behavior (Dupre & Yuste 2017; Yamamoto & Yuste 2020). Zebrafish whole-brain imaging finds noradrenergic neurons that detect swim failures and drive a futility state.

**Consequence.** L0 is the oldest layer. Body-state modulation of action predates nervous centralization. Any model that treats body state as optional is wrong at the level of the simplest animals.

### Lesson 8. Sequences are chains (tier B)

Zebra finch HVC generates song timing by chains of excitatory projection neurons embedded in local inhibition (Kornfeld et al., eLife 2017).

**Consequence.** Habits and scripts (L2) have a plausible structural form: chained excitation with inhibitory gating. Interrupting a habit means breaking a chain link, which predicts that habits are most fragile at transitions, consistent with the behavioral literature on context change.

### Lesson 9. Individual human connectomes are identifiable, and weakly predictive (tier A)

Functional connectivity profiles identify individuals from a group of over a hundred and the most individual connections (frontoparietal) are also the most predictive of fluid intelligence, with "a fair amount of error" (Finn et al., Nat Neurosci 2015).

**Consequence.** Even with a brain scan, individual prediction is modest. This sets expectations for the predictive model: a rich text profile is competitive with imaging for predicting behavior, and neither should be sold as individually precise.

### Lesson 10. Control can be distributed (tier B)

Two thirds of the octopus's ~500M neurons are in its arms; the vertical lobe alone holds ~25M. Arms run semi-autonomous programs.

**Consequence.** Mostly a caution against assuming a single executive. In humans the analogue is that gut, immune, and endocrine signaling (the vagus, CTRA gene expression) carry state information the cortex does not originate.

## 3. What changes in the framework

1. `03-framework.md` L1 gets the properties *graded, persistent, separable, history-gated* with the mouse and fly citations.
2. `output-schema.json` next revision: add `drives_dynamics` with a per-drive `time_constant` and `trigger_history` so persistent states can be represented.
3. `09-person-model.md` gains Lesson 1 as the biological argument for idiographic data.
4. `02-biological-substrate.md` points here for the full census.

## 4. What is still missing

- No developmental connectome beyond C. elegans. The claim that human development follows the same stable-core pattern is inference from MRI.
- No complete vertebrate synaptic connectome. Zebrafish is closest (projectome plus whole-brain activity); a synaptic reconstruction is in progress in several labs.
- No comparative connectomes across *individuals* in any vertebrate at synaptic resolution. The within-species variability story rests on worms and flies.
- The octopus and the honeybee have no connectome; both are frequently cited and should not be, beyond the partial data above.
