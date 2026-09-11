import Mathlib
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.Patterns
import RequestProject.AZ.CensusEngine

/-!
# Monoidal tensor powers of the census engine

`RequestProject.AZ.CensusEngine` builds the dimension-advancing extension engine
`dimEngine : Engine ℕ` (cart `d ↦ d + 1`) and proves that it conserves the
Altland–Zirnbauer K-group census at every finite step, with the generated stream of
periodic-table *columns* living on the `ℤ₈` Bott clock.

This file equips the generic `Engine` with a **monoidal tensor power** operation
`Engine.cartPow E k` — the engine whose single cart bundles together `k` steps of `E`'s
cart.  Tensor powers are the natural monoidal structure on engines: composing the cart
with itself `k` times.  We prove

* the tensor-power algebra (`cartPow_run`, `cartPow_one`, `cartPow_zero`,
  `cartPow_cartPow`),
* that **conservation laws survive tensoring** (`cartPow_conserves`): every quantity the
  base engine conserves is conserved by every tensor power, and
* the consequences for the AZ census engine: the conserved K-group census is mapped onto
  every tensor power (`dim_cartPow_census_conserved`, `run_cartPow_census_conserved`),
  the `k`-fold power advances the dimension by `n * k` after `n` steps
  (`dim_cartPow_run_eq`), and the two distinguished powers realise the Bott clock as
  *column-fixing* engines: the `8`-fold power fixes every column
  (`cartPow8_column_fixed`) and the `2`-fold power fixes the complex columns
  (`cartPow2_complex_fixed`).
-/

namespace AZ
namespace CensusEngine

open Class

namespace Engine

variable {S : Type*}

/-- The **monoidal tensor power** of an engine: `E.cartPow k` is the engine whose single
cart advance is `k` steps of `E`'s cart at once. -/
def cartPow (E : Engine S) (k : ℕ) : Engine S := ⟨fun s => E.run k s⟩

@[simp] theorem cartPow_step (E : Engine S) (k : ℕ) (s : S) :
    (E.cartPow k).step s = E.run k s := rfl

/-- Running the `k`-fold tensor power for `n` steps is the same as running the base engine
for `n * k` steps. -/
theorem cartPow_run (E : Engine S) (k n : ℕ) (s : S) :
    (E.cartPow k).run n s = E.run (n * k) s := by
  unfold Engine.run Engine.cartPow
  simp only [run]
  rw [Function.iterate_mul, Function.iterate_comm]

/-- The first tensor power is the engine itself. -/
@[simp] theorem cartPow_one (E : Engine S) : E.cartPow 1 = E := by
  congr

/-- The zeroth tensor power is the identity engine: running it never changes the state. -/
theorem cartPow_zero (E : Engine S) (n : ℕ) (s : S) :
    (E.cartPow 0).run n s = s := by
  induction n with
  | zero => rfl
  | succ n ih => rw [run_succ', cartPow_step, run_zero, ih]

/-- Tensor powers compose: `(E.cartPow j).cartPow k` runs `j * k` base steps per cart, the
same as `E.cartPow (j * k)`. -/
theorem cartPow_cartPow (E : Engine S) (j k n : ℕ) (s : S) :
    ((E.cartPow j).cartPow k).run n s = (E.cartPow (j * k)).run n s := by
  rw [cartPow_run, cartPow_run, cartPow_run]
  congr 1
  ring

/-- **Conservation laws survive tensoring.**  Any quantity conserved by an engine is
conserved by every one of its monoidal tensor powers. -/
theorem cartPow_conserves {α : Type*} (E : Engine S) (inv : S → α)
    (h : E.Conserves inv) (k : ℕ) : (E.cartPow k).Conserves inv := by
  intro s
  rw [cartPow_step]
  exact E.run_conserves inv h k s

end Engine

/-! ## The census engine under tensoring -/

/-- The `k`-fold tensor power of the dimensional engine advances the dimension by `n * k`
after `n` steps. -/
theorem dim_cartPow_run_eq (k n d : ℕ) :
    (dimEngine.cartPow k).run n d = d + n * k := by
  rw [Engine.cartPow_run, dim_run_eq]

/-- **Census conservation under tensoring (one step).**  Every tensor power of the
dimensional engine conserves the K-group census. -/
theorem dim_cartPow_census_conserved (k : ℕ) :
    (dimEngine.cartPow k).Conserves dimCensus :=
  dimEngine.cartPow_conserves dimCensus dim_census_conserved k

/-- **Census conservation under tensoring (engine limit).**  No matter the tensor power
`k` or the number of steps `n`, the K-group census is preserved exactly. -/
theorem run_cartPow_census_conserved (k n d : ℕ) :
    dimCensus ((dimEngine.cartPow k).run n d) = dimCensus d :=
  (dimEngine.cartPow k).run_conserves dimCensus (dim_cartPow_census_conserved k) n d

/-- **The `8`-fold tensor power fixes every column.**  Running the `8`-power any number of
times leaves every periodic-table column unchanged: it realises the real Bott clock as a
column-fixing engine. -/
theorem cartPow8_column_fixed (n d : ℕ) :
    column ((dimEngine.cartPow 8).run n d) = column d := by
  rw [dim_cartPow_run_eq]
  induction n with
  | zero => simp
  | succ n ih => rw [show d + (n + 1) * 8 = (d + n * 8) + 8 by ring, column_period8, ih]

/-- **The `2`-fold tensor power fixes the complex columns.**  For the two complex classes,
the `2`-power is column-fixing — the complex Bott clock realised as a tensor power. -/
theorem cartPow2_complex_fixed (c : Class) (hc : c.isComplex = true) (n d : ℕ) :
    column ((dimEngine.cartPow 2).run n d) c = column d c := by
  rw [dim_cartPow_run_eq]
  induction n with
  | zero => simp
  | succ n ih =>
      rw [show d + (n + 1) * 2 = (d + n * 2) + 2 by ring, complex_period2 c hc, ih]

end CensusEngine
end AZ
