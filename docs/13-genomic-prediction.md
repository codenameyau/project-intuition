# Gene expression and genomics as predictors

"DNA expression" enters the problem at three levels. They are very different in how much they predict, and conflating them is the commonest error in this literature.

| Level | What is measured | What it predicts | Strength |
|---|---|---|---|
| **Cell** | which genes a neuron expresses (its transcriptomic type) | its identity, connectivity, neurotransmitter, and therefore its circuit function | strong, in animals |
| **Activity** | activity-dependent genes (c-Fos, Arc) expressed after a neuron fires | which neurons were active during a behavior; what the brain *recorded* | strong, in animals |
| **Person** | germline genome (variants, polygenic scores), dynamic expression in blood (transcriptome, methylation) | traits, baseline affect, specific preferences, current stress state | weak to moderate, with sharp caveats |

## 1. Cell level: expression is the index into circuits

Modern circuit neuroscience does not find circuits by anatomy alone. It finds them by **genetic markers**: a gene whose expression defines a population, which can then be recorded, activated, or silenced.

- **AgRP** defines the hunger neurons of the arcuate nucleus; activating them produces feeding equal to a day's fasting (see `02`).
- **Esr1** (estrogen receptor 1) defines the VMHvl population that scales from investigation to mounting to attack with stimulation intensity (Lee et al., Nature 2014).
- **Tac2** (neurokinin B) is up-regulated brain-wide by two weeks of social isolation and is necessary and sufficient for the isolation phenotype; its expression in amygdala drives persistent fear, in hypothalamus drives aggression (Zelikowsky et al., Cell 2018).
- **fruitless** (male isoform fruM) specifies the fly P1 neurons that gate courtship and aggression; a sex-determination gene literally builds the social-decision circuit (Hoopfer et al. 2015).
- **npr-1**: one amino acid (valine vs phenylalanine at residue 215) decides whether C. elegans feeds alone or in groups (de Bono & Bargmann 1998). **foraging** (a cGMP-dependent kinase) separates rover from sitter flies and nurse from forager bees, though a 2014 wild-population study found the fly effect weak outside lab strains.
- **Dpr/DIP** cell-surface proteins in the fly visual system are expressed in complementary, layer-specific patterns in synaptic partners: the molecular code that says which neurons wire to which (Tan et al., Cell 2015; Cosmanescu et al.). Correlational in the data found; functional tests exist in later work.
- **Patch-seq** in mouse cortex: 28 inhibitory and 16 excitatory morpho-electric-transcriptomic types; transcriptomic variation predicts morphology, electrophysiology, and projection targets, and when applied to the MICrONS volume, predicted Sst subtypes have distinct output connectivity rules (Gouwens et al. 2020; Gamlin et al., Nature 2025).
- **Spatial transcriptomics**: ~70 neuronal types in the preoptic hypothalamus; 17 in VMHvl, several sex-specific; 5,322 clusters across the whole mouse brain, with the greatest diversity in the subcortical drive regions (Moffitt 2018; Kim 2019; Yao 2023).

**What this means for the framework.** The L1 drive systems are not folk categories. Each has at least one genetically defined population with a measurable gain. Gene expression is the coordinate system in which the biology of intuition is now written. For a human, we cannot read these populations directly, but the human orthologs of these marker genes are where polygenic signal for affect should concentrate, which is a testable prediction (and is partly borne out: the well-being GWAS implicates subiculum and GABAergic interneurons).

## 2. Activity level: expression records experience

Immediate early genes (c-Fos, Arc) are transcribed within minutes of strong neural activity. Tagging tools (FosTRAP, ArcTRAP) permanently label neurons active in a time window, producing brain-wide maps of which cells participated in a behavior and allowing later reactivation of "engram" populations (reviews: Nature Communications 2019, 2022). Combined with spatial transcriptomics, this is how Moffitt et al. found that parenting, aggression, and mating activate discrete cell populations.

**What this means.** In animals, expression is a readout of what a brain just did, at single-cell resolution. There is no human equivalent beyond coarse imaging. The relevance to the predictive model is conceptual: it is the empirical basis for saying drives are implemented in specific, separable populations whose activation can be measured, which justifies predicting drives as a quantitative vector.

## 3. Person level: what the genome and dynamic expression predict in humans

### 3a. Heritability sets the ceiling, and it is moderate

| Trait | Twin heritability | Source |
|---|---|---|
| Neuroticism | ~48% | GPC twin meta-analysis |
| Subjective well-being | 32–40% | Bartels 2015 (0.36); 13-study meta 0.40 |
| Political attitudes | ~30–40% | Alford, Funk & Hibbing and successors |
| Religiosity (adult) | ~40%, and its *political* role more heritable than its social role | Ksiazkiewicz & Friesen 2019 |
| Disgust sensitivity | substantial, three domains partly distinct | Sherlock 2016 *(not retrieved; cite with care)* |

Half or more of the variance in affective traits is not genetic, and most of the genetic half is not yet captured by any measurable score.

### 3b. Polygenic scores capture a small slice

| Phenotype | GWAS N | Loci | Polygenic score R² | Source |
|---|---|---|---|---|
| Neuroticism | 449,484 | 136 | up to 4.2% (0.6% in 2015) | Nagel et al., Nat Genet 2018 |
| Well-being spectrum (4 traits jointly) | 2.37M | 304 signals | +57% predictive power over univariate | Baselmans et al., Nat Genet 2019 |
| General risk tolerance | 975,353 | 99 | not retrieved; order of 1–2% | Karlsson Linnér et al., Nat Genet 2019 |
| Educational attainment | 3M | thousands | 12–16% | Okbay et al., Nat Genet 2022 |

Three corrections apply before using any of these:

1. **Within-family deflation.** Population GWAS effects mix direct genetic effects with population stratification, assortative mating, and parental (indirect) effects. Within-sibship estimates are substantially smaller for educational attainment, cognitive ability, depressive symptoms, and smoking (Howe et al., Nat Genet 2022; Lee 2018 reported ~40% lower for EA). A score's quoted R² overstates what the DNA itself does.
2. **Ancestry portability.** Prediction decays with genetic distance from the discovery sample; height R² roughly 11% in UK vs 3% in Japan (Martin et al. 2019 and successors). Most GWAS are European-ancestry. A score applied outside its ancestry is close to noise.
3. **Candidate genes failed.** Eighteen depression candidate genes studied at least ten times each, including 5-HTTLPR, were no more associated with depression than random genes in 620,000 people (Border et al., AJP 2019). OXTR rs53576 shows no reliable association with sociality (d ≈ 0.01). Any single-SNP "empathy gene" or "warrior gene" claim is tier C and must not enter the model.

### 3c. Large-effect variants for specific preferences are real

These are the exception: common variants with big, replicated effects on narrow, sensory or metabolic phenotypes, which are exactly the food-and-drink intuitions the playbooks care about.

| Variant | Effect | Strength |
|---|---|---|
| **TAS2R38** (bitter receptor) | bitter sensitivity; vegetable and sweet-food intake; cabbage dislike | A (replicated, modest effect on intake) |
| **ALDH2 rs671** | explains ~29% of variance in alcohol flushing in East Asian samples; shapes drinking, and via drinking, other diet associations | A |
| **CYP1A2 rs762551** | coffee intake in European-ancestry samples; not replicated in Asian samples; a CYP1A2 locus does show in Japanese diet GWAS | B |
| **LCT** (lactase persistence) | milk consumption *(standard; not retrieved in sweep)* | A |
| **FTO rs9939609** | satiety responsiveness in children, food cravings; small and mixed in adults | B |
| **MC4R** rare loss-of-function | hyperphagia *(standard; not retrieved)* | A for carriers, rare |
| **OR6A2** | cilantro "soapy" taste *(23andMe 2012; not retrieved)* | B |
| **AVPR1A RS3** (men) | lower pair-bonding scores in a Swedish twin sample; mixed in later work; vole analogy only | C |

### 3d. Dynamic expression as a state marker

- **Conserved transcriptional response to adversity (CTRA).** Chronic social threat, loneliness, and trauma shift leukocyte gene expression toward pro-inflammatory and away from antiviral genes, via sympathetic β-adrenergic signaling to NF-κB; eudaimonic well-being shows the reverse and dominates loneliness when both are modeled (Cole 2014; Fredrickson et al. 2015). This is the closest thing to a blood readout of L0/L1 state in humans. Tier B: consistent across studies, small samples, correlational.
- **DNA methylation of stress genes (NR3C1, FKBP5).** Direction of effect varies by CpG site; moderated by genotype; recent well-controlled child studies find associations that do not survive multiple-testing correction; cell-type composition confounds blood measures. Tier C for individual prediction.
- **Epigenetic clocks (GrimAge, DunedinPACE).** Mixed associations with stress and psychiatric disorders; conscientiousness is the only personality trait with consistent (slower aging) association across clocks. Not useful for predicting what someone will feel. Tier C for this purpose.
- **Blood transcriptome machine learning for mood.** Exists in mice; in humans the found studies are tiny (N = 10 vs 10). Tier C.

## 4. How to use genomics in the model

Add a `biology` block to the person schema (done in `framework/person-schema.yaml`) with these rules:

1. **Polygenic scores enter as ancestry-flagged z-scores**, never as raw R²-weighted features. The model learns their weight per ancestry; if `ancestry_matches_gwas` is false, the score is masked.
2. **Large-effect variants enter as categorical genotypes** gating specific preference predictions (bitter, alcohol, caffeine, dairy, cilantro). This is where genomics earns its place in the food playbook.
3. **CTRA-type biomarkers enter as state**, alongside hours since meal and sleep, when available (they almost never will be).
4. **Nothing is inferred from ancestry or appearance.** Missing genomic fields stay missing; the population prior is the same as with no biology block at all.
5. **Expected gain is small and specific.** Over a rich idiographic profile, polygenic scores for neuroticism and well-being should add on the order of 1–4% of variance to baseline affect predictions; the preference variants should add more for their specific domains. The design does not depend on either.

### Data sources (all restricted-access or animal)

- **UK Biobank**: genotypes plus neuroticism items, mood questionnaires, diet, alcohol, caffeine; the only large human resource with genomics and affective items. Application required.
- **Add Health, ABCD, Dunedin, Twins Early Development Study**: genotype plus behavior and some emotion measures, longitudinal.
- **Twin-2K-500 and Psych-101** have no genotypes; a genotyped replication of the Twin-2K-500 protocol would be the first dataset that ties PGS to measured emotional reactions to situations, and is proposed as a Track B stretch goal.
- Animal datasets (Allen cell atlas, MICrONS with Patch-seq, hypothalamic MERFISH) ground the drive layer mechanistically but do not train the human model.

## 5. What to refuse

- Predicting emotion or behavior from a person's ancestry, surname, or appearance as a proxy for genotype. The portability data show this is scientifically wrong before it is ethically wrong.
- Any single-gene personality claim. Border et al. 2019 closed that chapter.
- Using genomics in hiring, insurance, lending, or dating contexts. Out of scope for this project regardless of accuracy.

## 6. Summary

Gene expression is the right coordinate system for *circuits*: it is how the drive layer is defined and measured in animals, and it says drives are graded, persistent, separable, and genetically indexed. For *persons*, the germline genome predicts broad affective traits weakly (a few percent) and a handful of sensory and metabolic preferences well; dynamic expression tracks chronic social state coarsely. The model takes all of this, tagged and masked appropriately, and expects the idiographic text profile to remain the dominant signal.
