import Mathlib

/-!
# Rig designs — voxel blocks, well-formedness and share codes

A **rig** is a contraption the player builds out of unit blocks on a small square
lattice: a frame to hold it together, wheels to drive it, balloons to lift it,
ballast to keep it down, an engine for fuel and cargo to carry.  This file fixes
what a design *is*, what makes one legal, how the two editing moves (place a block,
lift a block off) behave, and how a design is written down as a short **share code**
that can be passed to another player.

The three things proved here are

* a design is legal exactly when the decidable checker `wfCheck` says so
  (`wfCheck_iff`), and legality is exactly: non-empty, no bigger than
  `maxBlocks`, inside the grid, no two blocks in one cell, all one connected piece;
* the editing moves keep a design legal (`place_wf`, `remove_wf`);
* a share code round-trips: `decode (encode d) = some d` for every legal design,
  and *every* code that decodes at all decodes to a legal design — so a code
  received from a stranger can never smuggle in an illegal rig
  (`decode_encode`, `decode_wf`, `encode_injective`).
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Rig

/-! ## Blocks -/

/-- Side of the square build grid, in blocks. -/
def gridW : Nat := 16

/-- Most blocks a single rig may use.  Sixty-three, so that the block count still
fits in one letter of the share alphabet. -/
def maxBlocks : Nat := 63

/-- The kinds of block a rig can be built from. -/
inductive Kind
  | frame | wheel | balloon | ballast | engine | cargo
deriving DecidableEq, Repr, Inhabited

namespace Kind

/-- All six kinds, in palette order. -/
def all : List Kind := [frame, wheel, balloon, ballast, engine, cargo]

/-- The byte a kind is stored as; `0` is reserved for "no block". -/
def code : Kind → Nat
  | frame => 1 | wheel => 2 | balloon => 3 | ballast => 4 | engine => 5 | cargo => 6

/-- Reading a kind back from its byte. -/
def ofCode : Nat → Option Kind
  | 1 => some frame | 2 => some wheel | 3 => some balloon
  | 4 => some ballast | 5 => some engine | 6 => some cargo
  | _ => none

/-- How heavy one block of this kind is. -/
def mass : Kind → Nat
  | frame => 2 | wheel => 3 | balloon => 1 | ballast => 8 | engine => 4 | cargo => 5

/-- Forward push one wheel provides. -/
def thrust : Kind → Nat
  | wheel => 6 | _ => 0

/-- Upward pull one balloon provides. -/
def lift : Kind → Nat
  | balloon => 5 | _ => 0

/-- Fuel one engine carries. -/
def fuelUnits : Kind → Nat
  | engine => 200 | _ => 0

/-- Points one crate of cargo is worth when it is carried to the end. -/
def payload : Kind → Nat
  | cargo => 40 | _ => 0

/-- Shop price of one block. -/
def price : Kind → Nat
  | frame => 5 | wheel => 20 | balloon => 15 | ballast => 8 | engine => 30 | cargo => 12

/-- Display name. -/
def name : Kind → String
  | frame => "frame" | wheel => "wheel" | balloon => "balloon"
  | ballast => "ballast" | engine => "engine" | cargo => "cargo"

/-- Colour the page paints this kind of block. -/
def hex : Kind → String
  | frame => "#8d8f99" | wheel => "#3f4756" | balloon => "#e0575f"
  | ballast => "#5c4a36" | engine => "#d9a441" | cargo => "#4f8f5a"

@[simp] theorem ofCode_code (k : Kind) : ofCode k.code = some k := by
  cases k <;> rfl

theorem code_pos (k : Kind) : 0 < k.code := by cases k <;> decide

theorem code_lt (k : Kind) : k.code < 7 := by cases k <;> decide

theorem ofCode_eq_some : ∀ {n : Nat} {k : Kind}, ofCode n = some k → n = k.code
  | 0, _, h => by simp [ofCode] at h
  | 1, _, h => by simp [ofCode] at h; subst h; rfl
  | 2, _, h => by simp [ofCode] at h; subst h; rfl
  | 3, _, h => by simp [ofCode] at h; subst h; rfl
  | 4, _, h => by simp [ofCode] at h; subst h; rfl
  | 5, _, h => by simp [ofCode] at h; subst h; rfl
  | 6, _, h => by simp [ofCode] at h; subst h; rfl
  | (_ + 7), _, h => by simp [ofCode] at h

theorem code_injective {a b : Kind} (h : a.code = b.code) : a = b := by
  have := ofCode_code a
  rw [h, ofCode_code] at this
  exact (Option.some.inj this).symm

end Kind

/-- One placed block: a lattice cell and what sits in it. -/
structure Block where
  x : Nat
  y : Nat
  kind : Kind
deriving DecidableEq, Repr, Inhabited

namespace Block

/-- The cell index of a block, `0 … 255`. -/
def pos (b : Block) : Nat := b.x + gridW * b.y

/-- Is the block inside the grid? -/
def inBounds (b : Block) : Bool := b.x < gridW && b.y < gridW

theorem pos_lt {b : Block} (h : b.inBounds = true) : b.pos < gridW * gridW := by
  simp [inBounds, gridW] at h
  simp [pos, gridW]
  omega

theorem pos_inj {a b : Block} (ha : a.inBounds = true) (hb : b.inBounds = true)
    (h : a.pos = b.pos) : a.x = b.x ∧ a.y = b.y := by
  simp [inBounds, gridW] at ha hb
  simp [pos, gridW] at h
  omega

end Block

/-- A design is the list of blocks the player has placed. -/
abbrev Design := List Block

namespace Design

/-- The occupied cells. -/
def cells (d : Design) : List Nat := d.map Block.pos

/-- Is a cell occupied? -/
def occupied (d : Design) (p : Nat) : Bool := d.any (fun b => b.pos == p)

/-- How many blocks of a given kind. -/
def count (d : Design) (k : Kind) : Nat := (d.filter (fun b => b.kind == k)).length

/-- Total mass. -/
def mass (d : Design) : Nat := (d.map (fun b => b.kind.mass)).sum

/-- Total forward push. -/
def thrust (d : Design) : Nat := (d.map (fun b => b.kind.thrust)).sum

/-- Total upward pull. -/
def lift (d : Design) : Nat := (d.map (fun b => b.kind.lift)).sum

/-- Total fuel on board. -/
def fuel (d : Design) : Nat := (d.map (fun b => b.kind.fuelUnits)).sum

/-- Total cargo value. -/
def payload (d : Design) : Nat := (d.map (fun b => b.kind.payload)).sum

/-- Total shop price. -/
def price (d : Design) : Nat := (d.map (fun b => b.kind.price)).sum

/-! ### Connectivity -/

/-- Two cells of the grid are neighbours if they share an edge. -/
def adjPos (p q : Nat) : Bool :=
  (p + 1 == q && (p + 1) % gridW != 0) ||
  (q + 1 == p && (q + 1) % gridW != 0) ||
  (p + gridW == q) || (q + gridW == p)

/-- One round of flood fill: everything already reached, plus every occupied cell
next to it. -/
def grow (d : Design) (s : List Nat) : List Nat :=
  s ++ (d.cells.filter (fun p => !s.contains p && s.any (fun q => adjPos q p)))

/-- Flood fill run `n` rounds. -/
def flood (d : Design) : Nat → List Nat
  | 0 => match d with | [] => [] | b :: _ => [b.pos]
  | n + 1 => grow d (flood d n)

/-- Is the rig one connected piece? -/
def connected (d : Design) : Bool :=
  d.cells.all (fun p => (flood d d.length).contains p)

/-! ### Legality -/

/-- The decidable legality test. -/
def wfCheck (d : Design) : Bool :=
  !d.isEmpty && d.length ≤ maxBlocks && d.all Block.inBounds &&
    d.cells.dedup.length == d.length && connected d

/-- A design is **legal** when it is a non-empty, bounded, in-grid, non-overlapping,
connected piece. -/
structure WF (d : Design) : Prop where
  nonempty : d ≠ []
  small : d.length ≤ maxBlocks
  inGrid : ∀ b ∈ d, b.inBounds = true
  nodup : d.cells.Nodup
  conn : connected d = true

theorem cells_length (d : Design) : d.cells.length = d.length := by
  simp [cells]

/-- The de-duplication test is exactly "no two blocks in one cell". -/
theorem dedup_length_iff (d : Design) : d.cells.dedup.length = d.length ↔ d.cells.Nodup := by
  rw [← cells_length d]
  constructor
  · intro hl
    have : d.cells.dedup = d.cells := (List.dedup_sublist d.cells).eq_of_length hl
    exact List.dedup_eq_self.mp this
  · intro hn
    rw [hn.dedup]

theorem wfCheck_iff (d : Design) : wfCheck d = true ↔ WF d := by
  unfold wfCheck
  simp only [Bool.and_eq_true]
  constructor
  · rintro ⟨⟨⟨⟨h1, h2⟩, h3⟩, h4⟩, h5⟩
    refine { nonempty := ?_, small := ?_, inGrid := ?_, nodup := ?_, conn := h5 }
    · simpa using h1
    · simpa using h2
    · simpa using h3
    · exact (dedup_length_iff d).mp (by simpa using h4)
  · intro h
    refine ⟨⟨⟨⟨?_, ?_⟩, ?_⟩, ?_⟩, h.conn⟩
    · simpa using h.nonempty
    · simpa using h.small
    · simpa using h.inGrid
    · simpa using (dedup_length_iff d).mpr h.nodup

instance (d : Design) : Decidable (WF d) :=
  decidable_of_iff _ (wfCheck_iff d)

/-! ### The two editing moves -/

/-- Place a block, if that is legal. -/
def place (d : Design) (b : Block) : Option Design :=
  let d' := b :: d
  if wfCheck d' then some d' else none

/-- Lift the block in a cell off the rig, if what is left is still legal. -/
def remove (d : Design) (p : Nat) : Option Design :=
  let d' := d.filter (fun b => b.pos != p)
  if wfCheck d' then some d' else none

theorem place_eq {d : Design} {b : Block} {d' : Design} (h : place d b = some d') :
    d' = b :: d ∧ wfCheck d' = true := by
  have hp : place d b = if wfCheck (b :: d) = true then some (b :: d) else none := rfl
  rw [hp] at h
  by_cases hc : wfCheck (b :: d) = true
  · rw [if_pos hc] at h
    exact ⟨(Option.some.inj h).symm, by rw [(Option.some.inj h).symm]; exact hc⟩
  · rw [if_neg hc] at h
    exact absurd h (by simp)

theorem remove_eq {d : Design} {p : Nat} {d' : Design} (h : remove d p = some d') :
    d' = d.filter (fun b => b.pos != p) ∧ wfCheck d' = true := by
  have hp : remove d p =
      if wfCheck (d.filter (fun b => b.pos != p)) = true
        then some (d.filter (fun b => b.pos != p)) else none := rfl
  rw [hp] at h
  by_cases hc : wfCheck (d.filter (fun b => b.pos != p)) = true
  · rw [if_pos hc] at h
    exact ⟨(Option.some.inj h).symm, by rw [(Option.some.inj h).symm]; exact hc⟩
  · rw [if_neg hc] at h
    exact absurd h (by simp)

theorem place_wf {d : Design} {b : Block} {d' : Design} (h : place d b = some d') : WF d' :=
  (wfCheck_iff d').mp (place_eq h).2

theorem remove_wf {d : Design} {p : Nat} {d' : Design} (h : remove d p = some d') : WF d' :=
  (wfCheck_iff d').mp (remove_eq h).2

theorem place_length {d : Design} {b : Block} {d' : Design} (h : place d b = some d') :
    d'.length = d.length + 1 := by
  rw [(place_eq h).1]
  simp

theorem remove_length_lt {d : Design} {p : Nat} {d' : Design}
    (h : remove d p = some d') (hp : d.occupied p = true) : d'.length < d.length := by
  obtain ⟨b, hb, hbp⟩ : ∃ b ∈ d, b.pos = p := by
    unfold occupied at hp
    simpa using hp
  rw [(remove_eq h).1]
  refine List.length_filter_lt_length_iff_exists.mpr ⟨b, hb, ?_⟩
  simp [hbp]

end Design

/-! ## Share codes

A design is written as a string over a 64-letter alphabet: one letter for the number
of blocks, two letters per block (cell and kind), one closing checksum letter. -/

/-- The share-code alphabet: 64 URL-safe letters. -/
def alphabet : String :=
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"

/-- Digit `n` of the alphabet. -/
def digit (n : Nat) : Char := (alphabet.toList[n % 64]?).getD 'A'

/-- The value of a letter, if it is one of the 64. -/
def undigit (c : Char) : Option Nat := alphabet.toList.idxOf? c

set_option maxRecDepth 20000 in
theorem undigit_digit_all : ∀ n < 64, undigit (digit n) = some n := by decide

@[simp] theorem undigit_digit {n : Nat} (h : n < 64) : undigit (digit n) = some n :=
  undigit_digit_all n h

theorem digit_injective {m n : Nat} (hm : m < 64) (hn : n < 64) (h : digit m = digit n) :
    m = n := by
  have h1 : undigit (digit m) = some m := undigit_digit hm
  rw [h, undigit_digit hn] at h1
  exact (Option.some.inj h1).symm

/-- The two letters that carry one block: the low six bits of the cell, then the
top two bits of the cell together with the kind. -/
def blockCode (b : Block) : List Char :=
  [digit (b.pos % 64), digit (b.kind.code * 4 + b.pos / 64)]

/-- The checksum letter: everything summed, six bits kept. -/
def checksum (cs : List Char) : Char :=
  digit ((cs.map (fun c => (undigit c).getD 0)).sum % 64)

/-- The share code of a design. -/
def encode (d : Design) : String :=
  let body := digit d.length :: (d.flatMap blockCode)
  String.ofList (body ++ [checksum body])

/-- Read one block back out of two letters. -/
def decodeBlock (c₁ c₂ : Char) : Option Block := do
  let lo ← undigit c₁
  let hi ← undigit c₂
  let k ← Kind.ofCode (hi / 4)
  let p := lo + 64 * (hi % 4)
  pure ⟨p % gridW, p / gridW, k⟩

/-- Read the blocks back out of the body of a code. -/
def decodeBlocks : List Char → Option Design
  | [] => some []
  | [_] => none
  | c₁ :: c₂ :: rest => do
      let b ← decodeBlock c₁ c₂
      let bs ← decodeBlocks rest
      pure (b :: bs)

/-- Read a design back out of a share code.  A code is accepted only when its
checksum matches, its declared block count is right, and the design it spells out
is legal. -/
def decodeParts (c : Char) (rest : List Char) : Option Design :=
  match rest.getLast? with
  | none => none
  | some sum =>
      let body := rest.dropLast
      match undigit c, decodeBlocks body with
      | some n, some d =>
          if checksum (c :: body) = sum && d.length = n && Design.wfCheck d then some d else none
      | _, _ => none

def decode (s : String) : Option Design :=
  match s.toList with
  | [] => none
  | c :: rest => decodeParts c rest

/-! ### The round trip -/

/-- Two letters carry one in-grid block exactly. -/
theorem decodeBlock_blockCode {b : Block} (h : b.inBounds = true) :
    decodeBlock (digit (b.pos % 64)) (digit (b.kind.code * 4 + b.pos / 64)) = some b := by
  have hb : b.x < 16 ∧ b.y < 16 := by
    simpa [Block.inBounds, gridW] using h
  have hpos : b.pos = b.x + 16 * b.y := by simp [Block.pos, gridW]
  have hlt : b.pos < 256 := by omega
  have h1 : b.pos % 64 < 64 := Nat.mod_lt _ (by norm_num)
  have hq : b.pos / 64 < 4 := by omega
  have hc := Kind.code_lt b.kind
  have h2 : b.kind.code * 4 + b.pos / 64 < 64 := by omega
  have hdiv : (b.kind.code * 4 + b.pos / 64) / 4 = b.kind.code := by omega
  have hmod : (b.kind.code * 4 + b.pos / 64) % 4 = b.pos / 64 := by omega
  have hp : b.pos % 64 + 64 * (b.pos / 64) = b.pos := by omega
  have hx : b.pos % gridW = b.x := by rw [hpos]; simp [gridW]; omega
  have hy : b.pos / gridW = b.y := by rw [hpos]; simp [gridW]; omega
  unfold decodeBlock
  rw [undigit_digit h1, undigit_digit h2]
  simp only [Option.pure_def, Option.bind_eq_bind, Option.bind_some, hdiv, hmod, hp,
    Kind.ofCode_code, hx, hy]

/-- The body of a code carries the blocks of an in-grid design exactly. -/
theorem decodeBlocks_flatMap (d : Design) (h : ∀ b ∈ d, b.inBounds = true) :
    decodeBlocks (d.flatMap blockCode) = some d := by
  induction d with
  | nil => rfl
  | cons b t ih =>
      have hb : b.inBounds = true := h b (List.mem_cons_self ..)
      have ht : decodeBlocks (t.flatMap blockCode) = some t :=
        ih (fun x hx => h x (List.mem_cons_of_mem _ hx))
      have : (b :: t).flatMap blockCode =
          digit (b.pos % 64) :: digit (b.kind.code * 4 + b.pos / 64) :: t.flatMap blockCode := by
        simp [List.flatMap_cons, blockCode]
      rw [this]
      show (do
        let b' ← decodeBlock (digit (b.pos % 64)) (digit (b.kind.code * 4 + b.pos / 64))
        let bs ← decodeBlocks (t.flatMap blockCode)
        pure (b' :: bs)) = some (b :: t)
      rw [decodeBlock_blockCode hb, ht]
      rfl

theorem decode_encode {d : Design} (h : Design.WF d) : decode (encode d) = some d := by
  have hlen : d.length < 64 := lt_of_le_of_lt h.small (by norm_num [maxBlocks])
  have hwf : Design.wfCheck d = true := (Design.wfCheck_iff d).mpr h
  have hflat : decodeBlocks (d.flatMap blockCode) = some d := decodeBlocks_flatMap d h.inGrid
  have hs : (encode d).toList =
      digit d.length :: (d.flatMap blockCode ++
        [checksum (digit d.length :: d.flatMap blockCode)]) := by
    rw [encode, String.toList_ofList]
    rfl
  have hstep : decode (encode d) =
      decodeParts (digit d.length) (d.flatMap blockCode ++
        [checksum (digit d.length :: d.flatMap blockCode)]) := by
    unfold decode
    rw [hs]
  rw [hstep]
  unfold decodeParts
  rw [List.getLast?_concat]
  simp only [List.dropLast_concat, undigit_digit hlen, hflat]
  simp [hwf]

theorem decodeParts_wfCheck {c : Char} {rest : List Char} {d : Design}
    (h : decodeParts c rest = some d) : Design.wfCheck d = true := by
  unfold decodeParts at h
  rcases hg : rest.getLast? with _ | sum
  · simp only [hg] at h
    exact absurd h (by simp)
  · rcases hu : undigit c with _ | n
    · simp only [hg, hu] at h
      exact absurd h (by simp)
    · rcases hd : decodeBlocks rest.dropLast with _ | d'
      · simp only [hg, hu, hd] at h
        exact absurd h (by simp)
      · simp only [hg, hu, hd] at h
        split at h
        · rename_i hcond
          rw [← Option.some.inj h]
          simpa using (by simpa using hcond : _ ∧ Design.wfCheck d' = true).2
        · simp at h

theorem decode_wf {s : String} {d : Design} (h : decode s = some d) : Design.WF d := by
  refine (Design.wfCheck_iff d).mp ?_
  unfold decode at h
  match hs : s.toList with
  | [] => rw [hs] at h; exact absurd h (by simp)
  | c :: rest =>
      rw [hs] at h
      exact decodeParts_wfCheck h

theorem encode_injective {a b : Design} (ha : Design.WF a) (hb : Design.WF b)
    (h : encode a = encode b) : a = b := by
  have h1 : decode (encode a) = some a := decode_encode ha
  have h2 : decode (encode b) = some b := decode_encode hb
  rw [h, h2] at h1
  exact (Option.some.inj h1).symm

end Rig
