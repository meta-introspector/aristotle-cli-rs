/-
  Badge.lean — the "Genesis Senator" badge of SOLFUNMEME issue #86.

  The badge described in the issue carries four things and nothing else:

      tier            (Senate / Representative / Vendor)
      token-days      ("365,000 Token-Days" etched below)
      genesis flag    (held since day one)
      a QR code       ("scans to flex his status, no address spilled")

  This file mints such a badge from a holder record and proves what the badge
  does and does not disclose:

    * it never depends on the address — the privacy claim holds;
    * it does not distinguish holders inside a tier — rank 1 and rank 100 mint
      the same badge;
    * but it *does* pin down the balance of a constant holder whose start date
      is known, which the "no address spilled" pitch does not mention;
    * a genesis holder's badge carries a guaranteed minimum area,
      threshold × days.

  The last section confronts the badge design with the electorate actually
  recorded in the dataset (`Review.PublishedData`): 42 senate credentials were
  issued against 100 Senate seats, and 652 credentials in all against 1600
  seats, so at most 42 Senate badges and 652 badges of any kind can be minted
  from the published snapshot.
-/

import Mathlib
import RequestProject.Solfunmeme.Badges.Tiers
import RequestProject.Solfunmeme.Badges.TokenDays
import RequestProject.Solfunmeme.Review.PublishedData

namespace Badges

/-! ### Holders and badges -/

/-- A holder record: the on-chain address, the rank in the holder table, the
holding history, and whether the holding reaches back to launch. -/
structure Holder where
  address : String
  rank : ℕ
  history : History
  sinceGenesis : Bool

/-- The badge: tier, accumulated token-days, genesis flag.  No address. -/
structure Badge where
  tier : Tier
  tokenDays : ℕ
  genesis : Bool
  deriving DecidableEq, Repr

/-- Minting a badge from a holder record. -/
def mint (h : Holder) : Badge :=
  { tier := tierOfRank h.rank
    tokenDays := tokenDays h.history
    genesis := h.sinceGenesis }

/-! ### What the badge hides -/

/-- **The privacy claim holds**: the badge does not depend on the address, so
two holders differing only in address mint identical badges. -/
theorem mint_address_irrelevant (h : Holder) (a : String) :
    mint { h with address := a } = mint h := rfl

/-- More generally, badges of holders agreeing on rank, history and genesis
status are equal, whatever their addresses. -/
theorem mint_eq_of_agree {h k : Holder} (hr : h.rank = k.rank)
    (hh : h.history = k.history) (hg : h.sinceGenesis = k.sinceGenesis) :
    mint h = mint k := by
  simp [mint, hr, hh, hg]

/-- The badge does not separate holders within a tier: the largest holder and
the hundredth holder, with the same history, mint the very same badge. -/
theorem mint_hides_rank_within_tier (hist : History) (g : Bool) :
    mint ⟨"A", 1, hist, g⟩ = mint ⟨"B", 100, hist, g⟩ := by
  have h1 : tierOfRank 1 = Tier.senate := by decide
  have h100 : tierOfRank 100 = Tier.senate := by decide
  simp [mint, h1, h100]

/-! ### What the badge reveals -/

/-- **The badge does leak the balance.**  For a holder who has held a constant
balance for a publicly known number of days — exactly the "Chad" case the issue
advertises — the token-day figure on the badge determines the balance. -/
theorem mint_reveals_constant_balance {b b' d : ℕ} (hd : 0 < d)
    (h : tokenDays [(b, d)] = tokenDays [(b', d)]) : b = b' := by
  simp only [tokenDays_cons, tokenDays_nil, Nat.add_zero] at h
  exact Nat.eq_of_mul_eq_mul_right hd h

/-! ### Genesis holders -/

/-- A holder is *genesis at threshold `tau`* when the balance never fell below
`tau` on any day of the recorded history. -/
def IsGenesis (tau : ℕ) (h : History) : Prop :=
  ∀ t < duration h, tau ≤ balanceOn h t

/-- A genesis badge carries a guaranteed area: threshold × days held. -/
theorem genesis_tokenDays_lower_bound {tau : ℕ} {h : History} (hg : IsGenesis tau h) :
    tau * duration h ≤ tokenDays h := by
  rw [tokenDays_eq_sum_balanceOn]
  calc tau * duration h
      = ∑ _t ∈ Finset.range (duration h), tau := by
        rw [Finset.sum_const, Finset.card_range, smul_eq_mul, mul_comm]
    _ ≤ ∑ t ∈ Finset.range (duration h), balanceOn h t :=
        Finset.sum_le_sum (fun t ht => hg t (Finset.mem_range.mp ht))

/-- Chad is a genesis holder at the 500-token bar. -/
theorem chad_isGenesis : IsGenesis 500 chadHistory := by
  intro t ht
  simp only [chadHistory, duration_cons, duration_nil, Nat.add_zero] at ht
  simp [chadHistory, ht]

/-- Chad's badge: Senate tier, 365 000 token-days, genesis. -/
theorem chad_badge :
    mint ⟨"Chad", 1, chadHistory, true⟩ = ⟨Tier.senate, 365000, true⟩ := by
  have h1 : tierOfRank 1 = Tier.senate := by decide
  simp [mint, chad_tokenDays, h1]

/-- And it clears the bound its genesis status guarantees. -/
theorem chad_badge_bound : 500 * duration chadHistory ≤ tokenDays chadHistory :=
  genesis_tokenDays_lower_bound chad_isGenesis

/-! ### How many badges the published snapshot can actually mint -/

open Review.PublishedData in
/-- Only 42 of the 100 Senate badges can be minted: the dataset issued 42 senate
credentials. -/
theorem senate_badges_short : senateCredentials < senateSeats := by decide

open Review.PublishedData in
/-- Across all three tiers the snapshot supports 652 badges against 1600 seats. -/
theorem all_badges_short : totalCredentials < votingSeats := by decide

open Review.PublishedData in
/-- The shortfall, tier by tier: 58 Senate, 355 Representative and 535 Vendor
badges have no holder to mint them from. -/
theorem badge_shortfall :
    senateCredentials + 58 = senateSeats ∧
    houseCredentials + 355 = repSeats ∧
    lobbyCredentials + 535 = vendorSeats := by
  refine ⟨by decide, by decide, by decide⟩

end Badges
