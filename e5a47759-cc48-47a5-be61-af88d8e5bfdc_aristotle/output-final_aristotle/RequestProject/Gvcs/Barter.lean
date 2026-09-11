import RequestProject.Gvcs.Ownership

/-!
# The price of the machine in jars of honey, and the stall that sells it

`RequestProject/Ownership.lean` prices the four ways of getting a LifeTrac in
money.  A farmers' market does not run on money alone, so this file re-quotes
the same four figures in the unit a market stall actually deals in — **a jar of
honey** — and then models the stall itself.

## The assumed prices

| assumption | value |
|---|---|
| a 500 g jar of honey at the stall | 12 |
| honey from one hive in a year | 25 kg, i.e. 50 jars (`hiveJars`) |
| one printed pack at the kiosk | 1 jar (`packPrice`) |

Everything else is derived.  `jars c` is the number of whole jars that settles
a bill of `c`: it always covers the bill (`jars_pays`) and never overpays by a
whole jar (`jars_tight`).  In those units the dealer's tractor is 3167 jars,
the same machine built from bought stock is 796, and built from the ground up
— ore, workflows and firewood, the whole bootstrap — it is **887**
(`the_price_in_honey`).  The dealer's machine costs more than three hives'
whole working lives more than the bootstrap one (`dealer_over_three_times`),
and eighteen hives cover a bootstrap machine in a single season
(`eighteen_hives_a_machine`).

## The kiosk

The stall is a state machine.  It holds printed packs on a shelf and jars in a
crate, and three things can happen to it: the beekeeper **prints** more packs
at home and puts them out, a visitor **buys** a pack for `packPrice` jars, or a
visitor **copies** the sheet — photographs it, or takes the file — which is
free.  `Kiosk.run` works through a day's moves.  What is proved of it:

* `takings_eq` — the crate always holds exactly `packPrice` jars per pack sold:
  the stall can be left unattended and still balances.
* `stock_eq` — every pack printed is either on the shelf or sold; the kiosk
  neither loses nor conjures paper.
* `buy_needs_stock` — a pack is never handed over off an empty shelf.
* `copying_is_free` — a day of nothing but copying costs no paper and takes no
  honey, and there is no bound on how many copies a single kiosk can give away
  (`copies_unbounded`).  The paper is rival and the design is not; that
  asymmetry is the whole point of the stall.
* `kiosk_funds_a_machine` — 887 jars over the counter pay for a machine built
  from the ground up.
-/

namespace LifeTrac
namespace Barter

open Ownership

/-! ## Honey as the unit of account -/

/-- What a 500 g jar of honey fetches at the stall. -/
def jarPrice : ℚ := 12

/-- Jars of honey one hive yields in a year (25 kg at 500 g a jar). -/
def hiveJars : ℕ := 50

theorem jarPrice_pos : 0 < jarPrice := by norm_num [jarPrice]

/-- The number of whole jars that settles a bill of `c`. -/
def jars (c : ℚ) : ℕ := ⌈c / jarPrice⌉₊

/-- The jars really do cover the bill. -/
theorem jars_pays (c : ℚ) : c ≤ (jars c : ℚ) * jarPrice := by
  have h : c / jarPrice ≤ (jars c : ℚ) := Nat.le_ceil (c / jarPrice)
  rw [div_le_iff₀ jarPrice_pos] at h
  exact h

/-- And they never overpay by a whole jar. -/
theorem jars_tight {c : ℚ} (hc : 0 ≤ c) : (jars c : ℚ) * jarPrice < c + jarPrice := by
  have hj : (0 : ℚ) < jarPrice := jarPrice_pos
  have h : (⌈c / jarPrice⌉₊ : ℚ) < c / jarPrice + 1 := Nat.ceil_lt_add_one (div_nonneg hc hj.le)
  have h2 : (jars c : ℚ) * jarPrice < (c / jarPrice + 1) * jarPrice := by
    rw [jars]; exact mul_lt_mul_of_pos_right h hj
  have h3 : (c / jarPrice + 1) * jarPrice = c + jarPrice := by field_simp
  linarith

/-- A dearer bill takes at least as many jars. -/
theorem jars_mono {c d : ℚ} (h : c ≤ d) : jars c ≤ jars d := by
  have hj : (0 : ℚ) < jarPrice := jarPrice_pos
  exact Nat.ceil_le_ceil (by gcongr)

/-! ## The four ways to get a tractor, priced in honey -/

/-- **The price list in jars.**  The dealer's machine is 3167 jars of honey;
buying the stock over the counter and valuing your own assembly time is 988;
buying the stock and not paying yourself is 796; and digging the ore, running
every workflow and burning the firewood is 887. -/
theorem the_price_in_honey :
    jars dealerPrice = 3167 ∧
    jars counterPrice = 988 ∧
    jars stockPrice = 796 ∧
    jars groundPrice = 887 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;>
    rw [jars, jarPrice, Nat.ceil_eq_iff (by norm_num)] <;>
    constructor <;>
    simp only [dealerPrice, counterPrice, stockPrice, groundPrice] <;> norm_num

/-- **The dealer's tractor costs more than three times the bootstrap one**, in
honey as in money. -/
theorem dealer_over_three_times : 3 * jars groundPrice < jars dealerPrice := by
  rw [the_price_in_honey.1, the_price_in_honey.2.2.2]
  norm_num

/-- Not paying yourself for the assembly is worth 192 jars; digging your own
ore costs 91 more than that, because ore is cheap and the labour to work it is
not. -/
theorem the_honey_gap :
    jars counterPrice - jars stockPrice = 192 ∧
    jars groundPrice - jars stockPrice = 91 ∧
    jars groundPrice < jars counterPrice := by
  rw [the_price_in_honey.2.1, the_price_in_honey.2.2.1, the_price_in_honey.2.2.2]
  exact ⟨rfl, rfl, by norm_num⟩

/-- **Eighteen hives buy a tractor in a season.**  A hive gives 50 jars a year,
so eighteen of them cover the 887 jars of a machine built from the ground up —
and seventeen do not. -/
theorem eighteen_hives_a_machine :
    jars groundPrice ≤ 18 * hiveJars ∧ 17 * hiveJars < jars groundPrice := by
  rw [the_price_in_honey.2.2.2, hiveJars]
  exact ⟨by norm_num, by norm_num⟩

/-- The dealer's machine is more than five hive-years dearer than that: it
takes 64 hive-years, against 18. -/
theorem dealer_takes_sixtyfour_hives :
    jars dealerPrice ≤ 64 * hiveJars ∧ 63 * hiveJars < jars dealerPrice := by
  rw [the_price_in_honey.1, hiveJars]
  exact ⟨by norm_num, by norm_num⟩

/-! ## The kiosk -/

/-- What a printed pack costs at the stall, in jars. -/
def packPrice : ℕ := 1

/-- The state of the stall: packs on the shelf, jars in the crate, and the
ledger — packs printed, packs sold, copies given away. -/
structure Kiosk where
  /-- Printed packs currently on the shelf. -/
  shelf : ℕ
  /-- Jars of honey in the crate. -/
  crate : ℕ
  /-- Packs printed since the stall opened. -/
  printed : ℕ
  /-- Packs sold since the stall opened. -/
  sold : ℕ
  /-- Copies of the design taken away (photographs, files, memory). -/
  copies : ℕ
  deriving DecidableEq, Repr

/-- The stall as it is set up in the morning. -/
def Kiosk.empty : Kiosk := ⟨0, 0, 0, 0, 0⟩

/-- What can happen at the stall. -/
inductive Move
  /-- The beekeeper puts `n` freshly printed packs out. -/
  | print (n : ℕ)
  /-- A visitor buys a pack, paying `packPrice` jars. -/
  | buy
  /-- A visitor copies the sheet: photograph, file, or memory. -/
  | copy
  deriving DecidableEq, Repr

/-- One move at the stall.  Buying off an empty shelf is not a move. -/
def Kiosk.step (k : Kiosk) : Move → Option Kiosk
  | .print n => some { k with shelf := k.shelf + n, printed := k.printed + n }
  | .buy =>
      if k.shelf = 0 then none
      else some { k with shelf := k.shelf - 1, crate := k.crate + packPrice,
                         sold := k.sold + 1 }
  | .copy => some { k with copies := k.copies + 1 }

/-- A day at the stall. -/
def Kiosk.run (k : Kiosk) : List Move → Option Kiosk
  | [] => some k
  | m :: ms => (k.step m).bind (fun k' => k'.run ms)

/-- The books balance: the crate holds one jar per pack sold, and every pack
printed is either on the shelf or gone. -/
def Kiosk.Balanced (k : Kiosk) : Prop :=
  k.crate = packPrice * k.sold ∧ k.shelf + k.sold = k.printed

theorem Kiosk.empty_balanced : Kiosk.empty.Balanced := ⟨rfl, rfl⟩

theorem Kiosk.step_balanced {k k' : Kiosk} {m : Move}
    (hk : k.Balanced) (h : k.step m = some k') : k'.Balanced := by
  obtain ⟨hc, hs⟩ := hk
  cases m with
  | print n =>
      simp only [Kiosk.step, Option.some.injEq] at h
      subst h
      exact ⟨hc, by simp only []; omega⟩
  | buy =>
      simp only [Kiosk.step] at h
      by_cases h0 : k.shelf = 0
      · simp [h0] at h
      · rw [if_neg h0] at h
        simp only [Option.some.injEq] at h
        subst h
        refine ⟨?_, by simp only []; omega⟩
        show k.crate + packPrice = packPrice * (k.sold + 1)
        rw [hc, Nat.mul_succ]
  | copy =>
      simp only [Kiosk.step, Option.some.injEq] at h
      subst h
      exact ⟨hc, hs⟩

theorem Kiosk.run_balanced {k k' : Kiosk} {ms : List Move}
    (hk : k.Balanced) (h : k.run ms = some k') : k'.Balanced := by
  induction ms generalizing k with
  | nil =>
      simp only [Kiosk.run, Option.some.injEq] at h
      exact h ▸ hk
  | cons m ms ih =>
      simp only [Kiosk.run, Option.bind_eq_some_iff] at h
      obtain ⟨k₁, h₁, h₂⟩ := h
      exact ih (Kiosk.step_balanced hk h₁) h₂

/-- **The takings are exactly the sales.**  However the day goes, the crate at
the end of it holds `packPrice` jars for every pack that left the shelf. -/
theorem takings_eq {k : Kiosk} {ms : List Move}
    (h : Kiosk.empty.run ms = some k) : k.crate = packPrice * k.sold :=
  (Kiosk.run_balanced Kiosk.empty_balanced h).1

/-- **No paper is lost or conjured.**  Packs printed = packs on the shelf +
packs sold. -/
theorem stock_eq {k : Kiosk} {ms : List Move}
    (h : Kiosk.empty.run ms = some k) : k.shelf + k.sold = k.printed :=
  (Kiosk.run_balanced Kiosk.empty_balanced h).2

/-- A pack is never handed over off an empty shelf. -/
theorem buy_needs_stock {k k' : Kiosk} (h : k.step .buy = some k') : k.shelf ≠ 0 := by
  intro h0
  simp [Kiosk.step, h0] at h

/-- Buying is paid for: the crate goes up by the price of a pack and the shelf
goes down by one. -/
theorem buy_is_paid {k k' : Kiosk} (h : k.step .buy = some k') :
    k'.crate = k.crate + packPrice ∧ k'.sold = k.sold + 1 ∧ k'.shelf + 1 = k.shelf := by
  have h0 : k.shelf ≠ 0 := buy_needs_stock h
  simp only [Kiosk.step, if_neg h0, Option.some.injEq] at h
  subst h
  refine ⟨rfl, rfl, ?_⟩
  simp only []
  omega

/-- **Copying is free, and the kiosk keeps everything it had.**  A day of
nothing but copying leaves the shelf, the crate and the ledger of sales exactly
where they were, and hands out one copy per visitor. -/
theorem copying_is_free (k : Kiosk) (n : ℕ) :
    k.run (List.replicate n .copy) =
      some { k with copies := k.copies + n } := by
  induction n generalizing k with
  | zero => simp [Kiosk.run]
  | succ n ih =>
      rw [List.replicate_succ]
      simp only [Kiosk.run, Kiosk.step, Option.bind_some]
      rw [ih]
      simp
      omega

/-- **The design cannot run out.**  For every `n` there is a day at the stall
after which `n` people have gone away with the plans, no pack has been printed
and no honey has changed hands.  Paper is rival; the design is not. -/
theorem copies_unbounded (n : ℕ) :
    ∃ k, Kiosk.empty.run (List.replicate n .copy) = some k ∧
      k.copies = n ∧ k.printed = 0 ∧ k.crate = 0 := by
  refine ⟨{ Kiosk.empty with copies := n }, ?_, rfl, rfl, rfl⟩
  simpa [Kiosk.empty] using copying_is_free Kiosk.empty n

/-- **What the stall has to take to build a tractor.**  Sell 887 packs at a jar
each and the crate is worth more than a LifeTrac built from the ground up —
ore, workflows, firewood and all. -/
theorem kiosk_funds_a_machine {k : Kiosk} {ms : List Move}
    (h : Kiosk.empty.run ms = some k) (hsold : jars groundPrice ≤ k.sold) :
    groundPrice ≤ (k.crate : ℚ) * jarPrice := by
  have hc : k.crate = k.sold := by
    have := takings_eq h
    simpa [packPrice] using this
  have h1 : (jars groundPrice : ℚ) ≤ (k.crate : ℚ) := by
    rw [hc]; exact_mod_cast hsold
  calc groundPrice ≤ (jars groundPrice : ℚ) * jarPrice := jars_pays _
    _ ≤ (k.crate : ℚ) * jarPrice := by
        exact mul_le_mul_of_nonneg_right h1 (le_of_lt jarPrice_pos)

set_option maxRecDepth 40000 in
/-- A concrete day: put out a thousand packs, sell 887 of them, and let a
hundred people photograph the sheet.  The crate holds 887 jars, 113 packs are
left, and the takings cover a machine. -/
theorem market_day :
    Kiosk.empty.run
        (.print 1000 :: (List.replicate 887 .buy ++ List.replicate 100 .copy)) =
      some ⟨113, 887, 1000, 887, 100⟩ ∧
    groundPrice ≤ ((887 : ℕ) : ℚ) * jarPrice := by
  refine ⟨by decide, ?_⟩
  rw [groundPrice, jarPrice]
  norm_num

end Barter
end LifeTrac
