import RequestProject.SuperBundle

/-!
# Automation: computing super-dimensions from twist lists

This file provides a small custom tactic, `compute_sdim`, that automatically computes and
simplifies the numeric super-dimension `sdimH0` / `sdimH1` of a `SplitSuperBundle` directly
from its even/odd twist lists, discharging the resulting integer/`Nat` arithmetic with
`omega`.

The numeric super-dimensions of `SuperBundleP1` are
```
sdimH0 E = ((E.even.map (d ↦ (d+1).toNat)).sum, (E.odd.map (d ↦ (d+1).toNat)).sum)
sdimH1 E = ((E.even.map (d ↦ (-d-1).toNat)).sum, (E.odd.map (d ↦ (-d-1).toNat)).sum)
```
so once the twist lists are concrete (or symbolic but of fixed length) the answer is a
finite sum of `Int.toNat`s, which `omega` understands.  The tactic:

1. unfolds `sdimH0` / `sdimH1` and evaluates the `List.map`/`List.sum` over the literal
   twist lists (`simp only` with the relevant `List` lemmas);
2. splits the resulting pair equality and discharges each component with `omega`.

It works both for fully numeric bundles (e.g. `⟨[2,1], [-5,-3]⟩`) and for symbolic twists
(e.g. `⟨[2,1], [m, 2-m]⟩` with `m : ℤ`).

If the bundle is presented through a definition `D` rather than a structure literal, unfold
it first (`unfold D` / `simp only [D]`) so the projections `.even`/`.odd` reduce, then call
`compute_sdim`.

## Main definitions and results

* `compute_sdim` : the tactic.
* `sdimH0_example`, `sdimH1_example`, `sdimH1_symbolic`, … : worked examples.
-/

open SuperBundleP1

/-- Automatically compute and simplify a numeric super-dimension goal `sdimH0 E = …` or
`sdimH1 E = …` whose bundle `E` is a (numeric or symbolic) `SplitSuperBundle` literal.
It unfolds the super-dimension to a finite sum of `Int.toNat` terms over the twist lists and
closes the resulting pair equality componentwise with `omega`. -/
syntax "compute_sdim" : tactic
macro_rules
  | `(tactic| compute_sdim) =>
    `(tactic|
        (simp only [sdimH0, sdimH1, List.map_cons, List.map_nil,
            List.sum_cons, List.sum_nil, add_zero, Prod.mk.injEq] <;>
          first
            | omega
            | (constructor <;> omega)
            | (refine Prod.ext ?_ ?_ <;> omega)))

namespace SuperBundleP1

/-- Example: a fully numeric bundle.  `H¹` super-dimension of `⟨[2,1], [-5,-3]⟩`. -/
example : sdimH1 ⟨[2, 1], [-5, -3]⟩ = (0, 6) := by compute_sdim

/-- Example: the `H⁰` super-dimension of the same numeric bundle. -/
example : sdimH0 ⟨[2, 1], [-5, -3]⟩ = (5, 0) := by compute_sdim

/-- Example: a symbolic odd twist list.  The tactic leaves the answer in `Int.toNat` form
and proves it for *all* `m : ℤ` at once. -/
example (m : ℤ) : sdimH1 ⟨[2, 1], [m, 2 - m]⟩ = (0, (-m - 1).toNat + (m - 3).toNat) := by
  compute_sdim

/-- Example: the symbolic `H⁰` super-dimension. -/
example (m : ℤ) : sdimH0 ⟨[2, 1], [m, 2 - m]⟩ = (5, (m + 1).toNat + (3 - m).toNat) := by
  compute_sdim

/-- Example: a longer mixed list, computed automatically. -/
example : sdimH1 ⟨[0, -1, -2], [-3, 7, -4]⟩ = (1, 5) := by compute_sdim

end SuperBundleP1
