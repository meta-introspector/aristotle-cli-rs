import Mathlib

/-!
# The `hopper.lua` glob matcher, verified

`hopper.lua` selects peripherals and items with a small pattern language
(`src/glob.lua`): a pattern string is a list of alternatives separated by `|`,
each alternative is anchored and matched literally except for `*`, which stands
for any run of characters, and the matcher returns the 1-based index of the
first alternative that matches (or nothing, in particular for the empty
pattern, which deliberately matches nothing).

`matchesStar` is the anchored single-alternative matcher, `GlobMatch` is its
declarative specification, and `matchesStar_iff` proves the two agree.
`globIdx` is the whole function, and the theorems below pin down the index it
returns.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace HopperGlob

/-! ## Matching one alternative -/

/-- The declarative meaning of a pattern: literal characters must agree, `*`
consumes any number of characters. -/
inductive GlobMatch : List Char → List Char → Prop
  /-- The empty pattern matches the empty string. -/
  | nil : GlobMatch [] []
  /-- A literal character must be present. -/
  | char (c : Char) (p s : List Char) : GlobMatch p s → GlobMatch (c :: p) (c :: s)
  /-- `*` may consume nothing. -/
  | starNil (p s : List Char) : GlobMatch p s → GlobMatch ('*' :: p) s
  /-- `*` may consume one more character. -/
  | starCons (c : Char) (p s : List Char) :
      GlobMatch ('*' :: p) s → GlobMatch ('*' :: p) (c :: s)

/-- The matcher `hopper.lua` obtains by turning `*` into `.*` and anchoring the
pattern. -/
def matchesStar : List Char → List Char → Bool
  | [], [] => true
  | [], _ :: _ => false
  | '*' :: p, [] => matchesStar p []
  | '*' :: p, c :: s => matchesStar p (c :: s) || matchesStar ('*' :: p) s
  | _ :: _, [] => false
  | c :: p, d :: s => c == d && matchesStar p s
  termination_by p s => p.length + s.length

/-- **The matcher implements the specification.** -/
theorem matchesStar_iff (p s : List Char) : matchesStar p s = true ↔ GlobMatch p s := by
  induction p, s using matchesStar.induct with
  | case1 => simp [matchesStar, GlobMatch.nil]
  | case2 c s =>
      simp only [matchesStar, Bool.false_eq_true, false_iff]
      intro h
      cases h
  | case3 p ih =>
      rw [matchesStar, ih]
      constructor
      · exact fun h => GlobMatch.starNil p [] h
      · intro h
        cases h with
        | starNil _ _ h => exact h
  | case4 p c s ih1 ih2 =>
      rw [matchesStar, Bool.or_eq_true, ih1, ih2]
      constructor
      · rintro (h | h)
        · exact GlobMatch.starNil _ _ h
        · exact GlobMatch.starCons c p s h
      · intro h
        cases h with
        | char _ _ _ h => exact Or.inr (GlobMatch.starNil _ _ h)
        | starNil _ _ h => exact Or.inl h
        | starCons _ _ _ h => exact Or.inr h
  | case5 c p hc =>
      simp only [matchesStar, Bool.false_eq_true, false_iff]
      intro h
      cases h
      simp_all
  | case6 c p d s hc ih =>
      rw [matchesStar, Bool.and_eq_true, ih]
      constructor
      · rintro ⟨h1, h2⟩
        have : c = d := by simpa using h1
        subst this
        exact GlobMatch.char c p s h2
      · intro h
        cases h with
        | char _ _ _ h => exact ⟨by simp, h⟩
        | starNil _ _ _ => exact (hc rfl).elim
        | starCons _ _ _ _ => exact (hc rfl).elim
      exact hc

/-- A star-free pattern matches only itself. -/
theorem matchesStar_of_star_free (p s : List Char) (hp : '*' ∉ p) :
    matchesStar p s = true ↔ p = s := by
  rw [matchesStar_iff]
  constructor
  · intro h
    induction h with
    | nil => rfl
    | char c p s _ ih => rw [ih (fun hc => hp (List.mem_cons_of_mem c hc))]
    | starNil p s _ _ => exact absurd (List.mem_cons_self) hp
    | starCons c p s _ _ => exact absurd (List.mem_cons_self) hp
  · rintro rfl
    clear hp
    induction p with
    | nil => exact GlobMatch.nil
    | cons c p ih => exact GlobMatch.char c p p ih

/-- **A lone `*` matches everything.** -/
theorem matchesStar_star (s : List Char) : matchesStar ['*'] s = true := by
  rw [matchesStar_iff]
  induction s with
  | nil => exact GlobMatch.starNil [] [] GlobMatch.nil
  | cons c s ih => exact GlobMatch.starCons c [] s ih

/-! ## Alternatives -/

/-- Split a pattern string at its `|` separators. -/
def splitBar : List Char → List (List Char)
  | [] => [[]]
  | c :: rest =>
      if c = '|' then [] :: splitBar rest
      else
        match splitBar rest with
        | a :: as => (c :: a) :: as
        | [] => [[c]]

/-- The alternatives of a pattern string: the nonempty pieces between `|`s,
exactly what the Lua `gmatch "[^|]+"` produces. -/
def alts (ps : List Char) : List (List Char) := (splitBar ps).filter (fun a => !a.isEmpty)

/-- `glob`: the 1-based index of the first matching alternative, or `none`.
The empty pattern matches nothing. -/
def globIdx (ps s : List Char) : Option ℕ :=
  if ps.isEmpty then none
  else ((alts ps).findIdx? (fun p => matchesStar p s)).map (· + 1)

/-- Convenience wrapper on strings. -/
def globStr (ps s : String) : Option ℕ := globIdx ps.toList s.toList

#guard globStr "" "minecraft:stone" == none
#guard globStr "*" "minecraft:stone" == some 1
#guard globStr "minecraft:*" "minecraft:stone" == some 1
#guard globStr "mekanism:*|minecraft:*" "minecraft:stone" == some 2
#guard globStr "mekanism:*|*:dirt" "minecraft:stone" == none
#guard globStr "*dust*" "mekanism:dust_iron" == some 1

/-- **The empty pattern matches nothing.** -/
theorem globIdx_nil (s : List Char) : globIdx [] s = none := rfl

/-- **A returned index is the position of a matching alternative**, counting
from one. -/
theorem globIdx_eq_some {ps s : List Char} {i : ℕ} (h : globIdx ps s = some i) :
    1 ≤ i ∧ ∃ p, (alts ps)[i - 1]? = some p ∧ matchesStar p s = true := by
  unfold globIdx at h
  split at h
  · exact absurd h (by simp)
  · simp only [Option.map_eq_some_iff] at h
    obtain ⟨j, hj, rfl⟩ := h
    have hmem := List.findIdx?_eq_some_iff_getElem.mp hj
    obtain ⟨hlt, hmatch, -⟩ := hmem
    refine ⟨by omega, (alts ps)[j], ?_, hmatch⟩
    simp [List.getElem?_eq_getElem hlt]

/-- **No earlier alternative matches**: the index really is the first one. -/
theorem globIdx_first {ps s : List Char} {i : ℕ} (h : globIdx ps s = some i)
    (j : ℕ) (hj : j < i - 1) (p : List Char) (hp : (alts ps)[j]? = some p) :
    matchesStar p s = false := by
  unfold globIdx at h
  split at h
  · exact absurd h (by simp)
  · simp only [Option.map_eq_some_iff] at h
    obtain ⟨k, hk, rfl⟩ := h
    obtain ⟨hklt, hkmatch, hbefore⟩ := List.findIdx?_eq_some_iff_getElem.mp hk
    have hjk : j < k := by omega
    have hjlt : j < (alts ps).length := by
      have := List.getElem?_eq_some_iff.mp hp
      exact this.1
    have := hbefore j hjk
    have hpe : (alts ps)[j] = p := by
      have h' := List.getElem?_eq_some_iff.mp hp
      simpa using h'.2
    simpa [hpe] using this

/-- **If nothing is returned, nothing matched.** -/
theorem globIdx_eq_none {ps s : List Char} (hps : ps ≠ []) (h : globIdx ps s = none)
    (p : List Char) (hp : p ∈ alts ps) : matchesStar p s = false := by
  unfold globIdx at h
  rw [if_neg (by simpa using hps)] at h
  simp only [Option.map_eq_none_iff] at h
  have := List.findIdx?_eq_none_iff.mp h
  simpa using this p hp

end HopperGlob
