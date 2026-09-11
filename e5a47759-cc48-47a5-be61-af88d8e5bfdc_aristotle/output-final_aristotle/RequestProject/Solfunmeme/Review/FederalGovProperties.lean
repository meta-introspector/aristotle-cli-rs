/-
  FederalGovProperties.lean — general (universally quantified) versions of the
  properties that `lean4/FederalGov.lean` and `lean4/Bills.lean` only exhibit on
  single hand-picked vote tallies.

  The upstream modules state claims such as "lobbyist votes are non-binding" and
  "either chamber can block" by checking one concrete `BicameralVote` each.  Those
  are tests, not theorems about the protocol.  Below, each such claim is stated for
  *all* votes, and the exact pass/fail characterisations of `resolveBill`,
  `vetoOverride` and `billPasses` are proved.
-/

import Mathlib.Tactic
import RequestProject.Solfunmeme.Upstream.FederalGov
import RequestProject.Solfunmeme.Upstream.Bills

namespace Review.FederalGov

/-! ### Characterisation of the chamber predicates -/

theorem chamberQuorum_iff (v : ChamberVote) :
    chamberQuorum v = true ↔ v.size < (v.yea + v.nay) * 2 := by
  simp [chamberQuorum]

theorem chamberPasses_iff (v : ChamberVote) :
    chamberPasses v = true ↔ v.size < (v.yea + v.nay) * 2 ∧ v.nay < v.yea := by
  simp [chamberPasses, chamberQuorum]

/-- Quorum is monotone: more participation in a chamber of the same size never
    destroys it. -/
theorem chamberQuorum_mono {v w : ChamberVote} (hs : w.size ≤ v.size)
    (h : v.yea + v.nay ≤ w.yea + w.nay) (hv : chamberQuorum v = true) :
    chamberQuorum w = true := by
  rw [chamberQuorum_iff] at hv ⊢
  omega

/-! ### Exact characterisation of `resolveBill`

    The upstream file proves eight instances of these; here is the general form. -/

theorem resolveBill_enacted_iff (b : BicameralVote) :
    resolveBill b = .enacted ↔
      chamberPasses b.senate = true ∧ chamberPasses b.house = true := by
  unfold resolveBill chamberPasses chamberQuorum
  split_ifs with h1 h2 h3 h4 <;> simp_all
  omega

theorem resolveBill_noQuorum_iff (b : BicameralVote) :
    resolveBill b = .noQuorum ↔
      chamberQuorum b.senate = false ∨ chamberQuorum b.house = false := by
  unfold resolveBill chamberQuorum
  split_ifs with h1 h2 h3 h4 <;> simp_all

theorem resolveBill_senateFailed_iff (b : BicameralVote) :
    resolveBill b = .senateFailed ↔
      chamberQuorum b.senate = true ∧ chamberQuorum b.house = true ∧
        b.senate.yea ≤ b.senate.nay ∧ b.house.nay < b.house.yea := by
  unfold resolveBill chamberQuorum
  split_ifs with h1 h2 h3 h4 <;> simp_all
  omega

theorem resolveBill_houseFailed_iff (b : BicameralVote) :
    resolveBill b = .houseFailed ↔
      chamberQuorum b.senate = true ∧ chamberQuorum b.house = true ∧
        b.senate.nay < b.senate.yea ∧ b.house.yea ≤ b.house.nay := by
  unfold resolveBill chamberQuorum
  split_ifs with h1 h2 h3 h4 <;> simp_all
  omega

/-- Bicameralism: a bill that does not carry the house cannot be enacted,
    whatever the senate does. -/
theorem senate_cannot_enact_alone (b : BicameralVote)
    (h : chamberPasses b.house = false) : resolveBill b ≠ .enacted := by
  rw [Ne, resolveBill_enacted_iff]
  simp [h]

theorem house_cannot_enact_alone (b : BicameralVote)
    (h : chamberPasses b.senate = false) : resolveBill b ≠ .enacted := by
  rw [Ne, resolveBill_enacted_iff]
  simp [h]

/-- A tie in either chamber blocks the bill (strict majority is required). -/
theorem tie_blocks_senate (b : BicameralVote) (h : b.senate.yea = b.senate.nay) :
    resolveBill b ≠ .enacted := by
  rw [Ne, resolveBill_enacted_iff, chamberPasses_iff, chamberPasses_iff]
  omega

theorem tie_blocks_house (b : BicameralVote) (h : b.house.yea = b.house.nay) :
    resolveBill b ≠ .enacted := by
  rw [Ne, resolveBill_enacted_iff, chamberPasses_iff, chamberPasses_iff]
  omega

/-! ### Lobbyists really are non-binding

    Upstream proves this for two particular tallies; in fact `resolveBill` and
    `vetoOverride` do not read the lobby field at all. -/

theorem resolveBill_lobby_irrelevant (s h l₁ l₂ : ChamberVote) :
    resolveBill ⟨s, h, l₁⟩ = resolveBill ⟨s, h, l₂⟩ := rfl

theorem vetoOverride_lobby_irrelevant (s h l₁ l₂ : ChamberVote) :
    vetoOverride ⟨s, h, l₁⟩ = vetoOverride ⟨s, h, l₂⟩ := rfl

/-! ### Veto override -/

theorem vetoOverride_iff (b : BicameralVote) :
    vetoOverride b = .overridden ↔
      b.senate.size * 2 ≤ b.senate.yea * 3 ∧ b.house.size * 2 ≤ b.house.yea * 3 := by
  simp only [vetoOverride, ge_iff_le, Bool.and_eq_true, decide_eq_true_eq]
  split_ifs with h <;> simp_all

/-- General form of the two upstream "neither chamber can override alone"
    instances: a house short of two thirds sustains the veto. -/
theorem no_override_without_house (b : BicameralVote)
    (h : b.house.yea * 3 < b.house.size * 2) : vetoOverride b = .sustained := by
  cases hv : vetoOverride b with
  | sustained => rfl
  | overridden =>
      have := ((vetoOverride_iff b).1 hv).2
      omega

theorem no_override_without_senate (b : BicameralVote)
    (h : b.senate.yea * 3 < b.senate.size * 2) : vetoOverride b = .sustained := by
  cases hv : vetoOverride b with
  | sustained => rfl
  | overridden =>
      have := ((vetoOverride_iff b).1 hv).1
      omega

/-- Note that `vetoOverride` checks no quorum at all: an override supermajority
    does imply a simple majority only when the nays make up the rest of the
    chamber.  (Upstream never states the relationship between the two rules.) -/
theorem override_implies_majority (v : ChamberVote)
    (hfull : v.yea + v.nay = v.size) (h : v.size * 2 ≤ v.yea * 3) (hpos : 0 < v.size) :
    chamberPasses v = true := by
  rw [chamberPasses_iff]
  omega

/-! ### `Bills.billPasses` is `resolveBill` with the chamber sizes hard-coded

    `BillVote` carries no chamber sizes, so `billPasses` bakes in 100 senators and
    500 representatives.  It therefore agrees with `resolveBill` exactly on votes
    whose chambers have those sizes — and silently uses the wrong quorum for any
    other electorate. -/

theorem billPasses_iff (v : BillVote) :
    billPasses v = true ↔
      100 < (v.senateYea + v.senateNay) * 2 ∧ 500 < (v.houseYea + v.houseNay) * 2 ∧
        v.senateNay < v.senateYea ∧ v.houseNay < v.houseYea := by
  simp only [billPasses, Bool.and_eq_true, decide_eq_true_eq, gt_iff_lt]
  tauto

theorem billPasses_iff_resolveBill (v : BillVote) (l : ChamberVote) :
    billPasses v = true ↔
      resolveBill ⟨⟨v.senateYea, v.senateNay, 100⟩,
                   ⟨v.houseYea, v.houseNay, 500⟩, l⟩ = .enacted := by
  rw [billPasses_iff, resolveBill_enacted_iff, chamberPasses_iff, chamberPasses_iff]
  tauto

/-- The lobby tally in `BillVote` is likewise ignored. -/
theorem billPasses_lobby_irrelevant (sy sn hy hn l₁ l₂ l₃ l₄ : Nat) :
    billPasses ⟨sy, sn, hy, hn, l₁, l₂⟩ = billPasses ⟨sy, sn, hy, hn, l₃, l₄⟩ := rfl

end Review.FederalGov
