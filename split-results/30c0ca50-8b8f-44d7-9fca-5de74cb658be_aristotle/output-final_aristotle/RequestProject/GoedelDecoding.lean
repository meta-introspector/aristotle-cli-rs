import Mathlib
import RequestProject.GodelBrainrot

/-!
# Gödel Brainrot Stealer — Decoding & Diagonalization

This module completes the "decode" half of the Gödel-Brainrot machinery and gives a
rigorous incompleteness/diagonalization theorem for the *unstealable meme*.

The encoding `GodelBrainrot.encodeBrainrot` sends a list of meme tokens to the product
`∏ᵢ pᵢ ^ (length of i-th token)` over the genuine prime table `GodelBrainrot.primes`.
Because the encoding only records token **lengths** (the prime *exponents*), the
information that can be recovered from a Gödel number is *exactly* the sequence of token
lengths — the actual letters are discarded.  Accordingly, the honest "decode" recovers
the exponent/length sequence, and the round-trip theorem `decodeLengths_encode` proves
this recovery is exact for every brainrot fitting in the prime table.

A flavourful, lossy `decodeBrainrot` is also provided for in-game display (it renders
each recovered length through a meme `tokenDictionary`); it is documented as lossy and
no false round-trip is claimed for it.

The headline logical result is `exists_unprovable_brainrot`: for **every** finite vault
of captured Gödel numbers there is a brainrot whose code escapes the vault — a
Gödel-style incompleteness statement, proved by a genuine diagonal/unboundedness
construction.
-/

namespace GodelBrainrot

open scoped BigOperators

/-- Human-readable meme token keyed by a token length.  This is a *lossy* display map
(several lengths share the fallback `"gyatt"`), used only to render decoded numbers in
the game UI — it is **not** used for the faithful round-trip theorem. -/
def tokenDictionary (len : Nat) : String :=
  match len with
  | 5 => "sigma"
  | 6 => "toilet"
  | 7 => "quantum"
  | 8 => "looksmax"
  | 9 => "skibidi"
  | _ => "gyatt"

/-- **Faithful Gödel decode.** Recover the exponent (= token-length) sequence at the
first `k` coordinate primes by reading off the prime factorization. -/
def decodeLengths (k n : Nat) : List Nat :=
  (List.range k).map (fun i => n.factorization (primes.getD i 2))

/-- **Lossy, human-readable decode** for the game UI: drop empty coordinates and render
each surviving length through `tokenDictionary`.  Returns `none` only for `0`. -/
def decodeBrainrot (n : Nat) : Option Brainrot :=
  if n = 0 then none
  else some ⟨((decodeLengths primes.length n).filter (· ≠ 0)).map tokenDictionary⟩

/-
The faithful decode of a freshly encoded brainrot returns exactly its token-length
sequence, for every brainrot that fits in the genuine prime table. This is the exact
inverse on the recoverable information (the exponents).
-/
theorem decodeLengths_encode (b : Brainrot) (hk : b.tokens.length ≤ primes.length) :
    decodeLengths b.tokens.length (encodeBrainrot b) = b.tokens.map String.length := by
  refine' List.ext_get _ _ <;> simp_all +decide [ decodeLengths, encodeBrainrot ];
  intro n hn; rw [ show List.foldl ( fun acc p => acc * primes[p.2]?.getD 2 ^ p.1.length ) 1 b.tokens.zipIdx = ∏ x ∈ Finset.range b.tokens.length, primes[x]?.getD 2 ^ b.tokens[x]!.length from ?_ ] ; rw [ Nat.factorization_prod ] <;> norm_num;
  · rw [ Finset.sum_eq_single n ] <;> simp_all +decide;
    · have : n < 12 := Nat.lt_of_lt_of_le hn hk; interval_cases n <;> norm_num [ primes ] ;
    · intro i hi hne; right; rw [ Nat.factorization_eq_zero_of_not_dvd ] ;
      have h_prime_distinct : ∀ i j : Fin primes.length, i ≠ j → ¬(primes.getD i 2 ∣ primes.getD j 2) := by
        native_decide;
      convert h_prime_distinct ⟨ n, by linarith ⟩ ⟨ i, by linarith ⟩ ( by simpa [ Fin.ext_iff ] using Ne.symm hne ) using 1;
  · intro x hx H; rcases x with ( _ | _ | _ | _ | _ | _ | _ | _ | _ | _ | _ | _ | x ) <;> simp_all +arith +decide;
    exact absurd H ( by rw [ List.getElem?_eq_none ] <;> norm_num ; linarith [ show primes.length = 12 by rfl ] );
  · induction' b.tokens using List.reverseRecOn with b ih <;> simp_all +decide [ Finset.prod_range_succ ];
    simp_all +decide [ List.zipIdx_append ];
    exact Or.inl ( Finset.prod_congr rfl fun x hx => by rw [ List.getElem?_append ] ; aesop )

/-
**Incompleteness / diagonalization.** For every finite vault `vaultUnion` of captured
Gödel numbers there exists a brainrot whose code is *not* in the vault: no finite vault
can ever contain all brainrot.  (The escaping witness is built by exceeding the vault's
maximum, the diagonal/unboundedness construction.)
-/
theorem exists_unprovable_brainrot (vaultUnion : Finset Nat) :
    ∃ b : Brainrot, encodeBrainrot b ∉ vaultUnion := by
  by_contra!;
  -- Let `N` be the maximum of `vaultUnion` (using `Finset.sup vaultUnion id`, every element `x ∈ vaultUnion` satisfies `x ≤ N` by `Finset.le_sup`).
  set N := Finset.sup vaultUnion id with hN_def;
  exact absurd ( GodelBrainrot.encode_unbounded N ) ( by rintro ⟨ b, hb ⟩ ; exact not_lt_of_ge ( Finset.le_sup ( f := id ) ( this b ) ) hb )

/-
A constructive diagonal form: for any finite list of brainrots there is a brainrot
whose code differs from every listed code.
-/
theorem exists_unstealable_brainrot (l : List Brainrot) :
    ∃ b : Brainrot, ∀ a ∈ l, encodeBrainrot b ≠ encodeBrainrot a := by
  obtain ⟨N, hN⟩ : ∃ N, ∀ a ∈ l, encodeBrainrot a ≤ N := by
    exact ⟨ l.toFinset.sup ( fun a => encodeBrainrot a ), fun a ha => Finset.le_sup ( f := fun a => encodeBrainrot a ) ( List.mem_toFinset.mpr ha ) ⟩;
  exact Exists.elim ( GodelBrainrot.encode_unbounded N ) fun b hb => ⟨ b, fun a ha => by linarith [ hN a ha ] ⟩

/-
`decodeBrainrot` only fails on `0`; every genuine (positive) Gödel number decodes.
-/
theorem decodeBrainrot_isSome (n : Nat) (hn : 0 < n) : (decodeBrainrot n).isSome := by
  unfold decodeBrainrot; aesop;

end GodelBrainrot