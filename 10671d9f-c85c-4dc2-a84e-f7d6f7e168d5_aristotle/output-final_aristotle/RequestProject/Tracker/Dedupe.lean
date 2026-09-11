import RequestProject.Tracker.Types

/-!
# The bounded, insertion-ordered dedupe set (`service.ts`: `seen` / `markSeen`)

The service keeps a `Map<string, {at, source}>` of post ids it has already
emitted, capped at `SEEN_MAX` entries and evicted from the front — "a Map
iterated from the front is a perfectly good FIFO".

The model stores the same information as a list ordered oldest-first.
`mark` returns the updated store together with the boolean the TypeScript
function returns: `true` when this call is the *first* to claim the id (the
source that "won the race"), `false` when another source got there first.

The properties proved here are the ones the rest of the tracker relies on:

* `mark` is first-wins: a repeat call changes nothing and returns `false`;
* after a successful `mark` the id really is in the store (so the poller
  cannot resurrect a post the push path already handled or deliberately
  dropped);
* the store never exceeds its cap, and eviction only ever removes the
  *oldest* entries — it can never drop the id just inserted.
-/

namespace Tracker

/-- Bounded FIFO of post ids already handled, oldest first. -/
structure SeenStore where
  entries : List (String × IngestSource)
  deriving DecidableEq, Repr, Inhabited

namespace SeenStore

/-- The empty dedupe set. -/
def empty : SeenStore := ⟨[]⟩

/-- Ids currently retained, oldest first. -/
def ids (s : SeenStore) : List String := s.entries.map Prod.fst

/-- Has this post id already been handled? -/
def has (s : SeenStore) (id : String) : Prop := id ∈ s.ids

instance (s : SeenStore) (id : String) : Decidable (s.has id) := by
  unfold SeenStore.has; infer_instance

/-- Evict from the front until at most `cap` entries remain. -/
def trim (cap : Nat) (s : SeenStore) : SeenStore :=
  ⟨s.entries.drop (s.entries.length - cap)⟩

/-- `markSeen`: claim an id for `src`.  Returns the new store and whether this
call was the first to claim it. -/
def mark (cap : Nat) (s : SeenStore) (id : String) (src : IngestSource) :
    SeenStore × Bool :=
  if s.has id then (s, false)
  else (trim cap ⟨s.entries ++ [(id, src)]⟩, true)

/-- The store after `mark`, for when the boolean is not needed. -/
def mark' (cap : Nat) (s : SeenStore) (id : String) (src : IngestSource) : SeenStore :=
  (mark cap s id src).1

@[simp] theorem ids_empty : empty.ids = [] := rfl

@[simp] theorem not_has_empty (id : String) : ¬ empty.has id := by
  simp [has, ids_empty]

/-- First wins: a second claim on the same id reports `false` and leaves the
store untouched. -/
theorem mark_of_has {cap : Nat} {s : SeenStore} {id : String} {src : IngestSource}
    (h : s.has id) : mark cap s id src = (s, false) := by
  simp [mark, h]

/-- The returned flag is exactly "this id had not been claimed before". -/
theorem mark_snd_eq {cap : Nat} {s : SeenStore} {id : String} {src : IngestSource} :
    (mark cap s id src).2 = true ↔ ¬ s.has id := by
  by_cases h : s.has id <;> simp [mark, h]

theorem mark'_of_has {cap : Nat} {s : SeenStore} {id : String} {src : IngestSource}
    (h : s.has id) : mark' cap s id src = s := by
  simp [mark', mark_of_has h]

/-- Trimming keeps a suffix of the entries: nothing is reordered and nothing
new appears. -/
theorem trim_entries_suffix (cap : Nat) (s : SeenStore) :
    (trim cap s).entries.IsSuffix s.entries :=
  List.drop_suffix _ _

/-- Eviction never removes the most recently inserted entry, provided the cap
allows at least one entry. -/
theorem mem_ids_trim_append {cap : Nat} (hcap : 1 ≤ cap) (l : List (String × IngestSource))
    (x : String × IngestSource) : x.1 ∈ (trim cap ⟨l ++ [x]⟩).ids := by
  have hlen : l.length + 1 - cap ≤ l.length := by omega
  have : x ∈ (l ++ [x]).drop (l.length + 1 - cap) := by
    have hx : (l ++ [x]).drop l.length = [x] := by simp
    have := List.drop_subset_drop_left (l := l ++ [x]) hlen
    exact this (by simp [hx])
  simpa [trim, ids] using List.mem_map_of_mem (f := Prod.fst) this

/-- After marking, the id is in the store (the cap is at least one). -/
theorem has_mark' {cap : Nat} (hcap : 1 ≤ cap) (s : SeenStore) (id : String)
    (src : IngestSource) : (mark' cap s id src).has id := by
  by_cases h : s.has id
  · simpa [mark'_of_has h] using h
  · unfold mark' mark
    rw [if_neg h]
    exact mem_ids_trim_append hcap s.entries (id, src)

/-- `mark` is idempotent: claiming twice is the same as claiming once. -/
theorem mark'_idem {cap : Nat} (hcap : 1 ≤ cap) (s : SeenStore) (id : String)
    (src : IngestSource) :
    mark' cap (mark' cap s id src) id src = mark' cap s id src :=
  mark'_of_has (has_mark' hcap s id src)

/-- The store is bounded by its cap. -/
theorem length_trim_le (cap : Nat) (s : SeenStore) : (trim cap s).entries.length ≤ cap := by
  simp only [trim, List.length_drop]
  omega

theorem length_mark'_le {cap : Nat} {s : SeenStore} (h : s.entries.length ≤ cap)
    (id : String) (src : IngestSource) : (mark' cap s id src).entries.length ≤ cap := by
  by_cases hs : s.has id
  · simpa [mark'_of_has hs] using h
  · simp only [mark', mark, if_neg hs]
    exact length_trim_le _ _

/-- Nothing is invented: every id in the store after a mark was either already
there or is the id just marked. -/
theorem ids_mark'_subset {cap : Nat} (s : SeenStore) (id : String) (src : IngestSource) :
    ∀ x ∈ (mark' cap s id src).ids, x ∈ s.ids ∨ x = id := by
  intro x hx
  by_cases hs : s.has id
  · exact Or.inl (by simpa [mark'_of_has hs] using hx)
  · simp only [mark', mark, if_neg hs, trim, ids, List.mem_map] at hx
    obtain ⟨p, hp, rfl⟩ := hx
    have hp' : p ∈ s.entries ++ [(id, src)] :=
      (List.drop_subset _ _) hp
    rcases List.mem_append.mp hp' with h | h
    · exact Or.inl (List.mem_map_of_mem h)
    · simp at h; simp [h]

/-- Below the cap nothing is evicted. -/
theorem trim_eq_self {cap : Nat} {s : SeenStore} (h : s.entries.length ≤ cap) :
    trim cap s = s := by
  simp [trim, Nat.sub_eq_zero_of_le h]

/-- Below the cap, marking is a plain append. -/
theorem ids_mark'_eq_append {cap : Nat} {s : SeenStore} {id : String} (h : ¬ s.has id)
    (hlen : s.entries.length + 1 ≤ cap) (src : IngestSource) :
    (mark' cap s id src).ids = s.ids ++ [id] := by
  have hle : (s.entries ++ [(id, src)]).length ≤ cap := by simpa using hlen
  unfold mark' mark
  rw [if_neg h]
  simp [trim_eq_self (s := ⟨s.entries ++ [(id, src)]⟩) hle, ids]

/-- Below the cap, nothing already known is forgotten. -/
theorem ids_subset_mark' {cap : Nat} {s : SeenStore} {id : String} (src : IngestSource)
    (hlen : s.entries.length + 1 ≤ cap) {x : String} (hx : x ∈ s.ids) :
    x ∈ (mark' cap s id src).ids := by
  by_cases h : s.has id
  · simpa [mark'_of_has h] using hx
  · simp [ids_mark'_eq_append h hlen src, hx]

end SeenStore

end Tracker
