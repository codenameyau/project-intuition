# The biological substrate: what has actually been mapped

This document separates what is **physically mapped** (whole neurons, synapses, wiring diagrams) from what is **inferred** (fMRI blobs, lesion studies, behavioral effects). The framework leans on both, but the reader should know which is which.

## 1. Complete and near-complete wiring diagrams

| Organism / region | Scale | What it teaches about intuition | Source |
|---|---|---|---|
| **C. elegans** (1986, refined since) | 302 neurons, ~7,000 synapses | Even in a 302-neuron animal, "simple" behaviors recruit brain-wide coordinated dynamics, not single neurons. The wiring diagram alone does not tell you which path runs; activity is needed too. | [UCSF whole-brain imaging](https://www.ucsf.edu/news/2017/10/408246/flashing-neurons-worms-reveal-how-brain-generates-behavior), [Flavell lab encoding atlas, Cell 2023](https://eprints.whiterose.ac.uk/203287/7/Brain-wide%20representations%20of%20behavior%20spanning%20multiple%20timescales%20and%20states%20in%20C.%20elegans.pdf) |
| **Drosophila whole brain (FlyWire, Oct 2024)** | ~140,000 neurons, ~54.5M synapses, 8,400 cell types | First complete adult brain. Explorable at codex.flywire.ai. | [Dorkenwald et al., Nature 2024 (ScienceDaily)](https://sciencedaily.com/releases/2024/10/241002123138.htm), [Champalimaud summary](https://www.fchampalimaud.org/news/first-complete-wiring-diagram-adult-brain-unveiled) |
| **Drosophila simulated brain (Shiu et al., Nature 2024)** | 127,400 neurons, leaky integrate-and-fire | **The single most important result for this project.** A wiring diagram plus a crude neuron model, with no learning, correctly predicted which neurons fire when sugar hits the tongue and which drive proboscis extension. Validated optogenetically. Stimulus → wiring → motor output, with no "decision" step. This is what an intuition literally is at 10^5 neurons. | [Shiu et al., Nature 634:210](https://collaborate.princeton.edu/en/publications/a-drosophila-computational-brain-model-reveals-sensorimotor-proce/) |
| **Mouse visual cortex (MICrONS, Apr 2025)** | 1 mm³, ~200k cells, ~75k neurons with recorded activity, 523M synapses | Largest functional connectome. Wiring rule: neurons that respond to similar features connect preferentially, regardless of distance. Hebbian learning at the structural level: "like wires to like" is how experience becomes priors. | [Nature 640:435](https://www.nih.gov/news-events/nih-research-matters/understanding-how-visual-information-processed-brain), [microns-explorer.org](https://www.microns-explorer.org/cortical-mm3) |
| **Human temporal cortex (H01, Science May 2024)** | 1 mm³, ~57,000 cells, ~150M synapses, 1.4 PB | Only human nanoscale fragment. Found a rare class of axons forming up to 50 synapses on one target, a structural basis for a few connections having outsized influence. Human cortex is not uniform; some signals are hard-wired to dominate. | [Shapson-Coe et al., Science 384](https://vcg.seas.harvard.edu/publications/20240510-a-connectomic-study-of-a-petascale-fragment-of-human-cerebral-cortex) |
| **Whole mouse brain cell atlas (Allen, Dec 2023)** | ~4M cells, 5,322 transcriptomic clusters, 34 classes | Cell-type diversity is highest in subcortical (ventral) regions, the home of the drive systems. The evolutionarily old parts are not simple. | [Nature 624:317](https://alleninstitute.org/news/scientists-unveil-first-complete-cellular-map-of-adult-mouse-brain) |

**Honest limit:** there is no human connectome. Everything about human intuition at the circuit level is inferred from animal homology, lesions, single-unit recordings in surgical patients, and fMRI.

## 2. Single neurons that have been recorded doing the job

- **Dopamine neurons (Schultz, Dayan & Montague, Science 1997).** Midbrain dopamine neurons in awake monkeys fire to unexpected reward, shift their firing to the predicting cue once learned, and dip below baseline when a predicted reward fails to arrive. This is a reward prediction error, the teaching signal of reinforcement learning. [Paper](https://www.its.caltech.edu/~jkenny/nb250c/papers/Schultz-1997.pdf)
- **Orbitofrontal taste neurons (Rolls).** In macaques, neurons in secondary taste cortex (caudolateral OFC) stop responding to a food the animal has eaten to satiety, but keep responding to other foods. Primary taste cortex does not change. Reward value, not sensation, is computed here. Human OFC activity tracks subjective pleasantness. [Rolls review](https://www.oxcns.org/papers/542%20Rolls%202015%20Taste,%20olfactory,%20and%20food%20reward%20value%20processing%20.pdf)
- **AgRP neurons (arcuate hypothalamus).** Optogenetic activation drives feeding equal to 24 h of deprivation; feeding scales with activation strength. Ghrelin acts on them and raises food *motivation* (lever pressing, blocked by D1 antagonists) without changing *pleasure* (lick patterns). Hunger is a motivational state injected into valuation. [J Neurosci 2016 review](https://pmc.ncbi.nlm.nih.gov/articles/PMC5125214)
- **Concept cells (Quian Quiroga).** Human hippocampal neurons recorded in epilepsy patients respond to a *concept* (the "Jennifer Aniston" cell also fired to her co-star, not to her with Brad Pitt). Abstract, person-level representations exist at the single-neuron level in humans. [Overview](https://fpmaragall.org/en/the-jennifer-aniston-neuron-or-how-do-neurons-remember-and-feel-by-rodrigo-quian-quiroga)
- **Hedonic hotspots (Berridge).** Cubic-millimeter sites in nucleus accumbens shell, ventral pallidum, and parabrachial nucleus where opioid stimulation amplifies "liking" reactions. The much larger dopamine network drives "wanting". Anatomically separate systems. [Nguyen, Naffziger & Berridge review](https://pmc.ncbi.nlm.nih.gov/articles/PMC7978410)
- **Von Economo neurons (anterior insula).** Large projection neurons concentrated in anterior insula and anterior cingulate, proposed by Craig as the substrate of integrated bodily feeling in primates. [Craig 2009 summary](https://carta.anthropogeny.org/node/309633)

## 3. Circuits (lesion, stimulation, imaging)

### Drive systems (subcortical, species-general)
Panksepp's electrical-stimulation program mapped seven affective circuits in homologous subcortical regions across mammals: SEEKING (mesolimbic dopamine, lateral hypothalamus), FEAR (amygdala, periaqueductal gray), RAGE (medial amygdala, hypothalamus, PAG), LUST (hypothalamus, sex steroids), CARE (oxytocin, preoptic area), PANIC/GRIEF (anterior cingulate, PAG, opioid withdrawal), PLAY (parafascicular thalamus, dorsal striatum). Decorticate rats still play; anencephalic infants show primary emotions. [PMC3168430](https://pmc.ncbi.nlm.nih.gov/articles/PMC3168430)

### Interoception → core affect
Posterior insula receives bodily state; mid and anterior insula re-represent it; anterior insula activity tracks *subjective ratings* more than the stimulus itself. Vagus nerve (80% afferent) carries gut signals, including microbiome-derived signals via enteroendocrine "neuropods". [Craig](https://carta.anthropogeny.org/node/309633), [gut-brain review 2025](https://pmc.ncbi.nlm.nih.gov/articles/PMC12293201)

### Valuation
- Nucleus accumbens tracks wanting / desirability; insula tracks price pain; medial PFC tracks bargain (price below expectation). Each independently predicted purchases in Knutson et al. 2007. [Neuron paper](https://web.stanford.edu/~knutson/bad/bk07n.pdf)
- Ventral pallidum scales effort to subliminal reward (coin shown for 50 ms, unseen, still raised grip force). [Pessiglione 2007](https://dericbownds.net/uploaded_images/pessiglione.pdf)
- Medial OFC pleasantness rises with *believed* price of identical wine. Expectation edits experience. [Plassmann 2008](https://pmc.ncbi.nlm.nih.gov/articles/PMC2242704)

### Habit vs goal-directed control
Dorsolateral striatum (putamen) for model-free habit; dorsomedial striatum and PFC for model-based planning. Daw, Niv & Dayan (2005) proposed each system reports its uncertainty and the more confident one takes control. Human habit induction via overtraining (Tricomi 2009) has **contested replications**. [Daw et al.](https://www.princeton.edu/~yael/NN2005.htm), [replication](https://www.biorxiv.org/content/10.1101/2022.12.12.520188.full.pdf)

### Fast threat / affect pathway
LeDoux's subcortical "low road" to the amygdala is well supported in rats; in humans it rests mainly on affective blindsight and is **debated**. Amygdala is nonetheless the most consistent region in negative face evaluation across 29 imaging studies. [Meta-analysis](https://pmc.ncbi.nlm.nih.gov/articles/PMC3594716)

### Social cognition
Right TPJ is selective for reasoning about beliefs; mentalizing network also includes mPFC, precuneus, STS. Observing disgust and feeling disgust activate the same anterior insula voxels. Romantic attraction recruits VTA, accumbens, caudate; pair bonding in voles needs oxytocin/vasopressin acting with dopamine in the same regions. [Saxe & Kanwisher 2003](https://mcgovern.mit.edu/wp-content/uploads/2019/01/Saxe-R.-Kanwisher-N.-2003.-People-thinking-about-thinking-people-fMRI-studies-of-Theory-of-Mind-Neuroimage.pdf), [Wicker 2003](https://www.sfu.ca/~kathleea/docs/phil_435_both_of_us_disgusted_%20the%20common%20neural%20basis%20of%20seeing%20and%20feeling%20disgust.pdf), [Blumenthal & Young 2023](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10295201/)

### Offline simulation
Hippocampal replay during rest predicts later re-planning in humans; Mattar & Daw model replay as prioritized evaluation of trajectories. "Sleeping on it" has a mechanism, even though the "unconscious thought advantage" paradigm itself **failed large-scale replication**. [Momennejad et al.](https://collaborate.princeton.edu/en/publications/offline-replay-supports-planning-in-human-reinforcement-learning/), [Nieuwenstein 2015](https://dlab.sauder.ubc.ca/sjdm/journal/14/14321/jdm14321.html)

### The narrator
Gazzaniga's "interpreter" (left hemisphere) generates causal stories for behavior it did not initiate. No authoritative localization beyond "predominantly left, language-adjacent". [Review](https://pmc.ncbi.nlm.nih.gov/articles/PMC4938250)

## 4. Design principles that fall out of the biology

For the full census of mapped nervous systems (Ciona, Platynereis, larval fly, Hydra, zebrafish, both worm sexes, worm development, predatory nematode, finch, octopus) and the lessons drawn from each, see `12-comparative-connectomes.md`. For gene expression as the index into drive circuits and as a person-level predictor, see `13-genomic-prediction.md`.

1. **Feed-forward is the default.** The fly result shows sensation can reach motor output through fixed wiring with no deliberation. Mammals add modulators (hunger, hormones, learned cue values), not a different architecture.
2. **Like wires to like.** Experience physically biases connectivity toward co-active features. Priors are structural, which is why they are fast and hard to argue with.
3. **A few connections dominate.** Multi-synapse axons in human cortex mean some inputs are built to win. Not every cue is equal.
4. **Old regions are not simple.** Subcortex has the richest cell-type diversity. The drive systems are sophisticated, just not verbal.
5. **Value is state-dependent at the neuron level.** The same food, the same face, the same price excite different firing depending on satiety, hormones, and expectation. There is no context-free preference.
6. **Wanting, liking, and learning are three systems.** They usually agree. When they do not (craving without pleasure, pleasure without pursuit), behavior looks irrational but is mechanistically ordinary.
