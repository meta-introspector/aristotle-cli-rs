import RequestProject.Solfunmeme.Ledger.Data.Spammers
import RequestProject.Solfunmeme.Ledger.Data.Bystanders
import RequestProject.Solfunmeme.Ledger.Data.Traders

/-!
# Who acted well, who acted badly, and a theory of each wallet

Twenty-two wallets, chosen from the 1 154 fee payers of the sample as the ones
with the most recorded activity together with three small retail participants,
are analysed here.  For each of them the file records:

* its **statistics** — how much it submitted, how much settled, what it paid,
  what it did to its holding of the governed token;
* its **verdict** under the four norms of `Ledger.Behaviour`;
* a **theory**: a predicate on single transactions, proved to hold of *every*
  recorded transaction of that wallet (`Sound`), corroborated by all of them
  (`Corroborated`), and refuted by transactions of other wallets
  (`Discriminates`) — so it is a description of that wallet and not of everyone.

Everything below is decided by the kernel from the rows in `Ledger.Data.*`.
What the theorems do *not* settle is intent: a wallet that fails 1 749 times is
proved to have failed 1 749 times, and calling that behaviour "bad" is the
`Verdict` definition of `Ledger.Behaviour` speaking, not the chain.
-/

set_option maxRecDepth 4000000
set_option maxHeartbeats 4000000

namespace Ledger.Verdicts

open Ledger Ledger.Data

/-! ### `J3Z1AfTD…` — the slippage spammer

    1 749 recorded transactions, not one of which settled.  1 730 of them died on the
    AMM's slippage check: the wallet had committed to a price, lost the race for it,
    and paid the fee anyway.  It moved no tokens at all — not for itself, not for
    anybody — and burnt every lamport it spent.
-/

theorem w_J3Z1AfTD_stats :
    nTx w_J3Z1AfTD = 1749 ∧ nOk w_J3Z1AfTD = 0 ∧ nFail w_J3Z1AfTD = 1749 ∧ nSlip w_J3Z1AfTD = 1730 ∧
    nLive w_J3Z1AfTD = 0 ∧ nMoves w_J3Z1AfTD = 0 ∧ nBuys w_J3Z1AfTD = 0 ∧ nSells w_J3Z1AfTD = 0 ∧
    nExits w_J3Z1AfTD = 0 ∧ fees w_J3Z1AfTD = 21634811 ∧ burnt w_J3Z1AfTD = 21634811 ∧ net w_J3Z1AfTD = 0 := by
  decide

theorem w_J3Z1AfTD_neverSettles : NeverSettles w_J3Z1AfTD := by decide
theorem w_J3Z1AfTD_inert : Inert w_J3Z1AfTD := by decide
theorem w_J3Z1AfTD_bystander : Bystander w_J3Z1AfTD := by decide

theorem w_J3Z1AfTD_verdict : verdict w_J3Z1AfTD = .bad := by decide

/-- A theory of `J3Z1AfTD…`: the shape every one of its 1749 recorded transactions has. -/
def th_J3Z1AfTD (t : Tx) : Bool := (t.ok == false) && (t.live == false) && (t.moves == false) && (5087 ≤ t.fee) && (t.fee ≤ 52043) && (314276636 ≤ t.slot) && (t.slot ≤ 314537241)

theorem w_J3Z1AfTD_theory_sound : Sound th_J3Z1AfTD w_J3Z1AfTD := by decide
theorem w_J3Z1AfTD_theory_corroborated : Corroborated th_J3Z1AfTD w_J3Z1AfTD 1749 := by decide
theorem w_J3Z1AfTD_theory_discriminates_7QeRHULB : Discriminates th_J3Z1AfTD w_7QeRHULB := by decide
theorem w_J3Z1AfTD_theory_discriminates_4AnrXS8H : Discriminates th_J3Z1AfTD w_4AnrXS8H := by decide
theorem w_J3Z1AfTD_theory_discriminates_9XvBYSKe : Discriminates th_J3Z1AfTD w_9XvBYSKe := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ### `7QeRHULB…` — the second slippage spammer

    The same behaviour again, from a different address: 896 transactions, none
    settled, 865 slippage failures, 20 480 279 lamports burnt.  This is what makes
    the first wallet's theory a *class* theory rather than a curiosity.
-/

theorem w_7QeRHULB_stats :
    nTx w_7QeRHULB = 896 ∧ nOk w_7QeRHULB = 0 ∧ nFail w_7QeRHULB = 896 ∧ nSlip w_7QeRHULB = 865 ∧
    nLive w_7QeRHULB = 0 ∧ nMoves w_7QeRHULB = 0 ∧ nBuys w_7QeRHULB = 0 ∧ nSells w_7QeRHULB = 0 ∧
    nExits w_7QeRHULB = 0 ∧ fees w_7QeRHULB = 20480279 ∧ burnt w_7QeRHULB = 20480279 ∧ net w_7QeRHULB = 0 := by
  decide

theorem w_7QeRHULB_neverSettles : NeverSettles w_7QeRHULB := by decide
theorem w_7QeRHULB_inert : Inert w_7QeRHULB := by decide
theorem w_7QeRHULB_bystander : Bystander w_7QeRHULB := by decide

theorem w_7QeRHULB_verdict : verdict w_7QeRHULB = .bad := by decide

/-- A theory of `7QeRHULB…`: the shape every one of its 896 recorded transactions has. -/
def th_7QeRHULB (t : Tx) : Bool := (t.ok == false) && (t.live == false) && (t.moves == false) && (5840 ≤ t.fee) && (t.fee ≤ 66285) && (314228012 ≤ t.slot) && (t.slot ≤ 314685626)

theorem w_7QeRHULB_theory_sound : Sound th_7QeRHULB w_7QeRHULB := by decide
theorem w_7QeRHULB_theory_corroborated : Corroborated th_7QeRHULB w_7QeRHULB 896 := by decide
theorem w_7QeRHULB_theory_discriminates_J3Z1AfTD : Discriminates th_7QeRHULB w_J3Z1AfTD := by decide
theorem w_7QeRHULB_theory_discriminates_9XvBYSKe : Discriminates th_7QeRHULB w_9XvBYSKe := by decide
theorem w_7QeRHULB_theory_discriminates_C9YvTztk : Discriminates th_7QeRHULB w_C9YvTztk := by decide
-- Refuted by 20 of the other 21 analysed wallets.
/-- Not refuted by: `4AnrXS8H…` — at this resolution these records are
    indistinguishable from this one. -/
theorem w_7QeRHULB_theory_also_fits_4AnrXS8H : Sound th_7QeRHULB w_4AnrXS8H := by decide

/-! ### `4AnrXS8H…` — the third slippage spammer

    And a third: 442 transactions, none settled, 416 on slippage.
-/

theorem w_4AnrXS8H_stats :
    nTx w_4AnrXS8H = 442 ∧ nOk w_4AnrXS8H = 0 ∧ nFail w_4AnrXS8H = 442 ∧ nSlip w_4AnrXS8H = 416 ∧
    nLive w_4AnrXS8H = 0 ∧ nMoves w_4AnrXS8H = 0 ∧ nBuys w_4AnrXS8H = 0 ∧ nSells w_4AnrXS8H = 0 ∧
    nExits w_4AnrXS8H = 0 ∧ fees w_4AnrXS8H = 13079922 ∧ burnt w_4AnrXS8H = 13079922 ∧ net w_4AnrXS8H = 0 := by
  decide

theorem w_4AnrXS8H_neverSettles : NeverSettles w_4AnrXS8H := by decide
theorem w_4AnrXS8H_inert : Inert w_4AnrXS8H := by decide
theorem w_4AnrXS8H_bystander : Bystander w_4AnrXS8H := by decide

theorem w_4AnrXS8H_verdict : verdict w_4AnrXS8H = .bad := by decide

/-- A theory of `4AnrXS8H…`: the shape every one of its 442 recorded transactions has. -/
def th_4AnrXS8H (t : Tx) : Bool := (t.ok == false) && (t.live == false) && (t.moves == false) && (7563 ≤ t.fee) && (t.fee ≤ 56639) && (314228294 ≤ t.slot) && (t.slot ≤ 314645781)

theorem w_4AnrXS8H_theory_sound : Sound th_4AnrXS8H w_4AnrXS8H := by decide
theorem w_4AnrXS8H_theory_corroborated : Corroborated th_4AnrXS8H w_4AnrXS8H 442 := by decide
theorem w_4AnrXS8H_theory_discriminates_J3Z1AfTD : Discriminates th_4AnrXS8H w_J3Z1AfTD := by decide
theorem w_4AnrXS8H_theory_discriminates_7QeRHULB : Discriminates th_4AnrXS8H w_7QeRHULB := by decide
theorem w_4AnrXS8H_theory_discriminates_9XvBYSKe : Discriminates th_4AnrXS8H w_9XvBYSKe := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ### `9XvBYSKe…` — the spammer that never reaches the pool

    377 transactions, none settled, and — unlike the three above — *not one* of them
    a slippage failure: this wallet's transactions die earlier, before the swap is
    attempted.  Same verdict, different mechanism, and the difference is provable.
-/

theorem w_9XvBYSKe_stats :
    nTx w_9XvBYSKe = 377 ∧ nOk w_9XvBYSKe = 0 ∧ nFail w_9XvBYSKe = 377 ∧ nSlip w_9XvBYSKe = 0 ∧
    nLive w_9XvBYSKe = 0 ∧ nMoves w_9XvBYSKe = 0 ∧ nBuys w_9XvBYSKe = 0 ∧ nSells w_9XvBYSKe = 0 ∧
    nExits w_9XvBYSKe = 0 ∧ fees w_9XvBYSKe = 11664468 ∧ burnt w_9XvBYSKe = 11664468 ∧ net w_9XvBYSKe = 0 := by
  decide

theorem w_9XvBYSKe_neverSettles : NeverSettles w_9XvBYSKe := by decide
theorem w_9XvBYSKe_inert : Inert w_9XvBYSKe := by decide
theorem w_9XvBYSKe_bystander : Bystander w_9XvBYSKe := by decide

theorem w_9XvBYSKe_verdict : verdict w_9XvBYSKe = .bad := by decide

/-- A theory of `9XvBYSKe…`: the shape every one of its 377 recorded transactions has. -/
def th_9XvBYSKe (t : Tx) : Bool := (t.ok == false) && (t.slip == false) && (t.live == false) && (t.moves == false) && (18408 ≤ t.fee) && (t.fee ≤ 66431) && (314228013 ≤ t.slot) && (t.slot ≤ 315489082)

theorem w_9XvBYSKe_theory_sound : Sound th_9XvBYSKe w_9XvBYSKe := by decide
theorem w_9XvBYSKe_theory_corroborated : Corroborated th_9XvBYSKe w_9XvBYSKe 377 := by decide
theorem w_9XvBYSKe_theory_discriminates_J3Z1AfTD : Discriminates th_9XvBYSKe w_J3Z1AfTD := by decide
theorem w_9XvBYSKe_theory_discriminates_7QeRHULB : Discriminates th_9XvBYSKe w_7QeRHULB := by decide
theorem w_9XvBYSKe_theory_discriminates_4AnrXS8H : Discriminates th_9XvBYSKe w_4AnrXS8H := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ### `C9YvTztk…` — the spammer with two accidents

    709 transactions of which exactly two settled, and those two moved the token for
    somebody else, never for this wallet.  A 99.7 % failure rate is not a
    misconfiguration, it is the operating mode.
-/

theorem w_C9YvTztk_stats :
    nTx w_C9YvTztk = 709 ∧ nOk w_C9YvTztk = 2 ∧ nFail w_C9YvTztk = 707 ∧ nSlip w_C9YvTztk = 681 ∧
    nLive w_C9YvTztk = 2 ∧ nMoves w_C9YvTztk = 0 ∧ nBuys w_C9YvTztk = 0 ∧ nSells w_C9YvTztk = 0 ∧
    nExits w_C9YvTztk = 0 ∧ fees w_C9YvTztk = 7810976 ∧ burnt w_C9YvTztk = 7799940 ∧ net w_C9YvTztk = 0 := by
  decide

theorem w_C9YvTztk_inert : Inert w_C9YvTztk := by decide

theorem w_C9YvTztk_verdict : verdict w_C9YvTztk = .bad := by decide

/-- A theory of `C9YvTztk…`: the shape every one of its 709 recorded transactions has. -/
def th_C9YvTztk (t : Tx) : Bool := (t.moves == false) && (5227 ≤ t.fee) && (t.fee ≤ 32231) && (314228423 ≤ t.slot) && (t.slot ≤ 314645789)

theorem w_C9YvTztk_theory_sound : Sound th_C9YvTztk w_C9YvTztk := by decide
theorem w_C9YvTztk_theory_corroborated : Corroborated th_C9YvTztk w_C9YvTztk 709 := by decide
theorem w_C9YvTztk_theory_discriminates_J3Z1AfTD : Discriminates th_C9YvTztk w_J3Z1AfTD := by decide
theorem w_C9YvTztk_theory_discriminates_7QeRHULB : Discriminates th_C9YvTztk w_7QeRHULB := by decide
theorem w_C9YvTztk_theory_discriminates_4AnrXS8H : Discriminates th_C9YvTztk w_4AnrXS8H := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ### `7dGrdJRY…` — the fee burner

    147 transactions, 4 of them settled, and 78 438 709 lamports paid — of which
    74 795 309 bought nothing.  Its largest single fee is 52 409 000 lamports
    (0.052 SOL) on a transaction that failed.  The one position it ever took, it
    closed: it sold 22 base units — 0.000022 of a token.
-/

theorem w_7dGrdJRY_stats :
    nTx w_7dGrdJRY = 147 ∧ nOk w_7dGrdJRY = 4 ∧ nFail w_7dGrdJRY = 143 ∧ nSlip w_7dGrdJRY = 0 ∧
    nLive w_7dGrdJRY = 4 ∧ nMoves w_7dGrdJRY = 1 ∧ nBuys w_7dGrdJRY = 0 ∧ nSells w_7dGrdJRY = 1 ∧
    nExits w_7dGrdJRY = 1 ∧ fees w_7dGrdJRY = 78438709 ∧ burnt w_7dGrdJRY = 74795309 ∧ net w_7dGrdJRY = -22 := by
  decide

theorem w_7dGrdJRY_exits : Exits w_7dGrdJRY := by decide

theorem w_7dGrdJRY_verdict : verdict w_7dGrdJRY = .bad := by decide

/-- A theory of `7dGrdJRY…`: the shape every one of its 147 recorded transactions has. -/
def th_7dGrdJRY (t : Tx) : Bool := (t.slip == false) && (5000 ≤ t.fee) && (t.fee ≤ 52409000) && (314228300 ≤ t.slot) && (t.slot ≤ 334033466)

theorem w_7dGrdJRY_theory_sound : Sound th_7dGrdJRY w_7dGrdJRY := by decide
theorem w_7dGrdJRY_theory_corroborated : Corroborated th_7dGrdJRY w_7dGrdJRY 147 := by decide
theorem w_7dGrdJRY_theory_discriminates_J3Z1AfTD : Discriminates th_7dGrdJRY w_J3Z1AfTD := by decide
theorem w_7dGrdJRY_theory_discriminates_7QeRHULB : Discriminates th_7dGrdJRY w_7QeRHULB := by decide
theorem w_7dGrdJRY_theory_discriminates_4AnrXS8H : Discriminates th_7dGrdJRY w_4AnrXS8H := by decide
-- Refuted by 17 of the other 21 analysed wallets.
/-- Not refuted by: `HxkTYMtx…`, `CMbBM2BW…`, `FwqxwTYu…`, `21nALQTX…` — at this resolution these records are
    indistinguishable from this one. -/
theorem w_7dGrdJRY_theory_also_fits_HxkTYMtx : Sound th_7dGrdJRY w_HxkTYMtx := by decide

/-! ### `HxkTYMtx…` — the bystander

    The busiest wallet in the whole sample: 1 892 transactions, 1 890 of which
    settled.  It is a model citizen by the settlement norm and a complete stranger to
    the token: in 1 892 transactions its own SOLFUNMEME balance never changes once,
    and the token moves for anybody at all in exactly one of them.  It appears in
    this token's index because its routes *mention* the mint.  Every count of
    "unique actors" that starts from `getSignaturesForAddress` counts this wallet.
-/

theorem w_HxkTYMtx_stats :
    nTx w_HxkTYMtx = 1892 ∧ nOk w_HxkTYMtx = 1890 ∧ nFail w_HxkTYMtx = 2 ∧ nSlip w_HxkTYMtx = 0 ∧
    nLive w_HxkTYMtx = 1 ∧ nMoves w_HxkTYMtx = 0 ∧ nBuys w_HxkTYMtx = 0 ∧ nSells w_HxkTYMtx = 0 ∧
    nExits w_HxkTYMtx = 0 ∧ fees w_HxkTYMtx = 74353622 ∧ burnt w_HxkTYMtx = 19258 ∧ net w_HxkTYMtx = 0 := by
  decide

theorem w_HxkTYMtx_inert : Inert w_HxkTYMtx := by decide

theorem w_HxkTYMtx_verdict : verdict w_HxkTYMtx = .bad := by decide

/-- A theory of `HxkTYMtx…`: the shape every one of its 1892 recorded transactions has. -/
def th_HxkTYMtx (t : Tx) : Bool := (t.slip == false) && (t.moves == false) && (5000 ≤ t.fee) && (t.fee ≤ 78556) && (314239607 ≤ t.slot) && (t.slot ≤ 326750230)

theorem w_HxkTYMtx_theory_sound : Sound th_HxkTYMtx w_HxkTYMtx := by decide
theorem w_HxkTYMtx_theory_corroborated : Corroborated th_HxkTYMtx w_HxkTYMtx 1892 := by decide
theorem w_HxkTYMtx_theory_discriminates_J3Z1AfTD : Discriminates th_HxkTYMtx w_J3Z1AfTD := by decide
theorem w_HxkTYMtx_theory_discriminates_7QeRHULB : Discriminates th_HxkTYMtx w_7QeRHULB := by decide
theorem w_HxkTYMtx_theory_discriminates_4AnrXS8H : Discriminates th_HxkTYMtx w_4AnrXS8H := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ### `EN4kMnNm…` — the inert fleet member

    132 transactions, all of which settled, none of which moved the token for anyone.
-/

theorem w_EN4kMnNm_stats :
    nTx w_EN4kMnNm = 132 ∧ nOk w_EN4kMnNm = 132 ∧ nFail w_EN4kMnNm = 0 ∧ nSlip w_EN4kMnNm = 0 ∧
    nLive w_EN4kMnNm = 0 ∧ nMoves w_EN4kMnNm = 0 ∧ nBuys w_EN4kMnNm = 0 ∧ nSells w_EN4kMnNm = 0 ∧
    nExits w_EN4kMnNm = 0 ∧ fees w_EN4kMnNm = 13317379 ∧ burnt w_EN4kMnNm = 0 ∧ net w_EN4kMnNm = 0 := by
  decide

theorem w_EN4kMnNm_alwaysSettles : AlwaysSettles w_EN4kMnNm := by decide
theorem w_EN4kMnNm_inert : Inert w_EN4kMnNm := by decide
theorem w_EN4kMnNm_bystander : Bystander w_EN4kMnNm := by decide

theorem w_EN4kMnNm_verdict : verdict w_EN4kMnNm = .bad := by decide

/-- A theory of `EN4kMnNm…`: the shape every one of its 132 recorded transactions has. -/
def th_EN4kMnNm (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (t.live == false) && (t.moves == false) && (5000 ≤ t.fee) && (t.fee ≤ 483671) && (314226180 ≤ t.slot) && (t.slot ≤ 314241161)

theorem w_EN4kMnNm_theory_sound : Sound th_EN4kMnNm w_EN4kMnNm := by decide
theorem w_EN4kMnNm_theory_corroborated : Corroborated th_EN4kMnNm w_EN4kMnNm 132 := by decide
theorem w_EN4kMnNm_theory_discriminates_J3Z1AfTD : Discriminates th_EN4kMnNm w_J3Z1AfTD := by decide
theorem w_EN4kMnNm_theory_discriminates_7QeRHULB : Discriminates th_EN4kMnNm w_7QeRHULB := by decide
theorem w_EN4kMnNm_theory_discriminates_4AnrXS8H : Discriminates th_EN4kMnNm w_4AnrXS8H := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ### `686oaTQa…` — the accumulator

    188 transactions, all settled; five acquisitions against one disposal, and a net
    gain of 2 748 573 432 958 base units (2.75 million tokens).  The one disposal took
    its position to zero, so it fails the custody norm — it left, and came back.
-/

theorem w_686oaTQa_stats :
    nTx w_686oaTQa = 188 ∧ nOk w_686oaTQa = 188 ∧ nFail w_686oaTQa = 0 ∧ nSlip w_686oaTQa = 0 ∧
    nLive w_686oaTQa = 6 ∧ nMoves w_686oaTQa = 6 ∧ nBuys w_686oaTQa = 5 ∧ nSells w_686oaTQa = 1 ∧
    nExits w_686oaTQa = 1 ∧ fees w_686oaTQa = 24181933 ∧ burnt w_686oaTQa = 0 ∧ net w_686oaTQa = 2748573432958 := by
  decide

theorem w_686oaTQa_alwaysSettles : AlwaysSettles w_686oaTQa := by decide
theorem w_686oaTQa_twoWay : TwoWay w_686oaTQa := by decide
theorem w_686oaTQa_exits : Exits w_686oaTQa := by decide

theorem w_686oaTQa_verdict : verdict w_686oaTQa = .mixed := by decide

/-- A theory of `686oaTQa…`: the shape every one of its 188 recorded transactions has. -/
def th_686oaTQa (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (5000 ≤ t.fee) && (t.fee ≤ 483671) && (314226185 ≤ t.slot) && (t.slot ≤ 314241549)

theorem w_686oaTQa_theory_sound : Sound th_686oaTQa w_686oaTQa := by decide
theorem w_686oaTQa_theory_corroborated : Corroborated th_686oaTQa w_686oaTQa 188 := by decide
theorem w_686oaTQa_theory_discriminates_J3Z1AfTD : Discriminates th_686oaTQa w_J3Z1AfTD := by decide
theorem w_686oaTQa_theory_discriminates_7QeRHULB : Discriminates th_686oaTQa w_7QeRHULB := by decide
theorem w_686oaTQa_theory_discriminates_4AnrXS8H : Discriminates th_686oaTQa w_4AnrXS8H := by decide
-- Refuted by 18 of the other 21 analysed wallets.
/-- Not refuted by: `6VzidcFh…`, `5ssQGkUG…`, `6DAHh1hH…` — at this resolution these records are
    indistinguishable from this one. -/
theorem w_686oaTQa_theory_also_fits_6VzidcFh : Sound th_686oaTQa w_6VzidcFh := by decide

/-! ### `6VzidcFh…` — the buyer that never sold

    121 transactions, all settled, two acquisitions, no disposal, no exit: the only
    wallet in this analysis that meets all four norms.
-/

theorem w_6VzidcFh_stats :
    nTx w_6VzidcFh = 121 ∧ nOk w_6VzidcFh = 121 ∧ nFail w_6VzidcFh = 0 ∧ nSlip w_6VzidcFh = 0 ∧
    nLive w_6VzidcFh = 2 ∧ nMoves w_6VzidcFh = 2 ∧ nBuys w_6VzidcFh = 2 ∧ nSells w_6VzidcFh = 0 ∧
    nExits w_6VzidcFh = 0 ∧ fees w_6VzidcFh = 20465670 ∧ burnt w_6VzidcFh = 0 ∧ net w_6VzidcFh = 498129900670 := by
  decide

theorem w_6VzidcFh_alwaysSettles : AlwaysSettles w_6VzidcFh := by decide
theorem w_6VzidcFh_onlyAcquires : OnlyAcquires w_6VzidcFh := by decide

theorem w_6VzidcFh_verdict : verdict w_6VzidcFh = .good := by decide

/-- A theory of `6VzidcFh…`: the shape every one of its 121 recorded transactions has. -/
def th_6VzidcFh (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (5000 ≤ t.fee) && (t.fee ≤ 483671) && (314226791 ≤ t.slot) && (t.slot ≤ 314237266)

theorem w_6VzidcFh_theory_sound : Sound th_6VzidcFh w_6VzidcFh := by decide
theorem w_6VzidcFh_theory_corroborated : Corroborated th_6VzidcFh w_6VzidcFh 121 := by decide
theorem w_6VzidcFh_theory_discriminates_J3Z1AfTD : Discriminates th_6VzidcFh w_J3Z1AfTD := by decide
theorem w_6VzidcFh_theory_discriminates_7QeRHULB : Discriminates th_6VzidcFh w_7QeRHULB := by decide
theorem w_6VzidcFh_theory_discriminates_4AnrXS8H : Discriminates th_6VzidcFh w_4AnrXS8H := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ### `27XHsdyK…` — the four-for-one trader

    135 transactions, all settled, four acquisitions and one disposal, net
    +719 845 402 765.  Ranked `gold` — a House seat — by the dataset's own snapshot,
    and classified there as a *closed* account.
-/

theorem w_27XHsdyK_stats :
    nTx w_27XHsdyK = 135 ∧ nOk w_27XHsdyK = 135 ∧ nFail w_27XHsdyK = 0 ∧ nSlip w_27XHsdyK = 0 ∧
    nLive w_27XHsdyK = 5 ∧ nMoves w_27XHsdyK = 5 ∧ nBuys w_27XHsdyK = 4 ∧ nSells w_27XHsdyK = 1 ∧
    nExits w_27XHsdyK = 1 ∧ fees w_27XHsdyK = 22076760 ∧ burnt w_27XHsdyK = 0 ∧ net w_27XHsdyK = 719845402765 := by
  decide

theorem w_27XHsdyK_alwaysSettles : AlwaysSettles w_27XHsdyK := by decide
theorem w_27XHsdyK_twoWay : TwoWay w_27XHsdyK := by decide
theorem w_27XHsdyK_exits : Exits w_27XHsdyK := by decide

theorem w_27XHsdyK_verdict : verdict w_27XHsdyK = .mixed := by decide

/-- A theory of `27XHsdyK…`: the shape every one of its 135 recorded transactions has. -/
def th_27XHsdyK (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (5000 ≤ t.fee) && (t.fee ≤ 483671) && (314226182 ≤ t.slot) && (t.slot ≤ 314237266)

theorem w_27XHsdyK_theory_sound : Sound th_27XHsdyK w_27XHsdyK := by decide
theorem w_27XHsdyK_theory_corroborated : Corroborated th_27XHsdyK w_27XHsdyK 135 := by decide
theorem w_27XHsdyK_theory_discriminates_J3Z1AfTD : Discriminates th_27XHsdyK w_J3Z1AfTD := by decide
theorem w_27XHsdyK_theory_discriminates_7QeRHULB : Discriminates th_27XHsdyK w_7QeRHULB := by decide
theorem w_27XHsdyK_theory_discriminates_4AnrXS8H : Discriminates th_27XHsdyK w_4AnrXS8H := by decide
-- Refuted by 19 of the other 21 analysed wallets.
/-- Not refuted by: `6VzidcFh…`, `5ssQGkUG…` — at this resolution these records are
    indistinguishable from this one. -/
theorem w_27XHsdyK_theory_also_fits_6VzidcFh : Sound th_27XHsdyK w_6VzidcFh := by decide

/-! ### `5ssQGkUG…` — the small two-way trader

    119 transactions, all settled, three acquisitions and two disposals, net
    +36 782 526 059.
-/

theorem w_5ssQGkUG_stats :
    nTx w_5ssQGkUG = 119 ∧ nOk w_5ssQGkUG = 119 ∧ nFail w_5ssQGkUG = 0 ∧ nSlip w_5ssQGkUG = 0 ∧
    nLive w_5ssQGkUG = 5 ∧ nMoves w_5ssQGkUG = 5 ∧ nBuys w_5ssQGkUG = 3 ∧ nSells w_5ssQGkUG = 2 ∧
    nExits w_5ssQGkUG = 2 ∧ fees w_5ssQGkUG = 16424241 ∧ burnt w_5ssQGkUG = 0 ∧ net w_5ssQGkUG = 36782526059 := by
  decide

theorem w_5ssQGkUG_alwaysSettles : AlwaysSettles w_5ssQGkUG := by decide
theorem w_5ssQGkUG_twoWay : TwoWay w_5ssQGkUG := by decide
theorem w_5ssQGkUG_exits : Exits w_5ssQGkUG := by decide

theorem w_5ssQGkUG_verdict : verdict w_5ssQGkUG = .mixed := by decide

/-- A theory of `5ssQGkUG…`: the shape every one of its 119 recorded transactions has. -/
def th_5ssQGkUG (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (5000 ≤ t.fee) && (t.fee ≤ 483671) && (314226190 ≤ t.slot) && (t.slot ≤ 314237250)

theorem w_5ssQGkUG_theory_sound : Sound th_5ssQGkUG w_5ssQGkUG := by decide
theorem w_5ssQGkUG_theory_corroborated : Corroborated th_5ssQGkUG w_5ssQGkUG 119 := by decide
theorem w_5ssQGkUG_theory_discriminates_J3Z1AfTD : Discriminates th_5ssQGkUG w_J3Z1AfTD := by decide
theorem w_5ssQGkUG_theory_discriminates_7QeRHULB : Discriminates th_5ssQGkUG w_7QeRHULB := by decide
theorem w_5ssQGkUG_theory_discriminates_4AnrXS8H : Discriminates th_5ssQGkUG w_4AnrXS8H := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ### `F4oEKU8a…` — the distributor with a House rank

    264 transactions, all settled, two acquisitions against four disposals and a net
    loss of 2 316 745 430 451 base units.  Four of its transactions take its holding
    to zero.  The dataset's `holder_identities.json` nevertheless ranks it `gold`,
    i.e. inside the 500-seat House, and records it as a closed account.
-/

theorem w_F4oEKU8a_stats :
    nTx w_F4oEKU8a = 264 ∧ nOk w_F4oEKU8a = 264 ∧ nFail w_F4oEKU8a = 0 ∧ nSlip w_F4oEKU8a = 0 ∧
    nLive w_F4oEKU8a = 6 ∧ nMoves w_F4oEKU8a = 6 ∧ nBuys w_F4oEKU8a = 2 ∧ nSells w_F4oEKU8a = 4 ∧
    nExits w_F4oEKU8a = 4 ∧ fees w_F4oEKU8a = 22383165 ∧ burnt w_F4oEKU8a = 0 ∧ net w_F4oEKU8a = -2316745430451 := by
  decide

theorem w_F4oEKU8a_alwaysSettles : AlwaysSettles w_F4oEKU8a := by decide
theorem w_F4oEKU8a_twoWay : TwoWay w_F4oEKU8a := by decide
theorem w_F4oEKU8a_exits : Exits w_F4oEKU8a := by decide

theorem w_F4oEKU8a_verdict : verdict w_F4oEKU8a = .mixed := by decide

/-- A theory of `F4oEKU8a…`: the shape every one of its 264 recorded transactions has. -/
def th_F4oEKU8a (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (5000 ≤ t.fee) && (t.fee ≤ 483671) && (314225849 ≤ t.slot) && (t.slot ≤ 314625401)

theorem w_F4oEKU8a_theory_sound : Sound th_F4oEKU8a w_F4oEKU8a := by decide
theorem w_F4oEKU8a_theory_corroborated : Corroborated th_F4oEKU8a w_F4oEKU8a 264 := by decide
theorem w_F4oEKU8a_theory_discriminates_J3Z1AfTD : Discriminates th_F4oEKU8a w_J3Z1AfTD := by decide
theorem w_F4oEKU8a_theory_discriminates_7QeRHULB : Discriminates th_F4oEKU8a w_7QeRHULB := by decide
theorem w_F4oEKU8a_theory_discriminates_4AnrXS8H : Discriminates th_F4oEKU8a w_4AnrXS8H := by decide
-- Refuted by 12 of the other 21 analysed wallets.
/-- Not refuted by: `EN4kMnNm…`, `686oaTQa…`, `6VzidcFh…`, `27XHsdyK…`, `5ssQGkUG…`, `G1uSQxpf…`, `FTotzvz1…`, `6DAHh1hH…`, `x3pJA2jG…` — at this resolution these records are
    indistinguishable from this one. -/
theorem w_F4oEKU8a_theory_also_fits_EN4kMnNm : Sound th_F4oEKU8a w_EN4kMnNm := by decide

/-! ### `G1uSQxpf…` — the distributor with a Lobby rank

    147 transactions, all settled, two for two, net −1 004 355 552 758; ranked
    `silver` (Lobby) and closed.
-/

theorem w_G1uSQxpf_stats :
    nTx w_G1uSQxpf = 147 ∧ nOk w_G1uSQxpf = 147 ∧ nFail w_G1uSQxpf = 0 ∧ nSlip w_G1uSQxpf = 0 ∧
    nLive w_G1uSQxpf = 4 ∧ nMoves w_G1uSQxpf = 4 ∧ nBuys w_G1uSQxpf = 2 ∧ nSells w_G1uSQxpf = 2 ∧
    nExits w_G1uSQxpf = 2 ∧ fees w_G1uSQxpf = 15524775 ∧ burnt w_G1uSQxpf = 0 ∧ net w_G1uSQxpf = -1004355552758 := by
  decide

theorem w_G1uSQxpf_alwaysSettles : AlwaysSettles w_G1uSQxpf := by decide
theorem w_G1uSQxpf_twoWay : TwoWay w_G1uSQxpf := by decide
theorem w_G1uSQxpf_exits : Exits w_G1uSQxpf := by decide

theorem w_G1uSQxpf_verdict : verdict w_G1uSQxpf = .mixed := by decide

/-- A theory of `G1uSQxpf…`: the shape every one of its 147 recorded transactions has. -/
def th_G1uSQxpf (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (5000 ≤ t.fee) && (t.fee ≤ 483671) && (314226170 ≤ t.slot) && (t.slot ≤ 314241183)

theorem w_G1uSQxpf_theory_sound : Sound th_G1uSQxpf w_G1uSQxpf := by decide
theorem w_G1uSQxpf_theory_corroborated : Corroborated th_G1uSQxpf w_G1uSQxpf 147 := by decide
theorem w_G1uSQxpf_theory_discriminates_J3Z1AfTD : Discriminates th_G1uSQxpf w_J3Z1AfTD := by decide
theorem w_G1uSQxpf_theory_discriminates_7QeRHULB : Discriminates th_G1uSQxpf w_7QeRHULB := by decide
theorem w_G1uSQxpf_theory_discriminates_4AnrXS8H : Discriminates th_G1uSQxpf w_4AnrXS8H := by decide
-- Refuted by 16 of the other 21 analysed wallets.
/-- Not refuted by: `EN4kMnNm…`, `6VzidcFh…`, `27XHsdyK…`, `5ssQGkUG…`, `FTotzvz1…` — at this resolution these records are
    indistinguishable from this one. -/
theorem w_G1uSQxpf_theory_also_fits_EN4kMnNm : Sound th_G1uSQxpf w_EN4kMnNm := by decide

/-! ### `DLp2YLYc…` — the trader with a House rank

    281 transactions, 280 settled, two acquisitions against one disposal, net
    +751 916 927 536; ranked `gold` and closed.
-/

theorem w_DLp2YLYc_stats :
    nTx w_DLp2YLYc = 281 ∧ nOk w_DLp2YLYc = 280 ∧ nFail w_DLp2YLYc = 1 ∧ nSlip w_DLp2YLYc = 0 ∧
    nLive w_DLp2YLYc = 3 ∧ nMoves w_DLp2YLYc = 3 ∧ nBuys w_DLp2YLYc = 2 ∧ nSells w_DLp2YLYc = 1 ∧
    nExits w_DLp2YLYc = 1 ∧ fees w_DLp2YLYc = 22246982 ∧ burnt w_DLp2YLYc = 30000 ∧ net w_DLp2YLYc = 751916927536 := by
  decide

theorem w_DLp2YLYc_twoWay : TwoWay w_DLp2YLYc := by decide
theorem w_DLp2YLYc_exits : Exits w_DLp2YLYc := by decide

theorem w_DLp2YLYc_verdict : verdict w_DLp2YLYc = .mixed := by decide

/-- A theory of `DLp2YLYc…`: the shape every one of its 281 recorded transactions has. -/
def th_DLp2YLYc (t : Tx) : Bool := (t.slip == false) && (5000 ≤ t.fee) && (t.fee ≤ 483671) && (314225836 ≤ t.slot) && (t.slot ≤ 314625405)

theorem w_DLp2YLYc_theory_sound : Sound th_DLp2YLYc w_DLp2YLYc := by decide
theorem w_DLp2YLYc_theory_corroborated : Corroborated th_DLp2YLYc w_DLp2YLYc 281 := by decide
theorem w_DLp2YLYc_theory_discriminates_J3Z1AfTD : Discriminates th_DLp2YLYc w_J3Z1AfTD := by decide
theorem w_DLp2YLYc_theory_discriminates_7QeRHULB : Discriminates th_DLp2YLYc w_7QeRHULB := by decide
theorem w_DLp2YLYc_theory_discriminates_4AnrXS8H : Discriminates th_DLp2YLYc w_4AnrXS8H := by decide
-- Refuted by 11 of the other 21 analysed wallets.
/-- Not refuted by: `EN4kMnNm…`, `686oaTQa…`, `6VzidcFh…`, `27XHsdyK…`, `5ssQGkUG…`, `F4oEKU8a…`, `G1uSQxpf…`, `FTotzvz1…`, `6DAHh1hH…`, `x3pJA2jG…` — at this resolution these records are
    indistinguishable from this one. -/
theorem w_DLp2YLYc_theory_also_fits_EN4kMnNm : Sound th_DLp2YLYc w_EN4kMnNm := by decide

/-! ### `HCb7hLss…` — the three-for-three trader

    281 transactions, 280 settled, three acquisitions against three disposals, net
    −1 001 618 842 378, three exits.
-/

theorem w_HCb7hLss_stats :
    nTx w_HCb7hLss = 281 ∧ nOk w_HCb7hLss = 280 ∧ nFail w_HCb7hLss = 1 ∧ nSlip w_HCb7hLss = 0 ∧
    nLive w_HCb7hLss = 6 ∧ nMoves w_HCb7hLss = 6 ∧ nBuys w_HCb7hLss = 3 ∧ nSells w_HCb7hLss = 3 ∧
    nExits w_HCb7hLss = 3 ∧ fees w_HCb7hLss = 22545794 ∧ burnt w_HCb7hLss = 30000 ∧ net w_HCb7hLss = -1001618842378 := by
  decide

theorem w_HCb7hLss_twoWay : TwoWay w_HCb7hLss := by decide
theorem w_HCb7hLss_exits : Exits w_HCb7hLss := by decide

theorem w_HCb7hLss_verdict : verdict w_HCb7hLss = .mixed := by decide

/-- A theory of `HCb7hLss…`: the shape every one of its 281 recorded transactions has. -/
def th_HCb7hLss (t : Tx) : Bool := (t.slip == false) && (5000 ≤ t.fee) && (t.fee ≤ 483671) && (314225834 ≤ t.slot) && (t.slot ≤ 314625403)

theorem w_HCb7hLss_theory_sound : Sound th_HCb7hLss w_HCb7hLss := by decide
theorem w_HCb7hLss_theory_corroborated : Corroborated th_HCb7hLss w_HCb7hLss 281 := by decide
theorem w_HCb7hLss_theory_discriminates_J3Z1AfTD : Discriminates th_HCb7hLss w_J3Z1AfTD := by decide
theorem w_HCb7hLss_theory_discriminates_7QeRHULB : Discriminates th_HCb7hLss w_7QeRHULB := by decide
theorem w_HCb7hLss_theory_discriminates_4AnrXS8H : Discriminates th_HCb7hLss w_4AnrXS8H := by decide
-- Refuted by 11 of the other 21 analysed wallets.
/-- Not refuted by: `EN4kMnNm…`, `686oaTQa…`, `6VzidcFh…`, `27XHsdyK…`, `5ssQGkUG…`, `F4oEKU8a…`, `G1uSQxpf…`, `FTotzvz1…`, `6DAHh1hH…`, `x3pJA2jG…` — at this resolution these records are
    indistinguishable from this one. -/
theorem w_HCb7hLss_theory_also_fits_EN4kMnNm : Sound th_HCb7hLss w_EN4kMnNm := by decide

/-! ### `FTotzvz1…` — the other three-for-three trader

    169 transactions, all settled, three for three, net −118 890 105 201.
-/

theorem w_FTotzvz1_stats :
    nTx w_FTotzvz1 = 169 ∧ nOk w_FTotzvz1 = 169 ∧ nFail w_FTotzvz1 = 0 ∧ nSlip w_FTotzvz1 = 0 ∧
    nLive w_FTotzvz1 = 6 ∧ nMoves w_FTotzvz1 = 6 ∧ nBuys w_FTotzvz1 = 3 ∧ nSells w_FTotzvz1 = 3 ∧
    nExits w_FTotzvz1 = 3 ∧ fees w_FTotzvz1 = 18547619 ∧ burnt w_FTotzvz1 = 0 ∧ net w_FTotzvz1 = -118890105201 := by
  decide

theorem w_FTotzvz1_alwaysSettles : AlwaysSettles w_FTotzvz1 := by decide
theorem w_FTotzvz1_twoWay : TwoWay w_FTotzvz1 := by decide
theorem w_FTotzvz1_exits : Exits w_FTotzvz1 := by decide

theorem w_FTotzvz1_verdict : verdict w_FTotzvz1 = .mixed := by decide

/-- A theory of `FTotzvz1…`: the shape every one of its 169 recorded transactions has. -/
def th_FTotzvz1 (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (5000 ≤ t.fee) && (t.fee ≤ 483671) && (314226171 ≤ t.slot) && (t.slot ≤ 314241176)

theorem w_FTotzvz1_theory_sound : Sound th_FTotzvz1 w_FTotzvz1 := by decide
theorem w_FTotzvz1_theory_corroborated : Corroborated th_FTotzvz1 w_FTotzvz1 169 := by decide
theorem w_FTotzvz1_theory_discriminates_J3Z1AfTD : Discriminates th_FTotzvz1 w_J3Z1AfTD := by decide
theorem w_FTotzvz1_theory_discriminates_7QeRHULB : Discriminates th_FTotzvz1 w_7QeRHULB := by decide
theorem w_FTotzvz1_theory_discriminates_4AnrXS8H : Discriminates th_FTotzvz1 w_4AnrXS8H := by decide
-- Refuted by 17 of the other 21 analysed wallets.
/-- Not refuted by: `EN4kMnNm…`, `6VzidcFh…`, `27XHsdyK…`, `5ssQGkUG…` — at this resolution these records are
    indistinguishable from this one. -/
theorem w_FTotzvz1_theory_also_fits_EN4kMnNm : Sound th_FTotzvz1 w_EN4kMnNm := by decide

/-! ### `6DAHh1hH…` — the one-for-one trader with a House rank

    186 transactions, all settled, one acquisition and one disposal, net
    −94 189 454 178; ranked `gold` and closed.
-/

theorem w_6DAHh1hH_stats :
    nTx w_6DAHh1hH = 186 ∧ nOk w_6DAHh1hH = 186 ∧ nFail w_6DAHh1hH = 0 ∧ nSlip w_6DAHh1hH = 0 ∧
    nLive w_6DAHh1hH = 2 ∧ nMoves w_6DAHh1hH = 2 ∧ nBuys w_6DAHh1hH = 1 ∧ nSells w_6DAHh1hH = 1 ∧
    nExits w_6DAHh1hH = 1 ∧ fees w_6DAHh1hH = 21505241 ∧ burnt w_6DAHh1hH = 0 ∧ net w_6DAHh1hH = -94189454178 := by
  decide

theorem w_6DAHh1hH_alwaysSettles : AlwaysSettles w_6DAHh1hH := by decide
theorem w_6DAHh1hH_twoWay : TwoWay w_6DAHh1hH := by decide
theorem w_6DAHh1hH_exits : Exits w_6DAHh1hH := by decide

theorem w_6DAHh1hH_verdict : verdict w_6DAHh1hH = .mixed := by decide

/-- A theory of `6DAHh1hH…`: the shape every one of its 186 recorded transactions has. -/
def th_6DAHh1hH (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (5000 ≤ t.fee) && (t.fee ≤ 483671) && (314226792 ≤ t.slot) && (t.slot ≤ 314241540)

theorem w_6DAHh1hH_theory_sound : Sound th_6DAHh1hH w_6DAHh1hH := by decide
theorem w_6DAHh1hH_theory_corroborated : Corroborated th_6DAHh1hH w_6DAHh1hH 186 := by decide
theorem w_6DAHh1hH_theory_discriminates_J3Z1AfTD : Discriminates th_6DAHh1hH w_J3Z1AfTD := by decide
theorem w_6DAHh1hH_theory_discriminates_7QeRHULB : Discriminates th_6DAHh1hH w_7QeRHULB := by decide
theorem w_6DAHh1hH_theory_discriminates_4AnrXS8H : Discriminates th_6DAHh1hH w_4AnrXS8H := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ### `x3pJA2jG…` — the single seller

    307 transactions, every one of them settled, and exactly one of them touches the
    token: it sells 547 790 364 478 base units and goes to zero.  The other 306 are
    the machinery around that one trade.
-/

theorem w_x3pJA2jG_stats :
    nTx w_x3pJA2jG = 307 ∧ nOk w_x3pJA2jG = 307 ∧ nFail w_x3pJA2jG = 0 ∧ nSlip w_x3pJA2jG = 0 ∧
    nLive w_x3pJA2jG = 1 ∧ nMoves w_x3pJA2jG = 1 ∧ nBuys w_x3pJA2jG = 0 ∧ nSells w_x3pJA2jG = 1 ∧
    nExits w_x3pJA2jG = 1 ∧ fees w_x3pJA2jG = 15726902 ∧ burnt w_x3pJA2jG = 0 ∧ net w_x3pJA2jG = -547790364478 := by
  decide

theorem w_x3pJA2jG_alwaysSettles : AlwaysSettles w_x3pJA2jG := by decide
theorem w_x3pJA2jG_exits : Exits w_x3pJA2jG := by decide

theorem w_x3pJA2jG_verdict : verdict w_x3pJA2jG = .mixed := by decide

/-- A theory of `x3pJA2jG…`: the shape every one of its 307 recorded transactions has. -/
def th_x3pJA2jG (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (6726 ≤ t.fee) && (t.fee ≤ 409033) && (314226169 ≤ t.slot) && (t.slot ≤ 314290512)

theorem w_x3pJA2jG_theory_sound : Sound th_x3pJA2jG w_x3pJA2jG := by decide
theorem w_x3pJA2jG_theory_corroborated : Corroborated th_x3pJA2jG w_x3pJA2jG 307 := by decide
theorem w_x3pJA2jG_theory_discriminates_J3Z1AfTD : Discriminates th_x3pJA2jG w_J3Z1AfTD := by decide
theorem w_x3pJA2jG_theory_discriminates_7QeRHULB : Discriminates th_x3pJA2jG w_7QeRHULB := by decide
theorem w_x3pJA2jG_theory_discriminates_4AnrXS8H : Discriminates th_x3pJA2jG w_4AnrXS8H := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ### `CMbBM2BW…` — the retail two-way participant

    Five transactions, all settled, all of them moving the token: four acquisitions
    and one disposal, and it never went to zero.
-/

theorem w_CMbBM2BW_stats :
    nTx w_CMbBM2BW = 5 ∧ nOk w_CMbBM2BW = 5 ∧ nFail w_CMbBM2BW = 0 ∧ nSlip w_CMbBM2BW = 0 ∧
    nLive w_CMbBM2BW = 5 ∧ nMoves w_CMbBM2BW = 5 ∧ nBuys w_CMbBM2BW = 4 ∧ nSells w_CMbBM2BW = 1 ∧
    nExits w_CMbBM2BW = 0 ∧ fees w_CMbBM2BW = 4953812 ∧ burnt w_CMbBM2BW = 0 ∧ net w_CMbBM2BW = -1899661477834 := by
  decide

theorem w_CMbBM2BW_alwaysSettles : AlwaysSettles w_CMbBM2BW := by decide
theorem w_CMbBM2BW_twoWay : TwoWay w_CMbBM2BW := by decide

theorem w_CMbBM2BW_verdict : verdict w_CMbBM2BW = .good := by decide

/-- A theory of `CMbBM2BW…`: the shape every one of its 5 recorded transactions has. -/
def th_CMbBM2BW (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (t.live == true) && (t.moves == true) && (80001 ≤ t.fee) && (t.fee ≤ 4005000) && (314263407 ≤ t.slot) && (t.slot ≤ 330624302)

theorem w_CMbBM2BW_theory_sound : Sound th_CMbBM2BW w_CMbBM2BW := by decide
theorem w_CMbBM2BW_theory_corroborated : Corroborated th_CMbBM2BW w_CMbBM2BW 5 := by decide
theorem w_CMbBM2BW_theory_discriminates_J3Z1AfTD : Discriminates th_CMbBM2BW w_J3Z1AfTD := by decide
theorem w_CMbBM2BW_theory_discriminates_7QeRHULB : Discriminates th_CMbBM2BW w_7QeRHULB := by decide
theorem w_CMbBM2BW_theory_discriminates_4AnrXS8H : Discriminates th_CMbBM2BW w_4AnrXS8H := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ### `FwqxwTYu…` — the retail buyer

    Four transactions, four acquisitions, nothing else.
-/

theorem w_FwqxwTYu_stats :
    nTx w_FwqxwTYu = 4 ∧ nOk w_FwqxwTYu = 4 ∧ nFail w_FwqxwTYu = 0 ∧ nSlip w_FwqxwTYu = 0 ∧
    nLive w_FwqxwTYu = 4 ∧ nMoves w_FwqxwTYu = 4 ∧ nBuys w_FwqxwTYu = 4 ∧ nSells w_FwqxwTYu = 0 ∧
    nExits w_FwqxwTYu = 0 ∧ fees w_FwqxwTYu = 620000 ∧ burnt w_FwqxwTYu = 0 ∧ net w_FwqxwTYu = 283103319232 := by
  decide

theorem w_FwqxwTYu_alwaysSettles : AlwaysSettles w_FwqxwTYu := by decide
theorem w_FwqxwTYu_onlyAcquires : OnlyAcquires w_FwqxwTYu := by decide

theorem w_FwqxwTYu_verdict : verdict w_FwqxwTYu = .good := by decide

/-- A theory of `FwqxwTYu…`: the shape every one of its 4 recorded transactions has. -/
def th_FwqxwTYu (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (t.live == true) && (t.moves == true) && (5000 ≤ t.fee) && (t.fee ≤ 305000) && (315056805 ≤ t.slot) && (t.slot ≤ 317426252)

theorem w_FwqxwTYu_theory_sound : Sound th_FwqxwTYu w_FwqxwTYu := by decide
theorem w_FwqxwTYu_theory_corroborated : Corroborated th_FwqxwTYu w_FwqxwTYu 4 := by decide
theorem w_FwqxwTYu_theory_discriminates_J3Z1AfTD : Discriminates th_FwqxwTYu w_J3Z1AfTD := by decide
theorem w_FwqxwTYu_theory_discriminates_7QeRHULB : Discriminates th_FwqxwTYu w_7QeRHULB := by decide
theorem w_FwqxwTYu_theory_discriminates_4AnrXS8H : Discriminates th_FwqxwTYu w_4AnrXS8H := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ### `21nALQTX…` — the retail trader

    Four transactions, three acquisitions and one disposal, no exit.
-/

theorem w_21nALQTX_stats :
    nTx w_21nALQTX = 4 ∧ nOk w_21nALQTX = 4 ∧ nFail w_21nALQTX = 0 ∧ nSlip w_21nALQTX = 0 ∧
    nLive w_21nALQTX = 4 ∧ nMoves w_21nALQTX = 4 ∧ nBuys w_21nALQTX = 3 ∧ nSells w_21nALQTX = 1 ∧
    nExits w_21nALQTX = 0 ∧ fees w_21nALQTX = 310593 ∧ burnt w_21nALQTX = 0 ∧ net w_21nALQTX = 664534442546 := by
  decide

theorem w_21nALQTX_alwaysSettles : AlwaysSettles w_21nALQTX := by decide
theorem w_21nALQTX_twoWay : TwoWay w_21nALQTX := by decide

theorem w_21nALQTX_verdict : verdict w_21nALQTX = .good := by decide

/-- A theory of `21nALQTX…`: the shape every one of its 4 recorded transactions has. -/
def th_21nALQTX (t : Tx) : Bool := (t.ok == true) && (t.slip == false) && (t.live == true) && (t.moves == true) && (70590 ≤ t.fee) && (t.fee ≤ 80001) && (326668811 ≤ t.slot) && (t.slot ≤ 329478812)

theorem w_21nALQTX_theory_sound : Sound th_21nALQTX w_21nALQTX := by decide
theorem w_21nALQTX_theory_corroborated : Corroborated th_21nALQTX w_21nALQTX 4 := by decide
theorem w_21nALQTX_theory_discriminates_J3Z1AfTD : Discriminates th_21nALQTX w_J3Z1AfTD := by decide
theorem w_21nALQTX_theory_discriminates_7QeRHULB : Discriminates th_21nALQTX w_7QeRHULB := by decide
theorem w_21nALQTX_theory_discriminates_4AnrXS8H : Discriminates th_21nALQTX w_4AnrXS8H := by decide
-- Refuted by 21 of the other 21 analysed wallets.

/-! ## A fleet

Eleven of the analysed wallets are not merely similar, they are *interchangeable*:
they trade in the same short window of slots, they land in the same blocks far
more often than their activity would suggest, and they pay from the same small
vocabulary of priority fees — down to values like 483 671 and 477 371 lamports,
which no other analysed wallet ever pays.

None of this proves common control; it is the evidence, and it is what the
theorems state.
-/

/-- The priority-fee values that occur in the record of *every* one of the eleven. -/
def fleetFees : List Nat := [5000, 57500, 73250, 89000, 95300, 430121, 464771, 477371, 483671]

/-- Those of them that are not the bare base fee of 5 000 lamports. -/
def fleetFeesExotic : List Nat := [57500, 73250, 89000, 95300, 430121, 464771, 477371, 483671]

/-- Does the record contain a transaction paying exactly this fee? -/
def paysFee (l : List Tx) (f : Nat) : Bool := l.any (fun t => t.fee == f)

/-- The slots in which the record has a transaction. -/
def slotsOf (l : List Tx) : List Nat := l.map (fun t => t.slot)

/-- How many transactions of `a` land in a slot that also carries one of `b`. -/
def coSlots (a b : List Tx) : Nat :=
  ((slotsOf a).filter (fun s => (slotsOf b).contains s)).length

theorem fleet_fees_wEN4kMnNm : ∀ f ∈ fleetFees, paysFee w_EN4kMnNm f = true := by decide
theorem fleet_fees_w686oaTQa : ∀ f ∈ fleetFees, paysFee w_686oaTQa f = true := by decide
theorem fleet_fees_w6VzidcFh : ∀ f ∈ fleetFees, paysFee w_6VzidcFh f = true := by decide
theorem fleet_fees_w27XHsdyK : ∀ f ∈ fleetFees, paysFee w_27XHsdyK f = true := by decide
theorem fleet_fees_w5ssQGkUG : ∀ f ∈ fleetFees, paysFee w_5ssQGkUG f = true := by decide
theorem fleet_fees_wF4oEKU8a : ∀ f ∈ fleetFees, paysFee w_F4oEKU8a f = true := by decide
theorem fleet_fees_wG1uSQxpf : ∀ f ∈ fleetFees, paysFee w_G1uSQxpf f = true := by decide
theorem fleet_fees_wDLp2YLYc : ∀ f ∈ fleetFees, paysFee w_DLp2YLYc f = true := by decide
theorem fleet_fees_wHCb7hLss : ∀ f ∈ fleetFees, paysFee w_HCb7hLss f = true := by decide
theorem fleet_fees_wFTotzvz1 : ∀ f ∈ fleetFees, paysFee w_FTotzvz1 f = true := by decide
theorem fleet_fees_w6DAHh1hH : ∀ f ∈ fleetFees, paysFee w_6DAHh1hH f = true := by decide

theorem no_exotic_fee_wJ3Z1AfTD : ∀ f ∈ fleetFeesExotic, paysFee w_J3Z1AfTD f = false := by decide
theorem no_exotic_fee_w7QeRHULB : ∀ f ∈ fleetFeesExotic, paysFee w_7QeRHULB f = false := by decide
theorem no_exotic_fee_w4AnrXS8H : ∀ f ∈ fleetFeesExotic, paysFee w_4AnrXS8H f = false := by decide
theorem no_exotic_fee_w9XvBYSKe : ∀ f ∈ fleetFeesExotic, paysFee w_9XvBYSKe f = false := by decide
theorem no_exotic_fee_wC9YvTztk : ∀ f ∈ fleetFeesExotic, paysFee w_C9YvTztk f = false := by decide
theorem no_exotic_fee_w7dGrdJRY : ∀ f ∈ fleetFeesExotic, paysFee w_7dGrdJRY f = false := by decide
theorem no_exotic_fee_wHxkTYMtx : ∀ f ∈ fleetFeesExotic, paysFee w_HxkTYMtx f = false := by decide
theorem no_exotic_fee_wx3pJA2jG : ∀ f ∈ fleetFeesExotic, paysFee w_x3pJA2jG f = false := by decide
theorem no_exotic_fee_wCMbBM2BW : ∀ f ∈ fleetFeesExotic, paysFee w_CMbBM2BW f = false := by decide
theorem no_exotic_fee_wFwqxwTYu : ∀ f ∈ fleetFeesExotic, paysFee w_FwqxwTYu f = false := by decide
theorem no_exotic_fee_w21nALQTX : ∀ f ∈ fleetFeesExotic, paysFee w_21nALQTX f = false := by decide

/-! ### Landing in the same blocks -/

theorem coSlots_wDLp2YLYc_wHCb7hLss : coSlots w_DLp2YLYc w_HCb7hLss = 97 := by decide
theorem coSlots_wF4oEKU8a_wHCb7hLss : coSlots w_F4oEKU8a w_HCb7hLss = 95 := by decide
theorem coSlots_wF4oEKU8a_wDLp2YLYc : coSlots w_F4oEKU8a w_DLp2YLYc = 90 := by decide
theorem coSlots_w686oaTQa_w6DAHh1hH : coSlots w_686oaTQa w_6DAHh1hH = 69 := by decide
theorem coSlots_w686oaTQa_wFTotzvz1 : coSlots w_686oaTQa w_FTotzvz1 = 68 := by decide
theorem coSlots_wHCb7hLss_w6DAHh1hH : coSlots w_HCb7hLss w_6DAHh1hH = 62 := by decide

/-! ### …and the wallets that do not -/

theorem coSlots_wHxkTYMtx_w686oaTQa : coSlots w_HxkTYMtx w_686oaTQa = 5 := by decide
theorem coSlots_wJ3Z1AfTD_w686oaTQa : coSlots w_J3Z1AfTD w_686oaTQa = 0 := by decide
theorem coSlots_wx3pJA2jG_w686oaTQa : coSlots w_x3pJA2jG w_686oaTQa = 28 := by decide
theorem coSlots_wHxkTYMtx_wDLp2YLYc : coSlots w_HxkTYMtx w_DLp2YLYc = 13 := by decide

end Ledger.Verdicts
