import Mathlib

/-!
# The vault is always incomplete: a diagonal incompleteness argument

This file gives a small, self-contained formalization of the **diagonal argument** that
underlies Gödel's first incompleteness theorem and Cantor's theorem, dressed in the
project's playful vocabulary.

Picture a *vault*: a device that stores knowledge.  Each slot of the vault holds a
*decision procedure* — a yes/no verdict (`Bool`) on every query (a natural number).
A vault can hold at most countably many such procedures, so it is exactly a function
`store : ℕ → (ℕ → Bool)`.  The vault is *complete* if every conceivable decision procedure
is stored somewhere in it (`store` is surjective).

The headline result, `vault_always_incomplete`, is that **no vault is complete**: by the
diagonal construction `d n = !(store n n)` one always exhibits a decision procedure that
the vault does not contain.  We also record the sharper `Vault.diagonal_not_stored`
(the diagonal verdict is *demonstrably* absent) and `no_truth_predicate`, an abstract
Tarski-style undefinability statement: a vault cannot store a Boolean "truth predicate"
for its own slots.
-/

namespace GodelBrainrot

/-- A **vault**: a countable store of decision procedures.  Slot `n` holds the procedure
`store n : ℕ → Bool`, which returns a `Bool` verdict on every query. -/
structure Vault where
  /-- The stored decision procedures, indexed by slot number. -/
  store : ℕ → (ℕ → Bool)

namespace Vault

/-- A vault is **complete** if every decision procedure is stored in some slot. -/
def Complete (V : Vault) : Prop := Function.Surjective V.store

/-- The **diagonal** decision procedure of a vault: on query `n` it returns the negation of
the verdict that slot `n` gives to `n`.  This is the witness defeating completeness. -/
def diagonal (V : Vault) : ℕ → Bool := fun n => !(V.store n n)

/-- The diagonal procedure differs from the procedure in every slot: slot `n` and the
diagonal disagree on the query `n`. -/
theorem diagonal_ne (V : Vault) (n : ℕ) : V.store n ≠ V.diagonal := by
  intro h
  have : V.store n n = V.diagonal n := by rw [h]
  simp [diagonal] at this

/-- The diagonal decision procedure is **not stored** anywhere in the vault. -/
theorem diagonal_not_stored (V : Vault) : V.diagonal ∉ Set.range V.store := by
  rintro ⟨n, hn⟩
  exact V.diagonal_ne n hn

end Vault

/-- **The vault is always incomplete.**  No vault stores every decision procedure: the
diagonal construction always escapes it.  This is the abstract core of Gödel's first
incompleteness theorem (and of Cantor's theorem). -/
theorem vault_always_incomplete (V : Vault) : ¬ V.Complete := by
  intro h
  obtain ⟨n, hn⟩ := h V.diagonal
  exact V.diagonal_ne n hn

/-- **No internal truth predicate** (a Tarski-style undefinability statement).  There is no
single slot of the vault whose verdict on `n` always agrees with whether slot `n` *accepts*
its own index — for otherwise the diagonal would be stored.  Concretely: no slot `t`
satisfies `store t n = !(store n n)` for all `n`. -/
theorem no_truth_predicate (V : Vault) :
    ¬ ∃ t : ℕ, ∀ n : ℕ, V.store t n = !(V.store n n) := by
  rintro ⟨t, ht⟩
  have : V.store t = V.diagonal := funext (fun n => ht n)
  exact V.diagonal_not_stored ⟨t, this⟩

end GodelBrainrot
