# Sources for the quantitative ontology and the predictive model

Tiers as in `06-evidence-and-sources.md`: A replicated or large-scale; B solid but single-lab, small-N, or preprint; C contested or secondary-only. *(secondary)* marks items confirmed only via abstracts, aggregators, or press during the sweep.

## Emotion taxonomies and dimensions

| Tier | Source | Used for |
|---|---|---|
| A | Cowen & Keltner, *PNAS* 114:E7900 (2017), 27 categories bridged by gradients. [PMC5617253](https://pmc.ncbi.nlm.nih.gov/articles/PMC5617253/) | tier-1 label set; "fuzzy categories on gradients" design. Barrett et al. 2018 reply: categories are conceptual. |
| B | Cowen & Keltner, *American Psychologist*, 28 facial-bodily categories; vocal bursts 24. [PMC6917997](https://pmc.ncbi.nlm.nih.gov/articles/PMC6917997) | expression-side categories |
| A | Demszky et al., GoEmotions, *ACL* 2020. [ACL](https://aclanthology.org/2020.acl-main.372) | 27 + neutral; 58k; soft labels from rater counts |
| A | Jackson et al., *Science* 366:1517 (2019), emotion semantics in 2,474 languages. [ScienceDaily](https://sciencedaily.com/releases/2019/12/191219142735.htm) | valence × arousal universal core; culture-specific layer |
| A | Mohammad, NRC VAD Lexicon, *ACL* 2018, 20k words, best-worst scaling, reliability .95/.90/.90. [PDF](https://www.saifmohammad.com/WebDocs/acl2018-VAD.pdf) | VAD prototypes; demographic differences in ratings noted |
| A | Warriner, Kuperman & Brysbaert, *Behav Res Methods* 45:1191 (2013), 13,915 lemmas. [McMaster](https://macsphere.mcmaster.ca/handle/11375/22965) | VAD prototypes; age/gender/education differences |
| B | Fontaine, Scherer & Soriano (eds.), *Components of Emotional Meaning* (GRID), 24 emotions × 142 features, 27 countries; 7 appraisal factors classify 57%. [OUP](https://academic.oup.com/book/2214), [Ch. 12](https://www.unige.ch/cisa/research/current-specific-research-projects/language-and-culture/grid-book/chapter-12-driving-emotion-process-appraisal-component) | appraisal columns and prototypes |
| A | Troiano, Oberländer & Klinger, crowd-enVent, *Computational Linguistics* (2023), 6,600 texts × 21 appraisals. [Lab page](https://www.ims.uni-stuttgart.de/data/appraisalemotion) | appraisal supervision; GPT-4 appraisal reliability study 2025 |
| B | Ortony, Clore & Collins (OCC), 22 types; Marsella & Gratch EMA. [EMA 2009](https://www.cs.uky.edu/~sgware/reading/papers/marsella2009ema.pdf) | eliciting-condition mapping |
| B | Plutchik wheel and dyads; Parrott (2001) tree; Shaver et al. 1987. [PyPlutchik](https://arxiv.org/pdf/2105.04295) | fine-grained ids and family structure |
| B | Scherer & Wallbott ISEAR *(secondary)* | 7-emotion situation corpus |
| B | Rashkin et al., EmpatheticDialogues (2019), 32 emotions *(secondary)* | dialogue supervision |
| B | MELD (13,708 utterances, 7 emotions), IEMOCAP, CMU-MOSEI, RECCON. [ERC survey](https://arxiv.org/pdf/1905.02947) | conversational and cause data |

## Person factors

| Tier | Source | Used for |
|---|---|---|
| A | Reed, Chan & Mikels (2014), positivity effect meta-analysis, 100 studies. [PDF](https://emocoglab.depaul.edu/publications/journals/Reed_Chan&Mikels_2014.pdf) | age field |
| A | Else-Quest et al. (2012) self-conscious emotions by gender; Chaplin & Aldao (2013) children's expression. [PubMed](https://pubmed.ncbi.nlm.nih.gov/22468881/), [PubMed](https://pubmed.ncbi.nlm.nih.gov/23231534/) | sex field: small effects |
| A | Marengo et al. (2021), *Sci Rep*, primary emotional systems and Big Five meta-analysis; Hengartner et al. (2017); Anglim & Horwood (2020). [DOAJ](https://doaj.org/article/74b07afd7f1f4815891fa0d91eda7ff5) | neuroticism and extraversion weights |
| A | Tsai, Affect Valuation Theory; meta-analysis of cultural variation in affect valuation; Tsai, Miao & Seppala (2007) on religion. [HUJI](https://cris.huji.ac.il/en/publications/a-meta-analytic-review-of-cultural-variation-in-affect-valuation/), [Springer](https://link.springer.com/doi/10.1007/s10902-007-9079-9) | ideal_affect field; culture and religion |
| B | Mesquita et al., culture shapes emotion through situation selection and appraisal. [PMC3569661](https://pmc.ncbi.nlm.nih.gov/articles/PMC3569661) | culture field |
| A | Atari et al. (2023), MFQ-2 validation; 19-nation study. [Abstract](https://www.aminer.org/pub/64b800d53fda6d7f069d10d2/moral-foundations-theory-validation-and-replication-of-the-mfq), [NSF PAR](https://par.nsf.gov/servlets/purl/10531651) | six foundations; second-order structure weak |
| A | Tybur et al., three domains of disgust (see `06`) | disgust_sensitivity field |
| B | Schwartz refined 19 values, PVQ-RR *(not retrieved in sweep; standard instrument)* | values block |
| B | Serapio-García et al. (2023), personality traits in LLMs. [arXiv](https://arxiv.org/abs/2307.00184v4) | synthetic profile generation; multi-trait steering is hard |
| B | Huang et al., PsychoBench, *ICLR* 2024, 13 clinical scales. [arXiv](https://arxiv.org/pdf/2310.01386.pdf) | psychometric evaluation of model personas |

## Person-conditioned prediction and its limits

| Tier | Source | Used for |
|---|---|---|
| A | Binz et al., Centaur, *Nature* 644:1002 (2025); Psych-101, 160 experiments, 60,092 participants, 10.7M choices; Llama 3.1 70B QLoRA. [arXiv](https://arxiv.org/abs/2410.20268), [PubMed](https://pubmed.ncbi.nlm.nih.gov/40604288/) | architecture precedent |
| B | Park et al. (2024), generative agent simulations of 1,052 people, 85% normalized GSS accuracy, interview-based. [arXiv](https://arxiv.org/abs/2411.10109) | idiographic > demographic; retest normalization |
| B | Toubia et al. (2025), Twin-2K-500, 2,058 participants × 500 questions, retest wave, pricing study. [arXiv](https://arxiv.org/abs/2505.17479) | individual-level benchmark with ceiling |
| A | Argyle et al., *Political Analysis* 31:337 (2023), silicon sampling and algorithmic fidelity. [arXiv](https://arxiv.org/abs/2209.06899) | demographic conditioning works at group level |
| A | Santurkar et al., OpinionQA, *ICML* 2023, 1,498 Pew questions, 60 groups; misalignment persists under steering. [PMLR](https://proceedings.mlr.press/v202/santurkar23a.html) | group audit; underserved groups |
| B | Durmus et al. (2023), GlobalOpinionQA. [DeepAI](https://deepai.org/publication/towards-measuring-the-representation-of-subjective-global-opinions-in-language-models) | cross-national audit; stereotype risk under country prompting |
| B | Hewitt, Ashokkumar, Ghezae & Willer (2024), LLMs predict survey experiment effects r ≈ .85 (early version), overestimate effect sizes. [Stanford](https://ai4pb.stanford.edu/projects/predicting-results-of-social-science-experiments-using-large-language-models) | population-level feasibility |
| A | Salganik et al., *PNAS* (2020), Fragile Families Challenge. [Princeton](https://insights.princeton.edu/2020/07/how-predictable-are-life-trajectories) | individual life-outcome limits |
| A | Peterson et al., *Science* 372:1209 (2021), choices13k; 2023 *Nat Hum Behav* critique of dataset noise. [GitHub](https://www.Github.com/jcpeterson/choices13k) | choice prediction data; noise caveat |
| C | 2025 persona study: LLMs capture ~3% of individual variance vs 54% retest *(secondary)*. [report](https://themodelwire.com/article/llms-fail-to-capture-individual-variation-in-large-scale-persona-study-01M1D8SDBMCTBFE76V02YHZXT2) | individual-level warning; verify |
| B | Shortcut-feature critique of LLM social prediction (2025–26 preprints). [ChatPaper](https://chatpaper.com/paper/78756) | audit design |
| B | Kirk et al. (2024), PRISM, 1,500 participants, 75 countries, 8,011 conversations. [arXiv](https://arxiv.org/abs/2404.16019v1) | profile-linked preferences |
| B | Gjurković et al. (2021), PANDORA, 10k+ Reddit users, Big Five + MBTI + demographics. [ACL](https://preview.aclanthology.org/moar-dois/2021.socialnlp-1.12) | trait–text data; within-group variance |
| B | WASSA 2021–2024 shared tasks (Buechel et al. 2018 base; Omitaomu et al. conversations): empathy, distress, emotion, Big Five, IRI, demographics. [2022 findings](https://aclweb.org/anthology/2022.wassa-1.26.pdf) | the only public personality + demographics + affective response corpus |

## Commonsense, norms, values

| Tier | Source | Used for |
|---|---|---|
| A | Hwang et al., COMET-ATOMIC 2020; Sap et al., ATOMIC 2019 (877k inferences; xReact, oReact, xIntent, xWant). [arXiv](https://arxiv.org/pdf/2010.05953) | population-level reaction and action priors |
| A | Forbes et al., Social Chemistry 101 (292k rules of thumb); Emelin et al., Moral Stories (12k). [HF](https://huggingface.co/datasets/demelin/moral_stories) | norm_compat; moral emotions |
| A | Lourie, Le Bras & Choi, Scruples, *AAAI* 2021, 32k anecdotes, 625k judgments, distributional. [AAAI](https://ojs.aaai.org/index.php/AAAI/article/view/17589) | distributional classification head |
| B | Sorensen et al., ValuePrism / Kaleido (218k values over 31k situations; 91% human-rated quality). [arXiv](https://arxiv.org/pdf/2309.00779v2.pdf) | value gating |

## Affective LLMs, benchmarks, theory of mind

| Tier | Source | Used for |
|---|---|---|
| B | Liu et al. (2024), EmoLLMs, 234K instruction samples incl. regression. [HF papers](https://huggingface.co/papers/2401.08508) | training precedent for mixed classification + regression |
| B | Zhang et al. (2024), affective computing in the LLM era survey. [arXiv](https://arxiv.org/abs/2408.04638v2) | landscape |
| B | Sabour et al., EmoBench, *ACL* 2024, 400 items; GPT-4 below human average. [ACL](https://preview.aclanthology.org/setup/2024.acl-long.326) | held-out EI evaluation |
| B | Tak & Gratch (2023), is GPT a computational model of emotion; Broekens et al. (2023), fine-grained affective processing. [arXiv](https://arxiv.org/pdf/2307.13779v1.pdf), [arXiv](https://arxiv.org/abs/2309.01664v1) | LLMs weak on intensity and coping; can run OCC appraisal from prompt |
| B | FANToM, OpenToM, BigToM, Hi-ToM, ToMBench; 2025 ToM survey. [arXiv](https://arxiv.org/pdf/2505.00026) | knowledge block training and evaluation |
| B | Zhou et al., SOTOPIA, *ICLR* 2024; LIFELONG-SOTOPIA 2025. [arXiv](https://arxiv.org/abs/2506.12666v1) | interactive action prediction; GPT-4 judge validity |

## Methods

| Tier | Source | Used for |
|---|---|---|
| A | Zausinger et al., "Regress, Don't Guess", *ICML* 2025, Number Token Loss. [PMLR](https://proceedings.mlr.press/v267/zausinger25a.html) | numeric fields in generated JSON |
| B | Kumar et al. (2023), conformal prediction with LLMs; Xi et al. (2024), calibration vs conformal set size. [arXiv](https://arxiv.org/html/2305.18404v3), [arXiv](https://arxiv.org/abs/2402.04344v3) | calibrated binary/classification heads |
| B | Label distribution learning and annotator-disagreement modeling for emotion (SeedBERT; MSP-Podcast studies). [arXiv](https://arxiv.org/pdf/2211.13196.pdf), [NSF PAR](https://par.nsf.gov/servlets/purl/10345753) | soft-label training and JS-divergence evaluation |
| A | Mohammad et al., SemEval-2018 Task 1. [ACL](https://aclanthology.org/S18-1001.pdf) | intensity regression and ordinal metrics |

## Gaps left by the sweep

- Schwartz PVQ-RR, HEXACO, ERQ, ECR-R, MAIA-2, BIS/BAS, DOSPERT instruments were not retrieved; they are standard and cited by name only.
- Hume AI's 48-dimension semantic-space model was not confirmed from a primary source and is not used.
- Pennebaker essays personality corpus not retrieved.
- Montoya & Insko reciprocity effect sizes still unverified (carried over from Phase 0).
- The "3% of individual variance" figure is from a news summary and must be traced to the paper before it is quoted anywhere outside this repo.
