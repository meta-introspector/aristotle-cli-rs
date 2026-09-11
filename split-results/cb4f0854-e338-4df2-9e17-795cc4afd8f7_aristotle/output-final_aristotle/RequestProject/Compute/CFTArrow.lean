/-
# CFTArrow — a renormalization-invariant semantics of arrows

## The slogan, made into mathematics

> Every syntactic object is simultaneously a bit-level excitation, a byte-level
> excitation, an n-gram excitation, a string excitation, a term excitation, an
> emoji excitation, a constant-integer excitation, a list excitation, a
> declaration excitation — *all as the same field*, just seen through different
> renormalization scales.

This module turns that slogan into a small, machine-checked structure.  Two
companion ideas from the rest of the project are reused verbatim:

* the **conformal weight** is `DistanceFromJ.distFromJ` — the integer distance of
  an object's numeric address to the nearest Fourier coefficient of `j(τ)`
  (`MoonshineCore.jCoeff`).  Weight `0` means the object lies *on* the Monster
  CFT (it is a genuine j-coefficient); small weight = a **relevant operator**
  (χ₂, the Leech data, …); large weight = an **irrelevant operator**.

## What is built here

1. `Scale` — the renormalization tower of resolutions
   `bit → byte → ngram → str → term → decl`.

2. `CFTArrow α` — a typeclass saying that a type's inhabitants are **addressed
   morphisms**: each `a : α` has a numeric address `addr a`.  Instances are given
   for `Bool` (a bit), `Char` (an emoji / code point), `ℕ` (a constant integer),
   `String` (a byte string) and `List ℕ` (a list excitation), so that the *same
   value* can be presented at many resolutions.

3. `moonshineWeight a := distFromJ (addr a)` — the scale-invariant conformal
   weight of any arrow, regardless of the type it is observed through.

4. `ScaleArrow` — a **conformal embedding** between two scales: a relabelling of
   addresses that *preserves the weight*.  Scale-preservation is therefore a
   field one must supply (and which we *prove* for the canonical embeddings), not
   an assumed axiom.

5. `ConformalSection` — the **multi-level presence** of one object: a value
   `rep s` at every scale `s`, together with a proof that its weight is the same
   at all scales (`conformal`).  The constant section `constSection n` realises
   "the integer `n`, present at every resolution".

The headline cross-scale theorem, `cross_scale_mckay`, shows McKay's `196883`
carrying weight `1` whether it is read as a constant integer, a singleton list,
or a split list — *the same arrow at different resolutions of the same tower*.
-/

import Mathlib
import RequestProject.Compute.DistanceFromJ

namespace RequestProject.Compute.CFT

open RequestProject.Compute.DistanceFromJ

/-! ## §1. The renormalization tower of scales -/

/-- The resolution scales of the tower, from finest (`bit`) to coarsest
    (`decl`).  A single object is observed at every one of these. -/
inductive Scale
  | bit | byte | ngram | str | term | decl
deriving DecidableEq, Repr

namespace Scale

/-- The position of a scale in the tower (`bit = 0`, …, `decl = 5`). -/
def idx : Scale → ℕ
  | bit => 0 | byte => 1 | ngram => 2 | str => 3 | term => 4 | decl => 5

/-- All six scales, in tower order. -/
def all : List Scale := [bit, byte, ngram, str, term, decl]

/-- Every scale appears in `all`. -/
theorem mem_all (s : Scale) : s ∈ all := by cases s <;> decide

/-- `idx` is injective: the scales are genuinely distinct rungs of the tower. -/
theorem idx_injective : Function.Injective idx := by
  intro a b h; cases a <;> cases b <;> simp_all [idx]

end Scale

/-! ## §2. `CFTArrow`: inhabitants are addressed morphisms -/

/-- A type carries a `CFTArrow` structure when each inhabitant is an **addressed
    morphism** — it has a numeric address.  The address is what the conformal
    weight is measured against, so a single value presented through different
    types (bit, char, list, …) shares one weight. -/
class CFTArrow (α : Type*) where
  /-- The numeric address of an arrow. -/
  addr : α → ℕ

export CFTArrow (addr)

/-- A bit-level excitation: `false ↦ 0`, `true ↦ 1`. -/
instance : CFTArrow Bool := ⟨fun b => if b then 1 else 0⟩

/-- A constant-integer excitation: an integer is its own address. -/
instance : CFTArrow ℕ := ⟨id⟩

/-- An emoji / code-point excitation: a character is addressed by its code point. -/
instance : CFTArrow Char := ⟨fun c => c.toNat⟩

/-- A byte-string excitation: a string is addressed by its big-endian byte value. -/
instance : CFTArrow String := ⟨fun s => s.foldl (fun a c => a * 256 + c.toNat) 0⟩

/-- A list excitation: a list is addressed by the sum of its parts. -/
instance : CFTArrow (List ℕ) := ⟨fun l => l.sum⟩

/-! ## §3. The conformal weight (= distance from J) -/

/-- The **conformal weight** of an arrow: the distance from its address to the
    nearest coefficient of `j(τ)`.  This is the same number for any type the
    address is observed through. -/
def moonshineWeight {α : Type*} [CFTArrow α] (a : α) : ℕ :=
  distFromJ (addr a)

/-- An arrow **lies on the Monster CFT** when its weight is `0` (its address is a
    genuine j-coefficient — a *primary field*). -/
def OnCFT {α : Type*} [CFTArrow α] (a : α) : Prop := moonshineWeight a = 0

/-- An arrow is a **relevant operator** of cutoff `b` when its weight is `≤ b`. -/
def IsRelevant {α : Type*} [CFTArrow α] (a : α) (b : ℕ) : Prop :=
  moonshineWeight a ≤ b

instance {α : Type*} [CFTArrow α] (a : α) : Decidable (OnCFT a) :=
  inferInstanceAs (Decidable (moonshineWeight a = 0))

instance {α : Type*} [CFTArrow α] (a : α) (b : ℕ) : Decidable (IsRelevant a b) :=
  inferInstanceAs (Decidable (moonshineWeight a ≤ b))

/-- The weight only depends on the address, so equal addresses (across *any* two
    types) give equal weight — the formal content of "same field, different
    resolution". -/
theorem weight_eq_of_addr_eq {α β : Type*} [CFTArrow α] [CFTArrow β]
    (a : α) (b : β) (h : addr a = addr b) : moonshineWeight a = moonshineWeight b := by
  unfold moonshineWeight; rw [h]

/-! ## §4. `ScaleArrow`: conformal embeddings between scales -/

/-- A **conformal embedding** from one scale to another: a relabelling `map` of
    addresses that *preserves the conformal weight*.  The `preserves` field is
    the scale-preservation requirement — supplied (and proved) rather than
    assumed as an axiom. -/
structure ScaleArrow where
  src : Scale
  tgt : Scale
  map : ℕ → ℕ
  preserves : ∀ n, distFromJ (map n) = distFromJ n

/-- The identity conformal embedding between any two scales: addresses (and hence
    the direction field) are carried through unchanged. -/
def confEmbed (s t : Scale) : ScaleArrow where
  src := s
  tgt := t
  map := id
  preserves := fun _ => rfl

/-- Composition of conformal embeddings is again conformal. -/
def ScaleArrow.comp (f g : ScaleArrow) : ScaleArrow where
  src := f.src
  tgt := g.tgt
  map := g.map ∘ f.map
  preserves := fun n => by
    simp only [Function.comp_apply]
    rw [g.preserves, f.preserves]

/-- The consecutive rungs of the tower `bit → byte → … → decl`, each a conformal
    embedding. -/
def towerSteps : List ScaleArrow :=
  [ confEmbed .bit .byte, confEmbed .byte .ngram, confEmbed .ngram .str,
    confEmbed .str .term, confEmbed .term .decl ]

/-- Folding the whole tower into a single conformal embedding. -/
def towerFold : ScaleArrow :=
  towerSteps.foldl ScaleArrow.comp (confEmbed .bit .bit)

/-- Climbing the entire tower preserves the conformal weight: an address seen at
    the finest scale has the same weight at the coarsest scale. -/
theorem towerFold_preserves (n : ℕ) : distFromJ (towerFold.map n) = distFromJ n :=
  towerFold.preserves n

/-! ## §5. `ConformalSection`: the multi-level presence of one object -/

/-- The **multi-level presence** of a single object: it has a representative
    `rep s` at every scale `s`, and its conformal weight is the same at all
    scales (`conformal`).  This is the precise sense in which one element is
    "present at all levels at once". -/
structure ConformalSection where
  rep : Scale → ℕ
  conformal : ∀ s t, distFromJ (rep s) = distFromJ (rep t)

/-- The (well-defined) weight of a section, read at the `bit` scale. -/
def ConformalSection.weight (x : ConformalSection) : ℕ := distFromJ (x.rep .bit)

/-- The weight of a section is the same when read at *any* scale. -/
theorem ConformalSection.weight_scale_invariant (x : ConformalSection) (s : Scale) :
    distFromJ (x.rep s) = x.weight :=
  x.conformal s .bit

/-- The constant section: the integer `n`, present at every resolution. -/
def constSection (n : ℕ) : ConformalSection where
  rep := fun _ => n
  conformal := fun _ _ => rfl

@[simp] theorem constSection_weight (n : ℕ) : (constSection n).weight = distFromJ n := rfl

/-- Pushing a section forward along a conformal embedding keeps every weight, so
    the result is again a (constant-weight) section with the same weight. -/
def ConformalSection.push (x : ConformalSection) (f : ScaleArrow) : ConformalSection where
  rep := fun s => f.map (x.rep s)
  conformal := fun s t => by rw [f.preserves, f.preserves]; exact x.conformal s t

theorem ConformalSection.push_weight (x : ConformalSection) (f : ScaleArrow) :
    (x.push f).weight = x.weight := by
  unfold ConformalSection.weight ConformalSection.push
  simp only []
  rw [f.preserves]

/-! ## §6. Worked readings -/

/-- `c(1) = 196884` lies on the Monster CFT, whether read as a constant integer
    or as a list excitation summing to it. -/
theorem onCFT_c1_nat : OnCFT (196884 : ℕ) := by native_decide

theorem onCFT_c1_list : OnCFT ([196884] : List ℕ) := by native_decide

/-- McKay's `χ₂ = 196883` is a relevant operator of weight `1`, presented as a
    constant integer, a singleton list, and a *split* list — the same arrow at
    three resolutions, one weight. -/
theorem cross_scale_mckay :
    moonshineWeight (196883 : ℕ) = 1 ∧
    moonshineWeight ([196883] : List ℕ) = 1 ∧
    moonshineWeight ([100000, 96883] : List ℕ) = 1 := by native_decide

/-- A byte with value `0xF4 = 244` has a well-defined moonshine radius. -/
theorem byte_F4_weight : moonshineWeight (Char.ofNat 244) = distFromJ 244 := by
  native_decide

/-- The constant section of `196884` is on the CFT at every scale (weight `0`). -/
theorem section_c1_on_cft (s : Scale) : distFromJ ((constSection 196884).rep s) = 0 := by
  rw [(constSection 196884).weight_scale_invariant s]; native_decide

/-- The constant section of `196883` carries weight `1` at every scale. -/
theorem section_chi2_weight (s : Scale) : distFromJ ((constSection 196883).rep s) = 1 := by
  rw [(constSection 196883).weight_scale_invariant s]; native_decide

-- #eval moonshineWeight (196883 : ℕ)
-- #eval moonshineWeight (Char.ofNat 244)

end RequestProject.Compute.CFT
