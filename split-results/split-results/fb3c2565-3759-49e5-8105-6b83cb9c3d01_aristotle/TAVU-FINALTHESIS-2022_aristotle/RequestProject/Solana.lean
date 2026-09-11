import Mathlib

/-!
# Formalization of vulnerability patterns from
*Automated Verification Techniques for Solana Smart Contracts* (Tien N. Tavu, 2022)

The thesis identifies four common vulnerability classes in Solana smart contracts and,
for each, the corrective check a developer should add:

1. **Missing ownership checks** (§2.1): a sensitive instruction must verify that an account
   it operates on is owned by the program (`account.owner == program_id`).
2. **Missing signer checks** (§2.2): a sensitive instruction must verify that the authorizing
   account actually signed the transaction (`authority.is_signer`).
3. **Unsafe signed invocation** (§2.3): before a cross-program invocation the caller must
   verify the invoked program's key (`token_program.key == spl_token::id()`).
4. **Arithmetic underflow/overflow** (§2.4): unchecked `u64` arithmetic wraps around (two's
   complement); the fix is to use `checked_add` / `checked_sub`.

This file gives a faithful executable model of these scenarios and proves, for each:

* a **safety theorem** — the *fixed* code can only succeed when the corresponding security
  precondition genuinely holds; and
* an **exploit theorem** — the *vulnerable* code can succeed even when the precondition is
  violated, witnessing the vulnerability described in the thesis.

For arithmetic it proves that `checked_add`/`checked_sub` detect overflow/underflow exactly,
and that the unchecked operations silently misrepresent the true value when they wrap.
-/

namespace Solana

/-- A Solana public key, modeled abstractly as a natural-number identifier. -/
abbrev Pubkey := Nat

/-- The number of distinct `u64` values, `2^64`.  All `lamports` amounts are `u64` in Solana. -/
def U64 : Nat := 2 ^ 64

theorem U64_pos : 0 < U64 := by unfold U64; positivity

/-- Simplified `AccountInfo` (Figure 2.1), keeping the fields relevant to the thesis. -/
structure Account where
  key : Pubkey
  isSigner : Bool
  lamports : Nat
  owner : Pubkey
deriving Repr, DecidableEq

/-- The error type a Solana `ProgramResult` can carry (the relevant subset). -/
inductive ProgramError
  | insufficientFunds
  | missingOwner
  | missingSigner
  | invalidTokenProgram
deriving Repr, DecidableEq

/-! ## §2.4  Checked vs. unchecked `u64` arithmetic -/

/-- `checked_add` on `u64`: returns `none` exactly when the mathematical sum overflows. -/
def checkedAdd (a b : Nat) : Option Nat :=
  if a + b < U64 then some (a + b) else none

/-- Unchecked `u64` addition: wraps around modulo `2^64` (two's complement), as in Figure 2.6/3.5. -/
def uncheckedAdd (a b : Nat) : Nat := (a + b) % U64

/-- `checked_sub` on `u64`: returns `none` exactly when the subtraction would underflow. -/
def checkedSub (a b : Nat) : Option Nat :=
  if b ≤ a then some (a - b) else none

/-- Unchecked `u64` subtraction: wraps around modulo `2^64` on underflow. -/
def uncheckedSub (a b : Nat) : Nat := (a + (U64 - b)) % U64

/-- `checked_add` reports overflow precisely: it is `none` iff the true sum is out of `u64` range. -/
theorem checkedAdd_eq_none_iff_overflow (a b : Nat) :
    checkedAdd a b = none ↔ U64 ≤ a + b := by
  unfold checkedAdd; split <;> simp_all

/-- When there is no overflow, `checked_add` returns the exact mathematical sum. -/
theorem checkedAdd_eq_some_of_no_overflow {a b : Nat} (h : a + b < U64) :
    checkedAdd a b = some (a + b) := by unfold checkedAdd; simp [h]

/-- A successful `checked_add` returns the exact sum, which is in range: no silent misrepresentation. -/
theorem checkedAdd_sound {a b r : Nat} (h : checkedAdd a b = some r) :
    r = a + b ∧ r < U64 := by
  unfold checkedAdd at h; split at h <;> simp_all

/-- On overflow the **unchecked** addition strictly under-represents the true total, i.e. it
    "inaccurately portrays the funding of total deposits" (§2.4). -/
theorem uncheckedAdd_lt_of_overflow {a b : Nat} (h : U64 ≤ a + b) :
    uncheckedAdd a b < a + b := by
  unfold uncheckedAdd
  have := Nat.mod_lt (a + b) U64_pos
  omega

/-- Without overflow, unchecked addition agrees with the true sum. -/
theorem uncheckedAdd_eq_of_no_overflow {a b : Nat} (h : a + b < U64) :
    uncheckedAdd a b = a + b := by unfold uncheckedAdd; exact Nat.mod_eq_of_lt h

/-- `checked_sub` reports underflow precisely: it is `none` iff `b > a`. -/
theorem checkedSub_eq_none_iff_underflow (a b : Nat) :
    checkedSub a b = none ↔ a < b := by unfold checkedSub; split <;> simp_all

/-- A successful `checked_sub` returns the exact difference. -/
theorem checkedSub_sound {a b r : Nat} (h : checkedSub a b = some r) :
    r = a - b ∧ b ≤ a := by
  unfold checkedSub at h; split at h <;> simp_all

/-- On underflow (`a < b`) the **unchecked** subtraction wraps to a huge value `≥ U64 - b`,
    not the intended (clamped) result, witnessing the underflow vulnerability. -/
theorem uncheckedSub_ne_zero_of_underflow {a b : Nat} (hb : b < U64) (h : a < b) :
    0 < uncheckedSub a b := by
  unfold uncheckedSub
  have h1 : a + (U64 - b) < U64 := by omega
  rw [Nat.mod_eq_of_lt h1]
  omega

/-! ### §2.4  `add_funds` (Figure 2.6) -/

/-- The fixed `add_funds`: update the running total with `checked_add`. -/
def addFundsChecked (total deposit : Nat) : Option Nat := checkedAdd total deposit

/-- The vulnerable `add_funds`: update the running total with unchecked (wrapping) addition. -/
def addFundsVulnerable (total deposit : Nat) : Nat := uncheckedAdd total deposit

/-- The fixed `add_funds` never silently overflows: any reported new total is the exact sum
    and is a valid `u64`. -/
theorem addFundsChecked_no_silent_overflow {total deposit r : Nat}
    (h : addFundsChecked total deposit = some r) :
    r = total + deposit ∧ r < U64 := by
  unfold addFundsChecked checkedAdd at h; split at h <;> simp_all

/-- The vulnerable `add_funds` can be exploited: there is a valid `u64` state and deposit for
    which the recorded total is strictly less than the true total (funds are silently lost). -/
theorem addFundsVulnerable_exploit :
    ∃ total deposit : Nat, total < U64 ∧ deposit < U64 ∧
      addFundsVulnerable total deposit < total + deposit := by
  refine ⟨U64 - 1, U64 - 1, by unfold U64; omega, by unfold U64; omega, ?_⟩
  unfold addFundsVulnerable uncheckedAdd U64
  norm_num

/-! ## §2.1–2.2  The `withdraw` instruction (Figures 2.2–2.4) -/

/-- The vulnerable `withdraw` (Figure 2.2): only checks sufficient funds, performing **no**
    ownership or signer validation. -/
def withdrawVulnerable (_programId : Pubkey) (wallet _authority : Account) (amount : Nat) :
    Except ProgramError Nat :=
  if amount > wallet.lamports then .error .insufficientFunds
  else .ok (wallet.lamports - amount)

/-- The fixed `withdraw`: validates ownership (Figure 2.3) and the signer (Figure 2.4) before
    touching funds. -/
def withdrawFixed (programId : Pubkey) (wallet authority : Account) (amount : Nat) :
    Except ProgramError Nat :=
  if wallet.owner ≠ programId then .error .missingOwner
  else if ¬ authority.isSigner then .error .missingSigner
  else if amount > wallet.lamports then .error .insufficientFunds
  else .ok (wallet.lamports - amount)

/-- **Safety of the fixed withdraw.**  Any successful withdrawal guarantees *all* the security
    preconditions: the wallet is owned by the program, the authority signed, and there are
    sufficient funds. -/
theorem withdrawFixed_safe {programId : Pubkey} {wallet authority : Account} {amount r : Nat}
    (h : withdrawFixed programId wallet authority amount = .ok r) :
    wallet.owner = programId ∧ authority.isSigner = true ∧ amount ≤ wallet.lamports := by
  unfold withdrawFixed at h
  split_ifs at h with h1 h2 h3
  simp_all

/-- The fixed withdraw rejects a spoofed (mis-owned) wallet, protecting the program's vault. -/
theorem withdrawFixed_rejects_bad_owner {programId : Pubkey} {wallet authority : Account}
    {amount : Nat} (h : wallet.owner ≠ programId) :
    withdrawFixed programId wallet authority amount = .error .missingOwner := by
  unfold withdrawFixed; simp [h]

/-- The fixed withdraw rejects an unsigned authority even when ownership is valid. -/
theorem withdrawFixed_rejects_unsigned {programId : Pubkey} {wallet authority : Account}
    {amount : Nat} (hown : wallet.owner = programId) (hsig : authority.isSigner = false) :
    withdrawFixed programId wallet authority amount = .error .missingSigner := by
  unfold withdrawFixed; simp [hown, hsig]

/-- **Ownership exploit (§2.1).**  The vulnerable withdraw succeeds even when the wallet is
    *not* owned by the program — the attack described in Figure 2.2. -/
theorem withdrawVulnerable_ownership_exploit :
    ∃ (programId : Pubkey) (wallet authority : Account) (amount : Nat),
      wallet.owner ≠ programId ∧
      (withdrawVulnerable programId wallet authority amount).isOk := by
  refine ⟨0, ⟨0, true, 10, 1⟩, ⟨0, true, 0, 0⟩, 5, by decide, by decide⟩

/-- **Signer exploit (§2.2).**  The vulnerable withdraw succeeds even when the authority did
    not sign the transaction. -/
theorem withdrawVulnerable_signer_exploit :
    ∃ (programId : Pubkey) (wallet authority : Account) (amount : Nat),
      authority.isSigner = false ∧
      (withdrawVulnerable programId wallet authority amount).isOk := by
  refine ⟨0, ⟨0, true, 10, 0⟩, ⟨0, false, 0, 0⟩, 5, by decide, by decide⟩

/-! ## §2.3  Signed cross-program invocation (Figure 2.5) -/

/-- The vulnerable invocation: invokes the supplied token program without checking its key. -/
def invokeVulnerable (_wantedProgram : Pubkey) (_tokenProgram : Account) :
    Except ProgramError Unit := .ok ()

/-- The fixed invocation: verifies the token program's key before invoking (Figure 2.5). -/
def invokeFixed (wantedProgram : Pubkey) (tokenProgram : Account) :
    Except ProgramError Unit :=
  if tokenProgram.key ≠ wantedProgram then .error .invalidTokenProgram else .ok ()

/-- **Safety of the fixed invocation.**  A successful invoke guarantees the invoked program is
    exactly the intended one. -/
theorem invokeFixed_safe {wantedProgram : Pubkey} {tokenProgram : Account}
    (h : invokeFixed wantedProgram tokenProgram = .ok ()) :
    tokenProgram.key = wantedProgram := by
  unfold invokeFixed at h; split at h <;> simp_all

/-- **Invocation exploit (§2.3).**  The vulnerable invoke succeeds even when the supplied
    program is not the intended one — a malicious program can be invoked. -/
theorem invokeVulnerable_exploit :
    ∃ (wantedProgram : Pubkey) (tokenProgram : Account),
      tokenProgram.key ≠ wantedProgram ∧
      (invokeVulnerable wantedProgram tokenProgram) = .ok () := by
  refine ⟨0, ⟨1, true, 0, 0⟩, by decide, rfl⟩

end Solana
