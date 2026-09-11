import RequestProject.Gvcs.Web.Fhe

/-!
# Boolean circuits run on ciphertext, and bootstrapping

The cipher is the one the single-page build already uses,
`RequestProject/Web/Fhe.lean`: a secret odd modulus `p`, a bit `m` encrypted as
`c = m + 2r + pq`, decryption `c % p % 2`, and the invariant `Web.Rep p c b B`
saying that `c` carries the parity of `b` with noise at most `B`.  `Rep.add`,
`Rep.mul` and `Rep.not` are its gates.

This file puts a boolean-circuit layer on top of that cipher, which is what the
sneakernet game needs:

* `Enc p B b c` — the same invariant, with the plaintext a `Bool`, and `dec` a
  `Bool`-valued decryption (`dec_enc`);
* `BCirc` — boolean circuits, evaluated in the clear (`eval`) and on
  ciphertexts (`evalEnc`), with the noise growth tracked by `bound`;
* `BCirc.dec_evalEnc` — **leveled homomorphic evaluation**: as long as the
  circuit's noise budget stays under the modulus, the ciphertext the evaluation
  produces decrypts to the true value of the circuit;
* `Refresh` and `BCirc.dec_evalR` — **bootstrapping**: given a recryption
  operation that returns a low-noise ciphertext of the same bit, circuits of
  unbounded size and depth evaluate correctly.

A relay can therefore check a mailed move against a rule book it cannot read.
-/

namespace LifeTrac
namespace Sneakernet

open Web

/-! ### Bits -/

/-- A bit as an integer. -/
def bitZ (b : Bool) : ℤ := if b then 1 else 0

@[simp] theorem bitZ_true : bitZ true = 1 := rfl
@[simp] theorem bitZ_false : bitZ false = 0 := rfl

theorem bitZ_nonneg (b : Bool) : 0 ≤ bitZ b := by cases b <;> simp
theorem bitZ_le_one (b : Bool) : bitZ b ≤ 1 := by cases b <;> simp
theorem bitZ_emod_two (b : Bool) : bitZ b % 2 = bitZ b := by cases b <;> decide

theorem bitZ_add_parity (a b : Bool) :
    (bitZ a + bitZ b) % 2 = bitZ (xor a b) % 2 := by cases a <;> cases b <;> decide

theorem bitZ_mul (a b : Bool) : bitZ a * bitZ b = bitZ (a && b) := by
  cases a <;> cases b <;> decide

theorem bitZ_not_parity (b : Bool) : (bitZ b + 1) % 2 = bitZ (!b) % 2 := by
  cases b <;> decide

/-! ### Ciphertexts of bits -/

/-- `Enc p B b c` — the integer `c` is a ciphertext of the bit `b` under the
modulus `p`, with noise at most `B`.  This is `Web.Rep` with a `Bool`
plaintext. -/
def Enc (p B : ℤ) (b : Bool) (c : ℤ) : Prop := Rep p c (bitZ b) B

/-- Anything `Web.Rep` proves about a plaintext of the right parity is a
statement about the corresponding bit. -/
theorem enc_of_rep {p B x c : ℤ} {b : Bool} (h : Rep p c x B)
    (hx : x % 2 = bitZ b % 2) : Enc p B b c := by
  obtain ⟨n, q, hc, h0, hn, hpar⟩ := h
  exact ⟨n, q, hc, h0, hn, by rw [hpar, hx]⟩

theorem Enc.mono {p B B' : ℤ} {b : Bool} {c : ℤ} (h : Enc p B b c) (hB : B ≤ B') :
    Enc p B' b c := Rep.mono h hB

/-- Decryption of a bit. -/
def dec (p c : ℤ) : Bool := decide (decBit p c = 1)

/-- **Correctness of decryption**: a ciphertext whose noise has stayed under the
modulus decrypts to the bit it carries. -/
theorem dec_enc {p B : ℤ} {b : Bool} {c : ℤ} (h : Enc p B b c) (hB : B < p) :
    dec p c = b := by
  have h1 : decBit p c = bitZ b % 2 := Rep.dec h hB
  rw [bitZ_emod_two] at h1
  unfold dec
  rw [h1]
  cases b <;> decide

/-- Encryption of a bit: `bit b + 2r + pq`. -/
def enc (p r q : ℤ) (b : Bool) : ℤ := encBit p (bitZ b) r q

theorem enc_valid {p R r : ℤ} (q : ℤ) (b : Bool) (hr0 : 0 ≤ r) (hrR : r ≤ R) :
    Enc p (1 + 2 * R) b (enc p r q b) :=
  Rep.enc (bitZ_nonneg b) (bitZ_le_one b) hr0 hrR

/-! ### The gates -/

/-- Homomorphic `xor`: add the ciphertexts. -/
def hxor (c₁ c₂ : ℤ) : ℤ := c₁ + c₂

/-- Homomorphic `and`: multiply the ciphertexts. -/
def hand (c₁ c₂ : ℤ) : ℤ := c₁ * c₂

/-- Homomorphic negation: add one. -/
def hnot (c : ℤ) : ℤ := c + 1

/-- A ciphertext of a constant bit, with noise one. -/
def hconst (b : Bool) : ℤ := bitZ b

theorem enc_hconst (p : ℤ) (b : Bool) : Enc p 1 b (hconst b) :=
  ⟨bitZ b, 0, by simp [hconst], bitZ_nonneg b, bitZ_le_one b, rfl⟩

theorem enc_hxor {p B₁ B₂ : ℤ} {b₁ b₂ : Bool} {c₁ c₂ : ℤ}
    (h₁ : Enc p B₁ b₁ c₁) (h₂ : Enc p B₂ b₂ c₂) :
    Enc p (B₁ + B₂) (xor b₁ b₂) (hxor c₁ c₂) :=
  enc_of_rep (Rep.add h₁ h₂) (by rw [bitZ_add_parity, bitZ_emod_two])

theorem enc_hand {p B₁ B₂ : ℤ} {b₁ b₂ : Bool} {c₁ c₂ : ℤ}
    (h₁ : Enc p B₁ b₁ c₁) (h₂ : Enc p B₂ b₂ c₂) :
    Enc p (B₁ * B₂) (b₁ && b₂) (hand c₁ c₂) := by
  have h := Rep.mul h₁ h₂
  rw [bitZ_mul] at h
  exact h

theorem enc_hnot {p B : ℤ} {b : Bool} {c : ℤ} (h : Enc p B b c) :
    Enc p (B + 1) (!b) (hnot c) :=
  enc_of_rep (Rep.not h) (by rw [bitZ_not_parity, bitZ_emod_two])

/-! ### Boolean circuits -/

/-- A boolean circuit on `n` inputs. -/
inductive BCirc (n : ℕ) where
  /-- The `i`-th input. -/
  | var : Fin n → BCirc n
  /-- A constant. -/
  | const : Bool → BCirc n
  /-- Negation. -/
  | not : BCirc n → BCirc n
  /-- Conjunction. -/
  | and : BCirc n → BCirc n → BCirc n
  /-- Exclusive or. -/
  | xor : BCirc n → BCirc n → BCirc n
  deriving Repr, DecidableEq

namespace BCirc

variable {n : ℕ}

/-- Evaluation in the clear. -/
def eval (x : Fin n → Bool) : BCirc n → Bool
  | .var i => x i
  | .const b => b
  | .not a => !(eval x a)
  | .and a b => (eval x a) && (eval x b)
  | .xor a b => Bool.xor (eval x a) (eval x b)

/-- Evaluation on ciphertexts: the same circuit, with homomorphic gates. -/
def evalEnc (cs : Fin n → ℤ) : BCirc n → ℤ
  | .var i => cs i
  | .const b => hconst b
  | .not a => hnot (evalEnc cs a)
  | .and a b => hand (evalEnc cs a) (evalEnc cs b)
  | .xor a b => hxor (evalEnc cs a) (evalEnc cs b)

/-- The noise budget after evaluating the circuit on inputs of noise `B`. -/
def bound (B : ℤ) : BCirc n → ℤ
  | .var _ => B
  | .const _ => 1
  | .not a => bound B a + 1
  | .and a b => bound B a * bound B b
  | .xor a b => bound B a + bound B b

theorem one_le_bound {B : ℤ} (hB : 1 ≤ B) (c : BCirc n) : 1 ≤ bound B c := by
  induction c with
  | var i => simpa [bound] using hB
  | const b => simp [bound]
  | not a ih => simp only [bound]; omega
  | and a b iha ihb =>
      simp only [bound]
      nlinarith
  | xor a b iha ihb => simp only [bound]; omega

/-- **Homomorphic evaluation is correct**: running a circuit on ciphertexts of
the input bits gives a ciphertext of the output bit, with noise at most
`bound`. -/
theorem enc_evalEnc {p B : ℤ} {x : Fin n → Bool} {cs : Fin n → ℤ}
    (hcs : ∀ i, Enc p B (x i) (cs i)) (c : BCirc n) :
    Enc p (bound B c) (eval x c) (evalEnc cs c) := by
  induction c with
  | var i => exact hcs i
  | const b => exact enc_hconst p b
  | not a ih => exact enc_hnot ih
  | and a b iha ihb => exact enc_hand iha ihb
  | xor a b iha ihb => exact enc_hxor iha ihb

/-- **Leveled homomorphic evaluation**: as long as the circuit's noise budget
stays under the modulus, the relay's computation decrypts to the true value of
the circuit. -/
theorem dec_evalEnc {p B : ℤ} {x : Fin n → Bool} {cs : Fin n → ℤ}
    (hcs : ∀ i, Enc p B (x i) (cs i)) (c : BCirc n) (hfit : bound B c < p) :
    dec p (evalEnc cs c) = eval x c :=
  dec_enc (enc_evalEnc hcs c) hfit

end BCirc

/-! ### Bootstrapping: unbounded depth -/

/-- A recryption (bootstrapping) operation for the modulus `p`: it maps any
correctly decryptable ciphertext to a ciphertext of the *same* bit with the
noise reset to `B`.  This is Gentry's refresh step; here it is a hypothesis on
the scheme rather than a construction. -/
structure Refresh (p B : ℤ) where
  /-- The recryption map. -/
  run : ℤ → ℤ
  /-- Recryption preserves the plaintext and resets the noise. -/
  law : ∀ {b : Bool} {c : ℤ} {B' : ℤ}, B' < p → Enc p B' b c → Enc p B b (run c)

namespace BCirc

variable {n : ℕ}

/-- Homomorphic evaluation with a refresh after every gate. -/
def evalR {p B : ℤ} (R : Refresh p B) (cs : Fin n → ℤ) : BCirc n → ℤ
  | .var i => cs i
  | .const b => R.run (hconst b)
  | .not a => R.run (hnot (evalR R cs a))
  | .and a b => R.run (hand (evalR R cs a) (evalR R cs b))
  | .xor a b => R.run (hxor (evalR R cs a) (evalR R cs b))

/-- The noise budget one gate needs when both its inputs sit at `B`. -/
def gateBound (B : ℤ) : ℤ := B * B + 2 * B + 1

theorem le_gateBound {B : ℤ} (hB : 1 ≤ B) : B ≤ gateBound B := by
  unfold gateBound; nlinarith

/-- **Bootstrapped evaluation is correct at every depth.**  With a refresh
operation the noise never grows past one gate, so circuits of arbitrary size
and depth evaluate correctly. -/
theorem enc_evalR {p B : ℤ} (R : Refresh p B) (hB : 1 ≤ B)
    (hfit : gateBound B < p) {x : Fin n → Bool} {cs : Fin n → ℤ}
    (hcs : ∀ i, Enc p B (x i) (cs i)) (c : BCirc n) :
    Enc p B (eval x c) (evalR R cs c) := by
  induction c with
  | var i => exact hcs i
  | const b =>
      refine R.law hfit (Enc.mono (enc_hconst p b) ?_)
      unfold gateBound; nlinarith
  | not a ih =>
      refine R.law hfit (Enc.mono (enc_hnot ih) ?_)
      unfold gateBound; nlinarith
  | and a b iha ihb =>
      refine R.law hfit (Enc.mono (enc_hand iha ihb) ?_)
      unfold gateBound; nlinarith
  | xor a b iha ihb =>
      refine R.law hfit (Enc.mono (enc_hxor iha ihb) ?_)
      unfold gateBound; nlinarith

/-- Decryption of a bootstrapped evaluation returns the value of the circuit,
whatever its size or depth. -/
theorem dec_evalR {p B : ℤ} (R : Refresh p B) (hB : 1 ≤ B)
    (hfit : gateBound B < p) {x : Fin n → Bool} {cs : Fin n → ℤ}
    (hcs : ∀ i, Enc p B (x i) (cs i)) (c : BCirc n) :
    dec p (evalR R cs c) = eval x c := by
  refine dec_enc (enc_evalR R hB hfit hcs c) ?_
  have := le_gateBound hB
  omega

end BCirc

end Sneakernet
end LifeTrac
