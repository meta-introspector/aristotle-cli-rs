/-
  Basic types - Lean 4 translation of UniMath-style definitions.
  Most of these already exist in Lean's core library, so we provide
  aliases and notations for compatibility.
-/

-- UU is just Type in Lean
abbrev UU := Type

-- Lean already has Empty, Unit, Bool, Sum (coprod), Prod (dirprod)

-- total2 is essentially a Sigma type (Σ x : T, P x)
-- In Lean 4 this is just `Sigma` or `(x : T) × P x`
structure Total2 {T : UU} (P : T → UU) where
  pr1 : T
  pr2 : P pr1

-- dirprod is just Prod
abbrev Dirprod (X Y : UU) := Total2 (fun (_ : X) => Y)
