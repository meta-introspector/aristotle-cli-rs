/-
# ScaleCategory — the renormalization tower as a genuine category

This module turns the renormalization tower of `RequestProject.Compute.CFTArrow`
into a *category* and shows that the conformal weight (`moonshineWeight =
distFromJ ∘ addr`) is a **functorial invariant** — literally a natural
transformation on the scale tower.

## What is built here

1. **`ScaleHom` / the `Category Scale` instance.**  A morphism `s ⟶ t` is a
   relabelling `map : ℕ → ℕ` of addresses that *preserves the conformal weight*.
   Identity is `confEmbed`, composition is function composition, and the category
   laws (`id_comp`, `comp_id`, `assoc`) all hold.

2. **`addrFunctor` and `weightNat`.**  `addrFunctor : Scale ⥤ Type` sends every
   rung to the address line `ℕ` and every conformal embedding to its underlying
   map.  The conformal weight is then a *natural transformation*
   `weightNat : addrFunctor ⟶ (const ℕ)` whose naturality square is exactly weight
   preservation.  This is the precise sense of "Moonshine is a natural
   transformation on the scale tower."

3. **Lossy conformal embeddings.**  `coarsenNgram`, `tokenizeStr` and
   `eraseDeclDetail` lose syntactic detail yet preserve the *address*, hence the
   j-spectrum coordinate: `*_preserves_weight`.  Information loss at the syntactic
   level does not move a field in the spectrum.

4. **A second (Hecke / DA51) spectral coordinate.**  `heckeWeight a : ℤ` is a
   `T₁₉`-residue of the address.  Together with `moonshineWeight` it gives a point
   `spectralPoint a` in a 2-D spectral plane, preserved by address-preserving
   embeddings.  Primaries are characterized by a joint constraint
   (`primary_iff_moonshine_hecke`).

5. **CRT coordinates.**  `addrCRT a` records the address modulo the supersingular
   primes `71, 59, 47`.  Since `71·59·47 = 196883 = χ₂`, the CRT coordinate is a
   *faithful* label for any address below `χ₂` (`addr_eq_iff_crt_eq`).

6. **Clifford blade label.**  `bladeOfAddr a` is the set of generators of the
   Clifford basis blade indexed by the binary support of the address, with grade
   `bladeGrade a`.  Weight invariance refines to blade invariance under
   address-preserving embeddings (`*_preserves_blade`, `*_preserves_grade`).
-/

import Mathlib
import RequestProject.Compute.CFTArrow

namespace RequestProject.Compute.CFT

open RequestProject.Compute.DistanceFromJ
open CategoryTheory

/-! ## §1. `ScaleHom` and the category `Scale` -/

/-- A morphism of the scale category: a relabelling `map` of addresses that
    *preserves the conformal weight* (`distFromJ`).  The source and target scales
    are recorded as type indices, so these compose like genuine arrows. -/
structure ScaleHom (s t : Scale) where
  /-- The underlying relabelling of addresses. -/
  map : ℕ → ℕ
  /-- Weight preservation: the defining "conformal" condition. -/
  preserves : ∀ n, distFromJ (map n) = distFromJ n

namespace ScaleHom

/-- Two scale morphisms are equal as soon as their underlying maps agree
    (the `preserves` field is a proposition). -/
@[ext] theorem ext {s t : Scale} {f g : ScaleHom s t} (h : f.map = g.map) : f = g := by
  cases f; cases g; cases h; rfl

/-- The identity morphism on a scale. -/
def id' (s : Scale) : ScaleHom s s := ⟨_root_.id, fun _ => rfl⟩

/-- Composition of scale morphisms (function composition of the address maps). -/
def comp {s t u : Scale} (f : ScaleHom s t) (g : ScaleHom t u) : ScaleHom s u where
  map := g.map ∘ f.map
  preserves := fun n => by
    simp only [Function.comp_apply]; rw [g.preserves, f.preserves]

end ScaleHom

/-- The scale tower is a category: objects are resolutions, morphisms are
    weight-preserving address relabellings. -/
instance : Category Scale where
  Hom := ScaleHom
  id := ScaleHom.id'
  comp := ScaleHom.comp
  id_comp := by intro X Y f; apply ScaleHom.ext; rfl
  comp_id := by intro X Y f; apply ScaleHom.ext; rfl
  assoc := by intro W X Y Z f g h; apply ScaleHom.ext; rfl

/-- The identity arrow is `confEmbed` (an honest categorical identity). -/
theorem id_eq_confEmbed (s : Scale) : (𝟙 s : ScaleHom s s).map = id := rfl

/-- Every previously-defined `ScaleArrow` is a morphism of `Scale`. -/
def ScaleArrow.toHom (a : ScaleArrow) : ScaleHom a.src a.tgt := ⟨a.map, a.preserves⟩

/-! ## §2. The weight as a functorial invariant -/

/-- The address line, seen as a functor on the scale tower: every rung is the
    address space `ℕ`, every conformal embedding acts by its map. -/
def addrFunctor : Scale ⥤ Type where
  obj := fun _ => ℕ
  map := fun {_ _} f => f.map
  map_id := fun _ => rfl
  map_comp := fun _ _ => rfl

/-- **Moonshine is a natural transformation.**  The conformal weight `distFromJ`
    is a natural transformation from the address functor to the constant functor
    at `ℕ`; its naturality square is precisely weight preservation. -/
def weightNat : addrFunctor ⟶ (Functor.const Scale).obj ℕ where
  app := fun _ => distFromJ
  naturality := fun {_ _} f => by
    funext n
    simp only [addrFunctor, types_comp_apply, Functor.const_obj_map, types_id_apply]
    exact f.preserves n

/-- Spelled-out naturality: pushing an address along any conformal embedding and
    then taking weight equals taking weight directly. -/
theorem weight_natural {s t : Scale} (f : ScaleHom s t) (n : ℕ) :
    distFromJ (f.map n) = distFromJ n := f.preserves n

/-! ## §3. Lossy conformal embeddings -/

/-- **Coarsen n-grams to a string-level address** by merging the overlapping
    n-grams into their summed address.  Lossy on list structure, exact on the
    address. -/
def coarsenNgram (l : List ℕ) : ℕ := l.sum

/-- **Tokenize a string to a term-level address.**  Lossy on the byte layout,
    exact on the address. -/
def tokenizeStr (s : String) : ℕ := addr s

/-- A declaration arrow: a semantic address together with droppable syntactic
    detail. -/
structure DeclArrow where
  /-- The semantic address — the part the j-spectrum sees. -/
  semAddr : ℕ
  /-- Droppable syntactic detail. -/
  detail : List ℕ
deriving Repr

/-- A declaration is addressed by its semantic address. -/
instance : CFTArrow DeclArrow := ⟨DeclArrow.semAddr⟩

/-- **Erase declaration detail** while keeping the semantic address. -/
def eraseDeclDetail (d : DeclArrow) : DeclArrow := { d with detail := [] }

/-- Coarsening n-grams preserves the conformal weight. -/
theorem coarsenNgram_preserves_weight (l : List ℕ) :
    moonshineWeight (coarsenNgram l) = moonshineWeight l :=
  weight_eq_of_addr_eq _ _ rfl

/-- Tokenizing a string preserves the conformal weight. -/
theorem tokenizeStr_preserves_weight (s : String) :
    moonshineWeight (tokenizeStr s) = moonshineWeight s :=
  weight_eq_of_addr_eq _ _ rfl

/-- Erasing declaration detail preserves the conformal weight. -/
theorem eraseDeclDetail_preserves_weight (d : DeclArrow) :
    moonshineWeight (eraseDeclDetail d) = moonshineWeight d :=
  weight_eq_of_addr_eq _ _ rfl

/-! ## §4. A second (Hecke / DA51) spectral coordinate -/

/-- The Hecke prime of the DA51 recipe (the `T₁₉` slot from the sheaf metadata). -/
def heckePrime : ℕ := 19

/-- The Hecke residue of a raw address: a `T₁₉`-style spectral coordinate. -/
def heckeOfAddr (n : ℕ) : ℤ := (n : ℤ) % (heckePrime : ℤ)

/-- The **Hecke weight** of an arrow: a second spectral coordinate, independent of
    `moonshineWeight`. -/
def heckeWeight {α : Type*} [CFTArrow α] (a : α) : ℤ := heckeOfAddr (addr a)

/-- Equal addresses give equal Hecke weight (across any two types). -/
theorem heckeWeight_eq_of_addr_eq {α β : Type*} [CFTArrow α] [CFTArrow β]
    (a : α) (b : β) (h : addr a = addr b) : heckeWeight a = heckeWeight b := by
  unfold heckeWeight; rw [h]

/-- The **joint spectral point** of an arrow in the `(moonshine, hecke)` plane. -/
def spectralPoint {α : Type*} [CFTArrow α] (a : α) : ℕ × ℤ :=
  (moonshineWeight a, heckeWeight a)

/-- "Same field, different resolution" is now "same point in the joint spectrum":
    equal addresses give the same spectral point. -/
theorem spectralPoint_eq_of_addr_eq {α β : Type*} [CFTArrow α] [CFTArrow β]
    (a : α) (b : β) (h : addr a = addr b) : spectralPoint a = spectralPoint b := by
  unfold spectralPoint
  rw [weight_eq_of_addr_eq a b h, heckeWeight_eq_of_addr_eq a b h]

/-- A **joint primary**: a field at the origin of the spectral plane (genuine
    j-coefficient *and* trivial Hecke residue). -/
def IsJointPrimary {α : Type*} [CFTArrow α] (a : α) : Prop :=
  moonshineWeight a = 0 ∧ heckeWeight a = 0

/-- Joint primaries are characterized by the joint constraint on both
    coordinates — i.e. landing at the spectral origin `(0, 0)`. -/
theorem primary_iff_moonshine_hecke {α : Type*} [CFTArrow α] (a : α) :
    IsJointPrimary a ↔ spectralPoint a = (0, 0) := by
  unfold IsJointPrimary spectralPoint
  rw [Prod.mk.injEq]

/-- Conformal *identity* embeddings preserve the Hecke coordinate. -/
theorem confEmbed_preserves_hecke (s t : Scale) (n : ℕ) :
    heckeOfAddr ((confEmbed s t).map n) = heckeOfAddr n := by
  norm_num [confEmbed]

/-- Folding the whole tower preserves the Hecke coordinate (analogue of
    `towerFold_preserves`). -/
theorem towerFold_preserves_hecke (n : ℕ) :
    heckeOfAddr (towerFold.map n) = heckeOfAddr n := by
  convert RequestProject.Compute.CFT.confEmbed_preserves_hecke .bit .decl n using 1

/-- Lossy coarsening preserves the Hecke coordinate too. -/
theorem coarsenNgram_preserves_hecke (l : List ℕ) :
    heckeWeight (coarsenNgram l) = heckeWeight l :=
  heckeWeight_eq_of_addr_eq _ _ rfl

/-! ## §5. CRT coordinates over the supersingular primes -/

/-- The supersingular Monster primes whose product is `χ₂ = 196883`. -/
def crtPrimes : List ℕ := [71, 59, 47]

/-- `71 · 59 · 47 = 196883`. -/
theorem crtPrimes_prod : crtPrimes.prod = 196883 := by native_decide

/-- The CRT coordinate of an address: its residues modulo `71, 59, 47`. -/
def addrCRT {α : Type*} [CFTArrow α] (a : α) : ℕ × ℕ × ℕ :=
  (addr a % 71, addr a % 59, addr a % 47)

/-- Equal addresses give equal CRT coordinates. -/
theorem addrCRT_eq_of_addr_eq {α β : Type*} [CFTArrow α] [CFTArrow β]
    (a : α) (b : β) (h : addr a = addr b) : addrCRT a = addrCRT b := by
  unfold addrCRT; rw [h]

/-- **Faithfulness of the CRT label below `χ₂`.**  For addresses smaller than
    `71·59·47 = 196883`, two arrows share an address iff they share their CRT
    coordinate. -/
theorem addr_eq_iff_crt_eq {α : Type*} [CFTArrow α] (a b : α)
    (ha : addr a < 196883) (hb : addr b < 196883) :
    addr a = addr b ↔ addrCRT a = addrCRT b := by
  unfold addrCRT
  constructor
  · intro h; rw [h]
  · intro h
    have h_mod : (addr a : ℤ) ≡ (addr b : ℤ) [ZMOD (71 * 59 * 47)] := by
      rw [Int.ModEq]; norm_cast; simp_all +decide [Nat.mod_eq_of_lt]; omega
    exact Nat.mod_eq_of_lt ha ▸ Nat.mod_eq_of_lt hb ▸ mod_cast h_mod

/-! ## §6. Clifford blade label -/

/-- The set of generators of the Clifford basis blade indexed by the binary
    support of `n` (bit `i` set ⟺ generator `eᵢ` present). -/
def bladeSupport (n : ℕ) : Finset ℕ :=
  (Finset.range (n + 1)).filter (fun i => n.testBit i)

/-- The Clifford basis blade attached to an arrow's address. -/
def bladeOfAddr {α : Type*} [CFTArrow α] (a : α) : Finset ℕ := bladeSupport (addr a)

/-- The grade of an arrow's blade (the number of generators in the blade). -/
def bladeGrade {α : Type*} [CFTArrow α] (a : α) : ℕ := (bladeOfAddr a).card

/-- Equal addresses give the same blade. -/
theorem bladeOfAddr_eq_of_addr_eq {α β : Type*} [CFTArrow α] [CFTArrow β]
    (a : α) (b : β) (h : addr a = addr b) : bladeOfAddr a = bladeOfAddr b := by
  unfold bladeOfAddr; rw [h]

/-- Equal addresses give the same grade — weight invariance refines to a grade
    constraint in the Clifford algebra. -/
theorem bladeGrade_eq_of_addr_eq {α β : Type*} [CFTArrow α] [CFTArrow β]
    (a : α) (b : β) (h : addr a = addr b) : bladeGrade a = bladeGrade b := by
  unfold bladeGrade; rw [bladeOfAddr_eq_of_addr_eq a b h]

/-- Erasing declaration detail keeps the entire Clifford blade. -/
theorem eraseDeclDetail_preserves_blade (d : DeclArrow) :
    bladeOfAddr (eraseDeclDetail d) = bladeOfAddr d :=
  bladeOfAddr_eq_of_addr_eq _ _ rfl

/-- Coarsening n-grams keeps the blade grade. -/
theorem coarsenNgram_preserves_grade (l : List ℕ) :
    bladeGrade (coarsenNgram l) = bladeGrade l :=
  bladeGrade_eq_of_addr_eq _ _ rfl

/-! ## §7. Worked readings -/

/-- `c(1) = 196884` is a genuine primary on the moonshine axis but carries Hecke
    residue `6`, so it is *not* a joint primary. -/
theorem c1_spectralPoint : spectralPoint (196884 : ℕ) = (0, 6) := by native_decide

/-- McKay's `χ₂ = 196883` sits at spectral point `(1, 5)` whether read as an
    integer or as a singleton list — one arrow, one point in the joint plane. -/
theorem chi2_spectralPoint :
    spectralPoint (196883 : ℕ) = (1, 5) ∧
    spectralPoint ([196883] : List ℕ) = (1, 5) := by native_decide

/-- The CRT coordinate of `χ₂ = 196883` is the all-zero residue (it is the
    product `71·59·47`). -/
theorem chi2_addrCRT : addrCRT (196883 : ℕ) = (0, 0, 0) := by native_decide

end RequestProject.Compute.CFT