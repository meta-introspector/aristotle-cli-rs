import RequestProject.Anim.Easing

/-!
# Keyframe tracks

The formal counterpart of the keyframe sampler in `web/js/timeline.js`.

A *track* is a list of keys, each carrying a time, a value and the easing that
governs the segment starting at that key.  `sample` reads the track at a time:
it holds the first value before the track starts, holds the last value after it
ends, and eases between consecutive keys in between.

The theorems below are the guarantees the studio's timeline relies on:

* `sample_head_of_le` — before the first key the first value is held;
* `sample_getLast_of_le` — after the last key the last value is held;
* `sample_key_eq` — every key is hit exactly at its own time;
* `le_sample` / `sample_le` — a sampled channel never leaves the range spanned
  by the key values, whatever easing is used.
-/

namespace Hesper.Anim

open Easing

/-- One keyframe: a time, a value, and the easing used on the segment that
starts here. -/
structure Key where
  /-- Time of the key, in seconds. -/
  t : ℝ
  /-- Value of the channel at that time. -/
  v : ℝ
  /-- Easing applied on the segment from this key to the next. -/
  ease : Easing

/-- A track is a list of keys, meant to be sorted by time. -/
abbrev Track := List Key

/-- A track is *ordered* when its key times are strictly increasing. -/
def Track.Ordered (ks : Track) : Prop := List.IsChain (fun a b => a.t < b.t) ks

namespace Track

theorem Ordered.of_cons {a : Key} {tl : Track} (h : Track.Ordered (a :: tl)) : Track.Ordered tl := by
  cases tl with
  | nil => simp [Ordered]
  | cons b rest => exact (List.isChain_cons_cons.mp h).2

theorem Ordered.head_lt {a b : Key} {tl : Track} (h : Track.Ordered (a :: b :: tl)) : a.t < b.t :=
  (List.isChain_cons_cons.mp h).1

/-- On an ordered track every later key is strictly later in time. -/
theorem Ordered.lt_of_mem_tail : ∀ (a : Key) (tl : Track), Track.Ordered (a :: tl) →
    ∀ k ∈ tl, a.t < k.t := by
  intro a tl
  induction tl generalizing a with
  | nil => intro _ k hk; simp at hk
  | cons b rest ih =>
    intro hord k hk
    have hab : a.t < b.t := Ordered.head_lt hord
    have htail : Track.Ordered (b :: rest) := Ordered.of_cons hord
    rcases List.mem_cons.mp hk with rfl | hk'
    · exact hab
    · exact lt_trans hab (ih b htail k hk')

/-- The last key of an ordered track is not earlier than its first. -/
theorem Ordered.head_le_getLast : ∀ (k : Key) (ks : Track), Track.Ordered (k :: ks) →
    k.t ≤ ((k :: ks).getLast (List.cons_ne_nil _ _)).t := by
  intro k ks
  induction ks generalizing k with
  | nil => intro _; simp
  | cons k' rest ih =>
    intro hord
    have h := List.isChain_cons_cons.mp hord
    have hrec := ih k' h.2
    rw [List.getLast_cons_cons]
    exact le_trans h.1.le hrec

end Track

namespace Key

/-- Eased interpolation from `k` to `k'` at time `t`.  Degenerate segments
(where the next key is not later) jump straight to the next value. -/
noncomputable def interp (k k' : Key) (t : ℝ) : ℝ :=
  if k'.t ≤ k.t then k'.v
  else k.v + (k'.v - k.v) * k.ease ((t - k.t) / (k'.t - k.t))

@[simp] theorem interp_of_degenerate {k k' : Key} (h : k'.t ≤ k.t) (t : ℝ) :
    k.interp k' t = k'.v := by
  simp [interp, h]

theorem interp_left {k k' : Key} (h : k.t < k'.t) : k.interp k' k.t = k.v := by
  have hne : ¬ k'.t ≤ k.t := not_le.mpr h
  simp [interp, hne, k.ease.map_zero]

theorem interp_right {k k' : Key} (h : k.t < k'.t) : k.interp k' k'.t = k'.v := by
  have hne : ¬ k'.t ≤ k.t := not_le.mpr h
  have hsub : k'.t - k.t ≠ 0 := sub_ne_zero.mpr (ne_of_gt h)
  simp [interp, hne, div_self hsub, k.ease.map_one]

/-- Interpolation between two keys never leaves the interval spanned by their
values: lower bound. -/
theorem le_interp {k k' : Key} {m t : ℝ} (hm : m ≤ k.v) (hm' : m ≤ k'.v)
    (hlt : k.t < t) (hle : t ≤ k'.t) : m ≤ k.interp k' t := by
  have hne : ¬ k'.t ≤ k.t := not_le.mpr (lt_of_lt_of_le hlt hle)
  have hspan : 0 < k'.t - k.t := by linarith [lt_of_lt_of_le hlt hle]
  set u : ℝ := (t - k.t) / (k'.t - k.t) with hu
  have hu0 : 0 ≤ u := by
    apply div_nonneg <;> linarith
  have hu1 : u ≤ 1 := by
    rw [hu, div_le_one hspan]; linarith
  have he0 : 0 ≤ k.ease u := k.ease.nonneg hu0 hu1
  have he1 : k.ease u ≤ 1 := k.ease.le_one hu0 hu1
  simp only [interp, hne, if_false, ← hu]
  nlinarith

/-- Interpolation between two keys never leaves the interval spanned by their
values: upper bound. -/
theorem interp_le {k k' : Key} {M t : ℝ} (hM : k.v ≤ M) (hM' : k'.v ≤ M)
    (hlt : k.t < t) (hle : t ≤ k'.t) : k.interp k' t ≤ M := by
  have hne : ¬ k'.t ≤ k.t := not_le.mpr (lt_of_lt_of_le hlt hle)
  have hspan : 0 < k'.t - k.t := by linarith [lt_of_lt_of_le hlt hle]
  set u : ℝ := (t - k.t) / (k'.t - k.t) with hu
  have hu0 : 0 ≤ u := by
    apply div_nonneg <;> linarith
  have hu1 : u ≤ 1 := by
    rw [hu, div_le_one hspan]; linarith
  have he0 : 0 ≤ k.ease u := k.ease.nonneg hu0 hu1
  have he1 : k.ease u ≤ 1 := k.ease.le_one hu0 hu1
  simp only [interp, hne, if_false, ← hu]
  nlinarith

end Key

/-- Sample a track at time `t`. -/
noncomputable def sample : Track → ℝ → ℝ
  | [], _ => 0
  | [k], _ => k.v
  | k :: k' :: rest, t =>
      if t ≤ k.t then k.v
      else if t ≤ k'.t then k.interp k' t
      else sample (k' :: rest) t

@[simp] theorem sample_nil (t : ℝ) : sample [] t = 0 := rfl

@[simp] theorem sample_singleton (k : Key) (t : ℝ) : sample [k] t = k.v := rfl

theorem sample_cons_cons (k k' : Key) (rest : Track) (t : ℝ) :
    sample (k :: k' :: rest) t =
      if t ≤ k.t then k.v else if t ≤ k'.t then k.interp k' t else sample (k' :: rest) t := rfl

/-- Before the first key, the first value is held. -/
theorem sample_head_of_le (k : Key) (ks : Track) {t : ℝ} (h : t ≤ k.t) :
    sample (k :: ks) t = k.v := by
  cases ks with
  | nil => simp
  | cons k' rest => simp [sample_cons_cons, h]

/-- After the last key, the last value is held. -/
theorem sample_getLast_of_le : ∀ (ks : Track), Track.Ordered ks → ∀ (h : ks ≠ []) (t : ℝ),
    (ks.getLast h).t ≤ t → sample ks t = (ks.getLast h).v := by
  intro ks
  induction ks with
  | nil => intro _ h; exact absurd rfl h
  | cons a tl ih =>
    intro hord _ t ht
    cases tl with
    | nil => simp
    | cons b rest =>
      have hab : a.t < b.t := Track.Ordered.head_lt hord
      have htail : Track.Ordered (b :: rest) := Track.Ordered.of_cons hord
      have hlastEq : ((a :: b :: rest).getLast (List.cons_ne_nil _ _))
          = ((b :: rest).getLast (List.cons_ne_nil _ _)) := List.getLast_cons_cons
      have hbL : b.t ≤ ((b :: rest).getLast (List.cons_ne_nil _ _)).t :=
        Track.Ordered.head_le_getLast b rest htail
      have htL : ((b :: rest).getLast (List.cons_ne_nil _ _)).t ≤ t := by
        rw [hlastEq] at ht; exact ht
      have hnotA : ¬ t ≤ a.t := by
        have : a.t < t := lt_of_lt_of_le hab (le_trans hbL htL)
        exact not_le.mpr this
      rw [sample_cons_cons, if_neg hnotA, hlastEq]
      by_cases hb : t ≤ b.t
      · -- `t` is squeezed onto `b.t`, so `b` must already be the last key
        have hEq : t = b.t := le_antisymm hb (le_trans hbL htL)
        have hrest : rest = [] := by
          cases rest with
          | nil => rfl
          | cons r rs =>
            exfalso
            have h1 : b.t < r.t := Track.Ordered.head_lt htail
            have h2 : r.t ≤ ((r :: rs).getLast (List.cons_ne_nil _ _)).t :=
              Track.Ordered.head_le_getLast r rs (Track.Ordered.of_cons htail)
            have h3 : ((b :: r :: rs).getLast (List.cons_ne_nil _ _))
                = ((r :: rs).getLast (List.cons_ne_nil _ _)) := List.getLast_cons_cons
            rw [h3] at htL
            have : b.t < t := lt_of_lt_of_le h1 (le_trans h2 htL)
            exact absurd hEq (ne_of_gt this)
        subst hrest
        simp [hEq, Key.interp_right hab]
      · rw [if_neg hb]
        exact ih htail (List.cons_ne_nil _ _) t htL

/-- Every key is reached exactly at its own time, on an ordered track. -/
theorem sample_key_eq : ∀ (ks : Track), Track.Ordered ks → ∀ k ∈ ks, sample ks k.t = k.v := by
  intro ks
  induction ks with
  | nil => intro _ k hk; simp at hk
  | cons a tl ih =>
    intro hord k hk
    cases tl with
    | nil =>
      rcases List.mem_cons.mp hk with rfl | hk'
      · simp
      · simp at hk'
    | cons b rest =>
      have hab : a.t < b.t := Track.Ordered.head_lt hord
      have htail : Track.Ordered (b :: rest) := Track.Ordered.of_cons hord
      rcases List.mem_cons.mp hk with rfl | hk'
      · rw [sample_cons_cons, if_pos le_rfl]
      · have hbk : b.t ≤ k.t := by
          rcases List.mem_cons.mp hk' with rfl | hk''
          · exact le_rfl
          · exact (Track.Ordered.lt_of_mem_tail b rest htail k hk'').le
        have hnotA : ¬ k.t ≤ a.t := not_le.mpr (lt_of_lt_of_le hab hbk)
        rw [sample_cons_cons, if_neg hnotA]
        by_cases hb : k.t ≤ b.t
        · have hEq : k.t = b.t := le_antisymm hb hbk
          have hkb : k = b := by
            rcases List.mem_cons.mp hk' with rfl | hk''
            · rfl
            · exact absurd hEq (ne_of_gt (Track.Ordered.lt_of_mem_tail b rest htail k hk''))
          subst hkb
          rw [if_pos hb, Key.interp_right hab]
        · rw [if_neg hb]
          exact ih htail k hk'

/-- A sampled channel never drops below a lower bound of the key values. -/
theorem le_sample : ∀ (ks : Track), ks ≠ [] → ∀ {m : ℝ}, (∀ k ∈ ks, m ≤ k.v) →
    ∀ t : ℝ, m ≤ sample ks t := by
  intro ks
  induction ks with
  | nil => intro h; exact absurd rfl h
  | cons a tl ih =>
    intro _ m hm t
    cases tl with
    | nil => simpa using hm a (by simp)
    | cons b rest =>
      have hma : m ≤ a.v := hm a (by simp)
      have hmb : m ≤ b.v := hm b (by simp)
      rw [sample_cons_cons]
      by_cases ha : t ≤ a.t
      · simpa [ha] using hma
      · rw [if_neg ha]
        by_cases hb : t ≤ b.t
        · rw [if_pos hb]
          exact Key.le_interp hma hmb (not_le.mp ha) hb
        · rw [if_neg hb]
          exact ih (List.cons_ne_nil _ _) (fun k hk => hm k (List.mem_cons_of_mem _ hk)) t

/-- A sampled channel never rises above an upper bound of the key values. -/
theorem sample_le : ∀ (ks : Track), ks ≠ [] → ∀ {M : ℝ}, (∀ k ∈ ks, k.v ≤ M) →
    ∀ t : ℝ, sample ks t ≤ M := by
  intro ks
  induction ks with
  | nil => intro h; exact absurd rfl h
  | cons a tl ih =>
    intro _ M hM t
    cases tl with
    | nil => simpa using hM a (by simp)
    | cons b rest =>
      have hMa : a.v ≤ M := hM a (by simp)
      have hMb : b.v ≤ M := hM b (by simp)
      rw [sample_cons_cons]
      by_cases ha : t ≤ a.t
      · simpa [ha] using hMa
      · rw [if_neg ha]
        by_cases hb : t ≤ b.t
        · rw [if_pos hb]
          exact Key.interp_le hMa hMb (not_le.mp ha) hb
        · rw [if_neg hb]
          exact ih (List.cons_ne_nil _ _) (fun k hk => hM k (List.mem_cons_of_mem _ hk)) t

/-- A track whose keys all carry the same value is constant. -/
theorem sample_const (ks : Track) (h : ks ≠ []) {c : ℝ} (hc : ∀ k ∈ ks, k.v = c) (t : ℝ) :
    sample ks t = c :=
  le_antisymm (sample_le ks h (fun k hk => (hc k hk).le) t)
    (le_sample ks h (fun k hk => (hc k hk).ge) t)

end Hesper.Anim
