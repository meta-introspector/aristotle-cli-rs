import Mathlib

/-!
# A formal model of Solana Program Derived Address (PDA) account creation

This file formalizes the behavioural content of the Solana documentation page
*"Program Derived Address → PDA Accounts"*.

That page is software documentation rather than a mathematical text, so most of it
(API usage, Anchor's `init` constraint, TypeScript test code) has no truth value to
prove.  The page does, however, state several precise, machine-checkable invariants
about the `initializePDA` instruction of the example `pda_account` program:

* The PDA at which the account is created is a *deterministic* function of the seeds
  (`b"data"`, the user's address) and the program id.
* The newly created account stores the user's address and the bump seed used to
  derive the PDA.
* "If you invoke the initializePDA instruction again with the same user address seed,
  the transaction will fail. This happens because an account already exists at the
  derived address."

We model the on-chain world abstractly:

* `Pubkey` is an arbitrary type of addresses with decidable equality.
* A `Store` maps each address to the optional account data living there.
* `derivePDA` is the (deterministic) seed-and-program-id → address derivation.
* `initializePDA` is the instruction handler: it derives the PDA, fails if an account
  already exists there, and otherwise creates one storing the user and bump.

The theorems below capture the three invariants above.
-/

namespace SolanaPDA

/-- The data stored in a `DataAccount`, mirroring the example program's
`#[account]` struct: the user's address and the canonical bump seed. -/
structure DataAccount (Pubkey : Type*) where
  /-- The address of the `user` that initialized the account. -/
  user : Pubkey
  /-- The canonical bump seed used to derive the PDA. -/
  bump : UInt8

/-- The on-chain account store: each address either has account data or is empty. -/
abbrev Store (Pubkey : Type*) := Pubkey → Option (DataAccount Pubkey)

variable {Pubkey : Type*} [DecidableEq Pubkey]

/-- The `initializePDA` instruction handler.

Given a deterministic PDA-derivation function `derive` (which bundles the seeds
`b"data"`, the program id, and the canonical bump), an account `store`, the `user`
that signs the transaction, and the `bump` seed:

* derive the PDA address for `user`;
* if an account already exists there, the transaction fails (`Except.error`);
* otherwise, create a new account at the PDA storing `user` and `bump`. -/
def initializePDA (derive : Pubkey → Pubkey) (store : Store Pubkey)
    (user : Pubkey) (bump : UInt8) : Except String (Store Pubkey) :=
  let pda := derive user
  match store pda with
  | some _ => Except.error "account already in use"
  | none   => Except.ok (Function.update store pda (some ⟨user, bump⟩))

/- **Determinism of PDA derivation.**  Re-deriving the PDA from the same seeds
(here, the same `user`) always yields the same address.  This is what lets the test
file recompute the PDA off-chain to fetch the account. -/
omit [DecidableEq Pubkey] in
theorem derivePDA_deterministic (derive : Pubkey → Pubkey) (user : Pubkey) :
    derive user = derive user := by
  rfl

/-- **The instruction succeeds exactly when the PDA is unoccupied**, and on success
it creates an account at the derived PDA storing the `user` and the `bump`. -/
theorem initialize_ok_iff (derive : Pubkey → Pubkey) (store : Store Pubkey)
    (user : Pubkey) (bump : UInt8) :
    (∃ store', initializePDA derive store user bump = Except.ok store') ↔
      store (derive user) = none := by
        unfold initializePDA;
        cases h : store ( derive user ) <;> simp +decide [ h ]

/-- **The created account stores the user and bump** at the derived PDA. -/
theorem initialize_creates_account (derive : Pubkey → Pubkey) (store : Store Pubkey)
    (user : Pubkey) (bump : UInt8) (h : store (derive user) = none) :
    ∃ store', initializePDA derive store user bump = Except.ok store' ∧
      store' (derive user) = some ⟨user, bump⟩ := by
        unfold initializePDA; aesop;

/-- **Re-initializing with the same user seed fails.**

If the first `initializePDA` with `user` succeeds, producing `store'`, then a second
`initializePDA` with the *same* `user` (any bump) on `store'` fails, because an account
already exists at the derived address.  This is the invariant stated at the end of
the documentation page. -/
theorem initialize_twice_fails (derive : Pubkey → Pubkey) (store : Store Pubkey)
    (user : Pubkey) (bump bump' : UInt8) (store' : Store Pubkey)
    (h : initializePDA derive store user bump = Except.ok store') :
    ∃ msg, initializePDA derive store' user bump' = Except.error msg := by
      unfold initializePDA at h ⊢; aesop;

end SolanaPDA