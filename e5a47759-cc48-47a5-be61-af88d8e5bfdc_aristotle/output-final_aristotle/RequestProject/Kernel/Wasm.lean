import RequestProject.Relay.Commit
import RequestProject.Edge.Wasm.Encode
import RequestProject.Edge.Wasm.Semantics

/-!
# The commitment kernel, in WebAssembly

The proof engine is meant to leave Lean.  `RequestProject.Kernel.Check` is the
part a JavaScript port reproduces (`www/kernel-engine.mjs`); this file is the
part that goes further down, into an actual `.wasm` binary emitted from Lean by
the verified encoder of `Kant.Wasm.Encode` — no `wat2wasm`, no C toolchain, no
trust in a compiler that is not in this repository.

The fragment `Kant.Wasm` covers is straight-line 64-bit integer arithmetic, so
what belongs in it is the *arithmetic core* of reading a payload and committing
to it, with the loop driven by the host:

| export | what it computes | Lean function |
|---|---|---|
| `digest_init` | the initial state of the commitment | `RequestProject.Relay.digest` (its seed) |
| `digest_step` | one character of the rolling hash | the fold step of `Relay.digest` |
| `is_digit` | is this character a decimal digit? | `Relay.isDigit` |
| `dec3` | three digits back to a character code | `Relay.decode` |
| `enc3_hi`, `enc3_mid`, `enc3_lo` | a character code as three digits | `Relay.enc3` |

Together they are enough to recompute, in a browser and with no Lean toolchain,
the commitment every program of the relay makes — which is exactly what a
reader needs to confirm that the copy they received is the copy that was
published (`Relay.commitment_eq`, `payload_eq_of_respond`).

Every export has a specification theorem below saying the wasm expression
computes the Lean function, and `Kant.Wasm.Expr.exec_compile` carries that from
the expression to the instruction sequence the encoder emits.
`commitmentKernel_wf` says no export can trap.

What is *not* claimed: this is not Lean 4 in WebAssembly, and the proof
checker itself is not here — the fragment has no memory and no loops, so the
checker's term structure cannot be expressed in it yet.  Extending the verified
fragment is the next step; until then the browser's checker is the JavaScript
port, pinned to Lean by conformance vectors.
-/

namespace RequestProject.Kernel.Wasm

open Kant.Wasm
open Kant.Wasm.Expr
open RequestProject.Relay (digest isDigit enc3 digitChar)

/-! ## The Lean functions, at the width the kernel works in -/

/-- The modulus of the relay's rolling hash. -/
def digestMod : Nat := 1000003

/-- One character of the commitment, on natural numbers: the fold step of
`RequestProject.Relay.digest`. -/
def digestStep (h c : Nat) : Nat := (h * 131 + c) % digestMod

/-- The commitment is that step, folded — definitionally. -/
theorem digest_eq_fold (l : List Char) :
    digest l = l.foldl (fun h c => digestStep h c.toNat) 7 := rfl

/-- One character of the commitment, at 64 bits: what the wasm export does. -/
def digestStepU (h c : UInt64) : UInt64 := (h * 131 + c) % 1000003

/-- Three payload digits back to the character code they encode. -/
def dec3 (a b c : Nat) : Nat := 100 * a + 10 * b + c

/-! ## The expressions -/

/-- `digest_init()` — the seed of the rolling hash. -/
def digestInitE : Expr := const 7

/-- `digest_step(h, c)`. -/
def digestStepE : Expr := modC (add (mul (var 0) (const 131)) (var 1)) 1000003

/-- `is_digit(c)` — 1 if `c` is the code of a decimal digit, else 0. -/
def isDigitE : Expr :=
  mul (cmp .leu (const 48) (var 0)) (cmp .leu (var 0) (const 57))

/-- `dec3(a, b, c)` — three digits to a character code. -/
def dec3E : Expr := add (add (mul (const 100) (var 0)) (mul (const 10) (var 1))) (var 2)

/-- `enc3_hi(n)`, `enc3_mid(n)`, `enc3_lo(n)` — a character code as three
decimal digits, the values `RequestProject.Relay.enc3` turns into characters. -/
def enc3HiE : Expr := modC (divC (var 0) 100) 10
/-- The middle digit of a three-digit character code. -/
def enc3MidE : Expr := modC (divC (var 0) 10) 10
/-- The last digit of a three-digit character code. -/
def enc3LoE : Expr := modC (var 0) 10

/-! ## The module -/

/-- The exported commitment kernel. -/
def commitmentKernel : Module :=
  { funcs :=
      [ { name := "digest_init", arity := 0, body := digestInitE },
        { name := "digest_step", arity := 2, body := digestStepE },
        { name := "is_digit", arity := 1, body := isDigitE },
        { name := "dec3", arity := 3, body := dec3E },
        { name := "enc3_hi", arity := 1, body := enc3HiE },
        { name := "enc3_mid", arity := 1, body := enc3MidE },
        { name := "enc3_lo", arity := 1, body := enc3LoE } ] }

/-- The bytes of `kernel-commitment.wasm`. -/
def kernelBytes : ByteArray := Encode.moduleBytes commitmentKernel

/-- **No export can trap.** Every local is a declared parameter, every literal
fits a signed 64-bit constant, and every division has a non-zero divisor. -/
theorem commitmentKernel_wf : Module.Wf commitmentKernel :=
  Module.wf_of_wfb (by decide)

/-! ## Specifications

Each theorem says the wasm expression computes the Lean function; with
`Expr.exec_compile` that carries over to the emitted instructions. -/

theorem digestInitE_spec : Expr.eval [] digestInitE = some 7 := rfl

theorem digestStepE_spec (h c : UInt64) :
    Expr.eval [h, c] digestStepE = some (digestStepU h c) := rfl

theorem isDigitE_spec (c : UInt64) :
    Expr.eval [c] isDigitE
      = some ((if (48 : UInt64) ≤ c then 1 else 0) * (if c ≤ (57 : UInt64) then 1 else 0)) :=
  rfl

theorem dec3E_spec (a b c : UInt64) :
    Expr.eval [a, b, c] dec3E = some (100 * a + 10 * b + c) := rfl

theorem enc3HiE_spec (n : UInt64) : Expr.eval [n] enc3HiE = some (n / 100 % 10) := rfl

theorem enc3MidE_spec (n : UInt64) : Expr.eval [n] enc3MidE = some (n / 10 % 10) := rfl

theorem enc3LoE_spec (n : UInt64) : Expr.eval [n] enc3LoE = some (n % 10) := rfl

/-! ### The bridge to the relay's own arithmetic

The exports work at 64 bits; the relay's definitions work on `Nat`.  The two
agree on the values that actually occur — a hash state below the modulus and a
character code below 1000 — which is what makes the wasm module a faithful
recomputation of the commitment rather than a lookalike. -/

theorem digestStepU_toNat {h c : UInt64} (hh : h.toNat < digestMod) (hc : c.toNat < 1000) :
    (digestStepU h c).toNat = digestStep h.toNat c.toNat := by
  simp only [digestMod] at hh
  have hpow : (2 : Nat) ^ 64 = 18446744073709551616 := by rfl
  have h131 : (131 : UInt64).toNat = 131 := rfl
  have hmul : (h * 131).toNat = h.toNat * 131 := by
    rw [UInt64.toNat_mul, h131]
    exact Nat.mod_eq_of_lt (by omega)
  have hadd : (h * 131 + c).toNat = h.toNat * 131 + c.toNat := by
    rw [UInt64.toNat_add, hmul]
    exact Nat.mod_eq_of_lt (by omega)
  simp only [digestStepU, digestStep, digestMod, UInt64.toNat_mod, hadd]
  rfl

theorem dec3E_toNat {a b c : UInt64} (ha : a.toNat < 10) (hb : b.toNat < 10)
    (hc : c.toNat < 10) : (100 * a + 10 * b + c).toNat = dec3 a.toNat b.toNat c.toNat := by
  have hpow : (2 : Nat) ^ 64 = 18446744073709551616 := by rfl
  have h100 : (100 : UInt64).toNat = 100 := rfl
  have h10 : (10 : UInt64).toNat = 10 := rfl
  have h1 : (100 * a).toNat = 100 * a.toNat := by
    rw [UInt64.toNat_mul, h100]; exact Nat.mod_eq_of_lt (by omega)
  have h2 : (10 * b).toNat = 10 * b.toNat := by
    rw [UInt64.toNat_mul, h10]; exact Nat.mod_eq_of_lt (by omega)
  have h3 : (100 * a + 10 * b).toNat = 100 * a.toNat + 10 * b.toNat := by
    rw [UInt64.toNat_add, h1, h2]; exact Nat.mod_eq_of_lt (by omega)
  rw [UInt64.toNat_add, h3]
  exact Nat.mod_eq_of_lt (by omega)

/-- The state of the commitment never leaves the range the bridge needs. -/
theorem digestStep_lt (h c : Nat) : digestStep h c < digestMod :=
  Nat.mod_lt _ (by simp [digestMod])

end RequestProject.Kernel.Wasm
