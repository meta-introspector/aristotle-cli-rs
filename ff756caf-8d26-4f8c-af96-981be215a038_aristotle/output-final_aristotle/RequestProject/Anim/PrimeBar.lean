import Mathlib

/-!
# Prime bar music

The semantics of `web/js/primebar.js`: the score whose bars are the natural
numbers.

Bar `n` sounds the prime factors of `n`, one note per factor, counted with
multiplicity.  Bar 1 is a rest, a prime bar is a single note, and a bar whose
number is a prime power is that note doubled.  The pitch of a prime is fixed by
its position in the sequence of primes: the k-th prime takes the k-th degree of
a seven-note scale, climbing an octave every seven primes.

Everything here is `Nat`: there is no floating point, no tuning system to
approximate and no rounding, so the statements are unconditional and
`tests/node/test_primebar.mjs` compares the runtime against them exactly.

What is proved:

* the chord of a product is the union of the chords (`chord_mul`) — the score
  is multiplicative, which is what makes it music rather than a list;
* a bar determines its number (`chord_injective`): unique factorization, heard;
* a bar is silent exactly at 1 (`chord_eq_zero_iff`) and a single note exactly
  at a prime (`noteCount_eq_one_iff_prime`);
* two bars share a note exactly when they are not coprime
  (`shares_note_iff_not_coprime`), so a coprime pair is heard as disjoint
  voices;
* the pitch map is strictly increasing in the degree and injective on primes
  (`pitch_strictMono`, `voice_injective_on_primes`), so no two primes collide.

No axioms are introduced: every assumption a statement needs is one of its
hypotheses.
-/

namespace Hesper.PrimeBar

/-! ## The chord of a bar -/

/-- The chord of bar `n`: its prime factors, with multiplicity.  Bar 0 is
silent by convention (0 has no factorization). -/
def chord (n : ℕ) : Multiset ℕ := (Nat.primeFactorsList n : Multiset ℕ)

/-- How many notes bar `n` has: Ω(n), the number of prime factors with
multiplicity. -/
def noteCount (n : ℕ) : ℕ := (chord n).card

@[simp] theorem chord_one : chord 1 = 0 := by simp [chord]

@[simp] theorem chord_prime {p : ℕ} (hp : p.Prime) : chord p = {p} := by
  simp [chord, Nat.primeFactorsList_prime hp]

/-- A prime power is one note, doubled: the same pitch `k` times. -/
theorem chord_prime_pow {p : ℕ} (hp : p.Prime) (k : ℕ) :
    chord (p ^ k) = Multiset.replicate k p := by
  simp [chord, hp.primeFactorsList_pow, ← Multiset.coe_replicate]

/-- **The score is multiplicative**: the chord of a product is the two chords
sounded together. -/
theorem chord_mul {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) :
    chord (m * n) = chord m + chord n := by
  have h := Nat.perm_primeFactorsList_mul hm hn
  show ((m * n).primeFactorsList : Multiset ℕ) = _
  rw [show ((chord m) + chord n)
      = ((m.primeFactorsList ++ n.primeFactorsList : List ℕ) : Multiset ℕ) by
    simp [chord]]
  exact Multiset.coe_eq_coe.mpr h

/-- …and so the number of notes adds. -/
theorem noteCount_mul {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) :
    noteCount (m * n) = noteCount m + noteCount n := by
  simp [noteCount, chord_mul hm hn]

/-- **A bar determines its number.**  Two bars that sound the same chord are
the same bar: unique factorization, heard. -/
theorem chord_injective {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) (h : chord m = chord n) : m = n :=
  Nat.eq_of_perm_primeFactorsList hm hn (Multiset.coe_eq_coe.mp h)

/-- The only silent bar is bar 1. -/
theorem chord_eq_zero_iff {n : ℕ} (hn : n ≠ 0) : chord n = 0 ↔ n = 1 := by
  constructor
  · intro h
    exact chord_injective hn one_ne_zero (by simpa using h)
  · rintro rfl; simp

/-- A bar is a single note exactly when its number is prime. -/
theorem noteCount_eq_one_iff_prime {n : ℕ} (hn : n ≠ 0) : noteCount n = 1 ↔ n.Prime := by
  constructor
  · intro h
    obtain ⟨p, hp⟩ := Multiset.card_eq_one.1 h
    have hmem : p ∈ Nat.primeFactorsList n := by
      have : p ∈ chord n := by rw [hp]; simp
      simpa [chord] using this
    have hpp : p.Prime := Nat.prime_of_mem_primeFactorsList hmem
    have : chord n = chord p := by rw [hp, chord_prime hpp]
    exact (chord_injective hn hpp.ne_zero this) ▸ hpp
  · intro hp
    simp [noteCount, chord_prime hp]

/-- A note of bar `n` is a prime dividing `n`, and every such prime is heard. -/
theorem mem_chord_iff {n p : ℕ} (hn : n ≠ 0) : p ∈ chord n ↔ p.Prime ∧ p ∣ n := by
  constructor
  · intro h
    have hmem : p ∈ Nat.primeFactorsList n := by simpa [chord] using h
    exact ⟨Nat.prime_of_mem_primeFactorsList hmem, Nat.dvd_of_mem_primeFactorsList hmem⟩
  · rintro ⟨hp, hdvd⟩
    have : p ∈ Nat.primeFactorsList n := (Nat.mem_primeFactorsList hn).2 ⟨hp, hdvd⟩
    simpa [chord] using this

/-- **Coprime bars are disjoint voices**: two bars share a note exactly when
their numbers share a prime factor. -/
theorem shares_note_iff_not_coprime {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) :
    (∃ p, p ∈ chord m ∧ p ∈ chord n) ↔ ¬ Nat.Coprime m n := by
  constructor
  · rintro ⟨p, hpm, hpn⟩ hco
    obtain ⟨hp, hdm⟩ := (mem_chord_iff hm).1 hpm
    obtain ⟨-, hdn⟩ := (mem_chord_iff hn).1 hpn
    have hdg : p ∣ Nat.gcd m n := Nat.dvd_gcd hdm hdn
    rw [Nat.Coprime] at hco
    rw [hco] at hdg
    exact hp.ne_one (Nat.dvd_one.mp hdg)
  · intro hco
    have hg : Nat.gcd m n ≠ 1 := hco
    obtain ⟨p, hp, hdvd⟩ := Nat.exists_prime_and_dvd hg
    exact ⟨p, (mem_chord_iff hm).2 ⟨hp, hdvd.trans (Nat.gcd_dvd_left m n)⟩,
      (mem_chord_iff hn).2 ⟨hp, hdvd.trans (Nat.gcd_dvd_right m n)⟩⟩

/-! ## Pitch

The k-th prime takes the k-th degree of a seven-note scale, climbing an octave
every seven primes.  The degree of a prime is how many primes come before it.
-/

/-- How many primes are below `p`: the degree of `p` in the scale. -/
def degree (p : ℕ) : ℕ := ((Finset.range p).filter Nat.Prime).card

@[simp] theorem degree_two : degree 2 = 0 := by decide

@[simp] theorem degree_three : degree 3 = 1 := by decide

theorem degree_five : degree 5 = 2 := by decide

theorem degree_seven : degree 7 = 3 := by decide

/-- A larger prime has a larger degree. -/
theorem degree_lt_degree {p q : ℕ} (hp : p.Prime) (hpq : p < q) : degree p < degree q := by
  refine Finset.card_lt_card ⟨?_, ?_⟩
  · intro x hx
    simp only [Finset.mem_filter, Finset.mem_range] at hx ⊢
    exact ⟨hx.1.trans hpq, hx.2⟩
  · intro hsub
    have : p ∈ (Finset.range q).filter Nat.Prime := by
      simp only [Finset.mem_filter, Finset.mem_range]
      exact ⟨hpq, hp⟩
    have := hsub this
    simp only [Finset.mem_filter, Finset.mem_range] at this
    exact lt_irrefl p this.1

/-- The semitones of the major scale, the degrees of one octave. -/
def scaleStep (r : ℕ) : ℕ := [0, 2, 4, 5, 7, 9, 11].getD r 0

theorem scaleStep_lt_twelve {r : ℕ} (hr : r < 7) : scaleStep r < 12 := by
  interval_cases r <;> decide

theorem scaleStep_lt {r s : ℕ} (hs : s < 7) (hrs : r < s) : scaleStep r < scaleStep s := by
  interval_cases s <;> interval_cases r <;> decide

/-- The MIDI note of scale degree `d` above `root`. -/
def pitch (root d : ℕ) : ℕ := root + 12 * (d / 7) + scaleStep (d % 7)

/-- The pitch climbs with the degree, so the primes are heard in order. -/
theorem pitch_strictMono (root : ℕ) : StrictMono (pitch root) := by
  intro a b hab
  have hqa : a / 7 ≤ b / 7 := Nat.div_le_div_right hab.le
  rcases lt_or_eq_of_le hqa with hq | hq
  · have ha : scaleStep (a % 7) < 12 := scaleStep_lt_twelve (Nat.mod_lt _ (by norm_num))
    have hb : 0 ≤ scaleStep (b % 7) := Nat.zero_le _
    simp only [pitch]
    omega
  · have hr : a % 7 < b % 7 := by
      have := Nat.div_add_mod a 7
      have := Nat.div_add_mod b 7
      omega
    have := scaleStep_lt (Nat.mod_lt _ (show 0 < 7 by norm_num)) hr
    simp only [pitch, hq]
    omega

/-- The voice a prime sings. -/
def voice (root p : ℕ) : ℕ := pitch root (degree p)

/-- **No two primes collide**: distinct primes take distinct pitches. -/
theorem voice_injective_on_primes {root p q : ℕ} (hp : p.Prime) (hq : q.Prime)
    (h : voice root p = voice root q) : p = q := by
  rcases lt_trichotomy p q with hlt | heq | hgt
  · exact absurd h (Nat.ne_of_lt ((pitch_strictMono root) (degree_lt_degree hp hlt))).elim
  · exact heq
  · exact absurd h.symm (Nat.ne_of_lt ((pitch_strictMono root) (degree_lt_degree hq hgt))).elim

/-- The notes of bar `n`, as pitches. -/
def bar (root n : ℕ) : Multiset ℕ := (chord n).map (voice root)

/-- The bar of a product is the two bars sounded together. -/
theorem bar_mul {root m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) :
    bar root (m * n) = bar root m + bar root n := by
  simp [bar, chord_mul hm hn]

/-- A bar has as many pitches as it has notes. -/
@[simp] theorem card_bar (root n : ℕ) : (bar root n).card = noteCount n := by
  simp [bar, noteCount]

/-- A prime bar is a single pitch: the voice of that prime. -/
theorem bar_prime {root p : ℕ} (hp : p.Prime) : bar root p = {voice root p} := by
  simp [bar, chord_prime hp]

/-- Bar 1 is a rest. -/
@[simp] theorem bar_one (root : ℕ) : bar root 1 = 0 := by simp [bar]

/-- How often a pitch is heard in a bar: exactly the multiplicity of its
prime. -/
theorem count_bar {root n : ℕ} (hn : n ≠ 0) {p : ℕ} (hp : p.Prime) :
    (bar root n).count (voice root p) = (chord n).count p := by
  classical
  rw [bar, Multiset.count_map, Multiset.count_eq_card_filter_eq]
  refine congrArg Multiset.card (Multiset.filter_congr ?_)
  intro a ha
  constructor
  · intro h
    exact (voice_injective_on_primes hp ((mem_chord_iff hn).1 ha).1 h)
  · intro h; rw [h]

/-- **A bar of pitches determines its number too**, since distinct primes take
distinct pitches: the score can be read back off what you hear. -/
theorem bar_injective {root m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0)
    (h : bar root m = bar root n) : m = n := by
  classical
  refine chord_injective hm hn (Multiset.ext.2 ?_)
  intro p
  by_cases hp : p.Prime
  · rw [← count_bar hm hp, ← count_bar hn hp, h]
  · have hzero : ∀ k : ℕ, k ≠ 0 → Multiset.count p (chord k) = 0 := by
      intro k hk
      by_contra hne
      exact hp ((mem_chord_iff hk).1 (Multiset.count_pos.1 (Nat.pos_of_ne_zero hne))).1
    rw [hzero m hm, hzero n hn]

end Hesper.PrimeBar
