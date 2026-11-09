# Open courseware: MIT OpenCourseWare and Harvard's free catalog

The owner asked for a plan to consume both. They differ sharply in what the law allows, and the project's non-commercial posture (section 1) settles the rest. Manifest: `data/open-courseware-manifest.yaml`. Nothing is ingested until the owner says build.

## 1. Non-commercial posture (owner statement, 2026-11-08)

The project is for research, education, and fun. It is not commercial. This changes the licensing analysis across the repo:

- Every CC BY-NC-SA source (OpenStax, MIT OCW, Noba, Stangor's social psychology text) is now **fully usable**: for evaluation, for retrieval, and for fine-tuning the project's own models, provided every derivative (including released weights trained on the text) is shared under CC BY-NC-SA with attribution. The NonCommercial clause no longer bites.
- Harvard's free courses remain **not ingestible**, because edX's terms grant only personal use within the course and forbid copying, redistribution, and derivatives. Non-commercial status does not change a terms-of-service restriction.
- Copyrighted textbooks (the eight in `docs/22`) remain design sources and exam syllabi; non-commercial status does not license their text either.
- The "closed API" tiers, pricing, B2B licensing, and commercial exports described earlier are retired (see section 5 and PLAN). All models and products of this project are released under CC BY-NC-SA-compatible research terms.

## 2. MIT OpenCourseWare

**License.** CC BY-NC-SA 4.0 for the OCW site's own materials. OCW's terms address AI directly: attribution must appear in training documentation and in any derivative works. Third-party content embedded in courses (textbook excerpts, some figures) is not covered and must be filtered.

**What was verified.** Ten courses with their instructors, terms, and material types, led by Gabrieli's 9.00SC Introduction to Psychology (full lecture videos and notes across 24 topics from brain methods to emotion, personality, development, stress, psychopathology, social psychology, and evolutionary psychology), Kanwisher's 9.13 The Human Brain (videos, notes, podcasts), Schilbach's 14.13 Psychology and Economics (videos, notes, problem sets), Schneider's 9.20 Animal Behavior and 9.14 Brain Structure (audio and notes), Bear and Seung's 9.01, Fee's 9.40 Neural Computation, Schulz's 9.85 infant cognition, Chorover's 9.70 Social Psychology, and the 2006 negotiation course. Several other candidates (Chorover's 9.68 on affect, 15.301 Managerial Psychology, 24.09 Minds and Machines, 9.46 Neuroscience of Morality) returned no page at the slugs tried; the OCW search and department listings are JavaScript-rendered, so enumeration needs a browser session when ingestion starts.

**What it adds that textbooks do not.** Lecture transcripts are *explanations by experts speaking*, with the hedges, caveats, and "we don't actually know" moments that textbooks edit out. That register is exactly what the engine's narrative outputs should learn from. Problem sets and exams with solutions are ready-made evaluation items for the textbook exam. Instructor insights pages describe how the course was taught, which is useful for Track D training simulations.

**Mapping.** 9.00SC and 9.70 feed every layer and the playbooks; 9.13 feeds the methods caveats and the social-perception parts of L3; 14.13 feeds the buying playbook, time and risk preferences, and the demotion of nudges; 9.20 and 9.14 feed the ethology framing and comparative neuroanatomy in docs/12; 9.40 feeds the fast-loop integrators and the view of decision as inference; 9.85 feeds the knowledge block's developmental origins.

## 3. Harvard Professional and Lifelong Learning, free catalog

118 free courses on the day checked, across four pages. Relevant titles: the three-part HarvardX Fundamentals of Neuroscience, Managing Happiness, Building Personal Resilience, The Path to Happiness (Chinese philosophy), Justice and Justice Today, Early Childhood Development, Child Protection, Global Health Case Studies from a Biosocial Perspective, The Opioid Crisis in America, Bioethics, the six religions-through-scriptures courses, three leadership courses, and three political science courses.

**License.** edX terms: materials belong to edX, 2U, or the institution; learners get a limited, revocable, personal, non-commercial license to use materials within the enrolled course; no copying beyond that, no redistribution, no derivatives. So:

- No ingestion of Harvard course content.
- Course descriptions and syllabi (public pages) are recorded in the curriculum as reading guidance.
- Team members take the courses as people; what they learn becomes schema fields and exam items written in their own words, the same way the copyrighted textbooks are used.

## 4. Ingestion plan (gated)

1. Enumerate OCW courses in Brain and Cognitive Sciences, Economics, Anthropology, Sloan, and Linguistics and Philosophy with a browser session; confirm the slugs in the manifest's to-verify list.
2. For each course, fetch the course bundle and the lecture-video caption files; tag every chunk with course number, term, instructor, lecture index, URL, and license.
3. Filter third-party excerpts; convert notes and transcripts to text; align transcripts to the lecture index.
4. Add lecture learning objectives, problem sets, and exam questions to the textbook exam alongside the OpenStax chapters.
5. Build one research retrieval index over OpenStax and OCW with the attribution records OCW requires.
6. Harvard: syllabi into `docs/22`, nothing else.

## 5. What changes elsewhere in the repo

- `00-vision.md`: pricing and B2B-versus-consumer are no longer open decisions; the posture is non-commercial and open.
- `17-model-export-and-deployment.md`: no closed tiers for commercial reasons; T0 may be hosted for cost reasons but is not sold; all tiers release under CC BY-NC-SA-compatible research terms with the attribution file.
- `15-product-spec.md` and `21-simulation-world.md`: no pricing; Dear You and the world are research and education instruments.
- `23-openstax-corpus.md`: the research-only decision stands and is now simply the project's posture; fine-tuning on OpenStax for the project's models is allowed.
- Track D's "training simulations as commercial wedge" becomes "training simulations as the first educational use".
