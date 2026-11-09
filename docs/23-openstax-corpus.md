# The OpenStax corpus

The owner asked for the OpenStax library to be consumed as the open-licensed textbook base. This document records what was found, the license finding that changes how the books can be used, which titles matter and why, and the ingestion plan. The manifest with repositories, collection files, module counts, and chapter mappings is `data/openstax-manifest.yaml`. Ingestion itself is code and waits for the owner's go-ahead.

## 0. Decision

Owner decision, 2026-11-08: **research-only.** The OpenStax corpus is used for evaluation, the textbook exam, research retrieval, and non-commercial research models. No commercial reuse request will be submitted, and nothing from this corpus enters Dear You, closed models, or commercial exports. The commercial training path is open-access primary literature plus concept-level encoding in the schemas.

## 1. License finding (corrects docs/22)

Earlier notes in this repo, and several library guides, describe OpenStax Psychology 2e and Introduction to Sociology 3e as CC BY 4.0. That is out of date. Checked on 2026-11-08:

- OpenStax's licensing help page states that its textbooks are published under **CC BY-NC-SA**, with a Content Reuse Request Form for commercial permission.
- The prefaces of Psychology 2e, Introduction to Sociology 3e, Introduction to Behavioral Neuroscience, Lifespan Development, Introduction to Anthropology, Organizational Behavior, Principles of Economics 3e, and Psychiatric-Mental Health Nursing each state **CC BY-NC-SA 4.0**.
- The `LICENSE` file in `openstax/osbooks-psychology` is CC BY-NC-SA 4.0. Some repositories carry a CC-BY-4.0 SPDX tag (translated editions, Introduction to Business, Physics); the book's own preface governs.

Consequences:

| Use | Allowed? |
|---|---|
| Research evaluation, the textbook exam, retrieval for the explain protocol in research settings | yes, with attribution |
| Fine-tuning a research model released under CC BY-NC-SA | yes |
| Any use inside Dear You, a closed model, a paid product, or Track D commercial exports | **no, without OpenStax permission** |
| Derivative text (summaries that reproduce the book, adapted chapters) | must be CC BY-NC-SA |

So OpenStax is the research and evaluation corpus, not the commercial training corpus. For commercial use the path is the reuse request (Phase B1), and the fallback is open-access primary literature plus concept-level encoding, which is what the schemas already are.

## 2. What is in the library that matters

OpenStax publishes 56 book repositories. Fourteen are relevant; five are central.

| Priority | Book | Modules | Why |
|---|---|---|---|
| 1 | **Psychology 2e** | 105 | learning, emotion and motivation, personality, social psychology, stress and health, disorders: the general backbone |
| 1 | **Introduction to Sociology 3e** | 96 | culture, socialization, deviance and social control, stratification, family, religion, health: the L3 and social-context backbone |
| 1 | **Introduction to Behavioral Neuroscience** (2024) | 106 | neurochemistry, comparative neuroscience, sexual behavior, stress, emotion and mood, rhythms and sleep, homeostasis, neuroimmunology, learning, executive function: a textbook-grade source for L0 to L2 and docs/12 and 13 |
| 2 | **Lifespan Development** (2024) | 100 | stage-by-stage priors for age, attachment origins, bereavement |
| 2 | **Introduction to Anthropology** | 121 | kinship, exchange, food, religion, inequality across cultures: the culture layer |
| 2 | **Organizational Behavior** | 121 | work motivation, groups, leadership, power, conflict, stress at work |
| 3 | Principles of Economics 3e; Principles of Marketing; Population Health for Nurses; Nutrition for Nurses; Psychiatric-Mental Health Nursing; Biology 2e; Anatomy and Physiology 2e; Introduction to Political Science | | economics baselines, the marketer's model of the buyer, social determinants of health, food, clinical vocabulary, gene expression and physiology, political orientation |

Chapter-to-schema mappings for every priority 1 and 2 title are in the manifest. Not relevant: math, physical sciences, accounting, computing, history, writing, and the translated editions.

## 3. What the corpus is for

1. **The textbook exam.** Each chapter's learning objectives and key terms become evaluation items the engine must pass before appraising real situations. Items are written fresh; the books supply the syllabus and the answer key.
2. **Retrieval for research.** The explain protocol can cite a module when it invokes a construct, which makes outputs auditable in research use.
3. **Research fine-tuning.** A CC BY-NC-SA research model trained on the corpus is a legitimate artifact and a useful baseline for the textbook exam. It is not the product model.
4. **Schema completeness audit.** Walking the chapter lists already exposed gaps (filled in docs/22 and the schemas: social context, opportunity structure). Behavioral Neuroscience's rhythms, neuroimmunology, and psychopharmacology chapters argue for chronotype and medication fields in the person schema, scheduled for B1.

## 4. Ingestion plan (gated)

1. Clone the fourteen repositories at pinned commits.
2. Parse each `collections/<slug>.collection.xml` for chapter and module order; convert `modules/<id>/index.cnxml` to markdown with an existing converter; drop exercises unless building the exam.
3. Store chunks with book, chapter, module id, license, attribution link, and commit hash.
4. Generate exam items per chapter; human-review a sample; store as the B1 release gate.
5. Build the research retrieval index.
6. No reuse request: by owner decision the corpus stays research-only.

Nothing above runs until the owner says build.
