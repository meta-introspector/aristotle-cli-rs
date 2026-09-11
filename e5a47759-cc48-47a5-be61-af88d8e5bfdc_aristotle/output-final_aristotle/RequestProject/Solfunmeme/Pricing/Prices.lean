/-
# The prices

The empirical half of `RequestProject/Pricing/Model.lean`.  Two kinds of number
live here, and they are kept apart on purpose.

* **Retrieved figures.**  A snapshot of a token-price aggregator's posted list
  (sixteen offers, sixteen pairs of dollars per million tokens) and a snapshot
  of a decentralised GPU marketplace's published lease prices, both of vintage
  `2026-08-24`, transcribed as exact rationals.  These come from the pricing
  model this project's earlier compute-market work was built on, and they are
  reproduced here unchanged so that the ledgers can be checked against them.
* **Assumptions.**  Everything that could not be retrieved: what a gigabyte of
  storage costs for a month, and the three rates that turn retained lines of
  Lean into billed tokens.  Each is flagged with `assumed`, and the theory file
  proves the answers are linear in them, so a reader who prefers other numbers
  can scale.

Nothing here is a measurement of what this project has actually been billed.
A posted price is a datum about a market, not about a ledger.
-/
import RequestProject.Solfunmeme.Pricing.Model

namespace RequestProject.Pricing

/-! ## Provenance -/

/-- Where the token price list comes from. -/
def priceListSource : String := "openrouter.ai/api/v1/models (via the project's pricing model)"

/-- The date the token price list was pulled. -/
def priceListVintage : String := "2026-08-24"

/-- Where the machine lease quotes come from. -/
def leaseSource : String := "Akash Network public API (via the project's pricing model)"

/-- The date the lease quotes were pulled. -/
def leaseVintage : String := "2026-08-24"

/-! ## The posted token price list

Sixteen offers, exactly as posted: dollars per million prompt tokens and
dollars per million completion tokens. -/

/-- `OpenAI: GPT-5.5 Pro` — $30/Mtok prompt, $180/Mtok completion. -/
def openaiGpt55Pro : Offer := ⟨"openai", "openai/gpt-5.5-pro", 30, 180⟩

/-- `OpenAI: GPT-5.5 Pro (batch)` — $15/Mtok prompt, $90/Mtok completion. -/
def openaiGpt55ProBatch : Offer := ⟨"openai", "openai/gpt-5.5-pro:batch", 15, 90⟩

/-- `OpenAI: GPT-5.5` — $5/Mtok prompt, $30/Mtok completion. -/
def openaiGpt55 : Offer := ⟨"openai", "openai/gpt-5.5", 5, 30⟩

/-- `OpenAI: GPT-5.5 (batch)` — $2.5/Mtok prompt, $15/Mtok completion. -/
def openaiGpt55Batch : Offer := ⟨"openai", "openai/gpt-5.5:batch", 5 / 2, 15⟩

/-- `Anthropic: Claude Opus 4.7` — $5/Mtok prompt, $25/Mtok completion. -/
def anthropicClaudeOpus47 : Offer := ⟨"anthropic", "anthropic/claude-opus-4.7", 5, 25⟩

/-- `Anthropic: Claude Opus 4.7 (batch)` — $2.5/Mtok prompt, $12.5/Mtok completion. -/
def anthropicClaudeOpus47Batch : Offer :=
  ⟨"anthropic", "anthropic/claude-opus-4.7:batch", 5 / 2, 25 / 2⟩

/-- `Google: Gemini 3.1 Pro Preview` — $2/Mtok prompt, $12/Mtok completion. -/
def googleGemini31Pro : Offer := ⟨"google", "google/gemini-3.1-pro-preview", 2, 12⟩

/-- `Google: Gemini 3.1 Pro Preview (batch)` — $1/Mtok prompt, $6/Mtok completion. -/
def googleGemini31ProBatch : Offer := ⟨"google", "google/gemini-3.1-pro-preview:batch", 1, 6⟩

/-- `Grok 4.6` — $2/Mtok prompt, $6/Mtok completion. -/
def xAiGrok46 : Offer := ⟨"x-ai", "x-ai/grok-4.6", 2, 6⟩

/-- `MoonshotAI: Kimi K3` — $3/Mtok prompt, $15/Mtok completion. -/
def moonshotaiKimiK3 : Offer := ⟨"moonshotai", "moonshotai/kimi-k3", 3, 15⟩

/-- `Mistral: Mistral Large 3 2512` — $0.5/Mtok prompt, $1.5/Mtok completion. -/
def mistralLarge2512 : Offer := ⟨"mistralai", "mistralai/mistral-large-2512", 1 / 2, 3 / 2⟩

/-- `DeepSeek: DeepSeek V4 Pro` — $0.526176/Mtok prompt, $1.05235/Mtok completion. -/
def deepseekV4Pro : Offer := ⟨"deepseek", "deepseek/deepseek-v4-pro", 16443 / 31250, 16443 / 15625⟩

/-- `DeepSeek: DeepSeek V4 Flash` — $0.0574/Mtok prompt, $0.1148/Mtok completion. -/
def deepseekV4Flash : Offer := ⟨"deepseek", "deepseek/deepseek-v4-flash", 287 / 5000, 287 / 2500⟩

/-- `Qwen: Qwen3.5 Plus` — $0.3/Mtok prompt, $1.8/Mtok completion. -/
def qwen35Plus : Offer := ⟨"qwen", "qwen/qwen3.5-plus-20260420", 3 / 10, 9 / 5⟩

/-- `Z.ai: GLM 4.7` — $0.4/Mtok prompt, $1.75/Mtok completion. -/
def zAiGlm47 : Offer := ⟨"z-ai", "z-ai/glm-4.7", 2 / 5, 7 / 4⟩

/-- `Z.ai: GLM 4.7 Flash` — $0.06/Mtok prompt, $0.4/Mtok completion. -/
def zAiGlm47Flash : Offer := ⟨"z-ai", "z-ai/glm-4.7-flash", 3 / 50, 2 / 5⟩

/-- The head of the price list, so routing can be stated over a nonempty list. -/
def priceListHead : Offer := openaiGpt55Pro

/-- The tail of the price list. -/
def priceListTail : List Offer :=
  [openaiGpt55ProBatch, openaiGpt55, openaiGpt55Batch, anthropicClaudeOpus47,
   anthropicClaudeOpus47Batch, googleGemini31Pro, googleGemini31ProBatch, xAiGrok46,
   moonshotaiKimiK3, mistralLarge2512, deepseekV4Pro, deepseekV4Flash, qwen35Plus,
   zAiGlm47, zAiGlm47Flash]

/-- The whole posted list. -/
def priceList : List Offer := priceListHead :: priceListTail

/-- The snapshot lists sixteen offers. -/
theorem priceList_length : priceList.length = 16 := by decide

/-- Every posted price in the snapshot is nonnegative. -/
theorem priceList_wellFormed : ∀ o ∈ priceList, o.WellFormed := by
  intro o ho
  fin_cases ho <;>
    exact ⟨by norm_num [openaiGpt55Pro, openaiGpt55ProBatch, openaiGpt55, openaiGpt55Batch,
            anthropicClaudeOpus47, anthropicClaudeOpus47Batch, googleGemini31Pro,
            googleGemini31ProBatch, xAiGrok46, moonshotaiKimiK3, mistralLarge2512,
            deepseekV4Pro, deepseekV4Flash, qwen35Plus, zAiGlm47, zAiGlm47Flash, priceListHead],
           by norm_num [openaiGpt55Pro, openaiGpt55ProBatch, openaiGpt55, openaiGpt55Batch,
            anthropicClaudeOpus47, anthropicClaudeOpus47Batch, googleGemini31Pro,
            googleGemini31ProBatch, xAiGrok46, moonshotaiKimiK3, mistralLarge2512,
            deepseekV4Pro, deepseekV4Flash, qwen35Plus, zAiGlm47, zAiGlm47Flash, priceListHead]⟩

/-- The cheapest completion price in the snapshot, and the dearest, as offers.
They are named so the ledgers can quote a range rather than a single number. -/
def cheapestOffer : Offer := zAiGlm47Flash

/-- The dearest offer in the snapshot. -/
def dearestOffer : Offer := openaiGpt55Pro

/-- The cheapest offer is on the list, and so is the dearest. -/
theorem extremes_listed : cheapestOffer ∈ priceList ∧ dearestOffer ∈ priceList := by
  constructor <;> simp [priceList, priceListHead, priceListTail, cheapestOffer, dearestOffer]

/-! ## Machine leases

Published GPU lease prices on a decentralised marketplace, in dollars per hour.
A node of this project needs no accelerator, so the cheapest quote in the
snapshot is used as an **upper bound** on what an hour of a small leased
machine costs: it buys a machine *with* a GPU attached. -/

/-- The cheapest lease quote in the marketplace snapshot: a P4, $0.03/hour. -/
def cheapestLeaseUSDPerHour : USD := 3 / 100

/-- An RTX 4090, average quote $0.36/hour — the class a build machine would
actually be rented at if one wanted headroom. -/
def rtx4090USDPerHour : USD := 9 / 25

/-- An H100 80GiB SXM5, average quote $2.58/hour. -/
def h100USDPerHour : USD := 129 / 50

/-- An H200 141GiB SXM5, the dearest quote in the snapshot, $4.45/hour. -/
def h200USDPerHour : USD := 89 / 20

/-- Total spend recorded by the marketplace over its whole history, $5,949,027.62.
Used only as a yardstick: it is the size of the market this project's bills sit
inside. -/
def marketplaceLifetimeSpendUSD : USD := 297451381 / 50

/-! ## The assumptions

Everything below is a stated assumption rather than a retrieved figure. -/

/-- **Assumed.**  Dollars per gigabyte-month of replicated object storage:
$0.02/GB-month. -/
def assumedStorageUSDPerGBMonth : USD := 1 / 50

/-- **Assumed.**  Completion tokens embodied in one retained line of Lean. -/
def assumedTokensPerLine : ℕ := 12

/-- **Assumed.**  Completion tokens generated per completion token retained:
failed proofs, discarded branches, rewritten files.  This is the one number in
the sizing that nobody can measure, and `Effort.quote_scale_draftMultiplier`
says the answer is exactly linear in it. -/
def assumedDraftMultiplier : ℕ := 40

/-- **Assumed.**  Prompt tokens read per completion token generated: the file,
its imports and the error messages, re-read on every call. -/
def assumedContextRatio : ℕ := 8

/-- Size a piece of formal work at the assumed rates. -/
def effortOf (lines : ℕ) : Effort :=
  ⟨lines, assumedTokensPerLine, assumedDraftMultiplier, assumedContextRatio⟩

/-- One retained line of Lean is billed as 480 completion tokens and 3,840
prompt tokens. -/
theorem effortOf_one : (effortOf 1).split = ⟨3840, 480⟩ := by decide

/-- Sizing is additive in the lines retained. -/
theorem effortOf_add (a b : ℕ) : (effortOf (a + b)).split = (effortOf a).split + (effortOf b).split :=
  Effort.split_add _ _ _ a b

/-! ## Rate cards

A rate card is a token price, a machine price and a storage price together.
Two are named: the cheap one a cost-minimising operator would run on, and the
dear one a buyer of frontier capacity would pay. -/

/-- The cheap rate card: the cheapest posted offer, the cheapest lease quote,
and the assumed storage price. -/
def commodityRates : RateCard := ⟨cheapestOffer, cheapestLeaseUSDPerHour, assumedStorageUSDPerGBMonth⟩

/-- The dear rate card: the dearest posted offer, an H100 lease, and the same
storage price. -/
def frontierRates : RateCard := ⟨dearestOffer, h100USDPerHour, assumedStorageUSDPerGBMonth⟩

/-- Both rate cards are well formed. -/
theorem rates_wellFormed : commodityRates.WellFormed ∧ frontierRates.WellFormed := by
  refine ⟨⟨⟨?_, ?_⟩, ?_, ?_⟩, ⟨⟨?_, ?_⟩, ?_, ?_⟩⟩ <;>
    norm_num [commodityRates, frontierRates, cheapestOffer, dearestOffer, zAiGlm47Flash,
      openaiGpt55Pro, cheapestLeaseUSDPerHour, h100USDPerHour, assumedStorageUSDPerGBMonth]

/-- **The commodity card is cheaper than the frontier card in every line**, so
by `RateCard.bill_mono` it is cheaper for every workload. -/
theorem commodity_le_frontier_rates :
    commodityRates.offer.inputUSDPerMTok ≤ frontierRates.offer.inputUSDPerMTok ∧
      commodityRates.offer.outputUSDPerMTok ≤ frontierRates.offer.outputUSDPerMTok ∧
      commodityRates.machineUSDPerHour ≤ frontierRates.machineUSDPerHour ∧
      commodityRates.storageUSDPerGBMonth ≤ frontierRates.storageUSDPerGBMonth := by
  refine ⟨by norm_num [commodityRates, frontierRates, cheapestOffer, dearestOffer,
    zAiGlm47Flash, openaiGpt55Pro], ?_, ?_, ?_⟩
  · norm_num [commodityRates, frontierRates, cheapestOffer, dearestOffer, zAiGlm47Flash,
      openaiGpt55Pro]
  · norm_num [commodityRates, frontierRates, cheapestLeaseUSDPerHour, h100USDPerHour]
  · norm_num [commodityRates, frontierRates]

/-- Hence the commodity card is cheaper for every workload that consumes
nothing negative. -/
theorem commodity_bill_le_frontier {w : Workload} (hw : w.WellFormed) :
    commodityRates.bill w ≤ frontierRates.bill w :=
  RateCard.bill_mono hw commodity_le_frontier_rates.1 commodity_le_frontier_rates.2.1
    commodity_le_frontier_rates.2.2.1 commodity_le_frontier_rates.2.2.2

end RequestProject.Pricing
