import Mathlib

/-!
# A somewhat-homomorphic bit cipher, and an adder run on ciphertext

The single-page build of the game (`RequestProject/Web/Standalone.lean`) hides
its WebAssembly module behind the keystream of a generator (see
`RequestProject/Web/Base64.lean`), and the seed of that generator is *not*
written into the page.  What is written into the page is an encryption of the
seed, in two halves, under the scheme developed here; the page recovers the
seed by adding the two halves **homomorphically — on the ciphertexts** — and
decrypting the result.  So the homomorphic evaluation is on the loading path:
get it wrong and the module does not unmask and the page does not run.

The scheme is the symmetric integer scheme of van Dijk–Gentry–Halevi–Vaikuntanathan:
a secret odd modulus `p`, and a bit `m` encrypted as

    c = m + 2r + pq

with small noise `r`.  Decryption is `c mod p mod 2`.  Addition of ciphertexts
is exclusive-or of plaintext bits and multiplication is conjunction, each at the
cost of noise growth — additive for `+`, multiplicative for `*` — so a circuit
of bounded depth can be evaluated on ciphertext and still decrypt correctly.
That bound is the content of `Rep`: `Rep p c b B` says `c` decrypts to the
parity of `b` with noise at most `B`.

* `Rep.dec` — a ciphertext whose noise is below `p` decrypts to its bit.
* `Rep.add`, `Rep.mul`, `Rep.not` — the gates, with their noise growth.
* `addBits_rep` — a ripple-carry adder of any width, evaluated on ciphertexts,
  represents the same adder evaluated on plaintexts, with an explicit noise
  bound.
* `addBits_val` — that plaintext adder is addition: reading the parities of its
  output as a binary numeral gives the sum of its inputs.
* `he_add_correct` — the two combined: encrypt two numbers bitwise, add the
  ciphertexts with the circuit, decrypt, and read the result — you get the sum.

*What is and is not claimed.*  The theorems here are correctness theorems: the
homomorphic evaluation decrypts to the right answer.  No security claim is made
or could be: the page must be able to decrypt, so it carries `p`, and anybody
reading the file can decrypt too.  Against a reader the construction is
obfuscation; the cryptography earns its keep as a *correctness* obligation that
Lean discharges, and as the interface a deployment with a hidden key would use
unchanged.
-/

namespace LifeTrac
namespace Web

/-! ## The scheme -/

/-- Decryption: reduce modulo the secret `p`, then modulo two. -/
def decBit (p c : ℤ) : ℤ := c % p % 2

/-- Encryption of the bit `m` with noise `r` and multiple `q`. -/
def encBit (p m r q : ℤ) : ℤ := m + 2 * r + p * q

/-- `Rep p c b B` — the ciphertext `c` carries the bit `b % 2` with noise
between `0` and `B`.  This is the invariant a homomorphic evaluation
propagates. -/
def Rep (p c b B : ℤ) : Prop :=
  ∃ n q : ℤ, c = n + p * q ∧ 0 ≤ n ∧ n ≤ B ∧ n % 2 = b % 2

theorem Rep.mono {p c b B B' : ℤ} (h : Rep p c b B) (hB : B ≤ B') : Rep p c b B' := by
  obtain ⟨n, q, hc, h0, hn, hp⟩ := h
  exact ⟨n, q, hc, h0, hn.trans hB, hp⟩

/-- Decryption is correct as long as the noise has stayed below the modulus. -/
theorem Rep.dec {p c b B : ℤ} (h : Rep p c b B) (hB : B < p) :
    decBit p c = b % 2 := by
  obtain ⟨n, q, hc, h0, hn, hpar⟩ := h
  have : c % p = n := by
    rw [hc, Int.add_mul_emod_self_left]
    exact Int.emod_eq_of_lt h0 (lt_of_le_of_lt hn hB)
  rw [decBit, this, hpar]

/-- Encryption meets the invariant. -/
theorem Rep.enc {p m r q R : ℤ} (hm0 : 0 ≤ m) (hm1 : m ≤ 1) (hr0 : 0 ≤ r) (hrR : r ≤ R) :
    Rep p (encBit p m r q) m (1 + 2 * R) :=
  ⟨m + 2 * r, q, by unfold encBit; ring, by linarith, by linarith, by omega⟩

/-! ## The gates -/

/-- Adding ciphertexts is exclusive-or of bits; the noises add. -/
theorem Rep.add {p c d b e B C : ℤ} (hc : Rep p c b B) (hd : Rep p d e C) :
    Rep p (c + d) (b + e) (B + C) := by
  obtain ⟨n, q, hc1, hn0, hnB, hnp⟩ := hc
  obtain ⟨m, s, hd1, hm0, hmC, hmp⟩ := hd
  refine ⟨n + m, q + s, by rw [hc1, hd1]; ring, by linarith, by linarith, ?_⟩
  omega

/-- Multiplying ciphertexts is conjunction of bits; the noises multiply. -/
theorem Rep.mul {p c d b e B C : ℤ} (hc : Rep p c b B) (hd : Rep p d e C) :
    Rep p (c * d) (b * e) (B * C) := by
  obtain ⟨n, q, hc1, hn0, hnB, hnp⟩ := hc
  obtain ⟨m, s, hd1, hm0, hmC, hmp⟩ := hd
  refine ⟨n * m, n * s + q * m + p * (q * s), by rw [hc1, hd1]; ring,
    mul_nonneg hn0 hm0, ?_, ?_⟩
  · exact mul_le_mul hnB hmC hm0 (le_trans hn0 hnB)
  · rw [Int.mul_emod, hnp, hmp, ← Int.mul_emod]

/-- Adding one flips the bit; the noise grows by one. -/
theorem Rep.not {p c b B : ℤ} (hc : Rep p c b B) : Rep p (c + 1) (b + 1) (B + 1) := by
  obtain ⟨n, q, hc1, hn0, hnB, hnp⟩ := hc
  refine ⟨n + 1, q, by rw [hc1]; ring, by linarith, by linarith, ?_⟩
  omega

/-! ## A ripple-carry adder

The same expression tree serves as the circuit and as its plaintext meaning:
`addBits` is written in `+` and `*` only, so running it on ciphertexts and
running it on plaintexts is literally the same function. -/

/-- Ripple-carry addition, least significant bit first.  The last entry of the
result is the outgoing carry. -/
def addBits : List ℤ → List ℤ → ℤ → List ℤ
  | c :: cs, d :: ds, cin => (c + d + cin) :: addBits cs ds (c * d + (c + d) * cin)
  | _, _, cin => [cin]

/-- The invariant, lifted to lists of ciphertexts. -/
def RepL (p : ℤ) (cs xs : List ℤ) (B : ℤ) : Prop :=
  List.Forall₂ (fun c x => Rep p c x B) cs xs

theorem RepL.mono {p : ℤ} {cs xs : List ℤ} {B B' : ℤ} (h : RepL p cs xs B) (hB : B ≤ B') :
    RepL p cs xs B' :=
  List.Forall₂.imp (fun _ _ hr => hr.mono hB) h

/-- How far the noise of the carry can have grown after one stage. -/
def carryBound (B Bc : ℤ) : ℤ := B * B + 2 * B * Bc

/-- …and after `n` stages. -/
def carryBoundN (B : ℤ) : ℕ → ℤ → ℤ
  | 0, Bc => Bc
  | n + 1, Bc => carryBoundN B n (carryBound B Bc)

/-- A single bound covering every output of an `n`-stage adder. -/
def sumBound (B : ℤ) (n : ℕ) (Bc : ℤ) : ℤ := 2 * B + carryBoundN B n Bc

theorem carryBound_nonneg {B Bc : ℤ} (hB : 1 ≤ B) (hBc : 0 ≤ Bc) : 0 ≤ carryBound B Bc := by
  unfold carryBound; nlinarith

theorem le_carryBound {B Bc : ℤ} (hB : 1 ≤ B) (hBc : 0 ≤ Bc) : Bc ≤ carryBound B Bc := by
  unfold carryBound; nlinarith

theorem carryBoundN_nonneg {B : ℤ} (hB : 1 ≤ B) : ∀ (n : ℕ) {Bc : ℤ}, 0 ≤ Bc →
    0 ≤ carryBoundN B n Bc
  | 0, _, h => h
  | n + 1, _, h => carryBoundN_nonneg hB n (carryBound_nonneg hB h)

theorem le_carryBoundN {B : ℤ} (hB : 1 ≤ B) : ∀ (n : ℕ) {Bc : ℤ}, 0 ≤ Bc →
    Bc ≤ carryBoundN B n Bc
  | 0, _, _ => le_rfl
  | n + 1, Bc, h => by
      have h1 : Bc ≤ carryBound B Bc := le_carryBound hB h
      have h2 : carryBound B Bc ≤ carryBoundN B n (carryBound B Bc) :=
        le_carryBoundN hB n (carryBound_nonneg hB h)
      exact h1.trans h2

/-- **The circuit is correct on ciphertext.**  Running the adder on ciphertexts
representing bits `xs` and `ys` with a carry representing `cb` yields
ciphertexts representing the outputs of the same adder run on `xs`, `ys` and
`cb`, with noise at most `sumBound`. -/
theorem addBits_rep {p B : ℤ} (hB : 1 ≤ B) : ∀ (cs xs ds ys : List ℤ) (cin cb Bc : ℤ),
    0 ≤ Bc → RepL p cs xs B → RepL p ds ys B → Rep p cin cb Bc →
    RepL p (addBits cs ds cin) (addBits xs ys cb) (sumBound B cs.length Bc)
  | [], xs, ds, ys, cin, cb, Bc, hBc, hcs, _, hcin => by
      cases hcs
      refine List.Forall₂.cons (hcin.mono ?_) List.Forall₂.nil
      simp only [sumBound, List.length_nil, carryBoundN]
      linarith
  | c :: cs, xs, [], ys, cin, cb, Bc, hBc, hcs, hds, hcin => by
      cases hds
      cases hcs with
      | cons _ _ =>
        refine List.Forall₂.cons (hcin.mono ?_) List.Forall₂.nil
        have h0 : 0 ≤ carryBoundN B (cs.length + 1) Bc :=
          carryBoundN_nonneg hB _ hBc
        have h1 : Bc ≤ carryBoundN B (cs.length + 1) Bc := le_carryBoundN hB _ hBc
        simp only [sumBound, List.length_cons]
        linarith
  | c :: cs, xs, d :: ds, ys, cin, cb, Bc, hBc, hcs, hds, hcin => by
      cases hcs with
      | cons hc hcs' =>
        cases hds with
        | cons hd hds' =>
          rename_i x xs' y ys'
          have hcarry : Rep p (c * d + (c + d) * cin) (x * y + (x + y) * cb)
              (carryBound B Bc) := by
            have h1 := (hc.mul hd).add ((hc.add hd).mul hcin)
            have hb : B * B + (B + B) * Bc = carryBound B Bc := by unfold carryBound; ring
            rwa [hb] at h1
          have ih := addBits_rep hB cs xs' ds ys' (c * d + (c + d) * cin)
            (x * y + (x + y) * cb) (carryBound B Bc)
            (carryBound_nonneg hB hBc) hcs' hds' hcarry
          have hhead : Rep p (c + d + cin) (x + y + cb) (sumBound B (cs.length + 1) Bc) := by
            refine ((hc.add hd).add hcin).mono ?_
            have h1 : Bc ≤ carryBoundN B (cs.length + 1) Bc := le_carryBoundN hB _ hBc
            simp only [sumBound]
            linarith
          simp only [addBits, List.length_cons]
          exact List.Forall₂.cons hhead (by
            simpa [sumBound, carryBoundN] using ih)

/-! ## Reading the answer -/

/-- The number a list of bits stands for, least significant first, taking each
entry modulo two. -/
def valBits : List ℤ → ℤ
  | [] => 0
  | b :: t => b % 2 + 2 * valBits t

/-- **The circuit is an adder.** -/
theorem addBits_val : ∀ (xs ys : List ℤ) (cin : ℤ), xs.length = ys.length →
    (∀ x ∈ xs, x = 0 ∨ x = 1) → (∀ y ∈ ys, y = 0 ∨ y = 1) →
    valBits (addBits xs ys cin) = valBits xs + valBits ys + cin % 2
  | [], [], cin, _, _, _ => by simp [addBits, valBits]
  | x :: xs, [], _, h, _, _ => by simp at h
  | [], y :: ys, _, h, _, _ => by simp at h
  | x :: xs, y :: ys, cin, hlen, hx, hy => by
      have hx0 : x = 0 ∨ x = 1 := hx x (by simp)
      have hy0 : y = 0 ∨ y = 1 := hy y (by simp)
      have ih := addBits_val xs ys (x * y + (x + y) * cin) (by simpa using hlen)
        (fun a ha => hx a (by simp [ha])) (fun a ha => hy a (by simp [ha]))
      simp only [addBits, valBits, ih]
      rcases hx0 with rfl | rfl <;> rcases hy0 with rfl | rfl <;> ring_nf <;> omega

/-! ## Numbers -/

/-- The `n` low bits of `x`, least significant first. -/
def bitsOf (x : ℤ) : ℕ → List ℤ
  | 0 => []
  | n + 1 => x % 2 :: bitsOf (x / 2) n

theorem bitsOf_length (x : ℤ) : ∀ n, (bitsOf x n).length = n
  | 0 => rfl
  | n + 1 => by simp [bitsOf, bitsOf_length]

theorem bitsOf_bits : ∀ (n : ℕ) (x : ℤ), 0 ≤ x → ∀ b ∈ bitsOf x n, b = 0 ∨ b = 1
  | 0, _, _ => by simp [bitsOf]
  | n + 1, x, hx => by
      intro b hb
      simp only [bitsOf, List.mem_cons] at hb
      rcases hb with rfl | hb
      · omega
      · exact bitsOf_bits n (x / 2) (Int.ediv_nonneg hx (by norm_num)) b hb

theorem valBits_bitsOf : ∀ (n : ℕ) (x : ℤ), 0 ≤ x → x < 2 ^ n → valBits (bitsOf x n) = x
  | 0, x, hx, hlt => by simp [bitsOf, valBits]; omega
  | n + 1, x, hx, hlt => by
      have hd : x / 2 < 2 ^ n := by
        have : (2:ℤ) ^ (n + 1) = 2 * 2 ^ n := by ring
        omega
      have ih := valBits_bitsOf n (x / 2) (Int.ediv_nonneg hx (by norm_num)) hd
      simp only [bitsOf, valBits, ih]
      omega

/-- Encrypt a list of bits, taking the noise from a list of pairs. -/
def encBits (p : ℤ) : List ℤ → List (ℤ × ℤ) → List ℤ
  | [], _ => []
  | b :: bs, [] => encBit p b 0 0 :: encBits p bs []
  | b :: bs, (r, q) :: rs => encBit p b r q :: encBits p bs rs

theorem encBits_length (p : ℤ) : ∀ (bs : List ℤ) (rs : List (ℤ × ℤ)),
    (encBits p bs rs).length = bs.length
  | [], _ => rfl
  | _ :: bs, [] => by simp [encBits, encBits_length]
  | _ :: bs, _ :: rs => by simp [encBits, encBits_length]

theorem valBits_map_emod : ∀ l : List ℤ, valBits (l.map (fun b => b % 2)) = valBits l
  | [] => rfl
  | b :: t => by
      simp only [List.map_cons, valBits, valBits_map_emod t, Int.emod_emod_of_dvd b (dvd_refl 2)]

/-- Every ciphertext of a represented list decrypts to the bit it carries. -/
theorem RepL.dec_map {p B : ℤ} (hB : B < p) : ∀ {cs xs : List ℤ},
    RepL p cs xs B → cs.map (decBit p) = xs.map (fun b => b % 2) := by
  intro cs xs h
  induction h with
  | nil => rfl
  | cons hhd _ ih => simp only [List.map_cons, ih, hhd.dec hB]

theorem encBits_rep {p R : ℤ} (hR : 0 ≤ R) : ∀ (bs : List ℤ) (rs : List (ℤ × ℤ)),
    (∀ b ∈ bs, b = 0 ∨ b = 1) → (∀ x ∈ rs, 0 ≤ x.1 ∧ x.1 ≤ R) →
    RepL p (encBits p bs rs) bs (1 + 2 * R)
  | [], _, _, _ => List.Forall₂.nil
  | b :: bs, [], hb, hr => by
      refine List.Forall₂.cons ?_ (encBits_rep hR bs [] (fun x hx => hb x (by simp [hx]))
        (by simp))
      have := hb b (by simp)
      exact Rep.enc (R := R) (by omega) (by omega) le_rfl hR
  | b :: bs, (r, q) :: rs, hb, hr => by
      have hb0 := hb b (by simp)
      have hr0 := hr (r, q) (by simp)
      refine List.Forall₂.cons ?_ (encBits_rep hR bs rs (fun x hx => hb x (by simp [hx]))
        (fun x hx => hr x (by simp [hx])))
      exact Rep.enc (R := R) (by omega) (by omega) hr0.1 hr0.2

/-- **Adding two encrypted numbers.**  Encrypt the `n` low bits of `x` and of
`y`, run the ripple-carry circuit on the ciphertexts, decrypt each output and
read the result as a binary numeral: the answer is `x + y`, provided the
modulus outruns the noise the circuit builds up. -/
theorem he_add_correct {p R x y : ℤ} {n : ℕ} {rs ss : List (ℤ × ℤ)}
    (hR : 0 ≤ R)
    (hx0 : 0 ≤ x) (hxn : x < 2 ^ n) (hy0 : 0 ≤ y) (hyn : y < 2 ^ n)
    (hrs : ∀ z ∈ rs, 0 ≤ z.1 ∧ z.1 ≤ R) (hss : ∀ z ∈ ss, 0 ≤ z.1 ∧ z.1 ≤ R)
    (hnoise : sumBound (1 + 2 * R) n 0 < p) :
    valBits ((addBits (encBits p (bitsOf x n) rs) (encBits p (bitsOf y n) ss) 0).map
      (decBit p)) = x + y := by
  set B : ℤ := 1 + 2 * R with hB
  have hB1 : 1 ≤ B := by omega
  have hxb : RepL p (encBits p (bitsOf x n) rs) (bitsOf x n) B :=
    encBits_rep hR _ _ (bitsOf_bits n x hx0) hrs
  have hyb : RepL p (encBits p (bitsOf y n) ss) (bitsOf y n) B :=
    encBits_rep hR _ _ (bitsOf_bits n y hy0) hss
  have hzero : Rep p 0 0 0 := ⟨0, 0, by ring, le_rfl, le_rfl, rfl⟩
  have hcirc := addBits_rep (p := p) (B := B) hB1 _ _ _ _ 0 0 0 le_rfl hxb hyb hzero
  rw [encBits_length] at hcirc
  rw [bitsOf_length] at hcirc
  have hdec := RepL.dec_map hnoise hcirc
  rw [hdec, valBits_map_emod,
    addBits_val (bitsOf x n) (bitsOf y n) 0 (by rw [bitsOf_length, bitsOf_length])
      (bitsOf_bits n x hx0) (bitsOf_bits n y hy0),
    valBits_bitsOf n x hx0 hxn, valBits_bitsOf n y hy0 hyn]
  simp

end Web
end LifeTrac
