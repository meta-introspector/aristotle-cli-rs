import Mathlib

/-!
# `M₁₁` as a coordinate system

The archive of `Archive.lean` needs addresses, and the addresses should carry
structure rather than being arbitrary.  This file builds the Mathieu group
`M₁₁` explicitly, as permutations of eleven points, and shows it is a *sharply
4-transitive* coordinate system: an element of the group is determined by, and
freely chosen by, where it sends the first four points.  So four distinct points
out of eleven — an ordered 4-subset — name exactly one of the 7920 group
elements, and can therefore serve as the address of a cell.

Everything here is about the concrete list `m11` of 7920 permutations:

* it is generated from the standard pair of generators by breadth-first search,
  and every element comes with the word in the generators that reaches it;
* `m11_card` : there are 7920 of them, all distinct (`m11_nodup`), each a
  permutation of the eleven points (`m11_perm`);
* `m11_mul_mem`, `m11_id_mem`, `m11_inv_mem` : it is closed under composition,
  contains the identity and is closed under inverses — a group of order 7920,
  the order of `M₁₁`;
* `m11_coord_unique` : **sharp 4-transitivity**.  For every ordered 4-tuple of
  distinct points there is exactly one element of the group sending
  `(0,1,2,3)` to it.  This is what makes `coord` a coordinate system: the
  addresses are the 7920 injective 4-tuples, one per group element.

The counting facts are compiled evaluations of the concrete list (they are
finite checks); the algebra — associativity, the identity laws, and closure of
the list under composition — is proved.
-/

set_option maxRecDepth 10000

namespace NixWars
namespace Holo
namespace M11

/-- A permutation of the eleven points, as the list of images of `0, …, 10`. -/
abbrev Perm11 := List Nat

/-- Composition: `comp p q` is `p` followed by `q`. -/
def comp (p q : Perm11) : Perm11 := (List.range 11).map (fun i => q.getD (p.getD i 0) 0)

/-- The identity permutation. -/
def idPerm : Perm11 := List.range 11

/-- The 11-cycle `(0 1 2 3 4 5 6 7 8 9 10)`. -/
def a11 : Perm11 := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0]

/-- The permutation `(2 6 10 7)(3 9 4 5)`. -/
def b11 : Perm11 := [0, 1, 6, 9, 5, 3, 10, 2, 8, 4, 7]

/-- The two generators, indexed by a bit. -/
def genOf (b : Bool) : Perm11 := if b then b11 else a11

/-- The value of a word in the generators. -/
def evalWord (w : List Bool) : Perm11 := w.foldl (fun p b => comp p (genOf b)) idPerm

/-- The inverse permutation. -/
def invPerm (p : Perm11) : Perm11 := (List.range 11).map (fun i => p.idxOf i)

/-- The coordinate of a group element: where it sends the first four points. -/
def coord (p : Perm11) : List Nat := p.take 4

/-- Being a permutation of the eleven points. -/
def IsPerm11 (p : Perm11) : Prop := p.length = 11 ∧ ∀ i ∈ p, i < 11

/-! ## The group, by breadth-first search from the generators -/

/-- The state of the search: what has been seen, what has been found (with the
word that reaches it), and the current frontier. -/
structure Bfs where
  /-- The elements already reached. -/
  seen : Std.HashSet Perm11
  /-- Everything found so far, each with a word in the generators. -/
  found : List (Perm11 × List Bool)
  /-- The elements found on the last round. -/
  frontier : List (Perm11 × List Bool)

/-- One round of the search: multiply the frontier by each generator. -/
def bfsStep (s : Bfs) : Bfs :=
  let next : List (Perm11 × List Bool) :=
    s.frontier.flatMap (fun pw => [true, false].map (fun b => (comp pw.1 (genOf b), pw.2 ++ [b])))
  let fresh := next.foldl (fun (acc : Std.HashSet Perm11 × List (Perm11 × List Bool)) pw =>
    if acc.1.contains pw.1 then acc else (acc.1.insert pw.1, pw :: acc.2)) (s.seen, [])
  { seen := fresh.1, found := s.found ++ fresh.2.reverse, frontier := fresh.2.reverse }

/-- The search starts at the identity, reached by the empty word. -/
def bfsInit : Bfs :=
  { seen := (Std.HashSet.emptyWithCapacity).insert idPerm, found := [(idPerm, [])],
    frontier := [(idPerm, [])] }

/-- The group, each element with a word in the generators reaching it. -/
def m11W : List (Perm11 × List Bool) := (bfsStep^[40] bfsInit).found

/-- The group `M₁₁`, as an explicit list of permutations of eleven points. -/
def m11 : List Perm11 := m11W.map Prod.fst

/-- All ordered 4-tuples of distinct points out of eleven: the addresses. -/
def tuples11 : List (List Nat) :=
  ((List.range 11).flatMap fun x => (List.range 11).flatMap fun y =>
    (List.range 11).flatMap fun z => (List.range 11).map fun w => [x, y, z, w]).filter
      (fun t => t.dedup.length == 4)

/-! ## The finite checks -/

/-- `M₁₁` has 7920 elements. -/
theorem m11_card : m11.length = 7920 := by native_decide

/-- The listed elements are distinct. -/
theorem m11_nodup : m11.Nodup := by native_decide

/-- Every element is a permutation of the eleven points. -/
theorem m11_perm : ∀ p ∈ m11, p.length = 11 ∧ (∀ i ∈ p, i < 11) ∧ p.Nodup := by native_decide

/-- The identity is in the group. -/
theorem m11_id_mem : idPerm ∈ m11 := by native_decide

/-- The list is closed under multiplication by either generator. -/
theorem m11_gens_closed : ∀ p ∈ m11, comp p a11 ∈ m11 ∧ comp p b11 ∈ m11 := by native_decide

/-- Each listed element is the value of its word in the generators. -/
theorem m11_word_eval : ∀ pw ∈ m11W, evalWord pw.2 = pw.1 := by native_decide

/-- The group is closed under inverses, and `invPerm` really is the inverse. -/
theorem m11_inv_mem : ∀ p ∈ m11, invPerm p ∈ m11 ∧ comp p (invPerm p) = idPerm := by native_decide

/-- Distinct elements have distinct coordinates. -/
theorem m11_coord_nodup : (m11.map coord).Nodup := by native_decide

/-- There are 7920 = 11·10·9·8 addresses, exactly as many as group elements. -/
theorem tuples11_card : tuples11.length = 7920 := by native_decide

/-- Every address is the coordinate of some element. -/
theorem m11_coord_covers : ∀ t ∈ tuples11, t ∈ m11.map coord := by native_decide

/-! ## The algebra -/

theorem getD_lt {p : Perm11} (hp : ∀ x ∈ p, x < 11) (i : Nat) : p.getD i 0 < 11 := by
  by_cases h : i < p.length
  · rw [List.getD_eq_getElem _ _ h]
    exact hp _ (List.getElem_mem h)
  · rw [List.getD_eq_default _ _ (by omega)]
    omega

@[simp] theorem comp_length (p q : Perm11) : (comp p q).length = 11 := by simp [comp]

theorem comp_getD (p q : Perm11) {i : Nat} (hi : i < 11) :
    (comp p q).getD i 0 = q.getD (p.getD i 0) 0 := by
  rw [List.getD_eq_getElem _ _ (by simp [hi])]
  simp [comp]

theorem comp_isPerm (p : Perm11) {q : Perm11} (hq : ∀ x ∈ q, x < 11) : IsPerm11 (comp p q) := by
  refine ⟨comp_length p q, ?_⟩
  intro i hi
  simp only [comp, List.mem_map] at hi
  obtain ⟨j, _, rfl⟩ := hi
  exact getD_lt hq _

theorem map_range_getD {p : Perm11} (h : p.length = 11) :
    (List.range 11).map (fun i => p.getD i 0) = p := by
  apply List.ext_getElem (by simp [h])
  intro i h1 h2
  simp only [List.getElem_map, List.getElem_range]
  exact List.getD_eq_getElem _ _ h2

theorem isPerm11_id : IsPerm11 idPerm := ⟨by simp [idPerm], by decide⟩
theorem isPerm11_a11 : IsPerm11 a11 := ⟨by simp [a11], by decide⟩
theorem isPerm11_b11 : IsPerm11 b11 := ⟨by simp [b11], by decide⟩

theorem isPerm11_genOf (b : Bool) : IsPerm11 (genOf b) := by
  cases b
  · exact isPerm11_a11
  · exact isPerm11_b11

theorem comp_id {p : Perm11} (hp : IsPerm11 p) : comp p idPerm = p := by
  unfold comp
  have : ∀ i ∈ List.range 11, idPerm.getD (p.getD i 0) 0 = p.getD i 0 := by
    intro i _
    have : p.getD i 0 < 11 := getD_lt hp.2 i
    rw [idPerm, List.getD_eq_getElem _ _ (by simpa using this)]
    simp
  rw [List.map_congr_left this, map_range_getD hp.1]

theorem id_comp {q : Perm11} (hq : IsPerm11 q) : comp idPerm q = q := by
  unfold comp
  have : ∀ i ∈ List.range 11, q.getD (idPerm.getD i 0) 0 = q.getD i 0 := by
    intro i hi
    rw [List.mem_range] at hi
    have hid : idPerm.getD i 0 = i := by
      rw [idPerm, List.getD_eq_getElem _ _ (by simpa using hi)]
      simp
    rw [hid]
  rw [List.map_congr_left this, map_range_getD hq.1]

theorem comp_assoc {p : Perm11} (hp : ∀ x ∈ p, x < 11) (q r : Perm11) :
    comp (comp p q) r = comp p (comp q r) := by
  have hl : comp (comp p q) r = (List.range 11).map
      (fun i => r.getD (q.getD (p.getD i 0) 0) 0) := by
    unfold comp
    refine List.map_congr_left ?_
    intro i hi
    rw [List.mem_range] at hi
    rw [show ((List.range 11).map (fun i => q.getD (p.getD i 0) 0)) = comp p q from rfl,
      comp_getD p q hi]
  have hr : comp p (comp q r) = (List.range 11).map
      (fun i => r.getD (q.getD (p.getD i 0) 0) 0) := by
    unfold comp
    refine List.map_congr_left ?_
    intro i _
    rw [show ((List.range 11).map (fun i => r.getD (q.getD i 0) 0)) = comp q r from rfl,
      comp_getD q r (getD_lt hp i)]
  rw [hl, hr]

/-! ## The list is a group -/

theorem foldl_mem (w : List Bool) : ∀ p ∈ m11,
    w.foldl (fun p b => comp p (genOf b)) p ∈ m11 := by
  induction w with
  | nil => intro p hp; simpa using hp
  | cons b w ih =>
    intro p hp
    have hnext : comp p (genOf b) ∈ m11 := by
      cases b
      · exact (m11_gens_closed p hp).1
      · exact (m11_gens_closed p hp).2
    simpa using ih _ hnext

theorem foldl_eq_comp (w : List Bool) : ∀ {p : Perm11}, IsPerm11 p →
    w.foldl (fun p b => comp p (genOf b)) p = comp p (evalWord w) := by
  induction w with
  | nil => intro p hp; simpa [evalWord] using (comp_id hp).symm
  | cons b w ih =>
    intro p hp
    have hgen : IsPerm11 (genOf b) := isPerm11_genOf b
    have h1 : (b :: w).foldl (fun p b => comp p (genOf b)) p =
        comp (comp p (genOf b)) (evalWord w) := by
      simpa using ih (comp_isPerm p hgen.2)
    have h2 : evalWord (b :: w) = comp (genOf b) (evalWord w) := by
      have : evalWord (b :: w) = w.foldl (fun p b => comp p (genOf b)) (genOf b) := by
        simp [evalWord, id_comp hgen]
      rw [this, ih hgen]
    rw [h1, h2, comp_assoc hp.2]

/-- **The list is closed under composition**: `m11` is a group of order 7920. -/
theorem m11_mul_mem {p q : Perm11} (hp : p ∈ m11) (hq : q ∈ m11) : comp p q ∈ m11 := by
  obtain ⟨pw, hpw, rfl⟩ := List.mem_map.mp hq
  have hword : evalWord pw.2 = pw.1 := m11_word_eval pw hpw
  have hperm : IsPerm11 p := ⟨(m11_perm p hp).1, (m11_perm p hp).2.1⟩
  rw [← hword, ← foldl_eq_comp pw.2 hperm]
  exact foldl_mem pw.2 p hp

/-! ## Sharp 4-transitivity: the coordinate system -/

/-- Elements are separated by their coordinates. -/
theorem m11_coord_injOn {p q : Perm11} (hp : p ∈ m11) (hq : q ∈ m11) (h : coord p = coord q) :
    p = q :=
  List.inj_on_of_nodup_map m11_coord_nodup hp hq h

theorem mem_tuples11 {t : List Nat} (h4 : t.length = 4) (hnd : t.Nodup)
    (hlt : ∀ x ∈ t, x < 11) : t ∈ tuples11 := by
  obtain ⟨x, y, z, w, rfl⟩ : ∃ x y z w, t = [x, y, z, w] := by
    match t, h4 with
    | [x, y, z, w], _ => exact ⟨x, y, z, w, rfl⟩
  refine List.mem_filter.mpr ⟨?_, ?_⟩
  · simp only [List.mem_flatMap, List.mem_map, List.mem_range]
    exact ⟨x, hlt x (by simp), y, hlt y (by simp), z, hlt z (by simp), w, hlt w (by simp), rfl⟩
  · rw [List.Nodup.dedup hnd]
    simp

/-- **Sharp 4-transitivity.**  For every ordered 4-tuple of distinct points out
of eleven there is exactly one element of `M₁₁` whose coordinate it is, so the
addresses are precisely the 7920 injective 4-tuples. -/
theorem m11_coord_unique {t : List Nat} (h4 : t.length = 4) (hnd : t.Nodup)
    (hlt : ∀ x ∈ t, x < 11) : ∃! p, p ∈ m11 ∧ coord p = t := by
  obtain ⟨p, hp, hpt⟩ := List.mem_map.mp (m11_coord_covers t (mem_tuples11 h4 hnd hlt))
  refine ⟨p, ⟨hp, hpt⟩, ?_⟩
  rintro q ⟨hq, hqt⟩
  exact m11_coord_injOn hq hp (by rw [hqt, hpt])

end M11
end Holo
end NixWars
