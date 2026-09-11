/-
  Translation of MetaCoq kernel data structures from Haskell to Lean 4.
  Original source: Server.MetaCoq.TestMeta (Haskell)

  These types represent the core data structures of the Coq proof assistant's kernel,
  as extracted by MetaCoq.
-/

namespace MetaCoq

/-! ## Binary number representations -/

/-- Positive binary numbers (1, 2, 3, ...) -/
inductive Positive where
  | xI : Positive → Positive  -- 2p + 1
  | xO : Positive → Positive  -- 2p
  | xH : Positive             -- 1
  deriving Repr, Inhabited, BEq, DecidableEq

/-- Non-negative binary numbers -/
inductive BinN where
  | n0 : BinN
  | npos : Positive → BinN
  deriving Repr, Inhabited, BEq, DecidableEq

/-- Binary integers -/
inductive BinZ where
  | z0 : BinZ
  | zpos : Positive → BinZ
  | zneg : Positive → BinZ
  deriving Repr, Inhabited, BEq, DecidableEq

/-! ## Positive arithmetic -/

def Positive.succ : Positive → Positive
  | .xI p => .xO (succ p)
  | .xO p => .xI p
  | .xH   => .xO .xH

mutual
def Positive.addCarry : Positive → Positive → Positive
  | .xI p, .xI q => .xI (Positive.addCarry p q)
  | .xI p, .xO q => .xO (Positive.addCarry p q)
  | .xI p, .xH   => .xI (p.succ)
  | .xO p, .xI q => .xO (Positive.addCarry p q)
  | .xO p, .xO q => .xI (Positive.add p q)
  | .xO p, .xH   => .xO (p.succ)
  | .xH,   .xI q => .xI (q.succ)
  | .xH,   .xO q => .xO (q.succ)
  | .xH,   .xH   => .xI .xH

def Positive.add : Positive → Positive → Positive
  | .xI p, .xI q => .xO (Positive.addCarry p q)
  | .xI p, .xO q => .xI (Positive.add p q)
  | .xI p, .xH   => .xO (p.succ)
  | .xO p, .xI q => .xI (Positive.add p q)
  | .xO p, .xO q => .xO (Positive.add p q)
  | .xO p, .xH   => .xI p
  | .xH,   .xI q => .xO (q.succ)
  | .xH,   .xO q => .xI q
  | .xH,   .xH   => .xO .xH
end

instance : Add Positive := ⟨Positive.add⟩

/-- Comparison with accumulator -/
def Positive.compareCont : Ordering → Positive → Positive → Ordering
  | r, .xI p, .xI q => compareCont r p q
  | _, .xI p, .xO q => compareCont .gt p q
  | _, .xI _,  .xH  => .gt
  | _, .xO p, .xI q => compareCont .lt p q
  | r, .xO p, .xO q => compareCont r p q
  | _, .xO _, .xH   => .gt
  | r, .xH,   .xH   => r
  | _, .xH,   _     => .lt

def Positive.compare (x y : Positive) : Ordering :=
  Positive.compareCont .eq x y

def Positive.predDouble : Positive → Positive
  | .xI p => .xI (.xO p)
  | .xO p => .xI (predDouble p)
  | .xH   => .xH

/-! ## Z arithmetic -/

def BinZ.double : BinZ → BinZ
  | .z0     => .z0
  | .zpos p => .zpos (.xO p)
  | .zneg p => .zneg (.xO p)

def BinZ.succDouble : BinZ → BinZ
  | .z0     => .zpos .xH
  | .zpos p => .zpos (.xI p)
  | .zneg p => .zneg (p.predDouble)

def BinZ.predDouble : BinZ → BinZ
  | .z0     => .zneg .xH
  | .zpos p => .zpos (p.predDouble)
  | .zneg p => .zneg (.xI p)

def BinZ.posSub : Positive → Positive → BinZ
  | .xI p, .xI q => (posSub p q).double
  | .xI p, .xO q => (posSub p q).succDouble
  | .xI p, .xH   => .zpos (.xO p)
  | .xO p, .xI q => (posSub p q).predDouble
  | .xO p, .xO q => (posSub p q).double
  | .xO p, .xH   => .zpos p.predDouble
  | .xH,   .xI q => .zneg (.xO q)
  | .xH,   .xO q => .zneg q.predDouble
  | .xH,   .xH   => .z0

def BinZ.add : BinZ → BinZ → BinZ
  | .z0,     y       => y
  | x,       .z0     => x
  | .zpos x, .zpos y => .zpos (x + y)
  | .zpos x, .zneg y => posSub x y
  | .zneg x, .zpos y => posSub y x
  | .zneg x, .zneg y => .zneg (x + y)

instance : Add BinZ := ⟨BinZ.add⟩

def BinZ.compare : BinZ → BinZ → Ordering
  | .z0,     .z0     => .eq
  | .z0,     .zpos _ => .lt
  | .z0,     .zneg _ => .gt
  | .zpos _, .z0     => .gt
  | .zpos x, .zpos y => x.compare y
  | .zpos _, .zneg _ => .gt
  | .zneg _, .z0     => .lt
  | .zneg _, .zpos _ => .lt
  | .zneg x, .zneg y => match x.compare y with
    | .eq => .eq | .lt => .gt | .gt => .lt

def BinZ.max (n m : BinZ) : BinZ :=
  match n.compare m with
  | .lt => m
  | _   => n

def BinZ.ltb (x y : BinZ) : Bool :=
  match x.compare y with
  | .lt => true
  | _   => false

def BinZ.leb (x y : BinZ) : Bool :=
  match x.compare y with
  | .gt => false
  | _   => true

def BinZ.zero : BinZ := .z0
def BinZ.one  : BinZ := .zpos .xH
def BinZ.two  : BinZ := .zpos (.xO .xH)

/-! ## Coq String type -/

/-- Coq string (byte list representation) -/
inductive CoqString where
  | emptyString : CoqString
  | string : UInt8 → CoqString → CoqString
  deriving Repr, Inhabited, BEq

/-- Convert CoqString to a list of characters -/
def CoqString.toCharList : CoqString → List Char
  | .emptyString => []
  | .string b rest => Char.ofNat b.toNat :: rest.toCharList

/-- Convert CoqString to Lean String -/
def CoqString.toLeanString (s : CoqString) : String :=
  String.ofList s.toCharList

instance : ToString CoqString := ⟨CoqString.toLeanString⟩

def CoqString.compare : CoqString → CoqString → Ordering
  | .emptyString, .emptyString => .eq
  | .emptyString, .string _ _  => .lt
  | .string _ _,  .emptyString => .gt
  | .string x xs, .string y ys =>
    match Ord.compare x.toNat y.toNat with
    | .eq => compare xs ys
    | r   => r

/-! ## Universe levels -/

/-- Universe level (corresponds to T_ / UniversalLevel) -/
inductive Level where
  | lzero : Level
  | level : CoqString → Level
  | lvar  : Nat → Level
  deriving Repr, Inhabited, BEq

def Level.compare : Level → Level → Ordering
  | .lzero,    .lzero    => .eq
  | .lzero,    _         => .lt
  | .level _,  .lzero    => .gt
  | .level s1, .level s2 => s1.compare s2
  | .level _,  .lvar _   => .lt
  | .lvar n,   .lvar m   => Ord.compare n m
  | .lvar _,   _         => .gt

/-! ## Numeric relation (used in universe constraints) -/

/-- Numeric relation type (Le z | Eq) -/
inductive NumRel where
  | le : BinZ → NumRel
  | eq0 : NumRel
  deriving Repr, Inhabited, BEq

def NumRel.compare : NumRel → NumRel → Ordering
  | .le n, .le m => n.compare m
  | .le _, .eq0  => .lt
  | .eq0,  .le _ => .gt
  | .eq0,  .eq0  => .eq

/-! ## Level expression sets -/

/-- Level expression: a level paired with a natural number offset -/
abbrev LevelExpr := Level × Nat

/-- Non-empty level expression set (sorted list) -/
abbrev NonEmptyLevelExprSet := List LevelExpr

def LevelExpr.compare' (x y : LevelExpr) : Ordering :=
  match x.1.compare y.1 with
  | .eq => Ord.compare x.2 y.2
  | r   => r

def LevelExpr.make (l : Level) : LevelExpr := (l, 0)
def LevelExpr.make' (l : Level) : NonEmptyLevelExprSet := [LevelExpr.make l]

def NonEmptyLevelExprSet.insert : LevelExpr → NonEmptyLevelExprSet → NonEmptyLevelExprSet
  | x, [] => [x]
  | x, y :: l =>
    match x.compare' y with
    | .eq => y :: l
    | .lt => x :: y :: l
    | .gt => y :: insert x l

def NonEmptyLevelExprSet.addList : List LevelExpr → NonEmptyLevelExprSet → NonEmptyLevelExprSet :=
  List.foldl (fun u e => u.insert e)

/-! ## Sorts -/

/-- Sort type (SProp, Prop, or Type u) -/
inductive CoqSort where
  | sProp : CoqSort
  | prop  : CoqSort
  | type  : NonEmptyLevelExprSet → CoqSort
  deriving Repr, Inhabited

/-- Sort/Prop indicator -/
inductive SortFamily where
  | lsProp : SortFamily
  | lProp  : SortFamily
  deriving Repr, Inhabited, BEq

def CoqSort.ofLevels : Sum SortFamily Level → CoqSort
  | .inl .lsProp => .sProp
  | .inl .lProp  => .prop
  | .inr l       => .type (LevelExpr.make' l)

/-! ## AVL Tree for Level sets -/

/-- AVL tree for Level sets -/
inductive LevelTree where
  | leaf : LevelTree
  | node : BinZ → LevelTree → Level → LevelTree → LevelTree
  deriving Repr, Inhabited

namespace LevelTree

def height : LevelTree → BinZ
  | .leaf => .z0
  | .node h _ _ _ => h

def create (l : LevelTree) (x : Level) (r : LevelTree) : LevelTree :=
  .node ((l.height.max r.height) + .one) l x r

def bal (l : LevelTree) (x : Level) (r : LevelTree) : LevelTree :=
  let hl := l.height
  let hr := r.height
  if (hr + .two).ltb hl then
    match l with
    | .leaf => create l x r
    | .node _ ll lx lr =>
      if lr.height.leb ll.height then
        create ll lx (create lr x r)
      else match lr with
        | .leaf => create l x r
        | .node _ lrl lrx lrr => create (create ll lx lrl) lrx (create lrr x r)
  else if (hl + .two).ltb hr then
    match r with
    | .leaf => create l x r
    | .node _ rl rx rr =>
      if rl.height.leb rr.height then
        create (create l x rl) rx rr
      else match rl with
        | .leaf => create l x r
        | .node _ rll rlx rlr => create (create l x rll) rlx (create rlr rx rr)
  else create l x r

def add (x : Level) : LevelTree → LevelTree
  | .leaf => .node .one .leaf x .leaf
  | .node h l y r =>
    match x.compare y with
    | .eq => .node h l y r
    | .lt => bal (add x l) y r
    | .gt => bal l y (add x r)

def empty : LevelTree := .leaf

def ofList (l : List Level) : LevelTree :=
  l.foldr add empty

end LevelTree

/-! ## Universe constraint tree -/

/-- Universe constraint: (level, numrel, level) -/
abbrev UnivConstraint := (Level × NumRel) × Level

/-- AVL tree for universe constraint sets -/
inductive ConstraintTree where
  | leaf : ConstraintTree
  | node : BinZ → ConstraintTree → UnivConstraint → ConstraintTree → ConstraintTree
  deriving Repr, Inhabited

namespace ConstraintTree

def height : ConstraintTree → BinZ
  | .leaf => .z0
  | .node h _ _ _ => h

def create (l : ConstraintTree) (x : UnivConstraint) (r : ConstraintTree) : ConstraintTree :=
  .node ((l.height.max r.height) + .one) l x r

def compareUC (x y : UnivConstraint) : Ordering :=
  match x.1.1.compare y.1.1 with
  | .eq => match x.1.2.compare y.1.2 with
    | .eq => x.2.compare y.2
    | r   => r
  | r => r

def bal (l : ConstraintTree) (x : UnivConstraint) (r : ConstraintTree) : ConstraintTree :=
  let hl := l.height
  let hr := r.height
  if (hr + .two).ltb hl then
    match l with
    | .leaf => create l x r
    | .node _ ll lx lr =>
      if lr.height.leb ll.height then
        create ll lx (create lr x r)
      else match lr with
        | .leaf => create l x r
        | .node _ lrl lrx lrr => create (create ll lx lrl) lrx (create lrr x r)
  else if (hl + .two).ltb hr then
    match r with
    | .leaf => create l x r
    | .node _ rl rx rr =>
      if rl.height.leb rr.height then
        create (create l x rl) rx rr
      else match rl with
        | .leaf => create l x r
        | .node _ rll rlx rlr => create (create l x rll) rlx (create rlr rx rr)
  else create l x r

def add (x : UnivConstraint) : ConstraintTree → ConstraintTree
  | .leaf => .node .one .leaf x .leaf
  | .node h l y r =>
    match compareUC x y with
    | .eq => .node h l y r
    | .lt => bal (add x l) y r
    | .gt => bal l y (add x r)

def empty : ConstraintTree := .leaf

end ConstraintTree

/-! ## Names and identifiers -/

abbrev Ident := CoqString
abbrev Dirpath := List Ident

/-- Module path -/
inductive Modpath where
  | mpfile  : Dirpath → Modpath
  | mpbound : Dirpath → Ident → Nat → Modpath
  | mpdot   : Modpath → Ident → Modpath
  deriving Repr, Inhabited, BEq

/-- Kernel name: module path + identifier -/
abbrev Kername := Modpath × Ident

/-- Name (anonymous or named) -/
inductive CoqName where
  | anon  : CoqName
  | named : Ident → CoqName
  deriving Repr, Inhabited, BEq

/-- Relevance annotation -/
inductive Relevance where
  | relevant   : Relevance
  | irrelevant : Relevance
  deriving Repr, Inhabited, BEq

/-- Binder annotation: name + relevance -/
structure BinderAnnot (α : Type) where
  name : α
  relevance : Relevance
  deriving Repr, Inhabited, BEq

abbrev Aname := BinderAnnot CoqName

/-! ## Cast kinds -/

inductive CastKind where
  | vmCast     : CastKind
  | nativeCast : CastKind
  | cast       : CastKind
  deriving Repr, Inhabited, BEq

/-! ## Inductive types -/

/-- Reference to an inductive type -/
structure Inductive where
  mind : Kername
  ind  : Nat
  deriving Repr, Inhabited, BEq

/-- Case info -/
structure CaseInfo where
  ind       : Inductive
  npar      : Nat
  relevance : Relevance
  deriving Repr, Inhabited, BEq

/-- Projection -/
structure Projection where
  ind   : Inductive
  npars : Nat
  arg   : Nat
  deriving Repr, Inhabited, BEq

/-! ## Universe declarations -/

inductive UniversesDecl where
  | monomorphicCtx  : UniversesDecl
  | polymorphicCtx  : UniversesDecl  -- not used in original
  deriving Repr, Inhabited, BEq

/-! ## Recursivity -/

inductive RecursivityKind where
  | finite   : RecursivityKind
  | coFinite : RecursivityKind
  | biFinite : RecursivityKind
  deriving Repr, Inhabited, BEq

/-! ## Allowed eliminations -/

inductive AllowedEliminations where
  | intoSProp        : AllowedEliminations
  | intoPropSProp     : AllowedEliminations
  | intoSetPropSProp  : AllowedEliminations
  | intoAny          : AllowedEliminations
  deriving Repr, Inhabited, BEq

/-! ## Variance -/

inductive Variance where
  | irrelevant : Variance
  | covariant  : Variance
  | invariant  : Variance
  deriving Repr, Inhabited, BEq

/-! ## Universe instance -/

abbrev UnivInstance := List Level

/-! ## Core Term type -/

/-- Definition in a (co-)fixpoint -/
structure Def (term : Type) where
  dname : Aname
  dtype : term
  dbody : term
  rarg  : Nat
  deriving Repr, Inhabited

/-- Branch of a match expression -/
structure Branch (term : Type) where
  bcontext : List Aname
  bbody    : term
  deriving Repr, Inhabited

/-- Predicate of a match expression -/
structure CoqPredicate (term : Type) where
  puinst    : UnivInstance
  pparams   : List term
  pcontext  : List Aname
  preturn   : term
  deriving Repr, Inhabited

/-- Context declaration -/
structure ContextDecl (term : Type) where
  declName : Aname
  declBody : Option term
  declType : term
  deriving Repr, Inhabited

/-- The core term type of Coq's calculus of constructions -/
inductive Term where
  | tRel       : Nat → Term
  | tVar       : Ident → Term
  | tEvar      : Nat → List Term → Term
  | tSort      : CoqSort → Term
  | tCast      : Term → CastKind → Term → Term
  | tProd      : Aname → Term → Term → Term
  | tLambda    : Aname → Term → Term → Term
  | tLetIn     : Aname → Term → Term → Term → Term
  | tApp       : Term → List Term → Term
  | tConst     : Kername → UnivInstance → Term
  | tInd       : Inductive → UnivInstance → Term
  | tConstruct : Inductive → Nat → UnivInstance → Term
  | tCase      : CaseInfo → CoqPredicate Term → Term → List (Branch Term) → Term
  | tProj      : Projection → Term → Term
  | tFix       : List (Def Term) → Nat → Term
  | tCoFix     : List (Def Term) → Nat → Term
  | tInt       : Int → Term
  | tFloat     : Float → Term
  deriving Repr, Inhabited

abbrev Context := List (ContextDecl Term)
abbrev Mfixpoint := List (Def Term)

/-! ## Global declarations -/

/-- Constant body -/
structure ConstantBody where
  constType      : Term
  constBody      : Option Term
  constUnivs     : UniversesDecl
  constRelevance : Relevance
  deriving Repr, Inhabited

/-- Constructor body -/
structure ConstructorBody where
  cstrName    : Ident
  cstrArgs    : Context
  cstrIndices : List Term
  cstrType    : Term
  cstrArity   : Nat
  deriving Repr, Inhabited

/-- Projection body -/
structure ProjectionBody where
  projName      : Ident
  projRelevance : Relevance
  projType      : Term
  deriving Repr, Inhabited

/-- One inductive body -/
structure OneInductiveBody where
  indName       : Ident
  indIndices    : Context
  indSort       : CoqSort
  indType       : Term
  indKelim      : AllowedEliminations
  indCtors      : List ConstructorBody
  indProjs      : List ProjectionBody
  indRelevance  : Relevance
  deriving Repr, Inhabited

/-- Mutual inductive body -/
structure MutualInductiveBody where
  indFinite   : RecursivityKind
  indNpars    : Nat
  indParams   : Context
  indBodies   : List OneInductiveBody
  indUnivs    : UniversesDecl
  indVariance : Option (List Variance)
  deriving Repr, Inhabited

/-- Global declaration: either a constant or an inductive -/
inductive GlobalDecl where
  | constantDecl  : ConstantBody → GlobalDecl
  | inductiveDecl : MutualInductiveBody → GlobalDecl
  deriving Repr, Inhabited

/-- A global declaration entry: kernel name + declaration -/
abbrev GlobalDeclEntry := Kername × GlobalDecl
abbrev GlobalDeclarations := List GlobalDeclEntry

/-- Retroknowledge -/
structure Retroknowledge where
  retroInt  : Option Kername
  retroBool : Option Kername
  deriving Repr, Inhabited

/-- Global environment -/
structure GlobalEnv where
  univs          : LevelTree × ConstraintTree
  decls          : GlobalDeclarations
  retroknowledge : Retroknowledge
  deriving Repr, Inhabited

/-! ## BigMama: the top-level type -/

/-- The top-level type: a global environment paired with a term -/
abbrev BigMama := GlobalEnv × Term

/-! ## Conversion helpers -/

def fromKernelRepr (e : Level × Bool) : LevelExpr :=
  (e.1, if e.2 then 1 else 0)

def fromKernelRepr1 (e : Level × Bool) (es : List (Level × Bool)) : CoqSort :=
  .type (NonEmptyLevelExprSet.addList (es.map fromKernelRepr) [fromKernelRepr e])

end MetaCoq
