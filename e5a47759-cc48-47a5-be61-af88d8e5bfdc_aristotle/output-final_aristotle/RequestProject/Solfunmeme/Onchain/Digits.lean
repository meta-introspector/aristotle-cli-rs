/-
Positional numeral systems, shared by the base-58 (public key) encoding and the
decimal-string amounts used by the Solana JSON-RPC wire format.

This module is deliberately free of `Mathlib` so that it can be linked into a
native executable; the theorems about it live in `RequestProject.Onchain.Proofs.*`.
-/

namespace Solana.Digits

/-- `ofDigitsBE base ds` reads `ds` as a big-endian list of digits in the given base. -/
def ofDigitsBE (base : Nat) (ds : List Nat) : Nat :=
  ds.foldl (fun acc d => acc * base + d) 0

/-- `digitsBE base n` is the minimal-length big-endian digit expansion of `n` in
`base` (so `digitsBE base 0 = []`, i.e. there are never leading zeros). -/
def digitsBE (base : Nat) (n : Nat) : List Nat :=
  if h : 2 ≤ base ∧ 0 < n then
    have : n / base < n := Nat.div_lt_self h.2 h.1
    digitsBE base (n / base) ++ [n % base]
  else
    []

/-- A digit list is *normalized* for `base` when every entry is a valid digit and
there is no leading zero. These are exactly the lists in the image of `digitsBE`. -/
def Normalized (base : Nat) (ds : List Nat) : Prop :=
  (∀ d ∈ ds, d < base) ∧ ds.head? ≠ some 0

end Solana.Digits
