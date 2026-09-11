import RequestProject.Craft.FileSystemPathsBasic

/-!
# ComputerCraft virtual file-system paths: main results

This file collects the main theorems about the model of ComputerCraft's
`FileSystem` path handling set up in `RequestProject.FileSystemPathsBasic`:
the shape of a sanitised path, idempotence of `sanitizePath` (and a
counterexample showing the proviso is needed), the round-trip laws for
`combine` with `getDirectory`/`getName` and with `toLocal`, and the
sandbox-safety statements about `contains` and `toLocal`.
-/

set_option maxRecDepth 10000

namespace CCFileSystem

/-! ## Main results: the shape of a sanitised path -/

/-- Every character surviving sanitisation passes the character filter, and no
backslash survives. -/
theorem sanitizeL_goodChars (aw : Bool) (p : List Char) : GoodChars aw (sanitizeL aw p) := by
  intro c hc
  rcases mem_joinParts hc with rfl | ⟨q, hq, hcq⟩
  · exact ⟨by cases aw <;> decide, by decide⟩
  · obtain ⟨r, hr, hcr⟩ := mem_normParts_char hq hcq
    have : c ∈ cleanChars aw p := by
      have := mem_joinParts_of_mem hr hcr
      rwa [joinParts_splitSlash] at this
    exact cleanChars_goodChars aw p c this

/-- The components of a sanitised path are exactly the normalised components of
the cleaned input. -/
theorem pathParts_sanitizeL (aw : Bool) (p : List Char) :
    pathParts (sanitizeL aw p) = normParts (splitSlash (cleanChars aw p)) := by
  rw [sanitizeL]
  refine pathParts_joinParts ?_
  intro q hq
  obtain ⟨hval, -⟩ := normParts_normalized (splitSlash_no_slash (cleanChars aw p))
  exact ⟨(hval q hq).1, (hval q hq).2.2.2⟩

/-- A sanitised path is normalised: all of its components are valid, and every
`".."` component sits at the very front. -/
theorem sanitizeL_normalized (aw : Bool) (p : List Char) :
    Normalized (pathParts (sanitizeL aw p)) := by
  rw [pathParts_sanitizeL]
  exact normParts_normalized (splitSlash_no_slash (cleanChars aw p))

/-- A sanitised path has no empty components: in particular it has no leading or
trailing slash and no doubled slash. -/
theorem sanitizeL_components_ne_nil (aw : Bool) (p : List Char) :
    ∀ q ∈ pathParts (sanitizeL aw p), q ≠ [] :=
  fun q hq => ((sanitizeL_normalized aw p).1 q hq).1

/-- A sanitised path contains no `"."` component. -/
theorem sanitizeL_components_ne_dot (aw : Bool) (p : List Char) :
    ∀ q ∈ pathParts (sanitizeL aw p), q ≠ ['.'] :=
  fun q hq => ((sanitizeL_normalized aw p).1 q hq).2.1

/-- Components of a sanitised path are at most 255 characters long. -/
theorem sanitizeL_components_length (aw : Bool) (p : List Char) :
    ∀ q ∈ pathParts (sanitizeL aw p), q.length ≤ 255 :=
  fun q hq => ((sanitizeL_normalized aw p).1 q hq).2.2.1

/-- All `".."` components of a sanitised path sit at its very front: a `".."`
can never appear after a real directory name, so a path can only escape its
root at the beginning. -/
theorem sanitizeL_dotdot_prefix (aw : Bool) (p : List Char) :
    ∃ k rest, pathParts (sanitizeL aw p) = List.replicate k dd ++ rest ∧ dd ∉ rest :=
  (sanitizeL_normalized aw p).2

/-! ## Fixed points and idempotence -/

/-- A path in sanitised form is left untouched by `sanitizePath`. -/
theorem sanitizeL_eq_self {aw : Bool} {s : List Char} (h : Sanitized aw s) :
    sanitizeL aw s = s := by
  obtain ⟨hgc, hnorm, hnd⟩ := h
  rw [sanitizeL, cleanChars_eq_self hgc]
  by_cases hs : s = []
  · subst hs
    rfl
  · rw [show splitSlash s = pathParts s from by rw [pathParts, if_neg hs],
      normParts_of_normalized hnorm hnd, joinParts_pathParts]

/-- Provided the 255-character truncation has not manufactured a run of dots,
the output of `sanitizePath` is in sanitised form. -/
theorem sanitized_sanitizeL {aw : Bool} {p : List Char}
    (h : NoDotRuns (pathParts (sanitizeL aw p))) : Sanitized aw (sanitizeL aw p) :=
  ⟨sanitizeL_goodChars aw p, sanitizeL_normalized aw p, h⟩

/-- `sanitizePath` is idempotent, provided no component of its output is a run
of three or more dots (see `sanitizeL_not_idem` for why that proviso is needed). -/
theorem sanitizeL_idem {aw : Bool} {p : List Char}
    (h : NoDotRuns (pathParts (sanitizeL aw p))) :
    sanitizeL aw (sanitizeL aw p) = sanitizeL aw p :=
  sanitizeL_eq_self (sanitized_sanitizeL h)

/-- `sanitizePath` is **not** idempotent in general: truncating a component of
length `≥ 255` can turn it into a run of dots, which the next pass deletes.
The witness is 255 dots followed by `'a'`. -/
theorem sanitizeL_dots_example :
    sanitizeL false (List.replicate 255 '.' ++ ['a']) = List.replicate 255 '.' := by
  set p : List Char := List.replicate 255 '.' ++ ['a'] with hp
  have hmema : 'a' ∈ p := by rw [hp]; exact List.mem_append_right _ (List.mem_singleton_self _)
  have hgc : GoodChars false p := by
    intro c hc
    rw [hp] at hc
    rcases List.mem_append.1 hc with h | h
    · rw [List.eq_of_mem_replicate h]; exact ⟨by decide, by decide⟩
    · rw [List.eq_of_mem_singleton h]; exact ⟨by decide, by decide⟩
  have hns : '/' ∉ p := by
    intro hc
    rw [hp] at hc
    rcases List.mem_append.1 hc with h | h
    · exact absurd (List.eq_of_mem_replicate h) (by decide)
    · exact absurd (List.eq_of_mem_singleton h) (by decide)
  have hlen : p.length = 256 := by
    rw [hp, List.length_append, List.length_replicate, List.length_singleton]
  have hne : p ≠ [] := by
    intro hc; rw [hc, List.length_nil] at hlen; omega
  have hnedot : p ≠ ['.'] := by
    intro hc; rw [hc] at hlen; rw [List.length_singleton] at hlen; omega
  have hnedd : p ≠ dd := by
    intro hc; rw [hc] at hlen; rw [show dd.length = 2 from rfl] at hlen; omega
  have htake : p.take 255 = List.replicate 255 '.' := by
    rw [hp]; exact List.take_left' (List.length_replicate)
  have hdots : isDotsRun p = false := by
    simp only [isDotsRun, Bool.and_eq_false_iff, List.all_eq_false]
    exact Or.inr ⟨'a', hmema, by decide⟩
  rw [sanitizeL, cleanChars_eq_self hgc, splitSlash_of_no_slash hns]
  have hpush : pushPart [] p = [List.replicate 255 '.'] := by
    unfold pushPart
    rw [if_neg (by push_neg; exact ⟨hne, hnedot, by rw [hdots]; exact Bool.false_ne_true⟩),
      if_neg hnedd, if_pos (by omega), htake]
  rw [normParts, List.foldl_cons, List.foldl_nil, hpush, List.reverse_singleton]
  rfl

/-- `sanitizePath` is **not** idempotent in general. -/
theorem sanitizeL_not_idem :
    ∃ p : List Char, sanitizeL false (sanitizeL false p) ≠ sanitizeL false p := by
  refine ⟨List.replicate 255 '.' ++ ['a'], ?_⟩
  rw [sanitizeL_dots_example]
  have hgc : GoodChars false (List.replicate 255 '.' : List Char) := by
    intro c hc
    rw [List.eq_of_mem_replicate hc]; exact ⟨by decide, by decide⟩
  have hns : '/' ∉ (List.replicate 255 '.' : List Char) := fun hc =>
    absurd (List.eq_of_mem_replicate hc) (by decide)
  have hdots : isDotsRun (List.replicate 255 '.' : List Char) = true := by
    simp only [isDotsRun, Bool.and_eq_true, decide_eq_true_eq, List.length_replicate,
      List.all_eq_true]
    exact ⟨by omega, fun c hc => by rw [List.eq_of_mem_replicate hc]; rfl⟩
  have h2 : sanitizeL false (List.replicate 255 '.' : List Char) = [] := by
    rw [sanitizeL, cleanChars_eq_self hgc, splitSlash_of_no_slash hns, normParts,
      List.foldl_cons, List.foldl_nil, pushPart, if_pos (Or.inr (Or.inr (by rw [hdots])))]
    rfl
  rw [h2]
  intro hc
  have hl := congrArg List.length hc
  rw [List.length_nil, List.length_replicate] at hl
  omega

/-- Sanitised without wildcards is in particular sanitised with wildcards allowed. -/
theorem sanitized_mono {s : List Char} (h : Sanitized false s) : Sanitized true s :=
  ⟨goodChars_mono h.1, h.2.1, h.2.2⟩

/-! ## Round-trip laws -/

theorem ddPrefix_take {ps : List Part} (h : DDPrefix ps) (i : ℕ) : DDPrefix (ps.take i) := by
  obtain ⟨k, rest, rfl, hdr⟩ := h
  by_cases hi : i ≤ k
  · refine ⟨i, [], ?_, by simp⟩
    rw [List.take_append_of_le_length (by simpa using hi), List.take_replicate]
    simp [min_eq_left hi]
  · push_neg at hi
    refine ⟨k, rest.take (i - k), ?_, fun hc => hdr (List.mem_of_mem_take hc)⟩
    rw [List.take_append, List.take_of_length_le
      (by rw [List.length_replicate]; omega : (List.replicate k dd).length ≤ i)]
    simp

theorem ddPrefix_drop {ps : List Part} (h : DDPrefix ps) (i : ℕ) : DDPrefix (ps.drop i) := by
  obtain ⟨k, rest, rfl, hdr⟩ := h
  by_cases hi : i ≤ k
  · refine ⟨k - i, rest, ?_, hdr⟩
    rw [List.drop_append]
    simp [List.drop_replicate, Nat.sub_eq_zero_of_le hi]
  · push_neg at hi
    refine ⟨0, rest.drop (i - k), ?_, fun hc => hdr (List.mem_of_mem_drop hc)⟩
    rw [List.drop_append, List.drop_eq_nil_of_le
      (by rw [List.length_replicate]; omega : (List.replicate k dd).length ≤ i)]
    simp

theorem goodChars_joinParts {aw : Bool} {qs : List Part} (h : ∀ q ∈ qs, GoodChars aw q) :
    GoodChars aw (joinParts qs) := by
  intro c hc
  rcases mem_joinParts hc with rfl | ⟨q, hq, hcq⟩
  · exact ⟨by cases aw <;> decide, by decide⟩
  · exact h q hq c hcq

theorem sanitized_joinParts {aw : Bool} {qs : List Part}
    (hval : ∀ q ∈ qs, ValidPart q) (hdd : DDPrefix qs) (hnd : NoDotRuns qs)
    (hgc : ∀ q ∈ qs, GoodChars aw q) : Sanitized aw (joinParts qs) := by
  have hpp : pathParts (joinParts qs) = qs :=
    pathParts_joinParts (fun q hq => ⟨(hval q hq).1, (hval q hq).2.2.2⟩)
  exact ⟨goodChars_joinParts hgc, by rw [hpp]; exact ⟨hval, hdd⟩, by rw [hpp]; exact hnd⟩

/-- A run of components of a sanitised path is itself a sanitised path. -/
theorem sanitized_parts_sub {aw : Bool} {p : List Char} (hs : Sanitized aw p)
    {qs : List Part} (hsub : ∀ q ∈ qs, q ∈ pathParts p) (hdd : DDPrefix qs) :
    Sanitized aw (joinParts qs) := by
  refine sanitized_joinParts (fun q hq => hs.2.1.1 q (hsub q hq)) hdd
    (fun q hq => hs.2.2 q (hsub q hq)) ?_
  intro q hq c hc
  have hcp : c ∈ p := by
    have := mem_joinParts_of_mem (hsub q hq) hc
    rwa [joinParts_pathParts] at this
  exact hs.1 c hcp

theorem takeWhile_ne_slash {u v : List Char} (h : '/' ∉ u) :
    (u ++ '/' :: v).takeWhile (· ≠ '/') = u := by
  induction u with
  | nil => simp
  | cons c cs ih =>
    simp only [List.mem_cons, not_or] at h
    rw [List.cons_append, List.takeWhile_cons, if_pos (by simpa using Ne.symm h.1), ih h.2]

theorem dropWhile_ne_slash {u v : List Char} (h : '/' ∉ u) :
    (u ++ '/' :: v).dropWhile (· ≠ '/') = '/' :: v := by
  induction u with
  | nil => simp
  | cons c cs ih =>
    simp only [List.mem_cons, not_or] at h
    rw [List.cons_append, List.dropWhile_cons, if_pos (by simpa using Ne.symm h.1), ih h.2]

theorem beforeLastSlash_split {u v : List Char} (hv : '/' ∉ v) :
    beforeLastSlash (u ++ '/' :: v) = u := by
  have hrev : (u ++ '/' :: v).reverse = v.reverse ++ '/' :: u.reverse := by simp
  rw [beforeLastSlash, hrev, dropWhile_ne_slash (by simpa using hv)]
  simp

theorem afterLastSlash_split {u v : List Char} (hv : '/' ∉ v) :
    afterLastSlash (u ++ '/' :: v) = v := by
  have hrev : (u ++ '/' :: v).reverse = v.reverse ++ '/' :: u.reverse := by simp
  rw [afterLastSlash, hrev, takeWhile_ne_slash (by simpa using hv)]
  simp

theorem beforeLastSlash_of_no_slash {p : List Char} (h : '/' ∉ p) : beforeLastSlash p = [] := by
  rw [beforeLastSlash, List.dropWhile_eq_nil_iff.2 ?_]
  intro x hx
  simpa using fun hc => h (by rw [← hc]; exact List.mem_reverse.1 hx)

theorem afterLastSlash_of_no_slash {p : List Char} (h : '/' ∉ p) : afterLastSlash p = p := by
  rw [afterLastSlash, List.takeWhile_eq_self_iff.2 ?_]
  · simp
  · intro x hx
    simpa using fun hc => h (by rw [← hc]; exact List.mem_reverse.1 hx)

theorem joinParts_append_singleton {ps : List Part} (hne : ps ≠ []) (x : Part) :
    joinParts (ps ++ [x]) = joinParts ps ++ '/' :: x := by
  induction ps with
  | nil => exact absurd rfl hne
  | cons p ps ih =>
    cases ps with
    | nil => simp [joinParts]
    | cons q qs =>
      rw [List.cons_append,
        show joinParts (p :: (q :: qs ++ [x])) = p ++ '/' :: joinParts (q :: qs ++ [x]) from rfl,
        ih (by simp),
        show joinParts (p :: q :: qs) = p ++ '/' :: joinParts (q :: qs) from rfl]
      simp

theorem combineL_eq {a b : List Char} (ha : sanitizeL true a = a) (hb : sanitizeL true b = b) :
    combineL a b = if a = [] then b else if b = [] then a else sanitizeL true (a ++ '/' :: b) := by
  simp only [combineL, ha, hb]

/-- `combine` reassembles a path from its directory and its name. -/
theorem combineL_getDirectoryL_getNameL {p : List Char} (hs : Sanitized true p) (hp : p ≠ []) :
    combineL (getDirectoryL p) (getNameL p) = p := by
  have hself : sanitizeL true p = p := sanitizeL_eq_self hs
  set ps := pathParts p with hps
  have hpsne : ps ≠ [] := by
    rw [hps, pathParts, if_neg hp]
    exact splitSlash_ne_nil p
  have hjoin : joinParts ps = p := joinParts_pathParts p
  have hval : ∀ q ∈ ps, ValidPart q := hs.2.1.1
  by_cases hdl : ps.dropLast = []
  · obtain ⟨x, hx⟩ : ∃ x, ps = [x] := by
      have hl : ps.length = 1 := by
        have h2 := List.length_dropLast (xs := ps)
        rw [hdl, List.length_nil] at h2
        have h3 : ps.length ≠ 0 := fun hc => hpsne (List.eq_nil_of_length_eq_zero hc)
        omega
      exact List.length_eq_one_iff.1 hl
    have hpeq : p = x := by rw [← hjoin, hx]; rfl
    have hnos : '/' ∉ p := by rw [hpeq]; exact (hval x (by rw [hx]; simp)).2.2.2
    rw [getDirectoryL, getNameL, hself, if_neg hp, if_neg hp,
      beforeLastSlash_of_no_slash hnos, afterLastSlash_of_no_slash hnos,
      combineL_eq (show sanitizeL true ([] : List Char) = [] from rfl) hself, if_pos rfl]
  · have hlast : ps.dropLast ++ [ps.getLast hpsne] = ps := List.dropLast_append_getLast hpsne
    have hvlast : ValidPart (ps.getLast hpsne) := hval _ (List.getLast_mem hpsne)
    have hsv : Sanitized true (ps.getLast hpsne) := by
      have h1 : Sanitized true (joinParts [ps.getLast hpsne]) := by
        refine sanitized_parts_sub hs ?_ ?_
        · intro q hq
          rw [List.mem_singleton] at hq
          rw [hq]; exact List.getLast_mem hpsne
        · have := ddPrefix_drop hs.2.1.2 (ps.length - 1)
          rwa [← hps, List.drop_length_sub_one hpsne] at this
      simpa [joinParts] using h1
    have hu : joinParts ps.dropLast ++ '/' :: ps.getLast hpsne = p := by
      rw [← joinParts_append_singleton hdl, hlast, hjoin]
    have hune : joinParts ps.dropLast ≠ [] := by
      rw [Ne, joinParts_eq_nil_iff (fun q hq => (hval q (List.dropLast_subset _ hq)).1)]
      exact hdl
    have hsu : Sanitized true (joinParts ps.dropLast) :=
      sanitized_parts_sub hs (fun q hq => List.dropLast_subset _ hq)
        (by rw [List.dropLast_eq_take]; exact ddPrefix_take hs.2.1.2 _)
    rw [getDirectoryL, getNameL, hself, if_neg hp, if_neg hp, ← hu,
      beforeLastSlash_split hvlast.2.2.2, afterLastSlash_split hvlast.2.2.2,
      combineL_eq (sanitizeL_eq_self hsu) (sanitizeL_eq_self hsv), if_neg hune, if_neg hvlast.1,
      hu, hself]

theorem joinParts_cons {x : Part} {ps : List Part} (hne : ps ≠ []) :
    joinParts (x :: ps) = x ++ '/' :: joinParts ps := by
  cases ps with
  | nil => exact absurd rfl hne
  | cons q qs => rfl

/-- A join of components can be cut at a slash only between two components. -/
theorem joinParts_split {ps : List Part} (hpart : ∀ q ∈ ps, q ≠ [] ∧ '/' ∉ q) {u v : List Char}
    (h : joinParts ps = u ++ '/' :: v) :
    ∃ i, 0 < i ∧ i < ps.length ∧ u = joinParts (ps.take i) ∧ v = joinParts (ps.drop i) := by
  induction ps generalizing u v with
  | nil => simp [joinParts] at h
  | cons x rest ih =>
    cases hrest : rest with
    | nil =>
      subst hrest
      rw [show joinParts [x] = x from rfl] at h
      exact absurd (h ▸ List.mem_append.2 (Or.inr (List.mem_cons_self ..))) (hpart x (by simp)).2
    | cons y ys =>
      subst hrest
      rw [joinParts_cons (by simp)] at h
      rcases List.append_eq_append_iff.1 h with ⟨a', hu, hrestv⟩ | ⟨c', hx, hv⟩
      · cases a' with
        | nil =>
          refine ⟨1, by norm_num, by simp, by simpa using hu, ?_⟩
          simpa using ((by simpa using hrestv : joinParts (y :: ys) = v)).symm
        | cons d a'' =>
          have hd : d = '/' := (by simpa using congrArg (fun l => l.head?) hrestv : '/' = d).symm
          subst hd
          have h2 : joinParts (y :: ys) = a'' ++ '/' :: v := by simpa using hrestv
          obtain ⟨j, hj0, hjl, hja, hjv⟩ := ih (fun q hq => hpart q (by simp [hq])) h2
          refine ⟨j + 1, by omega, by simpa using hjl, ?_, ?_⟩
          · rw [hu, hja, List.take_succ_cons, joinParts_cons ?_]
            intro hc
            rw [List.take_eq_nil_iff] at hc
            rcases hc with hc | hc
            · omega
            · simp at hc
          · simpa using hjv
      · cases c' with
        | nil =>
          refine ⟨1, by norm_num, by simp, by simpa using hx.symm, ?_⟩
          simpa using ((by simpa using hv : v = joinParts (y :: ys)))
        | cons d c'' =>
          have hd : d = '/' := (by simpa using congrArg (fun l => l.head?) hv : '/' = d).symm
          subst hd
          exact absurd (hx ▸ List.mem_append.2 (Or.inr (List.mem_cons_self ..)))
            (hpart x (by simp)).2

/-- A sanitised path never starts with a slash. -/
theorem sanitized_head_ne_slash {aw : Bool} {t : List Char} (h : Sanitized aw ('/' :: t)) :
    False := by
  have hpp : pathParts ('/' :: t) = [] :: splitSlash t := by
    rw [pathParts, if_neg (by simp), splitSlash, if_pos rfl]
  exact (h.2.1.1 [] (by rw [hpp]; simp)).1 rfl

/-- If `location` contains `path`, then combining `location` with the local form
of `path` recovers `path`. -/
theorem combineL_toLocalL {path location : List Char}
    (hp : Sanitized false path) (hl : Sanitized false location)
    (h : containsL location path = true) :
    combineL location (toLocalL path location) = path := by
  have hbp : sanitizeL false path = path := sanitizeL_eq_self hp
  have hbl : sanitizeL false location = location := sanitizeL_eq_self hl
  have hpT : sanitizeL true path = path := sanitizeL_eq_self (sanitized_mono hp)
  have hlT : sanitizeL true location = location := sanitizeL_eq_self (sanitized_mono hl)
  have htl : toLocalL path location =
      if (path.drop location.length).head? = some '/' then (path.drop location.length).tail
      else path.drop location.length := by
    simp only [toLocalL, hbp, hbl]
  rw [containsL] at h
  simp only [hbp, hbl] at h
  split_ifs at h with h1 h2 h3 h4
  · -- `path = location`
    subst h3
    rw [htl, List.drop_length]
    simp only [List.head?_nil, reduceCtorEq, if_false]
    rw [combineL_eq hpT (show sanitizeL true ([] : List Char) = [] from rfl)]
    by_cases he : path = []
    · simp [he]
    · rw [if_neg he, if_pos rfl]
  · -- `location` is the root
    subst h4
    rw [htl, List.length_nil, List.drop_zero]
    have hhead : path.head? ≠ some '/' := by
      intro hc
      cases hcase : path with
      | nil => rw [hcase] at hc; simp at hc
      | cons c cs =>
        rw [hcase] at hc
        simp at hc
        subst hc
        exact sanitized_head_ne_slash (hcase ▸ hp)
    rw [if_neg hhead, combineL_eq (show sanitizeL true ([] : List Char) = [] from rfl) hpT,
      if_pos rfl]
  · -- `location ++ "/"` is a prefix of `path`
    have hpre : (location ++ ['/']) <+: path := by
      simpa using (List.isPrefixOf_iff_prefix.1 h)
    obtain ⟨t, ht⟩ := hpre
    have hpath : path = location ++ '/' :: t := by rw [← ht]; simp
    set ps := pathParts path with hps
    have hpart : ∀ q ∈ ps, q ≠ [] ∧ '/' ∉ q := fun q hq =>
      ⟨(hp.2.1.1 q hq).1, (hp.2.1.1 q hq).2.2.2⟩
    have hjoin : joinParts ps = path := joinParts_pathParts path
    obtain ⟨i, hi0, hil, hiu, hiv⟩ := joinParts_split hpart (by rw [hjoin]; exact hpath)
    have hdropne : ps.drop i ≠ [] := by
      rw [Ne, List.drop_eq_nil_iff]
      omega
    have htne : t ≠ [] := by
      rw [hiv, Ne, joinParts_eq_nil_iff (fun q hq => (hpart q (List.mem_of_mem_drop hq)).1)]
      exact hdropne
    have hst : Sanitized true t := by
      rw [hiv]
      exact sanitized_parts_sub (sanitized_mono hp) (fun q hq => List.mem_of_mem_drop hq)
        (ddPrefix_drop hp.2.1.2 i)
    have hdrop : path.drop location.length = '/' :: t := by
      rw [hpath, List.drop_left]
    rw [htl, hdrop]
    simp only [List.head?_cons, List.tail_cons, if_true]
    rw [combineL_eq hlT (sanitizeL_eq_self hst), if_neg h4, if_neg htne, ← hpath, hpT]

/-! ## Sandbox safety -/

/-- A path that `contains` accepts never escapes upwards: it has no `".."` component. -/
theorem containsL_no_dotdot {path location : List Char} (hp : Sanitized false path)
    (h : containsL location path = true) : dd ∉ pathParts path := by
  have hbp : sanitizeL false path = path := sanitizeL_eq_self hp
  simp only [containsL, hbp] at h
  have h1 : path ≠ dd := by
    intro hc; rw [if_pos hc] at h; simp at h
  rw [if_neg h1] at h
  have h2 : ¬ ((dd ++ ['/']).isPrefixOf path = true) := by
    intro hc; rw [if_pos hc] at h; simp at h
  intro hmem
  obtain ⟨k, rest, hks, hdr⟩ := hp.2.1.2
  have hk : 0 < k := by
    rcases Nat.eq_zero_or_pos k with hk0 | hk0
    · rw [hk0, List.replicate_zero, List.nil_append] at hks
      exact absurd (hks ▸ hmem) hdr
    · exact hk0
  obtain ⟨k', rfl⟩ : ∃ k', k = k' + 1 := ⟨k - 1, by omega⟩
  have hps : pathParts path = dd :: (List.replicate k' dd ++ rest) := by
    rw [hks, List.replicate_succ, List.cons_append]
  have hjoin : joinParts (pathParts path) = path := joinParts_pathParts path
  cases hq : (List.replicate k' dd ++ rest : List Part) with
  | nil =>
    rw [hps, hq] at hjoin
    exact h1 (by simpa [joinParts] using hjoin.symm)
  | cons y ys =>
    have hpe : path = dd ++ '/' :: joinParts (y :: ys) := by
      rw [← hjoin, hps, hq, joinParts_cons (by simp)]
    refine h2 ?_
    rw [List.isPrefixOf_iff_prefix]
    exact ⟨joinParts (y :: ys), by rw [hpe]; simp⟩

/-- Every component of the local path produced by `toLocal` is a component of the
original path. -/
theorem pathParts_toLocalL_subset {path location : List Char}
    (hp : Sanitized false path) (hl : Sanitized false location)
    (h : containsL location path = true) :
    ∀ q ∈ pathParts (toLocalL path location), q ∈ pathParts path := by
  have hbp : sanitizeL false path = path := sanitizeL_eq_self hp
  have hbl : sanitizeL false location = location := sanitizeL_eq_self hl
  have htl : toLocalL path location =
      if (path.drop location.length).head? = some '/' then (path.drop location.length).tail
      else path.drop location.length := by
    simp only [toLocalL, hbp, hbl]
  rw [containsL] at h
  simp only [hbp, hbl] at h
  split_ifs at h with h1 h2 h3 h4
  · subst h3
    rw [htl, List.drop_length]
    simp only [List.head?_nil, reduceCtorEq, if_false]
    intro q hq
    simp [pathParts] at hq
  · subst h4
    rw [htl, List.length_nil, List.drop_zero]
    have hhead : path.head? ≠ some '/' := by
      intro hc
      cases hcase : path with
      | nil => rw [hcase] at hc; simp at hc
      | cons c cs =>
        rw [hcase] at hc
        simp at hc
        subst hc
        exact sanitized_head_ne_slash (hcase ▸ hp)
    rw [if_neg hhead]
    exact fun q hq => hq
  · have hpre : (location ++ ['/']) <+: path := by
      simpa using (List.isPrefixOf_iff_prefix.1 h)
    obtain ⟨t, ht⟩ := hpre
    have hpath : path = location ++ '/' :: t := by rw [← ht]; simp
    set ps := pathParts path with hps
    have hpart : ∀ q ∈ ps, q ≠ [] ∧ '/' ∉ q := fun q hq =>
      ⟨(hp.2.1.1 q hq).1, (hp.2.1.1 q hq).2.2.2⟩
    have hjoin : joinParts ps = path := joinParts_pathParts path
    obtain ⟨i, hi0, hil, hiu, hiv⟩ := joinParts_split hpart (by rw [hjoin]; exact hpath)
    have hdrop : path.drop location.length = '/' :: t := by
      rw [hpath, List.drop_left]
    rw [htl, hdrop]
    simp only [List.head?_cons, List.tail_cons, if_true]
    intro q hq
    rw [hiv, pathParts_joinParts (fun r hr => hpart r (List.mem_of_mem_drop hr))] at hq
    exact List.mem_of_mem_drop hq

/-- The local path handed to a mount by `toLocal` can never escape it: it contains
no `".."` component. -/
theorem toLocalL_no_dotdot {path location : List Char}
    (hp : Sanitized false path) (hl : Sanitized false location)
    (h : containsL location path = true) : dd ∉ pathParts (toLocalL path location) :=
  fun hc => containsL_no_dotdot hp h (pathParts_toLocalL_subset hp hl h dd hc)

end CCFileSystem
