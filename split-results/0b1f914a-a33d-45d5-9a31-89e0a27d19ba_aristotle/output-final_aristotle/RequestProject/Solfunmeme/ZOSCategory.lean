/-
# ZOS as a Category

The Zero Ontology System naturally wants morphisms. Content-addressed objects
(CAOs) are the objects, and semantic transformations are the morphisms.
-/

import Mathlib
import RequestProject.Solfunmeme.EmojiGrammar

namespace ZOSCategory

open EmojiGrammar

/-! ## §1. Content-Addressed Objects -/

structure CAO where
  hash     : Nat
  semantic : SemanticCompound
  deriving DecidableEq, Repr

def hashSemantic (sc : SemanticCompound) : Nat :=
  sc.foldl (fun acc _ => acc * 31 + 1) 0

def ContentAddressed (obj : CAO) : Prop :=
  obj.hash = hashSemantic obj.semantic

/-! ## §2. ZOS Morphisms -/

/-- A morphism in ZOS: a semantic transformation with proof it maps correctly. -/
structure ZOSHom (src dst : CAO) where
  transform : SemanticCompound → SemanticCompound
  maps : transform src.semantic = dst.semantic

/-! ## §3. Identity and Composition -/

def ZOSHom.idHom (x : CAO) : ZOSHom x x where
  transform := fun s => s
  maps := rfl

def ZOSHom.comp {x y z : CAO} (f : ZOSHom x y) (g : ZOSHom y z) : ZOSHom x z where
  transform := g.transform ∘ f.transform
  maps := by simp [Function.comp, f.maps, g.maps]

/-! ## §4. Category Laws (on semantic content) -/

theorem ZOSHom.assoc {w x y z : CAO}
    (f : ZOSHom w x) (g : ZOSHom x y) (h : ZOSHom y z) :
    ((f.comp g).comp h).transform = (f.comp (g.comp h)).transform := by
  ext s; simp [ZOSHom.comp, Function.comp]

/-! ## §5. ZOS as a Directed Graph -/

def ZOSGraph (x y : CAO) : Prop :=
  ∃ _ : ZOSHom x y, True

theorem ZOSGraph.refl (x : CAO) : ZOSGraph x x :=
  ⟨ZOSHom.idHom x, trivial⟩

theorem ZOSGraph.trans {x y z : CAO} :
    ZOSGraph x y → ZOSGraph y z → ZOSGraph x z := by
  intro ⟨f, _⟩ ⟨g, _⟩
  exact ⟨f.comp g, trivial⟩

/-! ## §6. Reachability in ZOS -/

inductive ZOSPath : CAO → CAO → Type where
  | refl : ZOSPath x x
  | step : ZOSHom x y → ZOSPath y z → ZOSPath x z

def ZOSPath.length : ZOSPath x y → Nat
  | .refl => 0
  | .step _ p => p.length + 1

def ZOSPath.concat : ZOSPath x y → ZOSPath y z → ZOSPath x z
  | .refl, p₂ => p₂
  | .step f p₁, p₂ => .step f (p₁.concat p₂)

theorem ZOSPath.concat_length (p₁ : ZOSPath x y) (p₂ : ZOSPath y z) :
    (p₁.concat p₂).length = p₁.length + p₂.length := by
  induction p₁ with
  | refl => simp [ZOSPath.concat, ZOSPath.length]
  | step _ _ ih => simp [ZOSPath.concat, ZOSPath.length, ih]; omega

/-! ## §7. Content-Addressing -/

def contentAddress (sc : SemanticCompound) : CAO where
  hash := hashSemantic sc
  semantic := sc

theorem contentAddress_valid (sc : SemanticCompound) :
    ContentAddressed (contentAddress sc) := by
  simp [ContentAddressed, contentAddress]

theorem contentAddress_deterministic (sc₁ sc₂ : SemanticCompound)
    (h : sc₁ = sc₂) :
    contentAddress sc₁ = contentAddress sc₂ := by rw [h]

/-! ## §8. The SOLFUNMEME Sequences as ZOS Objects -/

def selfReflectionCAO : CAO := contentAddress selfReflectionSeq
def emergentMeaningCAO : CAO := contentAddress emergentMeaningSeq
def consensusCAO : CAO := contentAddress consensusSeq
def evolutionCAO : CAO := contentAddress evolutionSeq

theorem solfunmeme_all_addressed :
    ContentAddressed selfReflectionCAO ∧
    ContentAddressed emergentMeaningCAO ∧
    ContentAddressed consensusCAO ∧
    ContentAddressed evolutionCAO :=
  ⟨contentAddress_valid _, contentAddress_valid _,
   contentAddress_valid _, contentAddress_valid _⟩

end ZOSCategory
