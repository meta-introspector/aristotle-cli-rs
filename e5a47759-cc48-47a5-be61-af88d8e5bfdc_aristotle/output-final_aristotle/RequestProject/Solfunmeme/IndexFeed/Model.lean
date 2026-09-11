import Mathlib

/-!
# A model of the tantivy index feed

The index over the corpus arrives as a sequence of `aristotle-index-chunk/1`
messages (`data/index/chunk.schema.json`).  Each message carries

* a sequence number `seq`,
* the documents it indexes, each an id and a path,
* the postings over them, each a term and the id of a document containing it.

This file models a chunk and the index obtained by ingesting a feed of chunks,
and proves the general facts used in `RequestProject/IndexFeed/Facts.lean`
about the feed that was actually received.  Nothing here mentions the received
data: that lives in the generated `Data.lean`.
-/

namespace Solfunmeme.IndexFeed

/-- An indexed document: an identifier and the path it was read from. -/
structure Doc where
  id : Nat
  path : String
deriving Repr, DecidableEq

/-- A posting: the term `term` occurs in the document with id `doc`. -/
structure Posting where
  doc : Nat
  term : String
deriving Repr, DecidableEq

/-- One chunk of the feed, as received. -/
structure RawChunk where
  seq : Nat
  docs : List Doc
  postings : List Posting
deriving Repr, DecidableEq

namespace RawChunk

/-- The ids of the documents a chunk carries. -/
def docIds (c : RawChunk) : List Nat := c.docs.map Doc.id

/-- A chunk has a payload when it carries documents or postings. -/
def hasPayload (c : RawChunk) : Bool := !c.docs.isEmpty || !c.postings.isEmpty

/-- The documents of a chunk with sequence number `s` occupy the block of
`blockSize` consecutive ids starting at `blockSize * (s - 1)`, in order. -/
def blockOK (blockSize : Nat) (c : RawChunk) : Bool :=
  c.docIds = List.range' (blockSize * (c.seq - 1)) blockSize

/-- Every posting of the chunk refers to a document of the same chunk. -/
def selfContained (c : RawChunk) : Bool :=
  c.postings.all fun p => c.docIds.contains p.doc

end RawChunk

/-- All documents of a feed, in arrival order. -/
def allDocs (f : List RawChunk) : List Doc := f.flatMap RawChunk.docs

/-- All postings of a feed, in arrival order. -/
def allPostings (f : List RawChunk) : List Posting := f.flatMap RawChunk.postings

/-- All document ids of a feed. -/
def docIds (f : List RawChunk) : List Nat := (allDocs f).map Doc.id

/-- The sequence numbers of a feed. -/
def seqs (f : List RawChunk) : List Nat := f.map RawChunk.seq

/-- The documents a query returns: those posted under the term. -/
def hits (f : List RawChunk) (t : String) : List Nat :=
  ((allPostings f).filter fun p => p.term = t).map Posting.doc

/-- How many documents a term is posted in. -/
def docFreq (f : List RawChunk) (t : String) : Nat := (hits f t).length

/-- The sequence numbers in `1, …, n` that the feed has not delivered. -/
def missing (f : List RawChunk) (n : Nat) : List Nat :=
  (List.range' 1 n).filter fun s => !(seqs f).contains s

/-- Document frequency of every term of the feed, counted from the postings. -/
def termCounts (f : List RawChunk) : Std.HashMap String Nat :=
  (allPostings f).foldl (fun m p => m.insert p.term ((m.getD p.term 0) + 1)) ∅

/-- How many distinct terms the feed indexes. -/
def termCount (f : List RawChunk) : Nat := (termCounts f).size

/-- How many terms occur in exactly one posting. -/
def hapaxCount (f : List RawChunk) : Nat :=
  ((termCounts f).toList.filter fun kv => kv.2 = 1).length

/-- How many documents of the feed carry no posting at all. -/
def docsWithoutPostings (f : List RawChunk) : Nat :=
  ((allDocs f).filter fun d => !(allPostings f).any fun p => p.doc = d.id).length

/-- How many documents of the feed sit under the given package directory. -/
def packageDocs (f : List RawChunk) (root pkg : String) : Nat :=
  ((allDocs f).filter fun d => (root ++ pkg ++ "/").isPrefixOf d.path).length

/-! ## General facts about ingesting a feed -/

@[simp] theorem allDocs_nil : allDocs [] = [] := rfl

@[simp] theorem allPostings_nil : allPostings [] = [] := rfl

@[simp] theorem allDocs_cons (c : RawChunk) (f : List RawChunk) :
    allDocs (c :: f) = c.docs ++ allDocs f := by
  simp [allDocs]

@[simp] theorem allPostings_cons (c : RawChunk) (f : List RawChunk) :
    allPostings (c :: f) = c.postings ++ allPostings f := by
  simp [allPostings]

theorem allPostings_append (f g : List RawChunk) :
    allPostings (f ++ g) = allPostings f ++ allPostings g := by
  simp [allPostings, List.flatMap_append]

theorem allDocs_append (f g : List RawChunk) :
    allDocs (f ++ g) = allDocs f ++ allDocs g := by
  simp [allDocs, List.flatMap_append]

/-- A query returns a document exactly when some chunk posted it under the
term: search is faithful to the feed. -/
theorem mem_hits (f : List RawChunk) (t : String) (d : Nat) :
    d ∈ hits f t ↔ ∃ c ∈ f, (⟨d, t⟩ : Posting) ∈ c.postings := by
  constructor
  · intro h
    simp only [hits, List.mem_map, List.mem_filter, allPostings, List.mem_flatMap] at h
    obtain ⟨p, ⟨⟨c, hc, hp⟩, ht⟩, hd⟩ := h
    refine ⟨c, hc, ?_⟩
    have : p = (⟨d, t⟩ : Posting) := by
      cases p with
      | mk pd pt => simp_all
    exact this ▸ hp
  · rintro ⟨c, hc, hp⟩
    simp only [hits, List.mem_map, List.mem_filter, allPostings, List.mem_flatMap]
    exact ⟨⟨d, t⟩, ⟨⟨c, hc, hp⟩, by simp⟩, rfl⟩

/-- Feeding more chunks only adds hits. -/
theorem hits_mono (f g : List RawChunk) (t : String) (d : Nat) (h : d ∈ hits f t) :
    d ∈ hits (f ++ g) t := by
  rw [mem_hits] at h ⊢
  obtain ⟨c, hc, hp⟩ := h
  exact ⟨c, by simp [hc], hp⟩

/-- Ingesting a feed in two halves gives the same hits as ingesting it whole. -/
theorem hits_append (f g : List RawChunk) (t : String) :
    hits (f ++ g) t = hits f t ++ hits g t := by
  simp [hits, allPostings_append, List.filter_append]

/-- Nothing is outstanding exactly when every sequence number up to `n`
has been delivered. -/
theorem missing_eq_nil_iff (f : List RawChunk) (n : Nat) :
    missing f n = [] ↔ ∀ s ∈ List.range' 1 n, s ∈ seqs f := by
  simp [missing, List.filter_eq_nil_iff]

/-- A chunk without a payload carries no documents. -/
theorem docs_eq_nil_of_not_hasPayload {c : RawChunk} (h : c.hasPayload = false) :
    c.docs = [] := by
  simp only [RawChunk.hasPayload, Bool.or_eq_false_iff, Bool.not_eq_false'] at h
  simpa using h.1

/-- A chunk without a payload carries no postings. -/
theorem postings_eq_nil_of_not_hasPayload {c : RawChunk} (h : c.hasPayload = false) :
    c.postings = [] := by
  simp only [RawChunk.hasPayload, Bool.or_eq_false_iff, Bool.not_eq_false'] at h
  simpa using h.2

/-- Dropping the payload-free chunks changes no document. -/
theorem allDocs_filter_hasPayload (f : List RawChunk) :
    allDocs (f.filter fun c => c.hasPayload) = allDocs f := by
  induction f with
  | nil => simp
  | cons c f ih =>
    by_cases h : c.hasPayload = true
    · simp [h, ih]
    · simp only [Bool.not_eq_true] at h
      simp [h, ih, docs_eq_nil_of_not_hasPayload h]

/-- Dropping the payload-free chunks changes no document id. -/
theorem docIds_filter_hasPayload (f : List RawChunk) :
    docIds (f.filter fun c => c.hasPayload) = docIds f := by
  simp [docIds, allDocs_filter_hasPayload]

/-- Dropping the payload-free chunks changes no posting. -/
theorem allPostings_filter_hasPayload (f : List RawChunk) :
    allPostings (f.filter fun c => c.hasPayload) = allPostings f := by
  induction f with
  | nil => simp
  | cons c f ih =>
    by_cases h : c.hasPayload = true
    · simp [h, ih]
    · simp only [Bool.not_eq_true] at h
      simp [h, ih, postings_eq_nil_of_not_hasPayload h]

/-- Two chunks with different sequence numbers occupy disjoint blocks of
document ids, so the head chunk of a feed shares no document with the rest. -/
theorem docIds_head_disjoint (c : RawChunk) (f : List RawChunk) (b : Nat)
    (hblocks : ∀ x ∈ c :: f, RawChunk.blockOK b x = true)
    (hnotmem : c.seq ∉ seqs f) (hpos : ∀ x ∈ c :: f, 0 < x.seq)
    (x : Nat) (hx : x ∈ c.docIds) (hxmem : x ∈ docIds f) : False := by
  have hc : c.docIds = List.range' (b * (c.seq - 1)) b := by
    have := hblocks c (by simp)
    simpa [RawChunk.blockOK, decide_eq_true_eq] using this
  obtain ⟨i, hi, hxc⟩ : ∃ i, i < b ∧ x = b * (c.seq - 1) + i := by
    rw [hc, List.mem_range'] at hx
    obtain ⟨i, hi, hx'⟩ := hx
    exact ⟨i, hi, by simpa using hx'⟩
  obtain ⟨d, hd, hxd⟩ : ∃ d ∈ f, x ∈ d.docIds := by
    simp only [docIds, allDocs, List.mem_map, List.mem_flatMap] at hxmem
    obtain ⟨doc, ⟨d, hd, hdoc⟩, hid⟩ := hxmem
    exact ⟨d, hd, List.mem_map.2 ⟨doc, hdoc, hid⟩⟩
  have hdblock : d.docIds = List.range' (b * (d.seq - 1)) b := by
    have := hblocks d (by simp [hd])
    simpa [RawChunk.blockOK, decide_eq_true_eq] using this
  obtain ⟨j, hj, hxj⟩ : ∃ j, j < b ∧ x = b * (d.seq - 1) + j := by
    rw [hdblock, List.mem_range'] at hxd
    obtain ⟨j, hj, hx'⟩ := hxd
    exact ⟨j, hj, by simpa using hx'⟩
  have hne : c.seq ≠ d.seq := fun h => hnotmem (h ▸ List.mem_map_of_mem hd)
  have hcs := hpos c (by simp)
  have hds := hpos d (by simp [hd])
  rcases Nat.lt_or_ge (c.seq - 1) (d.seq - 1) with h | h
  · have hle : b * (c.seq - 1) + b ≤ b * (d.seq - 1) := by
      have hrw : b * (c.seq - 1) + b = b * (c.seq - 1 + 1) := by ring
      rw [hrw]
      exact Nat.mul_le_mul_left b (by omega)
    have h1 : x < b * (c.seq - 1) + b := by
      rw [hxc]; exact Nat.add_lt_add_left hi _
    have h2 : b * (d.seq - 1) ≤ x := by
      rw [hxj]; exact Nat.le_add_right _ _
    exact absurd (lt_of_lt_of_le h1 (hle.trans h2)) (lt_irrefl x)
  · have h' : d.seq - 1 < c.seq - 1 := by omega
    have hle : b * (d.seq - 1) + b ≤ b * (c.seq - 1) := by
      have hrw : b * (d.seq - 1) + b = b * (d.seq - 1 + 1) := by ring
      rw [hrw]
      exact Nat.mul_le_mul_left b (by omega)
    have h1 : x < b * (d.seq - 1) + b := by
      rw [hxj]; exact Nat.add_lt_add_left hj _
    have h2 : b * (c.seq - 1) ≤ x := by
      rw [hxc]; exact Nat.le_add_right _ _
    exact absurd (lt_of_lt_of_le h1 (hle.trans h2)) (lt_irrefl x)

/-- If the chunks' document blocks are well formed and their sequence numbers
are distinct, the document ids of the whole feed are distinct: no document is
delivered twice. -/
theorem docIds_nodup_of_blocks (f : List RawChunk) (b : Nat)
    (hblocks : ∀ c ∈ f, RawChunk.blockOK b c = true)
    (hseq : (seqs f).Nodup) (hpos : ∀ c ∈ f, 0 < c.seq) :
    (docIds f).Nodup := by
  induction f with
  | nil => simp [docIds, allDocs]
  | cons c f ih =>
    have hc : c.docIds = List.range' (b * (c.seq - 1)) b := by
      have := hblocks c (by simp)
      simpa [RawChunk.blockOK, decide_eq_true_eq] using this
    have hseqcons := hseq
    simp only [seqs, List.map_cons, List.nodup_cons] at hseqcons
    have hrest : (docIds f).Nodup :=
      ih (fun x hx => hblocks x (by simp [hx])) hseqcons.2 (fun x hx => hpos x (by simp [hx]))
    have hsplit : docIds (c :: f) = c.docIds ++ docIds f := by
      simp [docIds, RawChunk.docIds, allDocs]
    rw [hsplit, List.nodup_append]
    refine ⟨by rw [hc]; exact List.nodup_range', hrest, ?_⟩
    rintro a ha b' hb rfl
    exact docIds_head_disjoint c f b hblocks hseqcons.1 hpos a ha hb

/-- A posting of a feed comes from one of its chunks. -/
theorem exists_chunk_of_mem_allPostings {f : List RawChunk} {p : Posting}
    (hp : p ∈ allPostings f) : ∃ c ∈ f, p ∈ c.postings := by
  simpa [allPostings, List.mem_flatMap] using hp

/-- The document of a self-contained chunk's posting is a document of the feed. -/
theorem mem_docIds_of_posting {f : List RawChunk} {c : RawChunk} {p : Posting}
    (hc : c ∈ f) (hself : RawChunk.selfContained c = true) (hp : p ∈ c.postings) :
    p.doc ∈ docIds f := by
  have hdoc : p.doc ∈ c.docIds := by
    have := (List.all_eq_true.1 hself) p hp
    simpa using this
  simp only [RawChunk.docIds, List.mem_map] at hdoc
  obtain ⟨d, hd, hid⟩ := hdoc
  simp only [docIds, allDocs, List.mem_map, List.mem_flatMap]
  exact ⟨d, ⟨c, hc, hd⟩, hid⟩

/-- If every chunk has distinct postings, keeps its postings inside its own
document block, and the blocks are well formed with distinct sequence numbers,
then the whole feed has distinct postings: no posting is delivered twice. -/
theorem allPostings_nodup_of_blocks (f : List RawChunk) (b : Nat)
    (hblocks : ∀ c ∈ f, RawChunk.blockOK b c = true)
    (hseq : (seqs f).Nodup) (hpos : ∀ c ∈ f, 0 < c.seq)
    (hself : ∀ c ∈ f, RawChunk.selfContained c = true)
    (hnd : ∀ c ∈ f, c.postings.Nodup) :
    (allPostings f).Nodup := by
  induction f with
  | nil => simp [allPostings]
  | cons c f ih =>
    have hseqcons := hseq
    simp only [seqs, List.map_cons, List.nodup_cons] at hseqcons
    have hrest : (allPostings f).Nodup :=
      ih (fun x hx => hblocks x (by simp [hx])) hseqcons.2 (fun x hx => hpos x (by simp [hx]))
        (fun x hx => hself x (by simp [hx])) (fun x hx => hnd x (by simp [hx]))
    rw [allPostings_cons, List.nodup_append]
    refine ⟨hnd c (by simp), hrest, ?_⟩
    rintro p hp q hq rfl
    obtain ⟨d, hd, hqd⟩ := exists_chunk_of_mem_allPostings hq
    have h1 : p.doc ∈ c.docIds := by
      have := (List.all_eq_true.1 (hself c (by simp))) p hp
      simpa using this
    have h2 : p.doc ∈ docIds f :=
      mem_docIds_of_posting hd (hself d (by simp [hd])) hqd
    exact docIds_head_disjoint c f b hblocks hseqcons.1 hpos p.doc h1 h2

end Solfunmeme.IndexFeed
