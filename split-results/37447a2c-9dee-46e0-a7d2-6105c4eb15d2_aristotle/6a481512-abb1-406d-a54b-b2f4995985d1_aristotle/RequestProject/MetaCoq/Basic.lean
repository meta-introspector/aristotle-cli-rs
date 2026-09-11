/-
  MetaCoq Kernel Term Language - Basic Types

  Formalization in Lean 4 of the MetaCoq kernel data structures,
  reconstructed from Template Haskell reification data in
  `Server.MetaCoq.TestMeta4`.
-/

set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace MetaCoq

/-! ## Primitive types -/

/-- String type used throughout MetaCoq (maps to Coq's `string` / bytestring). -/
def MyString := String
  deriving Inhabited, DecidableEq, Repr

/-- Identifiers are strings. Corresponds to `ident` in MetaCoq. -/
def Ident := MyString
  deriving Inhabited, DecidableEq, Repr

/-- Directory paths are lists of identifiers (in reverse order).
    Corresponds to `dirpath` in MetaCoq. -/
def Dirpath := List Ident
  deriving Repr

/-- Coq's `Z` (arbitrary-precision integers). Mapped to Lean's `Int`. -/
def Z := Int
  deriving Inhabited, DecidableEq, Repr

/-! ## Universe levels -/

/-- Base universe level type. Corresponds to `Level.t` in MetaCoq.
    In the Haskell extraction this appears as `T_`, `T3`, and `Elt0`. -/
inductive Level_t where
  | lzero : Level_t
  | level : MyString → Level_t
  | var : Nat → Level_t
  deriving Inhabited, DecidableEq, Repr

/-- `T_` from the Haskell extraction = `Level.t`. -/
abbrev T_ := Level_t

/-- `T3` from the Haskell extraction = `Level.t`. -/
abbrev T3 := T_

/-- `Elt0` from the Haskell extraction = `Level.t`. -/
abbrev Elt0 := T_

/-- A level expression: a base level paired with a natural number offset.
    `T14 = Prod T3 Nat = Level.t × Nat`.
    Represents `Level.t + n`. -/
abbrev T14 := T3 × Nat

/-- `Elt1 = T14` = level expression. -/
abbrev Elt1 := T14

/-- `Elt2 = T14` = level expression (duplicate alias). -/
abbrev Elt2 := T14

/-- `T18 = List Elt1` = list of level expressions. -/
abbrev T18 := List Elt1

/-- `T_1 = T18` = list of level expressions. -/
abbrev T_1 := T18

/-- `T21 = T_1` = list of level expressions. -/
abbrev T21 := T_1

/-- Non-empty set of level expressions. Represents a universe as the max
    of its constituent level expressions.
    `NonEmptyLevelExprSet = T21 = List (Level.t × Nat)`. -/
abbrev NonEmptyLevelExprSet := T21

/-- `T22 = NonEmptyLevelExprSet`. The universe type. -/
abbrev T22 := NonEmptyLevelExprSet

/-- `ListElt1 = List Elt1`. -/
abbrev ListElt1 := List Elt1

/-- `ListT3 = List T3 = List Level.t`. -/
abbrev ListT3 := List T3

/-- `T33 = List T3 = List Level.t`. -/
abbrev T33 := List T3

/-! ## Constraint types -/

/-- Universe constraint type. Corresponds to `ConstraintType.t` in MetaCoq.
    `T_3` in the Haskell extraction. -/
inductive ConstraintType where
  | le : ConstraintType
  | lt : ConstraintType
  | eq : ConstraintType
  deriving Inhabited, DecidableEq, Repr

/-- `T_3` from extraction = `ConstraintType`. -/
abbrev T_3 := ConstraintType

/-- `T24 = T_3 = ConstraintType`. -/
abbrev T24 := T_3

/-- `T25S = Prod T3 T24 = Level.t × ConstraintType`.
    First two components of a universe constraint. -/
abbrev T25S := T3 × T24

/-- `T25 = Prod T25S T3 = (Level.t × ConstraintType) × Level.t`.
    A full universe constraint: `l1 (≤|<|=) l2`. -/
abbrev T25 := T25S × T3

/-! ## Trees (for universe constraint sets / level sets) -/

/-- Tree type used for finite sets/maps in the extracted code.
    Corresponds to `Tree0` in the extraction, storing universe constraints.
    `T26 = Tree0`, `T_4 = T26`, `T32 = T_4`. -/
inductive Tree0 where
  | leaf : Tree0
  | node : Tree0 → T25 → Tree0 → Nat → Tree0
  deriving Inhabited, Repr

/-- `T26 = Tree0`. -/
abbrev T26 := Tree0

/-- `T_4 = T26 = Tree0`. -/
abbrev T_4 := T26

/-- `T32 = T_4 = Tree0`. Constraint set tree. -/
abbrev T32 := T_4

/-- Tree type for level sets, storing `Level.t` values.
    `T4 = Tree`. -/
inductive Tree where
  | leaf : Tree
  | node : Tree → Level_t → Tree → Nat → Tree
  deriving Inhabited, Repr

/-- `T4 = Tree`. Level set tree. -/
abbrev T4 := Tree

/-- `T_2` from extraction. Constraint set type. -/
abbrev T_2 := Tree0

/-- `T23 = T_2`. -/
abbrev T23 := T_2

/-- `T_0 = T4 = Tree` (from comments in original). -/
abbrev T_0 := T4

/-- `T10 = T_0 = Tree`. Level set. -/
abbrev T10 := T_0

/-- `T35 = Prod T10 T32 = Tree × Tree0`.
    A pair of (level set, constraint set). -/
abbrev T35 := T10 × T32

/-! ## Names and module paths -/

/-- Variable names. Corresponds to `name` in MetaCoq/Coq kernel. -/
inductive Name where
  | nAnon : Name
  | nNamed : Ident → Name
  deriving Inhabited, DecidableEq, Repr

/-- Relevance of a binder. -/
inductive Relevance where
  | relevant : Relevance
  | irrelevant : Relevance
  deriving Inhabited, DecidableEq, Repr

/-- Binder annotation, parameterized by the name type.
    Corresponds to `binder_annot` in MetaCoq. -/
structure BinderAnnot (α : Type) where
  binder_name : α
  binder_relevance : Relevance
  deriving Repr

/-- `Binder_annot = BinderAnnot` (type-level alias). -/
abbrev Binder_annot := BinderAnnot

/-- `Aname = Binder_annot Name = BinderAnnot Name`.
    Annotated name used in binders. -/
abbrev Aname := BinderAnnot Name

/-- `BinderAnnotName = BinderAnnot Name`. -/
abbrev BinderAnnotName := BinderAnnot Name

/-- `ListAname = List Aname`. -/
abbrev ListAname := List Aname

/-- Module path. Corresponds to `modpath` in MetaCoq. -/
inductive Modpath where
  | MPfile : Dirpath → Modpath
  | MPbound : Dirpath → Ident → Nat → Modpath
  | MPdot : Modpath → Ident → Modpath
  deriving Repr

instance : Inhabited Modpath := ⟨Modpath.MPfile []⟩

/-- Kernel name = module path × identifier.
    `Kername = Prod Modpath Ident`. -/
abbrev Kername := Modpath × Ident

/-- `OKername = Option Kername`. -/
abbrev OKername := Option Kername

end MetaCoq
