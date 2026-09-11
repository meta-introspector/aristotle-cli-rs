import Mathlib

/-!
# Per-Irrep CRT Spaces and Embeddings

Each irrep has its own prime support S_r ⊆ {2,3,5,7,11,13,17,19,23,29,31,41,47,59,71}
and a padic profile giving exponents at those primes. The product M_r = ∏_{p ∈ S_r} p
determines the irrep's CRT torus ℤ/M_r ≅ ∏_{p ∈ S_r} ℤ/pℤ.
-/

/-! ## Irrep Data -/

/-- An irrep's padic profile: a list of primes with associated exponents. -/
structure IrrepData where
  /-- List of (prime, exponent) pairs -/
  profile : List (ℕ × ℕ)
  /-- All first components are prime -/
  primes_prime : ∀ pe ∈ profile, Nat.Prime pe.1
  /-- The list of first components has no duplicates -/
  primes_nodup : (profile.map Prod.fst).Nodup

namespace IrrepData

/-- The prime support of an irrep. -/
def support (r : IrrepData) : List ℕ := r.profile.map Prod.fst

/-- The exponent list of an irrep. -/
def exponents (r : IrrepData) : List ℕ := r.profile.map Prod.snd

/-- Length of support equals length of exponents. -/
theorem support_length_eq (r : IrrepData) :
    r.support.length = r.exponents.length := by
  simp [support, exponents]

/-- The modulus of an irrep: product of all primes in its support. -/
def modulus (r : IrrepData) : ℕ := r.support.prod

/-- The CRT space of an irrep. -/
abbrev CRTSpace (r : IrrepData) : Type := ZMod r.modulus

end IrrepData

/-! ## CRT idempotents (computable) -/

/-- The complementary product: product of all primes except the i-th. -/
def complementaryProd (primes : List ℕ) (i : Fin primes.length) : ℕ :=
  (primes.eraseIdx i).prod

/-- Compute CRT idempotent value as a natural number mod M.
    Uses the extended Euclidean algorithm for modular inverse. -/
def crtIdempotentVal (primes : List ℕ) (i : Fin primes.length) : ℕ :=
  let M := primes.prod
  let p := primes.get i
  let compl := complementaryProd primes i
  let g := Nat.gcd compl p
  if g = 1 then
    let inv := ((Int.gcdA (compl : ℤ) (p : ℤ)) % (p : ℤ) + (p : ℤ)) % (p : ℤ)
    ((compl : ℤ) * inv % (M : ℤ)).toNat % M
  else 0

/-- The CRT coordinate from exponents: ∑ aᵢ · eᵢ mod M. -/
def crtCoord (primes exponents : List ℕ) : ℕ :=
  let M := primes.prod
  if M = 0 then 0 else
  let idemps := List.ofFn (fun i : Fin primes.length => crtIdempotentVal primes i)
  (idemps.zip exponents).foldl (fun acc ⟨ei, ai⟩ => (acc + ai * ei) % M) 0

/-! ## Verification against known Monster CRT values -/

def monsterPrimes : List ℕ := [47, 59, 71]

#eval crtIdempotentVal monsterPrimes ⟨0, by simp [monsterPrimes]⟩  -- 33512
#eval crtIdempotentVal monsterPrimes ⟨1, by simp [monsterPrimes]⟩  -- 113458
#eval crtIdempotentVal monsterPrimes ⟨2, by simp [monsterPrimes]⟩  -- 49914
#eval monsterPrimes.prod  -- 196883

/-! ## Zero-padding for embeddings -/

/-- Look up the exponent for prime p in a profile list. Returns 0 if not found. -/
def lookupExponent (profile : List (ℕ × ℕ)) (p : ℕ) : ℕ :=
  match profile.find? (fun pe => pe.1 == p) with
  | some (_, e) => e
  | none => 0

/-- Zero-pad a profile to a target list of primes. -/
def zeroPadExponents (profile_r : List (ℕ × ℕ)) (primes_s : List ℕ) : List ℕ :=
  primes_s.map (lookupExponent profile_r)

/-- The embedded CRT coordinate: zero-pad r's profile to the target primes,
    then compute the CRT coordinate in ℤ/M_s. -/
def embedCRTCoord (r : IrrepData) (primes_s : List ℕ) : ℕ :=
  crtCoord primes_s (zeroPadExponents r.profile primes_s)

/-! ## Union support -/

/-- The union of two irreps' prime supports (without duplicates). -/
def unionSupport (r s : IrrepData) : List ℕ :=
  (r.support ++ s.support).dedup

/-- The union modulus: product of all primes in the union support. -/
def unionModulus (r s : IrrepData) : ℕ :=
  (unionSupport r s).prod

/-! ## Concrete irrep rows -/

/-- Row 1: support = {47,59,71}, exponents = [1,1,1] -/
def row1 : IrrepData where
  profile := [(47,1),(59,1),(71,1)]
  primes_prime := by decide
  primes_nodup := by decide

/-- Row 0: trivial irrep, empty support -/
def row0 : IrrepData where
  profile := []
  primes_prime := by decide
  primes_nodup := by decide

/-- Row 192: support = {2,3,11,17,23,41,47,59,71} -/
def row192 : IrrepData where
  profile := [(2,46),(3,2),(11,2),(17,1),(23,1),(41,1),(47,1),(59,1),(71,1)]
  primes_prime := by decide
  primes_nodup := by decide

-- Verify moduli
#eval row1.modulus       -- 196883
#eval row0.modulus       -- 1
#eval row192.modulus     -- product of {2,3,11,17,23,41,47,59,71}

-- CRT coordinates
#eval crtCoord row1.support row1.exponents
#eval crtCoord row192.support row192.exponents

-- Embed row1 into monster base
#eval embedCRTCoord row1 monsterPrimes
-- Embed row192 into monster base (only sees 47,59,71 exponents)
#eval embedCRTCoord row192 monsterPrimes
-- Embed row1 into row192's CRT space
#eval embedCRTCoord row1 row192.support

-- Union support and modulus
#eval unionSupport row1 row192
#eval unionModulus row1 row192

/-! ## Formal properties -/

/-
Distinct primes are pairwise coprime.
-/
theorem distinct_primes_coprime (ps : List ℕ) (h_prime : ∀ p ∈ ps, Nat.Prime p)
    (h_nodup : ps.Nodup) : ps.Pairwise Nat.Coprime := by
  convert List.Pairwise.imp_of_mem _ h_nodup;
  exact fun { a b } ha hb hab => by have := Nat.coprime_primes ( h_prime a ha ) ( h_prime b hb ) ; tauto;

/-
The complementary product is coprime to the i-th prime.
-/
theorem complementary_coprime_of_primes (ps : List ℕ) (h_prime : ∀ p ∈ ps, Nat.Prime p)
    (h_nodup : ps.Nodup) (i : Fin ps.length) :
    Nat.Coprime (complementaryProd ps i) (ps.get i) := by
  have := @distinct_primes_coprime ps h_prime h_nodup; simp_all +decide [ List.pairwise_iff_getElem ] ;
  have h_coprime : ∀ p ∈ ps.eraseIdx i, Nat.Coprime p (ps.get i) := by
    intro p hp; have := List.mem_iff_get.mp hp; obtain ⟨ j, hj ⟩ := this; simp_all +decide;
    grind;
  convert Nat.coprime_list_prod_left_iff.mpr _;
  aesop

/-
The product of a list of primes is positive.
-/
theorem primes_prod_pos (ps : List ℕ) (h_prime : ∀ p ∈ ps, Nat.Prime p) :
    0 < ps.prod := by
  exact List.prod_pos fun p hp => Nat.Prime.pos ( h_prime p hp )

/-
Each prime divides the full product.
-/
theorem prime_dvd_prod' (ps : List ℕ) (i : Fin ps.length) :
    ps.get i ∣ ps.prod := by
  exact List.dvd_prod ( List.get_mem _ _ )

/-- Support inclusion is transitive. -/
theorem support_subset_trans {r s t : IrrepData}
    (hrs : ∀ p ∈ r.support, p ∈ s.support)
    (hst : ∀ p ∈ s.support, p ∈ t.support) :
    ∀ p ∈ r.support, p ∈ t.support :=
  fun p hp => hst p (hrs p hp)