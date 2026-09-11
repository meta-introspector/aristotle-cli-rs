import RequestProject.Gvcs.TechTree.Ir
import RequestProject.Gvcs.Steampunk.Jacquard

/-!
# Clay tablets: the program medium, and the round trip

§2a replaces the punched card with a pressed clay tablet.  The change is not
cosmetic.  A card is read by *absence* — a hole or no hole, and the needle
falls through or does not.  A tablet is read by *presence*: a stylus rides over
a relief and is lifted or not.  The encoding is a height, not a perforation,
and the model says so: `Relief` is an enum, binary for now (`embossed` or
`flat`), and everything downstream reads it through `Relief.bit`, so a deeper
scale of heights can be added later without disturbing the deck semantics.

* `Tablet` — a grid of reliefs addressed by row and column, with anything off
  the tablet reading flat, which is what an unpressed margin is.
* `stampTablets` — the writer: the deck, encoded to bits, cut into tablets of
  at most eight rows each.
* `readTablets` — the reader: the feeler arm, tracing rows back into cards.
* `tablet_correct` — **the round trip**: a deck whose fields fit the field
  width survives being stamped into clay and read back, unchanged.

The little-endian field codec is the one already proved in
`RequestProject/Steampunk/Jacquard.lean`, so the two media share a number
format and cannot drift apart.

What none of this says: anything about clay, tempering, firing, shrinkage or
mould wear.  Those are physical questions, this layer models no physics, and
the casting variant's "how many tablets before the mould is no good" is exactly
the sort of question to carry forward to physical validation.
-/

namespace LifeTrac
namespace TechTree

open Steampunk (writeNat readNat readNat_writeNat writeNat_length)

/-! ## Relief -/

/-- The height of one cell.  Binary for now; the enum is here so a deeper scale
can be added without changing the reader's interface. -/
inductive Relief where
  /-- Raised: the stylus rides up. -/
  | embossed : Relief
  /-- Flat: the stylus stays down. -/
  | flat : Relief
  deriving DecidableEq, Repr, Inhabited

/-- What the feeler arm reports. -/
def Relief.bit : Relief → Bool
  | .embossed => true
  | .flat => false

/-- What the stamp presses. -/
def Relief.ofBit : Bool → Relief
  | true => .embossed
  | false => .flat

@[simp] theorem Relief.bit_ofBit (b : Bool) : (Relief.ofBit b).bit = b := by
  cases b <;> rfl

/-! ## Tablets -/

/-- A tablet: a grid of reliefs.  Cells outside the grid read flat. -/
structure Tablet where
  /-- Cells across. -/
  width : ℕ
  /-- Rows down. -/
  height : ℕ
  /-- The relief at a row and a column. -/
  cell : ℕ → ℕ → Relief

/-- Read one row of a tablet as bits. -/
def Tablet.row (t : Tablet) (r : ℕ) : List Bool :=
  (List.range t.width).map (fun c => (t.cell r c).bit)

/-- Read a whole tablet, row by row. -/
def Tablet.rows (t : Tablet) : List (List Bool) :=
  (List.range t.height).map t.row

/-! ## Cutting a deck into tablets -/

/-- Cut a list into pieces of at most `n + 1`, with an explicit fuel so the
recursion is structural. -/
def chunksFuel (n : ℕ) : ℕ → List α → List (List α)
  | 0, _ => []
  | _ + 1, [] => []
  | f + 1, a :: rest =>
      (a :: rest).take (n + 1) :: chunksFuel n f ((a :: rest).drop (n + 1))

/-- Cut a list into pieces of at most `n + 1`. -/
def chunks (n : ℕ) (l : List α) : List (List α) := chunksFuel n l.length l

theorem flatten_chunksFuel (n : ℕ) :
    ∀ (f : ℕ) (l : List α), l.length ≤ f → (chunksFuel n f l).flatten = l
  | 0, l, h => by
      have : l = [] := List.eq_nil_of_length_eq_zero (Nat.le_zero.1 h)
      simp [chunksFuel, this]
  | f + 1, [], _ => rfl
  | f + 1, a :: rest, h => by
      have hdrop : ((a :: rest).drop (n + 1)).length ≤ f := by
        simp only [List.length_drop, List.length_cons] at h ⊢
        omega
      rw [chunksFuel, List.flatten_cons,
        flatten_chunksFuel n f ((a :: rest).drop (n + 1)) hdrop, List.take_append_drop]

/-- **Nothing is lost in the cutting.** -/
theorem flatten_chunks (n : ℕ) (l : List α) : (chunks n l).flatten = l :=
  flatten_chunksFuel n l.length l (le_refl _)

theorem mem_chunksFuel (n : ℕ) :
    ∀ (f : ℕ) (l p : List α), p ∈ chunksFuel n f l → ∀ a ∈ p, a ∈ l
  | 0, l, p, hp, a, _ => by simp [chunksFuel] at hp
  | f + 1, [], p, hp, a, _ => by simp [chunksFuel] at hp
  | f + 1, b :: rest, p, hp, a, ha => by
      rw [chunksFuel, List.mem_cons] at hp
      rcases hp with rfl | hp
      · exact List.mem_of_mem_take ha
      · exact List.mem_of_mem_drop
          (mem_chunksFuel n f ((b :: rest).drop (n + 1)) p hp a ha)

/-- Every piece is a piece of the original. -/
theorem mem_chunks (n : ℕ) (l p : List α) (hp : p ∈ chunks n l) (a : α) (ha : a ∈ p) : a ∈ l :=
  mem_chunksFuel n l.length l p hp a ha

/-! ## The bit encoding of a card -/

/-- Cells in a numeric field. -/
def fieldBits : ℕ := 16

/-- Cells across a row: a two-cell tag and two fields. -/
def rowBits : ℕ := 2 + 2 * fieldBits

theorem rowBits_eq : rowBits = 34 := by decide

/-- Rows on one tablet. -/
def tabletRows : ℕ := 8

/-- One card as one row of relief. -/
def encodeCard {n : ℕ} : Card n → List Bool
  | .inp i => [false, false] ++ writeNat fieldBits i.val ++ writeNat fieldBits 0
  | .const b => [false, true] ++ writeNat fieldBits (if b then 1 else 0) ++ writeNat fieldBits 0
  | .nand a b => [true, false] ++ writeNat fieldBits a ++ writeNat fieldBits b

/-- Read one row back as a card. -/
def decodeCard (n : ℕ) (l : List Bool) : Option (Card n) :=
  match l with
  | t₁ :: t₂ :: rest => do
      let (f₁, rest₁) ← readNat fieldBits rest
      let (f₂, _) ← readNat fieldBits rest₁
      match t₁, t₂ with
      | false, false => if h : f₁ < n then some (.inp ⟨f₁, h⟩) else none
      | false, true => some (.const (f₁ == 1))
      | true, false => some (.nand f₁ f₂)
      | true, true => none
  | _ => none

/-- A card fits a row when its fields fit the field width.  Input lines fit
automatically as long as the deck has at most `2 ^ 16` of them. -/
def CardFits (n : ℕ) : Card n → Prop
  | .inp i => i.val < 2 ^ fieldBits
  | .const _ => True
  | .nand a b => a < 2 ^ fieldBits ∧ b < 2 ^ fieldBits

instance (n : ℕ) (c : Card n) : Decidable (CardFits n c) := by
  cases c <;> unfold CardFits <;> infer_instance

@[simp] theorem encodeCard_length {n : ℕ} (c : Card n) : (encodeCard c).length = rowBits := by
  cases c <;> simp [encodeCard, rowBits, fieldBits]

theorem decodeCard_encodeCard {n : ℕ} (c : Card n) (h : CardFits n c) :
    decodeCard n (encodeCard c) = some c := by
  have hzero : (0 : ℕ) < 2 ^ fieldBits := pow_pos (by norm_num) _
  have hz : readNat fieldBits (writeNat fieldBits 0) = some (0, []) := by
    simpa using readNat_writeNat fieldBits 0 [] hzero
  cases c with
  | inp i =>
      have h1 : readNat fieldBits (writeNat fieldBits i.val ++ writeNat fieldBits 0) =
          some (i.val, writeNat fieldBits 0) := readNat_writeNat _ _ _ h
      simp [encodeCard, decodeCard, h1, hz, i.isLt]
  | const b =>
      cases b
      · have h1 : readNat fieldBits (writeNat fieldBits 0 ++ writeNat fieldBits 0) =
            some (0, writeNat fieldBits 0) := readNat_writeNat _ _ _ hzero
        simp [encodeCard, decodeCard, h1, hz]
      · have hone : (1 : ℕ) < 2 ^ fieldBits := by norm_num [fieldBits]
        have h1 : readNat fieldBits (writeNat fieldBits 1 ++ writeNat fieldBits 0) =
            some (1, writeNat fieldBits 0) := readNat_writeNat _ _ _ hone
        simp [encodeCard, decodeCard, h1, hz]
  | nand a b =>
      obtain ⟨ha, hb⟩ := h
      have h1 : readNat fieldBits (writeNat fieldBits a ++ writeNat fieldBits b) =
          some (a, writeNat fieldBits b) := readNat_writeNat _ _ _ ha
      have h2 : readNat fieldBits (writeNat fieldBits b) = some (b, []) := by
        simpa using readNat_writeNat fieldBits b [] hb
      simp [encodeCard, decodeCard, h1, h2]

/-! ## Stamping and reading -/

/-- A list of rows of a given width, as one tablet. -/
def tabletOfW (w : ℕ) (rows : List (List Bool)) : Tablet :=
  { width := w
    height := rows.length
    cell := fun r c => Relief.ofBit ((rows.getD r []).getD c false) }

/-- A list of card rows, as one tablet. -/
def tabletOf (rows : List (List Bool)) : Tablet := tabletOfW rowBits rows

/-- **The writer.**  The deck, encoded to relief, cut into tablets of at most
eight rows. -/
def stampTablets {n : ℕ} (cs : CardSet n) : List Tablet :=
  (chunks (tabletRows - 1) (cs.map encodeCard)).map tabletOf

/-- **The reader.**  The feeler arm traces every row of every tablet in turn. -/
def readTablets (n : ℕ) (ts : List Tablet) : Option (CardSet n) :=
  (ts.flatMap Tablet.rows).mapM (decodeCard n)

theorem map_getD_range {α : Type*} (d : α) (l : List α) :
    (List.range l.length).map (fun i => l.getD i d) = l := by
  apply List.ext_getElem
  · simp
  · intro i h1 h2
    simp [h2]

theorem tabletOfW_rows (w : ℕ) (rows : List (List Bool)) (h : ∀ r ∈ rows, r.length = w) :
    (tabletOfW w rows).rows = rows := by
  unfold tabletOfW Tablet.rows Tablet.row
  simp only [Relief.bit_ofBit]
  have hrow : ∀ i, i < rows.length →
      (List.range w).map (fun c => (rows.getD i []).getD c false) = rows.getD i [] := by
    intro i hi
    have hlen : (rows.getD i []).length = w := by
      rw [List.getD_eq_getElem _ _ hi]
      exact h _ (List.getElem_mem hi)
    rw [← hlen]
    exact map_getD_range false _
  calc (List.range rows.length).map
        (fun r => (List.range w).map (fun c => (rows.getD r []).getD c false))
      = (List.range rows.length).map (fun r => rows.getD r []) := by
        refine List.map_congr_left ?_
        intro i hi
        exact hrow i (List.mem_range.1 hi)
    _ = rows := map_getD_range [] rows

theorem tabletOf_rows (rows : List (List Bool)) (h : ∀ r ∈ rows, r.length = rowBits) :
    (tabletOf rows).rows = rows := tabletOfW_rows rowBits rows h

/-! ## Any rows, stamped and traced -/

/-- Stamp a list of rows of width `w` onto tablets of at most eight rows. -/
def stampRows (w : ℕ) (rows : List (List Bool)) : List Tablet :=
  (chunks (tabletRows - 1) rows).map (tabletOfW w)

/-- Trace every row of every tablet, in order. -/
def readRows (ts : List Tablet) : List (List Bool) := ts.flatMap Tablet.rows

/-- **Rows survive the clay.** -/
theorem readRows_stampRows (w : ℕ) (rows : List (List Bool))
    (h : ∀ r ∈ rows, r.length = w) : readRows (stampRows w rows) = rows := by
  unfold readRows stampRows
  rw [List.flatMap_map]
  calc (chunks (tabletRows - 1) rows).flatMap (fun p => (tabletOfW w p).rows)
      = (chunks (tabletRows - 1) rows).flatMap id := by
        refine List.flatMap_congr ?_
        intro p hp
        have : (tabletOfW w p).rows = p :=
          tabletOfW_rows w p (fun r hr => h r (mem_chunks _ _ p hp r hr))
        simpa using this
    _ = (chunks (tabletRows - 1) rows).flatten := by simp
    _ = rows := flatten_chunks _ _

theorem rows_stampTablets {n : ℕ} (cs : CardSet n) :
    (stampTablets cs).flatMap Tablet.rows = cs.map encodeCard := by
  unfold stampTablets
  rw [List.flatMap_map]
  have hall : ∀ p ∈ chunks (tabletRows - 1) (cs.map encodeCard),
      (tabletOf p).rows = p := by
    intro p hp
    refine tabletOf_rows p ?_
    intro r hr
    have : r ∈ cs.map encodeCard := mem_chunks _ _ p hp r hr
    obtain ⟨c, _, rfl⟩ := List.mem_map.1 this
    exact encodeCard_length c
  calc (chunks (tabletRows - 1) (cs.map encodeCard)).flatMap (fun p => (tabletOf p).rows)
      = (chunks (tabletRows - 1) (cs.map encodeCard)).flatMap id := by
        refine List.flatMap_congr ?_
        intro p hp
        simpa using hall p hp
    _ = (chunks (tabletRows - 1) (cs.map encodeCard)).flatten := by
        simp
    _ = cs.map encodeCard := flatten_chunks _ _

theorem mapM_decodeCard {n : ℕ} :
    ∀ (cs : CardSet n), (∀ c ∈ cs, CardFits n c) →
      (cs.map encodeCard).mapM (decodeCard n) = some cs
  | [], _ => rfl
  | c :: rest, h => by
      have hc := decodeCard_encodeCard c (h c (by simp))
      have hrest := mapM_decodeCard rest (fun d hd => h d (by simp [hd]))
      simp [List.mapM_cons, hc, hrest]

/-- **`tablet_correct`.**  A deck whose fields fit survives being stamped into
clay and traced back off it. -/
theorem tablet_correct {n : ℕ} (cs : CardSet n) (h : ∀ c ∈ cs, CardFits n c) :
    readTablets n (stampTablets cs) = some cs := by
  unfold readTablets
  rw [rows_stampTablets]
  exact mapM_decodeCard cs h

/-- The tablets a deck needs: one per eight cards. -/
theorem stampTablets_length {n : ℕ} (cs : CardSet n) :
    (stampTablets cs).length = (chunks (tabletRows - 1) (cs.map encodeCard)).length := by
  simp [stampTablets]

end TechTree
end LifeTrac
