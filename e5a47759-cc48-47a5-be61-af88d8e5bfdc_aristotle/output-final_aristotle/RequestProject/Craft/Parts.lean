import RequestProject.Craft.SelfCopying

/-!
# Boxes of parts, assembly, and fabrication

The deck model in `RequestProject/SelfCopying.lean` says *which machines* exist and
in what order they are fired.  It says nothing about what a machine is physically
made of.  This file adds that layer:

* a **part** is an atomic component (a fired plate, a lever arm, a pipe segment …);
* a **box** is a bin holding `count` copies of one part — the crates you see on the
  workshop floor;
* a **stock** is what is on hand, counted part by part;
* **assembly** consumes exactly the bill of materials of a machine out of stock;
* **fabrication** is the machine's own output: it makes parts, one per cycle.

The point of the file is the accounting: assembly neither creates nor destroys a
part (`assemble_conserves`, `assembleDeck_conserves`), it succeeds exactly when the
stock covers the bill (`assemble_isSome_iff`), and a machine that fabricates its own
bill of materials can be assembled from that output with **nothing left over**
(`assembleDeck_exact`).  That last statement is what makes the replication in
`RequestProject/Replicator.lean` a closed loop rather than a claim.
-/

namespace Replicate

open SelfCopy

/-! ## §1  Parts -/

/-- An atomic component.  The first six belong to the fired-clay backend, the last
six to the pipe backend. -/
inductive Part
  | clayBrick | firedPlate | leverArm | stoneWeight | matrixBed | reedPin
  | pipeSegment | elbow | valveBody | filterMesh | pumpRotor | flange
deriving DecidableEq, Repr

namespace Part

/-- Every part, in display order.  `mem_allParts` says the list really is complete. -/
def all : List Part :=
  [clayBrick, firedPlate, leverArm, stoneWeight, matrixBed, reedPin,
   pipeSegment, elbow, valveBody, filterMesh, pumpRotor, flange]

theorem mem_all (p : Part) : p ∈ all := by cases p <;> decide

/-- The name stencilled on the box. -/
def name : Part → String
  | clayBrick   => "clay brick"
  | firedPlate  => "fired plate"
  | leverArm    => "lever arm"
  | stoneWeight => "stone weight"
  | matrixBed   => "matrix bed"
  | reedPin     => "reed pin"
  | pipeSegment => "pipe segment"
  | elbow       => "elbow"
  | valveBody   => "valve body"
  | filterMesh  => "filter mesh"
  | pumpRotor   => "pump rotor"
  | flange      => "flange"

/-- A single glyph, for the ASCII elevations. -/
def glyph : Part → Char
  | clayBrick   => '#'
  | firedPlate  => '='
  | leverArm    => '/'
  | stoneWeight => 'O'
  | matrixBed   => 'M'
  | reedPin     => 'i'
  | pipeSegment => '='
  | elbow       => 'L'
  | valveBody   => 'V'
  | filterMesh  => '%'
  | pumpRotor   => '@'
  | flange      => 'o'

end Part

/-- A **box**: a bin of `count` identical parts. -/
structure Box where
  part  : Part
  count : Nat
deriving DecidableEq, Repr

/-- What is on hand, counted part by part. -/
def Stock := Part → Nat

namespace Stock

/-- Nothing on hand. -/
def empty : Stock := fun _ => 0

/-- Pointwise sum of two stocks. -/
def add (s t : Stock) : Stock := fun p => s p + t p

/-- Pointwise truncated difference. -/
def sub (s t : Stock) : Stock := fun p => s p - t p

/-- The total number of individual parts on hand. -/
def total (s : Stock) : Nat := (Part.all.map s).foldr (· + ·) 0

/-- `s` covers `t`: every part `t` asks for is on hand. -/
def covers (s t : Stock) : Bool := Part.all.all (fun p => decide (t p ≤ s p))

theorem covers_iff (s t : Stock) : covers s t = true ↔ ∀ p, t p ≤ s p := by
  constructor
  · intro h p
    have := List.all_eq_true.mp h p (Part.mem_all p)
    simpa using this
  · intro h
    refine List.all_eq_true.mpr ?_
    intro p _
    simpa using h p

@[simp] theorem empty_apply (p : Part) : empty p = 0 := rfl
@[simp] theorem add_apply (s t : Stock) (p : Part) : add s t p = s p + t p := rfl
@[simp] theorem sub_apply (s t : Stock) (p : Part) : sub s t p = s p - t p := rfl

/-- Extensional equality of stocks, decidable because there are finitely many parts. -/
def eqOn (s t : Stock) : Bool := Part.all.all (fun p => decide (s p = t p))

theorem eqOn_iff (s t : Stock) : eqOn s t = true ↔ ∀ p, s p = t p := by
  constructor
  · intro h p
    have := List.all_eq_true.mp h p (Part.mem_all p)
    simpa using this
  · intro h
    refine List.all_eq_true.mpr ?_
    intro p _
    simpa using h p

end Stock

/-- Read a pile of boxes as a stock. -/
def stockOfBoxes (bs : List Box) : Stock :=
  fun p => (bs.map (fun b => if b.part = p then b.count else 0)).foldr (· + ·) 0

@[simp] theorem stockOfBoxes_nil (p : Part) : stockOfBoxes [] p = 0 := rfl

@[simp] theorem stockOfBoxes_cons (b : Box) (bs : List Box) (p : Part) :
    stockOfBoxes (b :: bs) p = (if b.part = p then b.count else 0) + stockOfBoxes bs p := rfl

theorem stockOfBoxes_append (bs cs : List Box) (p : Part) :
    stockOfBoxes (bs ++ cs) p = stockOfBoxes bs p + stockOfBoxes cs p := by
  induction bs with
  | nil => simp
  | cons b bs ih => simp [ih, Nat.add_assoc]

/-- Present a stock as the boxes standing on the floor: one box per part that is
actually present, in `Part.all` order.  This is the inverse of `stockOfBoxes` up to
the empty boxes it drops (`stockOfBoxes_boxesOf`). -/
def boxesOf (s : Stock) : List Box :=
  Part.all.filterMap (fun p => if s p = 0 then none else some ⟨p, s p⟩)

private theorem stockOfBoxes_filterMap_not_mem (s : Stock) :
    ∀ (l : List Part) (p : Part), p ∉ l →
      stockOfBoxes (l.filterMap (fun q => if s q = 0 then none else some ⟨q, s q⟩)) p = 0 := by
  intro l
  induction l with
  | nil => intro p _; rfl
  | cons q l ih =>
      intro p hp
      have hne : q ≠ p := fun h => hp (by simp [h])
      have hnot : p ∉ l := fun h => hp (by simp [h])
      by_cases hz : s q = 0 <;> simp [hz, hne, ih p hnot]

private theorem stockOfBoxes_filterMap_mem (s : Stock) :
    ∀ (l : List Part) (p : Part), p ∈ l → l.Nodup →
      stockOfBoxes (l.filterMap (fun q => if s q = 0 then none else some ⟨q, s q⟩)) p = s p := by
  intro l
  induction l with
  | nil => intro p hp; simp at hp
  | cons q l ih =>
      intro p hp hnd
      rcases List.mem_cons.mp hp with rfl | hmem
      · have hnot : p ∉ l := (List.nodup_cons.mp hnd).1
        by_cases hz : s p = 0 <;>
          simp [hz, stockOfBoxes_filterMap_not_mem s l p hnot]
      · have hnd' := (List.nodup_cons.mp hnd).2
        by_cases hq : q = p
        · exact absurd (hq ▸ hmem) (List.nodup_cons.mp hnd).1
        · by_cases hz : s q = 0 <;>
            simp [hz, hq, ih p hmem hnd']

theorem Part.all_nodup : Part.all.Nodup := by decide

/-- Turning a stock into boxes and reading the boxes back gives the stock again. -/
theorem stockOfBoxes_boxesOf (s : Stock) (p : Part) : stockOfBoxes (boxesOf s) p = s p :=
  stockOfBoxes_filterMap_mem s Part.all p (Part.mem_all p) Part.all_nodup

/-! ## §2  Bills of materials -/

/-- The bill of materials of one machine, as the boxes of parts it takes.  This is
the crate list you see laid out before assembly. -/
def partsOf (c : Card) : List Box :=
  match c.name with
  | "clay tablet press" =>
      [⟨.clayBrick, 6⟩, ⟨.firedPlate, 2⟩, ⟨.leverArm, 1⟩,
       ⟨.stoneWeight, 1⟩, ⟨.matrixBed, 1⟩, ⟨.reedPin, 4⟩]
  | "kiln"        => [⟨.clayBrick, 8⟩, ⟨.firedPlate, 1⟩]
  | "reed stylus" => [⟨.reedPin, 2⟩]
  | "tablet press" =>
      [⟨.clayBrick, 3⟩, ⟨.leverArm, 1⟩, ⟨.stoneWeight, 1⟩, ⟨.matrixBed, 1⟩]
  | "pipe tablet press" =>
      [⟨.pipeSegment, 6⟩, ⟨.elbow, 4⟩, ⟨.valveBody, 2⟩,
       ⟨.filterMesh, 1⟩, ⟨.pumpRotor, 1⟩, ⟨.flange, 3⟩]
  | "pipe furnace"  => [⟨.pipeSegment, 2⟩, ⟨.flange, 2⟩, ⟨.valveBody, 1⟩]
  | "pipe extruder" => [⟨.pipeSegment, 3⟩, ⟨.elbow, 2⟩, ⟨.pumpRotor, 1⟩]
  | _ => []

/-- The bill of materials of one machine, as a stock. -/
def bomOf (c : Card) : Stock := stockOfBoxes (partsOf c)

/-- The bill of materials of a whole deck: every part of every machine on it. -/
def deckBOM (cs : CardSet) : Stock :=
  fun p => (cs.map (fun c => bomOf c p)).foldr (· + ·) 0

@[simp] theorem deckBOM_nil (p : Part) : deckBOM [] p = 0 := rfl

@[simp] theorem deckBOM_cons (c : Card) (cs : CardSet) (p : Part) :
    deckBOM (c :: cs) p = bomOf c p + deckBOM cs p := rfl

/-- All the boxes of parts a deck calls for, in one crate list. -/
def deckBoxes (cs : CardSet) : List Box := boxesOf (deckBOM cs)

/-! ## §3  Assembly -/

/-- **Assemble one machine** out of stock: if the stock covers its bill of
materials, the machine is built and exactly that bill is consumed; otherwise
assembly is refused. -/
def assemble (s : Stock) (c : Card) : Option Stock :=
  if Stock.covers s (bomOf c) then some (Stock.sub s (bomOf c)) else none

/-- **Assembly consumes exactly the bill.**  Nothing is created, nothing vanishes:
what is left plus what went into the machine is what you started with. -/
theorem assemble_conserves {s s' : Stock} {c : Card} (h : assemble s c = some s') :
    ∀ p, s' p + bomOf c p = s p := by
  unfold assemble at h
  split at h
  · rename_i hc
    have hcov := (Stock.covers_iff s (bomOf c)).mp hc
    have : s' = Stock.sub s (bomOf c) := by injection h with h; exact h.symm
    subst this
    intro p
    have := hcov p
    simp [Stock.sub]
    omega
  · exact absurd h (by simp)

/-- Assembly succeeds precisely when the stock covers the bill. -/
theorem assemble_isSome_iff (s : Stock) (c : Card) :
    (assemble s c).isSome = true ↔ ∀ p, bomOf c p ≤ s p := by
  unfold assemble
  by_cases h : Stock.covers s (bomOf c) = true
  · simp [h, (Stock.covers_iff s (bomOf c)).mp h]
  · simp only [Bool.not_eq_true] at h
    simp only [h, Bool.false_eq_true, if_false, Option.isSome_none, false_iff]
    intro hall
    exact absurd ((Stock.covers_iff s (bomOf c)).mpr hall) (by simp [h])

/-- **Assemble a whole deck**, machine by machine, in deck order. -/
def assembleDeck (s : Stock) : CardSet → Option Stock
  | [] => some s
  | c :: rest => match assemble s c with
      | none => none
      | some s' => assembleDeck s' rest

/-- **A whole build consumes exactly the deck's bill of materials.** -/
theorem assembleDeck_conserves :
    ∀ (cs : CardSet) (s s' : Stock), assembleDeck s cs = some s' →
      ∀ p, s' p + deckBOM cs p = s p := by
  intro cs
  induction cs with
  | nil =>
      intro s s' h p
      simp [assembleDeck] at h
      subst h
      simp
  | cons c rest ih =>
      intro s s' h p
      unfold assembleDeck at h
      cases hc : assemble s c with
      | none => rw [hc] at h; exact absurd h (by simp)
      | some s1 =>
          rw [hc] at h
          have h1 := assemble_conserves hc p
          have h2 := ih s1 s' h p
          simp only [deckBOM_cons]
          omega

/-- Assembling a deck out of a stock that covers its bill leaves the stock minus the
bill; in particular assembling out of *exactly* the bill leaves nothing. -/
theorem assembleDeck_of_covers :
    ∀ (cs : CardSet) (s : Stock), (∀ p, deckBOM cs p ≤ s p) →
      ∃ s', assembleDeck s cs = some s' ∧ ∀ p, s' p + deckBOM cs p = s p := by
  intro cs
  induction cs with
  | nil => intro s _; exact ⟨s, rfl, by simp⟩
  | cons c rest ih =>
      intro s hcov
      have hc : (assemble s c).isSome = true := by
        refine (assemble_isSome_iff s c).mpr ?_
        intro p
        have := hcov p
        simp only [deckBOM_cons] at this
        omega
      obtain ⟨s1, hs1⟩ := Option.isSome_iff_exists.mp hc
      have hcons := assemble_conserves hs1
      have hcov1 : ∀ p, deckBOM rest p ≤ s1 p := by
        intro p
        have h1 := hcons p
        have h2 := hcov p
        simp only [deckBOM_cons] at h2
        omega
      obtain ⟨s', hs', hbal⟩ := ih s1 hcov1
      refine ⟨s', ?_, ?_⟩
      · unfold assembleDeck; rw [hs1]; exact hs'
      · intro p
        have h1 := hcons p
        have h2 := hbal p
        simp only [deckBOM_cons]
        omega

/-- **Exact build.**  Fabricate precisely the deck's bill of materials and the whole
deck assembles out of it with nothing left over: no shortage, no surplus. -/
theorem assembleDeck_exact (cs : CardSet) :
    ∃ s', assembleDeck (deckBOM cs) cs = some s' ∧ ∀ p, s' p = 0 := by
  obtain ⟨s', hs', hbal⟩ := assembleDeck_of_covers cs (deckBOM cs) (fun _ => Nat.le_refl _)
  exact ⟨s', hs', fun p => by have := hbal p; omega⟩

/-! ## §4  Fabrication

The machine's own output.  A fabricator turns bootstrap raw material into parts,
one part per cycle, in a fixed order; `fabricate n want` is the stock it has made
after `n` cycles when the order it was given is `want`. -/

/-- The parts a crate list contains, expanded one by one into the order they come
off the machine. -/
def partSeq (bs : List Box) : List Part :=
  bs.flatMap (fun b => List.replicate b.count b.part)

/-- The parts a whole deck calls for, in fabrication order. -/
def deckPartSeq (cs : CardSet) : List Part := cs.flatMap (fun c => partSeq (partsOf c))

/-- How many `p`s a run of parts contains. -/
def countPart (l : List Part) (p : Part) : Nat := (l.filter (fun q => q = p)).length

@[simp] theorem countPart_nil (p : Part) : countPart [] p = 0 := rfl

theorem countPart_append (l l' : List Part) (p : Part) :
    countPart (l ++ l') p = countPart l p + countPart l' p := by
  simp [countPart, List.filter_append]

theorem countPart_replicate (n : Nat) (q p : Part) :
    countPart (List.replicate n q) p = if q = p then n else 0 := by
  induction n with
  | zero => simp [countPart]
  | succ n ih =>
      by_cases h : q = p <;>
        simp [countPart, List.replicate_succ, h] at ih ⊢ <;>
        omega

/-- Reading the fabrication order back as a stock gives the crate list again. -/
theorem countPart_partSeq (bs : List Box) (p : Part) :
    countPart (partSeq bs) p = stockOfBoxes bs p := by
  induction bs with
  | nil => rfl
  | cons b bs ih =>
      simp only [partSeq, List.flatMap_cons] at *
      rw [countPart_append, ih, countPart_replicate]
      simp [stockOfBoxes_cons]

/-- The same, for a whole deck. -/
theorem countPart_deckPartSeq (cs : CardSet) (p : Part) :
    countPart (deckPartSeq cs) p = deckBOM cs p := by
  induction cs with
  | nil => rfl
  | cons c cs ih =>
      simp only [deckPartSeq, List.flatMap_cons] at *
      rw [countPart_append, ih, countPart_partSeq]
      rfl

/-- The stock made by the first `n` cycles of a fabrication run. -/
def fabricate (order : List Part) (n : Nat) : Stock :=
  fun p => countPart (order.take n) p

@[simp] theorem fabricate_zero (order : List Part) (p : Part) : fabricate order 0 p = 0 := rfl

/-- **One cycle makes exactly one part** — the part next in the order, and no other. -/
theorem fabricate_succ (order : List Part) (n : Nat) (p : Part) :
    fabricate order (n + 1) p =
      fabricate order n p + (if order[n]? = some p then 1 else 0) := by
  unfold fabricate
  rw [List.take_add_one, countPart_append]
  congr 1
  cases h : order[n]? with
  | none => simp [countPart]
  | some q =>
      by_cases hq : q = p <;> simp [countPart, hq]

/-- After a full run the fabricator has made exactly the parts it was asked for. -/
theorem fabricate_full (bs : List Box) (p : Part) :
    fabricate (partSeq bs) (partSeq bs).length p = stockOfBoxes bs p := by
  unfold fabricate
  rw [List.take_length, countPart_partSeq]

/-- **The machine makes its own bill of materials.**  A full fabrication run on the
deck's parts order produces exactly the deck's bill of materials. -/
theorem fabricate_deck (cs : CardSet) (p : Part) :
    fabricate (deckPartSeq cs) (deckPartSeq cs).length p = deckBOM cs p := by
  unfold fabricate
  rw [List.take_length, countPart_deckPartSeq]

end Replicate
