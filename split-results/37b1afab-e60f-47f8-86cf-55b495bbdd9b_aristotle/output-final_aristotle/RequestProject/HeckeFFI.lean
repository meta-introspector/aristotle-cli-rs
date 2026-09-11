/-
# Executable Hecke operators `T_1 … T_72`, exposed for FFI

This module is the **computational / executable** counterpart of the verified
development in `RequestProject.HeckeOperator`.  It is deliberately written using only
the Lean core library (no `Mathlib` import) so that the generated C code links against
the standard Lean runtime alone and can be called from foreign code (e.g. Rust) without
dragging in the whole of `Mathlib` as a native dependency.

The mathematical content — that this really computes the classical Hecke-operator
coefficient formula

  `(T_m a)(n) = ∑_{d ∣ gcd(m,n)} d^{k-1} · a(m·n / d²)`

— is proved in `RequestProject.HeckeFFICorrect`, where `heckeOpInt` is shown equal to the
`Mathlib`-based `HeckeRelations.heckeOp`.

## FFI entry point

`hecke_op_eval (k m n : UInt64) (coeffs : @& Array Int) : Int64`

is exported under the C symbol `hecke_op_eval`.  A thin C shim (see `ffi/`) marshals a
raw `const int64_t *` buffer into a Lean `Array Int`, lets Lean compute the coefficient,
and hands back the `int64_t` result.  Rust then calls the shim through the usual
`extern "C"` mechanism.  Driving `m` over `1 … 72` realises the operators `T_1 … T_72`.
-/

namespace HeckeFFI

/-- Read the `n`-th coefficient of a finite coefficient sequence, treating every index
outside the array as `0` (the coefficient sequence of a power series is `0` beyond the
stored prefix). -/
@[inline] def coeffOfArray (coeffs : Array Int) (n : Nat) : Int :=
  coeffs.getD n 0

/-- The divisors of `g` in increasing order, computed by a direct scan of `1 … g`.
`heckeDivisors 0 = []`, matching `Nat.divisors 0 = ∅`. -/
def heckeDivisors (g : Nat) : List Nat :=
  (List.range (g + 1)).filterMap (fun d => if d != 0 && g % d == 0 then some d else none)

/-- The executable `m`-th weight-`k` Hecke operator acting on a finite integer
coefficient sequence:

  `heckeOpInt k m coeffs n = ∑_{d ∣ gcd(m,n)} d^{k-1} · coeffs(m·n / d²)`.

This is the concrete, `Int`/`Array`-based version of `HeckeRelations.heckeOp`; the two
are proved equal in `RequestProject.HeckeFFICorrect`. -/
def heckeOpInt (k m : Nat) (coeffs : Array Int) (n : Nat) : Int :=
  (heckeDivisors (Nat.gcd m n)).foldl
    (fun acc d => acc + (Int.ofNat (d ^ (k - 1))) * coeffOfArray coeffs (m * n / (d * d))) 0

/-- C-ABI entry point. Evaluates `(T_m a)(n)` for the weight-`k` Hecke operator, where
`a` is given by the borrowed coefficient array `coeffs`. The result is returned as a
machine `Int64` (sufficient for the coefficient ranges used in practice; large values are
truncated to 64 bits, as for any fixed-width integer FFI boundary).

Iterating `m` over `1 … 72` on the foreign side yields the operators `T_1 … T_72`. -/
@[export hecke_op_eval]
def hecke_op_eval (k m n : UInt64) (coeffs : @& Array Int) : Int64 :=
  (heckeOpInt k.toNat m.toNat coeffs n.toNat).toInt64

/-! ## Sanity checks (evaluated at build/elaboration time) -/

/-- Ramanujan's `τ` for `n = 0 … 11` (with `τ(0) = 0` padding the constant term). -/
def tauSample : Array Int :=
  #[0, 1, -24, 252, -1472, 4830, -6048, -16744, 84480, -113643, -115920, 534612]

-- `(T_m a)(1) = a m`: the operator recovers the coefficient.
#eval (List.range 11).map (fun m => heckeOpInt 12 (m + 1) tauSample 1)
-- coprime multiplicativity: `(T_2 τ)(3) = τ(6) = -6048`.
#eval heckeOpInt 12 2 tauSample 3
-- prime recursion: `(T_2 τ)(2) = τ(4) + 2¹¹·τ(1) = -1472 + 2048 = 576`.
#eval heckeOpInt 12 2 tauSample 2
-- through the exported FFI wrapper:
#eval hecke_op_eval 12 7 1 tauSample  -- τ(7) = -16744

end HeckeFFI
