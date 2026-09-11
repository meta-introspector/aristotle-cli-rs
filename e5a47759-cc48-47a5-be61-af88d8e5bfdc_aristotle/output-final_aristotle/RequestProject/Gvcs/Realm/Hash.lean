import RequestProject.Gvcs.Realm.Rules

/-!
# Writing a game down, and committing to it

A page of `Realm` carries the whole game as a list of small numbers — one per
move — and a **digest** of that list.  The digest is what a player puts on a
chain (or in any public place) when they stake on the game: it is short, it is
cheap to publish, and the claim it makes is that the game is *this* one.

This file is the writing-down and the digesting.

* `Move.code` / `Move.ofCode` — a move as one number below `moveCodeBound`, and
  back; `Move.ofCode_code` is the round trip, and `Move.code_inj` says that a
  transcript of numbers determines the moves that made it.
* `foldWith` — a chained digest: start from a seed, absorb one code at a time.
* `foldWith_inj` — **the binding theorem**: if the compression function never
  collides and never lands back on the seed, the digest determines the whole
  transcript.  This is a theorem about any such function, and it is not vacuous:
  `idealMix` (Cantor pairing, shifted off the seed) satisfies both hypotheses,
  which is what `idealDigest_inj` records.
* `mix`, `digestOf`, `chainDigest` — the concrete 64-bit FNV-1a chain the pages
  and the JavaScript actually compute.  It is a *finite* digest, so by counting
  it cannot literally be injective; `foldWith_inj` is the statement of what one
  is assuming when one stakes on a 64-bit commitment, and
  `chainDigest_eq_of_eq` is the half of it that is unconditionally true and is
  all a verifier ever needs: the same game always digests to the same number.
-/

namespace LifeTrac
namespace Realm

/-! ## Moves as numbers -/

/-- A building kind as a number. -/
def BKind.code : BKind → Nat
  | .farm => 0
  | .barracks => 1

/-- A number as a building kind. -/
def BKind.ofCode : Nat → BKind
  | 0 => .farm
  | _ => .barracks

@[simp] theorem BKind.ofCode_code (b : BKind) : BKind.ofCode b.code = b := by cases b <;> rfl

@[simp] theorem BKind.code_lt (b : BKind) : b.code < 2 := by cases b <;> simp [BKind.code]

/-- A piece kind as a number. -/
def UKind.code : UKind → Nat
  | .worker => 0
  | .soldier => 1

/-- A number as a piece kind. -/
def UKind.ofCode : Nat → UKind
  | 0 => .worker
  | _ => .soldier

@[simp] theorem UKind.ofCode_code (k : UKind) : UKind.ofCode k.code = k := by cases k <;> rfl

@[simp] theorem UKind.code_lt (k : UKind) : k.code < 2 := by cases k <;> simp [UKind.code]

/-- Every code of a writable move is below this: six kinds of move, sixty-four
tiles, four directions. -/
def moveCodeBound : Nat := 1536

/-- A move as a single number: the kind of move in the units, the tile in the
next six bits' worth, and the direction or the kind on top. -/
def Move.code : Move → Nat
  | .march p d => 0 + 6 * (p + 64 * d)
  | .gather p => 1 + 6 * p
  | .build p b => 2 + 6 * (p + 64 * b.code)
  | .train p k => 3 + 6 * (p + 64 * k.code)
  | .strike p d => 4 + 6 * (p + 64 * d)
  | .endTurn => 5

/-- The move named by a kind `t`, a tile `p` and an extra field `a`. -/
def Move.ofParts (t p a : Nat) : Option Move :=
  if t = 0 then some (.march p a)
  else if t = 1 then (if a = 0 then some (.gather p) else none)
  else if t = 2 then (if a < 2 then some (.build p (BKind.ofCode a)) else none)
  else if t = 3 then (if a < 2 then some (.train p (UKind.ofCode a)) else none)
  else if t = 4 then some (.strike p a)
  else if p = 0 ∧ a = 0 then some Move.endTurn else none

/-- A number as a move, when it names one. -/
def Move.ofCode (n : Nat) : Option Move :=
  if moveCodeBound ≤ n then none else Move.ofParts (n % 6) ((n / 6) % 64) (n / 384)

theorem Move.code_lt {m : Move} (h : m.Ok) : m.code < moveCodeBound := by
  cases m with
  | march p d => obtain ⟨hp, hd⟩ := h; simp only [boardN] at hp
                 simp only [Move.code, moveCodeBound]; omega
  | gather p => simp only [Move.Ok, boardN] at h; simp only [Move.code, moveCodeBound]; omega
  | build p b => simp only [Move.Ok, boardN] at h; have := b.code_lt
                 simp only [Move.code, moveCodeBound]; omega
  | train p k => simp only [Move.Ok, boardN] at h; have := k.code_lt
                 simp only [Move.code, moveCodeBound]; omega
  | strike p d => obtain ⟨hp, hd⟩ := h; simp only [boardN] at hp
                  simp only [Move.code, moveCodeBound]; omega
  | endTurn => simp [Move.code, moveCodeBound]

theorem Move.ofCode_code {m : Move} (h : m.Ok) : Move.ofCode m.code = some m := by
  have hb := Move.code_lt h
  rw [Move.ofCode, if_neg (by omega)]
  cases m with
  | march p d =>
    obtain ⟨hp, hd⟩ := h
    simp only [boardN] at hp
    simp only [Move.code]
    rw [show (0 + 6 * (p + 64 * d)) % 6 = 0 by omega,
        show (0 + 6 * (p + 64 * d)) / 6 % 64 = p by omega,
        show (0 + 6 * (p + 64 * d)) / 384 = d by omega]
    rfl
  | gather p =>
    simp only [Move.Ok, boardN] at h
    simp only [Move.code]
    rw [show (1 + 6 * p) % 6 = 1 by omega, show (1 + 6 * p) / 6 % 64 = p by omega,
        show (1 + 6 * p) / 384 = 0 by omega]
    rfl
  | build p b =>
    simp only [Move.Ok, boardN] at h
    have hbc := b.code_lt
    simp only [Move.code]
    rw [show (2 + 6 * (p + 64 * b.code)) % 6 = 2 by omega,
        show (2 + 6 * (p + 64 * b.code)) / 6 % 64 = p by omega,
        show (2 + 6 * (p + 64 * b.code)) / 384 = b.code by omega]
    simp [Move.ofParts, hbc]
  | train p k =>
    simp only [Move.Ok, boardN] at h
    have hkc := k.code_lt
    simp only [Move.code]
    rw [show (3 + 6 * (p + 64 * k.code)) % 6 = 3 by omega,
        show (3 + 6 * (p + 64 * k.code)) / 6 % 64 = p by omega,
        show (3 + 6 * (p + 64 * k.code)) / 384 = k.code by omega]
    simp [Move.ofParts, hkc]
  | strike p d =>
    obtain ⟨hp, hd⟩ := h
    simp only [boardN] at hp
    simp only [Move.code]
    rw [show (4 + 6 * (p + 64 * d)) % 6 = 4 by omega,
        show (4 + 6 * (p + 64 * d)) / 6 % 64 = p by omega,
        show (4 + 6 * (p + 64 * d)) / 384 = d by omega]
    rfl
  | endTurn => rfl

/-- **A transcript names one game.**  Two writable move lists with the same
codes are the same list. -/
theorem Move.code_inj {ms ms' : List Move} (h1 : ∀ m ∈ ms, m.Ok) (h2 : ∀ m ∈ ms', m.Ok)
    (h : ms.map Move.code = ms'.map Move.code) : ms = ms' := by
  induction ms generalizing ms' with
  | nil => cases ms' with
    | nil => rfl
    | cons b bs => simp at h
  | cons a as ih =>
    cases ms' with
    | nil => simp at h
    | cons b bs =>
      simp only [List.map_cons, List.cons.injEq] at h
      have ha : a.Ok := h1 a (by simp)
      have hb : b.Ok := h2 b (by simp)
      have : some a = some b := by
        rw [← Move.ofCode_code ha, ← Move.ofCode_code hb, h.1]
      simp only [Option.some.injEq] at this
      subst this
      exact congrArg _ (ih (fun m hm => h1 m (by simp [hm])) (fun m hm => h2 m (by simp [hm])) h.2)

/-! ## An encoding that never collides -/

theorem BKind.code_inj {a b : BKind} (h : a.code = b.code) : a = b := by
  cases a <;> cases b <;> simp_all [BKind.code]

theorem UKind.code_inj {a b : UKind} (h : a.code = b.code) : a = b := by
  cases a <;> cases b <;> simp_all [UKind.code]

/-- A move as a number that leaves nothing out: the kind of move paired with its
fields, by the Cantor pairing.  `Move.code` is the compact encoding the pages
use, and is injective on the moves that can be written down; this one is
injective on every move there is, which is what the idealized digest of
`RequestProject/Realm/Ledger.lean` needs. -/
def Move.fullCode : Move → Nat
  | .march p d => Nat.pair 0 (Nat.pair p d)
  | .gather p => Nat.pair 1 (Nat.pair p 0)
  | .build p b => Nat.pair 2 (Nat.pair p b.code)
  | .train p k => Nat.pair 3 (Nat.pair p k.code)
  | .strike p d => Nat.pair 4 (Nat.pair p d)
  | .endTurn => Nat.pair 5 0

theorem Move.fullCode_inj : Function.Injective Move.fullCode := by
  intro a b h
  cases a <;> cases b <;>
    simp only [Move.fullCode, Nat.pair_eq_pair] at h <;>
    first
      | omega
      | rfl
      | (obtain ⟨-, hp, hq⟩ := h; subst hp; first
          | (subst hq; rfl)
          | (rw [BKind.code_inj hq])
          | (rw [UKind.code_inj hq])
          | rfl)

/-! ## A chained digest -/

/-- The digest of a transcript under a compression function `f` and a seed:
absorb the codes one at a time, left to right. -/
def foldWith (f : Nat → Nat → Nat) (seed : Nat) (l : List Nat) : Nat := l.foldl f seed

@[simp] theorem foldWith_nil (f : Nat → Nat → Nat) (seed : Nat) : foldWith f seed [] = seed := rfl

theorem foldWith_concat (f : Nat → Nat → Nat) (seed : Nat) (l : List Nat) (x : Nat) :
    foldWith f seed (l ++ [x]) = f (foldWith f seed l) x := by
  simp [foldWith, List.foldl_append]

/-- **The binding theorem.**  If the compression function never collides, and
never lands back on the seed, then the digest of a transcript determines the
transcript: a player who publishes the digest has published the game. -/
theorem foldWith_inj {f : Nat → Nat → Nat} {seed : Nat}
    (hf : ∀ h x h' x', f h x = f h' x' → h = h' ∧ x = x')
    (hs : ∀ h x, f h x ≠ seed) :
    Function.Injective (foldWith f seed) := by
  intro l
  induction l using List.reverseRecOn with
  | nil =>
    intro l' h
    induction l' using List.reverseRecOn with
    | nil => rfl
    | append_singleton ys y _ =>
      rw [foldWith_nil, foldWith_concat] at h
      exact absurd h.symm (hs _ _)
  | append_singleton xs x ih =>
    intro l' h
    induction l' using List.reverseRecOn with
    | nil =>
      rw [foldWith_nil, foldWith_concat] at h
      exact absurd h (hs _ _)
    | append_singleton ys y _ =>
      rw [foldWith_concat, foldWith_concat] at h
      obtain ⟨hd, hx⟩ := hf _ _ _ _ h
      rw [ih hd, hx]

/-! ## An idealized digest, and the real one -/

/-- An idealized compression function: the Cantor pairing of `RequestProject`'s
`Nat.pair`, moved off zero.  It is what a digest would be if a digest could be
as wide as it liked. -/
def idealMix (h x : Nat) : Nat := Nat.pair h x + 1

/-- The idealized digest of a transcript. -/
def idealDigest (l : List Nat) : Nat := foldWith idealMix 0 l

/-- The hypotheses of `foldWith_inj` are satisfiable: the idealized digest
really does determine the transcript. -/
theorem idealDigest_inj : Function.Injective idealDigest := by
  apply foldWith_inj
  · intro h x h' x' he
    simp only [idealMix, Nat.add_right_cancel_iff, Nat.pair_eq_pair] at he
    exact he
  · intro h x
    simp [idealMix]

/-- Two to the sixty-fourth: digests are that wide. -/
def word : Nat := 18446744073709551616

/-- The FNV-1a prime. -/
def fnvPrime : Nat := 1099511628211

/-- The FNV-1a offset basis, which is where a digest starts. -/
def fnvSeed : Nat := 14695981039346656037

/-- One round of FNV-1a, over a whole move code rather than a byte: exclusive
or the code in, multiply by the prime, keep sixty-four bits.  This is what the
page and its JavaScript compute. -/
def mix (h x : Nat) : Nat := ((h ^^^ (x % word)) * fnvPrime) % word

/-- The digest of a transcript of codes. -/
def digestOf (l : List Nat) : Nat := foldWith mix fnvSeed l

/-- The digest of a game: the number a player publishes when they stake. -/
def chainDigest (ms : List Move) : Nat := digestOf (ms.map Move.code)

@[simp] theorem digestOf_nil : digestOf [] = fnvSeed := rfl

theorem digestOf_concat (l : List Nat) (x : Nat) : digestOf (l ++ [x]) = mix (digestOf l) x :=
  foldWith_concat _ _ _ _

/-- **Each move extends the commitment of the last.**  The digest of a game with
one more move is the digest of the game so far, with the new move absorbed —
which is why a page need only carry its predecessor's digest and its own move
for the chain of pages to be checkable link by link. -/
theorem chainDigest_concat (ms : List Move) (m : Move) :
    chainDigest (ms ++ [m]) = mix (chainDigest ms) m.code := by
  simp [chainDigest, digestOf, List.map_append, foldWith_concat]

theorem mix_lt (h x : Nat) : mix h x < word := Nat.mod_lt _ (by norm_num [word])

/-- A digest is a sixty-four bit number, so it fits in the word a chain stores. -/
theorem digestOf_lt (l : List Nat) : digestOf l < word := by
  induction l using List.reverseRecOn with
  | nil => norm_num [digestOf, foldWith, fnvSeed, word]
  | append_singleton xs x _ => rw [digestOf_concat]; exact mix_lt _ _

theorem chainDigest_lt (ms : List Move) : chainDigest ms < word := digestOf_lt _

/-- The unconditional half of binding, and the half a verifier uses: the same
game always commits to the same number, so a digest that does not match the
transcript on the page is proof that the page has been tampered with. -/
theorem chainDigest_eq_of_eq {ms ms' : List Move} (h : ms = ms') :
    chainDigest ms = chainDigest ms' := congrArg _ h

theorem ne_of_chainDigest_ne {ms ms' : List Move} (h : chainDigest ms ≠ chainDigest ms') :
    ms ≠ ms' := fun he => h (chainDigest_eq_of_eq he)

end Realm
end LifeTrac
