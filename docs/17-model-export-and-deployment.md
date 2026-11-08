# Model export and deployment tiers

Track B produces one teacher model. Tracks C and D need it in forms that fit a hosted backend, a browser, a game engine on a console, and a phone. This document defines the export tiers, formats, licensing, and the data-consent rules that govern what can be released as open weights.

## 1. Tiers

| Tier | Form | Size | Runs on | Latency target | Used by |
|---|---|---|---|---|---|
| **T0 Teacher** | full fine-tune (Llama-class 70B, QLoRA merged) | 70B | hosted GPUs | seconds | Track B research; closed API for Dear You's hardest questions; distillation source |
| **T1 Server student** | distilled 7–8B, full output schema with reasoning trace | 8B | hosted GPU or workstation | under 2 s | Dear You default; game servers; authoring tools |
| **T2 Edge student** | distilled 1–4B, output schema without trace, quantized Q4–Q8 | 1–4B | consumer GPU, console, high-end phone | under 300 ms per event | NPC slow loop; offline Dear You |
| **T3 Affect head** | small regression and classification network on frozen embeddings or hand features | 1–50M | any CPU, browser WASM, game fast loop | under 1 ms | NPC fast loop; browser summaries; batch scoring |
| **T4 Tables** | the ontology prototype tables and drive dynamics as plain data | KB | anything | none | expression mapping; fallback when no model is present |

Distillation is sequence-level: T0 generates full output-schema records with traces for a large synthetic and Stage E corpus; T1 learns traces and outputs; T2 learns outputs only, with the trace used as an auxiliary target during training and dropped at inference; T3 learns the numeric blocks (drives, appraisals, emotion vector, VAD) from T1's hidden states or from a compact feature set.

## 2. Formats

- **T0, T1**: safetensors with the tokenizer and a model card; served behind the provider interface in `product/api.md` or any OpenAI-compatible server.
- **T2**: safetensors for the reference, plus **GGUF** for llama.cpp and its engine bindings (LlamaSharp, LLMUnity, the Unreal GGUF runtime plugins), and **ONNX** for Unreal's Neural Network Engine and ONNX Runtime on mobile. Arm's Unreal case study ran a bartender NPC through NNE with ONNX Runtime after fine-tuning and compression; mobile comparisons found llama.cpp strongest for token generation and LiteRT-LM for prompt processing. Quantize from the BF16 source, not from a prior quantization.
- **T3**: ONNX for engines and servers; a WASM build for browsers; a plain weight dump with a reference implementation under 200 lines for engines that embed nothing.
- **T4**: CSV and JSON, versioned with the ontology.

Every export carries the ontology version, the schema versions, and the calibration tables (temperature per head, conformal thresholds) it was validated with. A model used with a mismatched ontology version must refuse to load.

## 3. Structured output on small models

T2 models produce the output schema with constrained decoding (grammar-based sampling against the JSON schema), and the numeric fields are trained with the Number Token Loss so near-misses are penalized less than far misses. T3 heads produce the numeric blocks directly. Game integrations should call T3 for every tick and T2 for events; T2's text fields (inner speech, stated reason) feed dialogue generation; T3 never produces text.

## 4. Open and closed weights

| Tier | Release | Why |
|---|---|---|
| T0 | closed, API only | largest capability; most sensitive if misused for real-person profiling at scale; also the costliest to serve |
| T1 | **dual**: closed API for Dear You; open weights for research and for game studios under license | the capability floor for product use; studios need to ship it |
| T2 | **open weights** | must run inside games and on devices; cannot be API-gated |
| T3, T4 | **open**, permissive | tables and tiny heads; no meaningful misuse surface beyond what the published science already allows |

License for open tiers: an open-weights license with a use policy covering the standing rules (no manipulation design against the subject or player, no use for inferring protected attributes of real people, no profiling of real individuals from scraped data). The license text is a legal deliverable; the policy content is already in `07-caveats.md` and `10-ml-training-plan.md` section 8.

## 5. Training-data consent and what can be exported

- **Stage A, B, D datasets** are public research corpora with their own licenses; derivative model weights may be released where those licenses permit (most do; GoEmotions, ATOMIC, Scruples, SOTOPIA are permissive; check each).
- **Stage C** includes restricted resources. Twin-2K-500 is public; Psych-101 is public; UK Biobank derivatives cannot leave the approved environment and must not enter any released weights.
- **Stage E** (the idiographic benchmark) collects a separate opt-in for "use of my anonymized responses to train models that may be released publicly" distinct from "use for research and for the hosted product". Only records with the release opt-in enter the open-weight tiers. This is set in the consent form before collection, not retrofitted.
- **Dear You user data** never enters any released model. Hosted calibration on consented subject self-reports stays in the closed tiers.
- Synthetic data generated by T0 is released alongside the open weights so studios can fine-tune characters without touching human data.

## 6. Deployment patterns

- **Dear You backend**: T1 behind the provider interface; T0 for low-coverage or relational questions where the extra capability pays; T3 for summary-card refreshes.
- **Dear You browser**: T3 in WASM for instant local previews of how a note changes the summary before the server answer arrives.
- **Game, online**: T2 on the server per shard with batched event appraisal; T3 and T4 in the client fast loop.
- **Game, offline or console**: T2 quantized in the client via GGUF or ONNX, T3 and T4 in the fast loop; memory budget 1–3 GB for T2 at Q4.
- **Mobile**: T2 at 1–2B with Q4 where the device allows; otherwise T3 and T4 only, with T2 calls deferred to a server when online.

## 7. Evaluation per tier

Every tier is evaluated on the same held-out sets as Track B (emotion CCC and JS divergence, appraisal RMSE, action log-likelihood, binary Brier and ECE, counterfactual direction agreement, stereotype audit). Distillation is accepted when the student keeps at least 90% of the teacher's score on each metric for its output blocks and passes the stereotype audit at parity. Latency and memory are measured on named reference hardware per tier and published in the model card.
