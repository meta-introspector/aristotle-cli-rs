/-
# The pricing model

The senator's report leaves a wish list (`RequestProject/Market/Roadmap.lean`),
and the project runs on infrastructure.  Neither has ever been priced.  This
directory prices both, and it does so with the pricing model this line of work
already uses rather than a new one: a **posted price list** of offers, each
quoting two numbers per million tokens (prompt and completion); a **router**
that sends a workload to the cheapest offer; a **gateway** that adds a fee on
top; and a **make-or-buy** comparison that recovers a fixed cost out of a
per-token saving.

This file is the theory.  It contains no price, no provider and no wish: only
the shapes and the inequalities that hold for every price list.  The numbers
live in `RequestProject/Pricing/Prices.lean` (what things cost) and the two
ledgers `Wishes.lean` (what the wishes cost) and `Infra.lean` (what the
infrastructure costs), where each figure is a theorem the kernel decides.

What is proved here:

* `Offer.quote_add` — billing is linear in the workload, so splitting a job
  across calls changes nothing;
* `Offer.blended_mem_Icc` — a route's headline "dollars per million tokens" is
  never outside the two posted numbers of the offer serving it;
* `routeCost_le_of_mem`, `routeCost_mem`, `routeCost_cons_le` — routing to the
  cheapest offer really is cheapest, is a price somebody posted, and can only
  fall when a competitor is added;
* `routeCost_le_blend` — no mix of providers beats the cheapest single one;
* `Gateway.charge_eq_add_fee` — the buyer's bill is the provider's price plus
  the gateway's fee, with no third term;
* `MakeOrBuy.makeCost_le_buyCost_iff`, `MakeOrBuy.buying_always_wins` — the
  breakeven volume exists exactly when serving in house saves something;
* `RateCard.bill_add`, `RateCard.bill_mono` — a bill made of tokens, machine
  hours and stored bytes is additive over work and monotone in the rates;
* `Effort.split_add`, `RateCard.effortCost_linear`,
  `RateCard.effortCost_scale_draftMultiplier` — the cost of *producing* a
  formal artifact is linear in the lines retained and linear in the assumed
  discovery multiplier, so the one number in the model that cannot be measured
  scales the answer and nothing else.

Nothing here says a posted price is a cost, and nothing says a size estimate is
a measurement.
-/
import Mathlib

namespace RequestProject.Pricing

/-- Dollars, as an exact rational.  No floating-point number occurs anywhere in
this development. -/
abbrev USD := ℚ

/-! ## Offers -/

/-- A posted offer: one model, served by one provider, at two prices — dollars
per million prompt tokens and dollars per million completion tokens. -/
structure Offer where
  /-- The organisation serving the model. -/
  provider : String
  /-- The model identifier. -/
  model : String
  /-- Posted price of a million prompt (input) tokens, in dollars. -/
  inputUSDPerMTok : USD
  /-- Posted price of a million completion (output) tokens, in dollars. -/
  outputUSDPerMTok : USD
  deriving Repr, DecidableEq

/-- An offer is well formed when neither posted price is negative. -/
structure Offer.WellFormed (o : Offer) : Prop where
  /-- Prompt tokens are not paid for by the seller. -/
  input_nonneg : 0 ≤ o.inputUSDPerMTok
  /-- Completion tokens are not paid for by the seller. -/
  output_nonneg : 0 ≤ o.outputUSDPerMTok

/-- How a workload divides into billed prompt and completion tokens.  For a
proof-search campaign the completion side includes every discarded branch,
since those tokens are generated and therefore billed. -/
structure TokenSplit where
  /-- Prompt tokens sent, summed over every call in the workload. -/
  inputTokens : ℕ
  /-- Completion tokens generated, summed over every call, including discarded
  candidates. -/
  outputTokens : ℕ
  deriving Repr, DecidableEq

namespace TokenSplit

/-- All billed tokens of the workload. -/
def total (s : TokenSplit) : ℕ := s.inputTokens + s.outputTokens

/-- Running two workloads is the workload of their sums. -/
instance : Add TokenSplit where
  add a b := ⟨a.inputTokens + b.inputTokens, a.outputTokens + b.outputTokens⟩

@[simp] theorem add_inputTokens (a b : TokenSplit) :
    (a + b).inputTokens = a.inputTokens + b.inputTokens := rfl

@[simp] theorem add_outputTokens (a b : TokenSplit) :
    (a + b).outputTokens = a.outputTokens + b.outputTokens := rfl

/-- Two workloads with the same two counts are the same workload. -/
theorem ext' {a b : TokenSplit} (hi : a.inputTokens = b.inputTokens)
    (ho : a.outputTokens = b.outputTokens) : a = b := by
  cases a; cases b; simp_all

/-- The share of billed tokens that are generated rather than sent. -/
def outputShare (s : TokenSplit) : ℚ := (s.outputTokens : ℚ) / (s.total : ℚ)

theorem outputShare_nonneg (s : TokenSplit) : 0 ≤ s.outputShare := by
  unfold outputShare
  positivity

theorem outputShare_le_one (s : TokenSplit) : s.outputShare ≤ 1 := by
  unfold outputShare total
  rcases Nat.eq_zero_or_pos (s.inputTokens + s.outputTokens) with h0 | hpos
  · simp [h0]
  · have hq : (0 : ℚ) < ((s.inputTokens + s.outputTokens : ℕ) : ℚ) := by exact_mod_cast hpos
    rw [div_le_one hq]
    push_cast
    linarith [Nat.cast_nonneg (α := ℚ) s.inputTokens]

end TokenSplit

namespace Offer

/-- What the offer charges for a workload, in dollars. -/
def quote (o : Offer) (s : TokenSplit) : USD :=
  (s.inputTokens : ℚ) / 1000000 * o.inputUSDPerMTok
    + (s.outputTokens : ℚ) / 1000000 * o.outputUSDPerMTok

/-- The blended price of the route: dollars per million tokens actually billed,
prompt and completion together. -/
def blendedUSDPerMTok (o : Offer) (s : TokenSplit) : USD :=
  1000000 * o.quote s / (s.total : ℚ)

theorem quote_nonneg {o : Offer} (ho : o.WellFormed) (s : TokenSplit) : 0 ≤ o.quote s := by
  have h1 := ho.input_nonneg
  have h2 := ho.output_nonneg
  unfold quote
  positivity

/-- **Billing is linear in the workload.**  Splitting a job into two calls, or
merging two jobs into one, changes nothing about what it costs. -/
theorem quote_add (o : Offer) (a b : TokenSplit) :
    o.quote (a + b) = o.quote a + o.quote b := by
  unfold quote
  simp only [TokenSplit.add_inputTokens, TokenSplit.add_outputTokens]
  push_cast
  ring

/-- The blended price is the two posted prices weighted by the output share. -/
theorem blended_eq (o : Offer) {s : TokenSplit} (hs : 0 < s.total) :
    o.blendedUSDPerMTok s =
      (1 - s.outputShare) * o.inputUSDPerMTok + s.outputShare * o.outputUSDPerMTok := by
  have hq : (0 : ℚ) < (s.total : ℚ) := by exact_mod_cast hs
  have hne : ((s.total : ℚ)) ≠ 0 := ne_of_gt hq
  have hne' : ((s.inputTokens : ℚ) + (s.outputTokens : ℚ)) ≠ 0 := by
    simpa [TokenSplit.total, Nat.cast_add] using hne
  unfold blendedUSDPerMTok quote TokenSplit.outputShare TokenSplit.total
  push_cast
  field_simp
  ring

/-- **A route's headline price is never outside the two posted prices.** -/
theorem blended_mem_Icc {o : Offer} {s : TokenSplit} (hs : 0 < s.total) :
    min o.inputUSDPerMTok o.outputUSDPerMTok ≤ o.blendedUSDPerMTok s ∧
      o.blendedUSDPerMTok s ≤ max o.inputUSDPerMTok o.outputUSDPerMTok := by
  have hw0 := s.outputShare_nonneg
  have hw1 := s.outputShare_le_one
  rw [blended_eq o hs]
  set w := s.outputShare
  constructor
  · have h1 : min o.inputUSDPerMTok o.outputUSDPerMTok ≤ o.inputUSDPerMTok := min_le_left _ _
    have h2 : min o.inputUSDPerMTok o.outputUSDPerMTok ≤ o.outputUSDPerMTok := min_le_right _ _
    nlinarith
  · have h1 : o.inputUSDPerMTok ≤ max o.inputUSDPerMTok o.outputUSDPerMTok := le_max_left _ _
    have h2 : o.outputUSDPerMTok ≤ max o.inputUSDPerMTok o.outputUSDPerMTok := le_max_right _ _
    nlinarith

/-- Generating more tokens costs more. -/
theorem quote_mono_outputTokens {o : Offer} (ho : 0 ≤ o.outputUSDPerMTok)
    {i n₁ n₂ : ℕ} (h : n₁ ≤ n₂) :
    o.quote ⟨i, n₁⟩ ≤ o.quote ⟨i, n₂⟩ := by
  have hn : ((n₁ : ℚ)) ≤ (n₂ : ℚ) := by exact_mod_cast h
  unfold quote
  simp only
  gcongr

end Offer

/-! ## Routing -/

/-- The cost of serving a workload by routing it to the cheapest of a nonempty
list of offers, the list being given as a head and a tail. -/
def routeCost (s : TokenSplit) (o : Offer) (os : List Offer) : USD :=
  os.foldr (fun a b => min (a.quote s) b) (o.quote s)

@[simp] theorem routeCost_nil (s : TokenSplit) (o : Offer) : routeCost s o [] = o.quote s := rfl

theorem routeCost_cons (s : TokenSplit) (o a : Offer) (os : List Offer) :
    routeCost s o (a :: os) = min (a.quote s) (routeCost s o os) := rfl

/-- **The routed price undercuts every listed offer.** -/
theorem routeCost_le_of_mem {s : TokenSplit} {o a : Offer} {os : List Offer}
    (h : a ∈ o :: os) : routeCost s o os ≤ a.quote s := by
  induction os with
  | nil =>
      rcases List.mem_singleton.mp h with rfl
      exact le_refl _
  | cons b bs ih =>
      rw [routeCost_cons]
      rcases List.mem_cons.mp h with rfl | hmem
      · exact le_trans (min_le_right _ _) (ih (List.mem_cons_self ..))
      · rcases List.mem_cons.mp hmem with rfl | hmem'
        · exact min_le_left _ _
        · exact le_trans (min_le_right _ _) (ih (List.mem_cons_of_mem _ hmem'))

/-- **…and is itself a posted price.**  The router does not invent a number. -/
theorem routeCost_mem (s : TokenSplit) (o : Offer) (os : List Offer) :
    ∃ a ∈ o :: os, routeCost s o os = a.quote s := by
  induction os with
  | nil => exact ⟨o, List.mem_cons_self .., rfl⟩
  | cons b bs ih =>
      obtain ⟨a, ha, hEq⟩ := ih
      rw [routeCost_cons]
      rcases le_total (b.quote s) (routeCost s o bs) with hle | hle
      · exact ⟨b, List.mem_cons_of_mem _ (List.mem_cons_self ..), by rw [min_eq_left hle]⟩
      · refine ⟨a, ?_, by rw [min_eq_right hle]; exact hEq⟩
        rcases List.mem_cons.mp ha with rfl | hmem
        · exact List.mem_cons_self ..
        · exact List.mem_cons_of_mem _ (List.mem_cons_of_mem _ hmem)

/-- **More competition cannot raise the routed price.** -/
theorem routeCost_cons_le (s : TokenSplit) (o a : Offer) (os : List Offer) :
    routeCost s o (a :: os) ≤ routeCost s o os := by
  rw [routeCost_cons]
  exact min_le_right _ _

theorem routeCost_nonneg {s : TokenSplit} {o : Offer} {os : List Offer}
    (ho : o.WellFormed) (hos : ∀ a ∈ os, a.WellFormed) : 0 ≤ routeCost s o os := by
  obtain ⟨a, ha, hEq⟩ := routeCost_mem s o os
  rw [hEq]
  rcases List.mem_cons.mp ha with rfl | hmem
  · exact Offer.quote_nonneg ho s
  · exact Offer.quote_nonneg (hos a hmem) s

/-- The cost of splitting a workload across providers in given shares. -/
def blendCost (s : TokenSplit) (ws : List (ℚ × Offer)) : USD :=
  (ws.map fun p => p.1 * p.2.quote s).sum

/-- The shares of a mix. -/
def shares (ws : List (ℚ × Offer)) : ℚ := (ws.map Prod.fst).sum

theorem blendCost_ge_of_forall {s : TokenSplit} {m : ℚ} {ws : List (ℚ × Offer)}
    (hw : ∀ p ∈ ws, 0 ≤ p.1) (hq : ∀ p ∈ ws, m ≤ p.2.quote s) :
    m * shares ws ≤ blendCost s ws := by
  induction ws with
  | nil => simp [blendCost, shares]
  | cons p ps ih =>
      have hp0 : 0 ≤ p.1 := hw p (List.mem_cons_self ..)
      have hpq : m ≤ p.2.quote s := hq p (List.mem_cons_self ..)
      have hrest := ih (fun q hq' => hw q (List.mem_cons_of_mem _ hq'))
        (fun q hq' => hq q (List.mem_cons_of_mem _ hq'))
      have : m * p.1 ≤ p.1 * p.2.quote s := by nlinarith
      simp only [blendCost, shares, List.map_cons, List.sum_cons] at *
      nlinarith

/-- **No mix of providers beats the cheapest provider.** -/
theorem routeCost_le_blend {s : TokenSplit} {o : Offer} {os : List Offer}
    {ws : List (ℚ × Offer)} (hw : ∀ p ∈ ws, 0 ≤ p.1)
    (hmem : ∀ p ∈ ws, p.2 ∈ o :: os) (hshare : shares ws = 1) :
    routeCost s o os ≤ blendCost s ws := by
  have h := blendCost_ge_of_forall (m := routeCost s o os) hw
    (fun p hp => routeCost_le_of_mem (hmem p hp))
  rwa [hshare, mul_one] at h

/-! ## The gateway -/

/-- A routing gateway, described by the fraction it adds to the provider price. -/
structure Gateway where
  /-- Name of the aggregator. -/
  name : String
  /-- Fraction added on top of the routed provider price. -/
  feeRate : ℚ
  deriving Repr, DecidableEq

namespace Gateway

/-- What the buyer is charged for a route that costs `base` at the provider. -/
def charge (g : Gateway) (base : USD) : USD := base * (1 + g.feeRate)

/-- The gateway's own revenue on the route. -/
def fee (g : Gateway) (base : USD) : USD := base * g.feeRate

/-- **The buyer's bill is the provider's price plus the gateway's fee**, with no
third term. -/
theorem charge_eq_add_fee (g : Gateway) (base : USD) :
    g.charge base = base + g.fee base := by
  unfold charge fee; ring

/-- A zero-fee gateway is a pass-through. -/
@[simp] theorem charge_of_feeRate_zero (n : String) (base : USD) :
    (Gateway.mk n 0).charge base = base := by
  simp [charge]

theorem charge_mono_base {g : Gateway} (hf : 0 ≤ g.feeRate) {b₁ b₂ : USD} (h : b₁ ≤ b₂) :
    g.charge b₁ ≤ g.charge b₂ := by
  unfold charge
  have : (0 : ℚ) ≤ 1 + g.feeRate := by linarith
  exact mul_le_mul_of_nonneg_right h this

/-- **A gateway cannot make routing dearer than any offer it hides**, beyond its
own fee. -/
theorem charge_routeCost_le {g : Gateway} (hf : 0 ≤ g.feeRate) {s : TokenSplit}
    {o a : Offer} {os : List Offer} (h : a ∈ o :: os) :
    g.charge (routeCost s o os) ≤ g.charge (a.quote s) :=
  charge_mono_base hf (routeCost_le_of_mem h)

end Gateway

/-! ## Make or buy -/

/-- The choice between buying tokens at a market price and standing up one's own
serving programme: a one-off, and two per-token rates. -/
structure MakeOrBuy where
  /-- Everything the programme costs before a single token is served. -/
  fixedUSD : USD
  /-- What one more token costs once the programme exists. -/
  ownUSDPerToken : USD
  /-- What one token costs on the market. -/
  marketUSDPerToken : USD
  deriving Repr, DecidableEq

namespace MakeOrBuy

/-- Buying `n` tokens on the market. -/
def buyCost (m : MakeOrBuy) (n : ℚ) : USD := m.marketUSDPerToken * n

/-- Building the programme and serving `n` tokens on it. -/
def makeCost (m : MakeOrBuy) (n : ℚ) : USD := m.fixedUSD + m.ownUSDPerToken * n

/-- What each token served in house saves against the market price. -/
def margin (m : MakeOrBuy) : USD := m.marketUSDPerToken - m.ownUSDPerToken

/-- The volume at which building and buying cost the same. -/
def breakevenTokens (m : MakeOrBuy) : ℚ := m.fixedUSD / m.margin

/-- **Building pays exactly above the breakeven volume.** -/
theorem makeCost_le_buyCost_iff {m : MakeOrBuy} (hm : 0 < m.margin) (n : ℚ) :
    m.makeCost n ≤ m.buyCost n ↔ m.breakevenTokens ≤ n := by
  unfold makeCost buyCost breakevenTokens margin at *
  rw [div_le_iff₀ hm]
  constructor <;> intro h <;> nlinarith

/-- **When the market price is at or below one's own marginal cost, no volume
justifies building.** -/
theorem buying_always_wins {m : MakeOrBuy} (hf : 0 ≤ m.fixedUSD) (hm : m.margin ≤ 0)
    {n : ℚ} (hn : 0 ≤ n) : m.buyCost n ≤ m.makeCost n := by
  unfold makeCost buyCost margin at *
  nlinarith

theorem breakevenTokens_nonneg {m : MakeOrBuy} (hf : 0 ≤ m.fixedUSD) (hm : 0 < m.margin) :
    0 ≤ m.breakevenTokens := div_nonneg hf hm.le

end MakeOrBuy

/-! ## A bill with three lines

Tokens are not the only thing this project pays for.  A workload also occupies a
machine for a while and leaves bytes behind, and both are billed at posted rates
in exactly the same way. -/

/-- A unit of work, in the three things it consumes. -/
structure Workload where
  /-- Prompt and completion tokens billed. -/
  tokens : TokenSplit
  /-- Wall-clock hours of a leased machine. -/
  machineHours : ℚ
  /-- Gigabyte-months of stored bytes. -/
  storageGBMonths : ℚ
  deriving Repr, DecidableEq

namespace Workload

/-- Doing two things is doing their sum. -/
instance : Add Workload where
  add a b := ⟨a.tokens + b.tokens, a.machineHours + b.machineHours,
    a.storageGBMonths + b.storageGBMonths⟩

@[simp] theorem add_tokens (a b : Workload) : (a + b).tokens = a.tokens + b.tokens := rfl

@[simp] theorem add_machineHours (a b : Workload) :
    (a + b).machineHours = a.machineHours + b.machineHours := rfl

@[simp] theorem add_storageGBMonths (a b : Workload) :
    (a + b).storageGBMonths = a.storageGBMonths + b.storageGBMonths := rfl

/-- The empty workload. -/
def zero : Workload := ⟨⟨0, 0⟩, 0, 0⟩

/-- A workload consumes nothing negative. -/
structure WellFormed (w : Workload) : Prop where
  /-- Machines are occupied for a nonnegative time. -/
  hours_nonneg : 0 ≤ w.machineHours
  /-- Bytes are stored for a nonnegative time. -/
  storage_nonneg : 0 ≤ w.storageGBMonths

end Workload

/-- Everything this project is charged for, at posted rates: an offer for
tokens, a lease rate for machines, and a storage rate for bytes. -/
structure RateCard where
  /-- The offer tokens are bought at. -/
  offer : Offer
  /-- Dollars per hour of the leased machine. -/
  machineUSDPerHour : USD
  /-- Dollars per gigabyte-month of storage. -/
  storageUSDPerGBMonth : USD
  deriving Repr, DecidableEq

/-- A rate card is well formed when no rate is negative. -/
structure RateCard.WellFormed (r : RateCard) : Prop where
  /-- Token prices are nonnegative. -/
  offer : r.offer.WellFormed
  /-- Machine time is nonnegative. -/
  machine_nonneg : 0 ≤ r.machineUSDPerHour
  /-- Storage is nonnegative. -/
  storage_nonneg : 0 ≤ r.storageUSDPerGBMonth

namespace RateCard

/-- The bill for a workload at a rate card: tokens, machine hours, stored bytes. -/
def bill (r : RateCard) (w : Workload) : USD :=
  r.offer.quote w.tokens + r.machineUSDPerHour * w.machineHours
    + r.storageUSDPerGBMonth * w.storageGBMonths

/-- **The bill is additive over work.**  There is no discount and no penalty for
grouping: what a programme costs is the sum of what its parts cost. -/
theorem bill_add (r : RateCard) (a b : Workload) :
    r.bill (a + b) = r.bill a + r.bill b := by
  unfold bill
  simp only [Workload.add_tokens, Workload.add_machineHours, Workload.add_storageGBMonths,
    Offer.quote_add]
  ring

@[simp] theorem bill_zero (r : RateCard) : r.bill Workload.zero = 0 := by
  simp [bill, Workload.zero, Offer.quote]

/-- The bill of a list of jobs is the sum of their bills. -/
theorem bill_sum (r : RateCard) (ws : List Workload) :
    r.bill (ws.foldr (· + ·) Workload.zero) = (ws.map r.bill).sum := by
  induction ws with
  | nil => simp
  | cons a as ih => simp [bill_add, ih]

theorem bill_nonneg {r : RateCard} (hr : r.WellFormed) {w : Workload} (hw : w.WellFormed) :
    0 ≤ r.bill w := by
  have h1 := Offer.quote_nonneg hr.offer w.tokens
  have h2 := mul_nonneg hr.machine_nonneg hw.hours_nonneg
  have h3 := mul_nonneg hr.storage_nonneg hw.storage_nonneg
  unfold bill
  linarith

/-- **A cheaper rate card is cheaper for every workload.** -/
theorem bill_mono {r₁ r₂ : RateCard} {w : Workload} (hw : w.WellFormed)
    (hi : r₁.offer.inputUSDPerMTok ≤ r₂.offer.inputUSDPerMTok)
    (ho : r₁.offer.outputUSDPerMTok ≤ r₂.offer.outputUSDPerMTok)
    (hm : r₁.machineUSDPerHour ≤ r₂.machineUSDPerHour)
    (hs : r₁.storageUSDPerGBMonth ≤ r₂.storageUSDPerGBMonth) :
    r₁.bill w ≤ r₂.bill w := by
  have hq : r₁.offer.quote w.tokens ≤ r₂.offer.quote w.tokens := by
    unfold Offer.quote
    gcongr
  have h2 : r₁.machineUSDPerHour * w.machineHours ≤ r₂.machineUSDPerHour * w.machineHours :=
    mul_le_mul_of_nonneg_right hm hw.hours_nonneg
  have h3 : r₁.storageUSDPerGBMonth * w.storageGBMonths
      ≤ r₂.storageUSDPerGBMonth * w.storageGBMonths :=
    mul_le_mul_of_nonneg_right hs hw.storage_nonneg
  unfold bill
  linarith

end RateCard

/-! ## Sizing a piece of formal work

A wish is granted by writing Lean and getting it past the kernel.  The only
thing about that work which can be *measured* after the fact is how many lines
were retained.  Everything else in the sizing — how many tokens a line embodies,
how many tokens are generated per token retained, how much context is re-read
per token generated — is an assumption, and is named as one.  The two theorems
that matter are that the answer is linear in each of them, so an assumption that
is wrong by a factor scales the answer by that factor and does nothing else. -/

/-- The sizing of a piece of formal work: what was (or would be) retained, and
the three assumed rates that turn retained lines into billed tokens. -/
structure Effort where
  /-- Lines of Lean retained in the repository. -/
  retainedLines : ℕ
  /-- Completion tokens embodied in one retained line. -/
  tokensPerLine : ℕ
  /-- Completion tokens generated per completion token retained: failed proofs,
  discarded branches, rewritten files. -/
  draftMultiplier : ℕ
  /-- Prompt tokens read per completion token generated: the file, its imports
  and the error messages, re-read on every call. -/
  contextRatio : ℕ
  deriving Repr, DecidableEq

namespace Effort

/-- Completion tokens the work generates. -/
def outputTokens (e : Effort) : ℕ := e.draftMultiplier * (e.tokensPerLine * e.retainedLines)

/-- The billed workload of the effort. -/
def split (e : Effort) : TokenSplit :=
  ⟨e.contextRatio * e.outputTokens, e.outputTokens⟩

/-- Two efforts sized at the same rates add by adding their lines. -/
theorem split_add (t d c : ℕ) (l₁ l₂ : ℕ) :
    (Effort.mk (l₁ + l₂) t d c).split = (Effort.mk l₁ t d c).split + (Effort.mk l₂ t d c).split :=
  TokenSplit.ext' (by simp [split, outputTokens]; ring) (by simp [split, outputTokens]; ring)

/-- **The bill is linear in the lines retained.** -/
theorem quote_linear (o : Offer) (t d c l k : ℕ) :
    o.quote (Effort.mk (k * l) t d c).split = k * o.quote (Effort.mk l t d c).split := by
  simp only [split, outputTokens, Offer.quote]
  push_cast
  ring

/-- **The bill is linear in the assumed discovery multiplier.**  The one number
in the sizing that nobody can measure scales the answer and nothing else. -/
theorem quote_scale_draftMultiplier (o : Offer) (t d c l k : ℕ) :
    o.quote (Effort.mk l t (k * d) c).split = k * o.quote (Effort.mk l t d c).split := by
  simp only [split, outputTokens, Offer.quote]
  push_cast
  ring

/-- Retaining more lines costs more, at any offer with nonnegative prices. -/
theorem quote_mono {o : Offer} (ho : o.WellFormed) (t d c : ℕ) {l₁ l₂ : ℕ} (h : l₁ ≤ l₂) :
    o.quote (Effort.mk l₁ t d c).split ≤ o.quote (Effort.mk l₂ t d c).split := by
  have h1 : ((d * (t * l₁) : ℕ) : ℚ) ≤ ((d * (t * l₂) : ℕ) : ℚ) := by
    exact_mod_cast Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ h)
  have h2 : ((c * (d * (t * l₁)) : ℕ) : ℚ) ≤ ((c * (d * (t * l₂)) : ℕ) : ℚ) := by
    exact_mod_cast Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ h))
  have hi := ho.input_nonneg
  have hoo := ho.output_nonneg
  simp only [split, outputTokens, Offer.quote]
  gcongr

end Effort

end RequestProject.Pricing
