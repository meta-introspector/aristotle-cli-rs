import Mathlib

/-!
# The holographic knowledge archive: cells, byte offsets, range requests

One static file on a dumb host, and a knowledge base with random access.  The
corpus is cut into **cells**, one per major concept.  A cell carries its own
supporting material, is independently decodable, and names its neighbours by
concept rather than copying them, so the same fact is stored once.  Laying the
cells out end to end turns the concept index into a table of byte offsets: to
read a concept you issue one HTTP `Range` request for its interval and decode
what comes back, without touching the rest of the file.

* `Cell` — a concept key, the payload of supporting facts, the outbound links.
* `Cell.encode` / `decodeCell` — the self-contained wire form.  `decodeCell` on
  *any* suffix of the archive beginning at a cell's offset returns exactly that
  cell and the remaining bytes (`decodeCell_encode`), which is what makes a
  partial fetch legal: the reader never needs bytes it did not ask for.
* `Archive.offset` / `Archive.bytes` — the layout.  `Archive.range_fetch` says
  the byte interval `[offset i, offset i + size i)` *is* the cell's wire form,
  `Archive.fetch_at_offset` that seeking to the offset and decoding returns the
  cell, and `Archive.intervals_disjoint` that distinct cells never share a byte.
* `Archive.seek` — the index: a concept key in, an offset and a length out
  (`seek_fetch`).  Following a link is therefore one more range request
  (`follow_link`).
* `Archive.duplication` — the overlap the partition is supposed to minimise;
  it is zero exactly when no fact is stored twice (`duplication_eq_zero_iff`).
* `Archive.view` — what a client that has loaded a set of cells can see.  It
  only grows as more cells are loaded (`view_mono`), each new cell strictly
  increases it (`view_length_cons`), and loading everything reconstructs the
  corpus exactly (`view_all`).
-/

set_option maxRecDepth 10000

namespace NixWars
namespace Holo

/-- A **holographic knowledge block**: a canonical concept key, all the
supporting material held for that concept, and compact references to the
neighbouring cells.  Facts and keys are numbers here; the labels live in the
presentation layer. -/
structure Cell where
  /-- The canonical concept this cell is centred on. -/
  key : Nat
  /-- The supporting material held for the concept: entities, claims,
  definitions, derived data, all as fact identifiers. -/
  payload : List Nat
  /-- The keys of the neighbouring cells: references, not copies. -/
  links : List Nat
deriving DecidableEq, Repr, Inhabited

namespace Cell

/-- The wire form of a cell: the key, then the payload with its length in
front, then the links with their length in front.  Length prefixes are what
make the block independently decodable — a reader that starts at the first byte
of a cell knows where the cell ends without consulting anything else. -/
def encode (c : Cell) : List Nat :=
  c.key :: c.payload.length :: (c.payload ++ (c.links.length :: c.links))

/-- The compressed length of the cell, `ℓ_i`. -/
def size (c : Cell) : Nat := c.encode.length

@[simp] theorem size_eq (c : Cell) : c.size = c.payload.length + c.links.length + 3 := by
  simp [size, encode]
  omega

theorem size_pos (c : Cell) : 0 < c.size := by simp

end Cell

/-- Read one cell off the front of a byte stream, returning it and the bytes
that follow.  Nothing outside the stream is consulted. -/
def decodeCell (bs : List Nat) : Option (Cell × List Nat) :=
  match bs with
  | k :: n :: rest =>
    if rest.length < n then none
    else
      match rest.drop n with
      | [] => none
      | m :: rest₂ =>
        if rest₂.length < m then none
        else some (⟨k, rest.take n, rest₂.take m⟩, rest₂.drop m)
  | _ => none

/-- **A cell is self-contained.**  Decoding the bytes at a cell's offset returns
that cell and stops exactly at its end, whatever follows it in the file. -/
@[simp] theorem decodeCell_encode (c : Cell) (rest : List Nat) :
    decodeCell (c.encode ++ rest) = some (c, rest) := by
  cases c with
  | mk k payload links =>
    simp only [Cell.encode, decodeCell, List.cons_append, List.append_assoc]
    rw [if_neg (by simp)]
    rw [List.drop_append_of_le_length (le_refl _)]
    simp

/-- An archive is a sequence of cells laid out end to end. -/
abbrev Archive := List Cell

namespace Archive

/-- The bytes of the whole archive. -/
def bytes (A : Archive) : List Nat := (A.map Cell.encode).flatten

/-- The byte offset `o_i` at which cell `i` begins. -/
def offset (A : Archive) (i : Nat) : Nat := ((A.take i).map Cell.size).sum

@[simp] theorem offset_zero (A : Archive) : A.offset 0 = 0 := by simp [offset]

private theorem sum_take_succ (l : List Nat) (i : Nat) (h : i < l.length) :
    (l.take (i + 1)).sum = (l.take i).sum + l[i] := by
  rw [List.take_add_one, List.getElem?_eq_getElem h, List.sum_append]
  simp

private theorem sum_take_mono (l : List Nat) {i j : Nat} (h : i ≤ j) :
    (l.take i).sum ≤ (l.take j).sum :=
  (List.take_sublist_take_left h).sum_le_sum (by intro a _; omega)

theorem offset_succ (A : Archive) (i : Nat) (h : i < A.length) :
    A.offset (i + 1) = A.offset i + (A[i]'h).size := by
  unfold offset
  have := sum_take_succ (A.map Cell.size) i (by simpa using h)
  simpa using this

theorem offset_mono (A : Archive) {i j : Nat} (h : i ≤ j) : A.offset i ≤ A.offset j := by
  unfold offset
  simpa using sum_take_mono (A.map Cell.size) h

theorem length_bytes (A : Archive) : A.bytes.length = A.offset A.length := by
  unfold bytes offset
  simp only [List.length_flatten, List.take_length, List.map_map]
  rfl

/-- Splitting the file at cell `i`: what comes before, the cell, what comes
after. -/
theorem bytes_split (A : Archive) (i : Nat) (h : i < A.length) :
    A.bytes = ((A.take i).map Cell.encode).flatten ++
      ((A[i]'h).encode ++ ((A.drop (i + 1)).map Cell.encode).flatten) := by
  conv_lhs => rw [bytes, ← List.take_append_drop i A]
  rw [List.drop_eq_getElem_cons h, List.map_append, List.flatten_append, List.map_cons,
    List.flatten_cons]

theorem length_prefix (A : Archive) (i : Nat) :
    (((A.take i).map Cell.encode).flatten).length = A.offset i := by
  unfold offset Cell.size
  simp [List.length_flatten, Function.comp_def]

/-- Seeking to an offset puts the reader at the first byte of a cell, with the
rest of the file behind it. -/
theorem bytes_drop (A : Archive) (i : Nat) :
    A.bytes.drop (A.offset i) = ((A.drop i).map Cell.encode).flatten := by
  have hsplit : A.bytes =
      ((A.take i).map Cell.encode).flatten ++ ((A.drop i).map Cell.encode).flatten := by
    rw [← List.flatten_append, ← List.map_append, List.take_append_drop]
    rfl
  rw [hsplit, ← length_prefix A i, List.drop_left]

/-- Seeking to the offset of cell `i` puts the reader at the first byte of that
cell. -/
theorem bytes_drop_offset (A : Archive) (i : Nat) (h : i < A.length) :
    A.bytes.drop (A.offset i) = (A[i]'h).encode ++ ((A.drop (i + 1)).map Cell.encode).flatten := by
  rw [bytes_split A i h, ← length_prefix A i, List.drop_left]

/-- The bytes of a run of `n` cells starting at `i`. -/
theorem offset_add (A : Archive) (i n : Nat) :
    A.offset (i + n) = A.offset i + ((((A.drop i).take n)).map Cell.size).sum := by
  unfold offset
  rw [List.take_add, List.map_append, List.sum_append]

/-- **The offset is a retrieval coordinate.**  Seeking to `o_i` and reading
`ℓ_i` bytes returns exactly the wire form of cell `i`. -/
theorem range_fetch (A : Archive) (i : Nat) (h : i < A.length) :
    (A.bytes.drop (A.offset i)).take (A[i]'h).size = (A[i]'h).encode := by
  rw [bytes_drop_offset A i h, Cell.size, List.take_left]

/-- **A single seek is enough.**  A client that opens the file at the cell's
offset and decodes gets that cell back, with no knowledge of the rest. -/
theorem fetch_at_offset (A : Archive) (i : Nat) (h : i < A.length) :
    decodeCell (A.bytes.drop (A.offset i)) =
      some (A[i]'h, ((A.drop (i + 1)).map Cell.encode).flatten) := by
  rw [bytes_drop_offset A i h]
  exact decodeCell_encode _ _

/-- Distinct cells occupy disjoint byte intervals: the file wastes nothing and
overlaps nothing. -/
theorem intervals_disjoint (A : Archive) {i j : Nat} (hij : i < j) (hj : j < A.length) :
    A.offset i + (A[i]'(lt_trans hij hj)).size ≤ A.offset j := by
  have := offset_succ A i (lt_trans hij hj)
  have hmono := offset_mono A (show i + 1 ≤ j by omega)
  omega

/-! ## The index: concept keys to byte ranges -/

/-- The position of the cell holding a concept, if the archive has one. -/
def find (A : Archive) (k : Nat) : Option Nat := A.findIdx? (fun c => c.key = k)

/-- The index of the archive: for a concept key, the byte offset and the
compressed length of its cell — everything a range request needs. -/
def seek (A : Archive) (k : Nat) : Option (Nat × Nat) :=
  (A.find k).bind fun i =>
    if hi : i < A.length then some (A.offset i, (A[i]'hi).size) else none

theorem find_spec {A : Archive} {k i : Nat} (h : A.find k = some i) :
    ∃ hi : i < A.length, (A[i]'hi).key = k := by
  unfold find at h
  have hi : i < A.length := List.findIdx?_eq_some_iff_getElem.mp h |>.1
  refine ⟨hi, ?_⟩
  have := (List.findIdx?_eq_some_iff_getElem.mp h).2.1
  simpa using this

/-- **Looking a concept up and fetching its range returns its cell.** -/
theorem seek_fetch (A : Archive) (k o l : Nat) (h : A.seek k = some (o, l)) :
    ∃ (i : Nat) (hi : i < A.length),
      (A[i]'hi).key = k ∧ o = A.offset i ∧ l = (A[i]'hi).size ∧
      decodeCell (A.bytes.drop o) = some (A[i]'hi, ((A.drop (i + 1)).map Cell.encode).flatten) := by
  unfold seek at h
  rw [Option.bind_eq_some_iff] at h
  obtain ⟨i, hf, h⟩ := h
  obtain ⟨hi, hkey⟩ := find_spec hf
  rw [dif_pos hi, Option.some_inj] at h
  cases h
  exact ⟨i, hi, hkey, rfl, rfl, fetch_at_offset A i hi⟩

/-- Every outbound reference points at a cell the archive actually holds. -/
def LinksClosed (A : Archive) : Prop :=
  ∀ c ∈ A, ∀ k ∈ c.links, ∃ d ∈ A, d.key = k

instance (A : Archive) : Decidable (LinksClosed A) :=
  inferInstanceAs (Decidable (∀ c ∈ A, ∀ k ∈ c.links, ∃ d ∈ A, d.key = k))

/-- **Following a link is one more range request.**  In a link-closed archive
every reference resolves to an offset and a length. -/
theorem follow_link {A : Archive} (hA : LinksClosed A) {c : Cell} (hc : c ∈ A)
    {k : Nat} (hk : k ∈ c.links) : (A.seek k).isSome := by
  obtain ⟨d, hd, hdk⟩ := hA c hc k hk
  have hfind : (A.find k).isSome := by
    unfold find
    rw [List.findIdx?_isSome, List.any_eq_true]
    exact ⟨d, hd, by simp [hdk]⟩
  obtain ⟨i, hi⟩ := Option.isSome_iff_exists.mp hfind
  obtain ⟨hlt, _⟩ := find_spec hi
  simp [seek, hi, hlt]

/-! ## Overlap -/

/-- Every fact the archive holds, with multiplicity. -/
def facts (A : Archive) : List Nat := A.flatMap Cell.payload

/-- The bytes the partition wastes on duplicated facts. -/
def duplication (A : Archive) : Nat := A.facts.length - A.facts.dedup.length

/-- **Overlap is zero exactly when nothing is stored twice.** -/
theorem duplication_eq_zero_iff (A : Archive) : A.duplication = 0 ↔ A.facts.Nodup := by
  constructor
  · intro h
    have hsub : List.Sublist A.facts.dedup A.facts := A.facts.dedup_sublist
    have hlen : A.facts.dedup.length = A.facts.length := by
      have := hsub.length_le
      unfold duplication at h
      omega
    have : A.facts.dedup = A.facts := hsub.eq_of_length hlen
    exact this ▸ A.facts.nodup_dedup
  · intro h
    unfold duplication
    rw [List.Nodup.dedup h]
    omega

/-! ## What a client can see -/

/-- The view of a client holding the cells whose keys are in `S`: the union of
their payloads. -/
def view (A : Archive) (S : List Nat) : List Nat :=
  (A.filter (fun c => c.key ∈ S)).flatMap Cell.payload

/-- **More cells never means less view.** -/
theorem view_mono (A : Archive) {S T : List Nat} (h : S ⊆ T) : A.view S ⊆ A.view T := by
  intro x hx
  simp only [view, List.mem_flatMap, List.mem_filter, decide_eq_true_eq] at hx ⊢
  obtain ⟨c, ⟨hc, hkey⟩, hx⟩ := hx
  exact ⟨c, ⟨hc, h hkey⟩, hx⟩

/-- Loading one more cell adds exactly its payload, when the keys are distinct:
the view grows by the size of the block fetched, no more and no less. -/
theorem view_length_cons (A : Archive) (S : List Nat) {c : Cell}
    (hkeys : (A.map Cell.key).Nodup) (hc : c ∈ A) (hS : c.key ∉ S) :
    (A.view (c.key :: S)).length = (A.view S).length + c.payload.length := by
  induction A with
  | nil => cases hc
  | cons a t ih =>
    simp only [List.map_cons, List.nodup_cons, List.mem_map] at hkeys
    obtain ⟨hnot, htail⟩ := hkeys
    simp only [view] at ih ⊢
    rcases List.mem_cons.mp hc with rfl | hct
    · have hfilter : (t.filter (fun d => d.key ∈ c.key :: S)) =
          (t.filter (fun d => d.key ∈ S)) := by
        apply List.filter_congr
        intro d hd
        have : d.key ≠ c.key := fun h => hnot ⟨d, hd, h⟩
        simp [List.mem_cons, this]
      simp only [List.filter_cons]
      rw [if_pos (by simp), if_neg (by simpa using hS), hfilter]
      simp [Nat.add_comm]
    · have hane : a.key ≠ c.key := fun h => hnot ⟨c, hct, h.symm⟩
      simp only [List.filter_cons]
      by_cases ha : a.key ∈ S
      · rw [if_pos (by simp [ha]), if_pos (by simpa using ha)]
        simp only [List.flatMap_cons, List.length_append]
        rw [ih htail hct]
        omega
      · rw [if_neg (by simp [ha, hane]), if_neg (by simpa using ha)]
        exact ih htail hct

/-- **Every new cell strictly raises the resolution** of the client's view, as
long as it carries anything at all. -/
theorem view_length_lt (A : Archive) (S : List Nat) {c : Cell}
    (hkeys : (A.map Cell.key).Nodup) (hc : c ∈ A) (hS : c.key ∉ S)
    (hne : c.payload ≠ []) :
    (A.view S).length < (A.view (c.key :: S)).length := by
  rw [view_length_cons A S hkeys hc hS]
  have : 0 < c.payload.length := List.length_pos_iff.mpr hne
  omega

/-- **Loading every cell reconstructs the corpus exactly.** -/
theorem view_all (A : Archive) : A.view (A.map Cell.key) = A.facts := by
  unfold view facts
  congr 1
  apply List.filter_eq_self.mpr
  intro c hc
  simp [List.mem_map]
  exact ⟨c, hc, rfl⟩

end Archive
end Holo
end NixWars
