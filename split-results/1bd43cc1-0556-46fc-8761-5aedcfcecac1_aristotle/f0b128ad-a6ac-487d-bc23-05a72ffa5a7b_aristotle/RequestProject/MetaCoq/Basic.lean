import Lean.Data.Json

/-!
# MetaCoq Basic Types

Translation of basic types from the Haskell MetaCoq extraction:
`Positive`, `N`, `Z`, `Comparison`, `Byte`, `MyString`, and related functions.
-/

namespace MetaCoq

/-! ## Positive numbers (binary representation) -/

/-- Binary positive integers, corresponding to Coq's `positive`. -/
inductive Positive where
  | xI : Positive → Positive  -- 2p + 1
  | xO : Positive → Positive  -- 2p
  | xH : Positive             -- 1
  deriving Repr, BEq, Inhabited, Hashable

/-- Binary natural numbers, corresponding to Coq's `N`. -/
inductive BinNat where
  | n0 : BinNat
  | npos : Positive → BinNat
  deriving Repr, BEq, Inhabited, Hashable

/-- Binary integers, corresponding to Coq's `Z`. -/
inductive BinInt where
  | z0 : BinInt
  | zpos : Positive → BinInt
  | zneg : Positive → BinInt
  deriving Repr, BEq, Inhabited, Hashable

/-- Comparison result, corresponding to Coq's `comparison`. -/
inductive Comparison where
  | eq : Comparison
  | lt : Comparison
  | gt : Comparison
  deriving Repr, BEq, Inhabited

/-! ## Positive arithmetic -/

def Positive.succ : Positive → Positive
  | .xI p => .xO (succ p)
  | .xO p => .xI p
  | .xH   => .xO .xH

mutual
def Positive.addCarry : Positive → Positive → Positive
  | .xI p, .xI q => .xI (addCarry p q)
  | .xI p, .xO q => .xO (addCarry p q)
  | .xI p, .xH   => .xI (Positive.succ p)
  | .xO p, .xI q => .xO (addCarry p q)
  | .xO p, .xO q => .xI (Positive.add p q)
  | .xO p, .xH   => .xO (Positive.succ p)
  | .xH,   .xI q => .xI (Positive.succ q)
  | .xH,   .xO q => .xO (Positive.succ q)
  | .xH,   .xH   => .xI .xH

def Positive.add : Positive → Positive → Positive
  | .xI p, .xI q => .xO (Positive.addCarry p q)
  | .xI p, .xO q => .xI (add p q)
  | .xI p, .xH   => .xO (Positive.succ p)
  | .xO p, .xI q => .xI (add p q)
  | .xO p, .xO q => .xO (add p q)
  | .xO p, .xH   => .xI p
  | .xH,   .xI q => .xO (Positive.succ q)
  | .xH,   .xO q => .xI q
  | .xH,   .xH   => .xO .xH
end

instance : Add Positive := ⟨Positive.add⟩

def Positive.predDouble : Positive → Positive
  | .xI p => .xI (.xO p)
  | .xO p => .xI (predDouble p)
  | .xH   => .xH

def Positive.compareCont : Comparison → Positive → Positive → Comparison
  | c, .xI p, .xI q => compareCont c p q
  | _, .xI p, .xO q => compareCont .gt p q
  | _, .xI _,  .xH  => .gt
  | _, .xO p, .xI q => compareCont .lt p q
  | c, .xO p, .xO q => compareCont c p q
  | _, .xO _, .xH   => .gt
  | c, .xH,   .xH   => c
  | _, .xH,   _     => .lt

def Positive.compare (x y : Positive) : Comparison :=
  compareCont .eq x y

/-- Convert a positive number to `Nat` using iterated addition. -/
def Positive.toNat (p : Positive) : Nat :=
  iterOp (· + ·) p 1
where
  iterOp {α : Type} (op : α → α → α) : Positive → α → α
    | .xI p, a => op a (iterOp op p (op a a))
    | .xO p, a => iterOp op p (op a a)
    | .xH,   a => a

/-! ## BinInt (Z) arithmetic -/

def BinInt.double : BinInt → BinInt
  | .z0     => .z0
  | .zpos p => .zpos (.xO p)
  | .zneg p => .zneg (.xO p)

def BinInt.succDouble : BinInt → BinInt
  | .z0     => .zpos .xH
  | .zpos p => .zpos (.xI p)
  | .zneg p => .zneg (Positive.predDouble p)

def BinInt.predDouble : BinInt → BinInt
  | .z0     => .zneg .xH
  | .zpos p => .zpos (Positive.predDouble p)
  | .zneg p => .zneg (.xI p)

def BinInt.posSub : Positive → Positive → BinInt
  | .xI p, .xI q => (posSub p q).double
  | .xI p, .xO q => (posSub p q).succDouble
  | .xI p, .xH   => .zpos (.xO p)
  | .xO p, .xI q => (posSub p q).predDouble
  | .xO p, .xO q => (posSub p q).double
  | .xO p, .xH   => .zpos (Positive.predDouble p)
  | .xH,   .xI q => .zneg (.xO q)
  | .xH,   .xO q => .zneg (Positive.predDouble q)
  | .xH,   .xH   => .z0

def BinInt.add : BinInt → BinInt → BinInt
  | .z0,     y       => y
  | x,       .z0     => x
  | .zpos x, .zpos y => .zpos (x + y)
  | .zpos x, .zneg y => posSub x y
  | .zneg x, .zpos y => posSub y x
  | .zneg x, .zneg y => .zneg (x + y)

instance : Add BinInt := ⟨BinInt.add⟩

def Comparison.compOpp : Comparison → Comparison
  | .eq => .eq
  | .lt => .gt
  | .gt => .lt

def BinInt.compare : BinInt → BinInt → Comparison
  | .z0,     .z0     => .eq
  | .z0,     .zpos _ => .lt
  | .z0,     .zneg _ => .gt
  | .zpos _, .z0     => .gt
  | .zpos x, .zpos y => Positive.compare x y
  | .zpos _, .zneg _ => .gt
  | .zneg _, .z0     => .lt
  | .zneg _, .zpos _ => .lt
  | .zneg x, .zneg y => (Positive.compare x y).compOpp

def BinInt.max (n m : BinInt) : BinInt :=
  match BinInt.compare n m with
  | .lt => m
  | _   => n

def BinInt.ltb (x y : BinInt) : Bool :=
  match BinInt.compare x y with
  | .lt => true
  | _   => false

def BinInt.leb (x y : BinInt) : Bool :=
  match BinInt.compare x y with
  | .gt => false
  | _   => true

def BinNat.compare : BinNat → BinNat → Comparison
  | .n0,      .n0      => .eq
  | .n0,      .npos _  => .lt
  | .npos _,  .n0      => .gt
  | .npos n', .npos m' => Positive.compare n' m'

/-! ## Byte -/

/-- A byte value (0–255), corresponding to Coq's `Byte.byte`.
    We use `UInt8` for efficiency. -/
abbrev Byte := UInt8

/-- Convert a positive `Nat` to `Positive`. -/
private def natToPositive : Nat → Positive
  | 0 => .xH  -- shouldn't happen
  | 1 => .xH
  | n + 2 =>
    if (n + 2) % 2 == 0 then
      .xO (natToPositive ((n + 2) / 2))
    else
      .xI (natToPositive ((n + 2) / 2))
termination_by n => n
decreasing_by all_goals omega

/-- Convert a `UInt8` to `BinNat`. -/
def Byte.toBinNat (b : UInt8) : BinNat :=
  match b.toNat with
  | 0 => .n0
  | n + 1 => .npos (natToPositive (n + 1))

/-- Convert a byte to a `Char`. -/
def byteToChar (b : UInt8) : Char :=
  Char.ofNat b.toNat

/-- Get the positive from a BinNat, defaulting to xH for n0. -/
def BinNat.getNpos : BinNat → Positive
  | .n0    => .xH
  | .npos x => x

/-! ## MyString -/

/-- Coq-extracted string type (list of bytes). -/
inductive MyString where
  | emptyString : MyString
  | string : Byte → MyString → MyString
  deriving Repr, BEq, Inhabited

/-- Convert `MyString` to a list of chars. -/
def MyString.toCharList : MyString → List Char
  | .emptyString => []
  | .string b rest => byteToChar b :: rest.toCharList

/-- Convert `MyString` to a Lean `String`. -/
def MyString.asString (s : MyString) : String :=
  String.ofList s.toCharList

/-- Convert a Lean `String` to `MyString`. -/
def MyString.ofString (s : String) : MyString :=
  go s.toList
where
  go : List Char → MyString
    | [] => .emptyString
    | c :: cs => .string (UInt8.ofNat c.toNat) (go cs)

instance : ToString MyString := ⟨MyString.asString⟩

def MyString.compare : MyString → MyString → Comparison
  | .emptyString,  .emptyString  => .eq
  | .emptyString,  .string _ _   => .lt
  | .string _ _,   .emptyString  => .gt
  | .string x xs,  .string y ys  =>
    match BinNat.compare (Byte.toBinNat x) (Byte.toBinNat y) with
    | .eq => MyString.compare xs ys
    | c   => c

/-! ## Universe Levels -/

/-- Universe level expressions, corresponding to Coq's `Level.t`. -/
inductive Level where
  | lzero : Level
  | level : MyString → Level
  | lvar  : Nat → Level
  deriving Repr, BEq, Inhabited

abbrev T3 := Level

/-- Compare two natural numbers. -/
def natCompare : Nat → Nat → Comparison
  | 0,     0     => .eq
  | 0,     _ + 1 => .lt
  | _ + 1, 0     => .gt
  | n + 1, m + 1 => natCompare n m

def Level.compare : Level → Level → Comparison
  | .lzero,    .lzero    => .eq
  | .lzero,    _         => .lt
  | .level _,  .lzero    => .gt
  | .level s1, .level s2 => MyString.compare s1 s2
  | .level _,  .lvar _   => .lt
  | .lvar n,   .lvar m   => natCompare n m
  | .lvar _,   _         => .gt

/-! ## Level constraints -/

/-- Constraint type, corresponding to `ConstraintType.t`. -/
inductive ConstraintType where
  | le : BinInt → ConstraintType
  | eq0 : ConstraintType
  deriving Repr, BEq, Inhabited

def ConstraintType.compare : ConstraintType → ConstraintType → Comparison
  | .le n,  .le m  => BinInt.compare n m
  | .le _,  .eq0   => .lt
  | .eq0,   .le _  => .gt
  | .eq0,   .eq0   => .eq

/-- A universe constraint: (level, constraint_type, level). -/
structure Constraint where
  fst : Level
  ct  : ConstraintType
  snd : Level
  deriving Repr, BEq, Inhabited

def Constraint.compare (c1 c2 : Constraint) : Comparison :=
  match Level.compare c1.fst c2.fst with
  | .eq => match ConstraintType.compare c1.ct c2.ct with
           | .eq => Level.compare c1.snd c2.snd
           | x   => x
  | x   => x

/-! ## Level expression sets -/

/-- A level expression: (level, nat) pair. -/
structure LevelExpr where
  level : Level
  n     : Nat
  deriving Repr, BEq, Inhabited

/-- Create a level expression with n = 0. -/
def LevelExpr.make (l : Level) : LevelExpr := ⟨l, 0⟩

/-- A non-empty set of level expressions (sorted list). -/
abbrev NonEmptyLevelExprSet := List LevelExpr

def LevelExpr.compare (x y : LevelExpr) : Comparison :=
  match Level.compare x.level y.level with
  | .eq => natCompare x.n y.n
  | c   => c

/-- Add a level expression to a sorted list (set). -/
def NonEmptyLevelExprSet.add (x : LevelExpr) : List LevelExpr → List LevelExpr
  | [] => [x]
  | y :: l =>
    match LevelExpr.compare x y with
    | .eq => y :: l
    | .lt => x :: y :: l
    | .gt => y :: NonEmptyLevelExprSet.add x l

def NonEmptyLevelExprSet.singleton (x : LevelExpr) : NonEmptyLevelExprSet := [x]

def NonEmptyLevelExprSet.addList (es : List LevelExpr) (u : NonEmptyLevelExprSet)
    : NonEmptyLevelExprSet :=
  es.foldl (fun acc e => NonEmptyLevelExprSet.add e acc) u

/-- Make a singleton non-empty level expr set from a level. -/
def NonEmptyLevelExprSet.make' (l : Level) : NonEmptyLevelExprSet :=
  NonEmptyLevelExprSet.singleton (LevelExpr.make l)

/-! ## Sort / Universe -/

/-- Sort families. -/
inductive SortFamily where
  | sProp : SortFamily
  | prop  : SortFamily
  deriving Repr, BEq, Inhabited

/-- Universe sorts, corresponding to Coq's `Universe.t`.
    Named `UnivSort` to avoid conflict with Lean's `Sort`. -/
inductive UnivSort where
  | lSProp : UnivSort
  | lProp  : UnivSort
  | lType  : NonEmptyLevelExprSet → UnivSort
  deriving Repr, Inhabited

/-- Build a `UnivSort` from a kernel representation. -/
def UnivSort.ofLevels : SortFamily ⊕ Level → UnivSort
  | .inl .sProp => .lSProp
  | .inl .prop  => .lProp
  | .inr l      => .lType (NonEmptyLevelExprSet.make' l)

def UnivSort.fromKernelRepr (e : Level × Bool) : LevelExpr :=
  ⟨e.1, if e.2 then 1 else 0⟩

def UnivSort.fromKernelRepr1 (e : Level × Bool) (es : List (Level × Bool)) : UnivSort :=
  .lType (NonEmptyLevelExprSet.addList (es.map fromKernelRepr)
          (NonEmptyLevelExprSet.singleton (fromKernelRepr e)))

/-! ## AVL Tree for Level sets -/

/-- AVL tree for sets of `Level`, corresponding to `MSetAVL` in Coq. -/
inductive LevelTree where
  | leaf : LevelTree
  | node : BinInt → LevelTree → Level → LevelTree → LevelTree
  deriving Repr, BEq, Inhabited

def LevelTree.height : LevelTree → BinInt
  | .leaf         => .z0
  | .node h _ _ _ => h

def LevelTree.create (l : LevelTree) (x : Level) (r : LevelTree) : LevelTree :=
  .node (BinInt.max l.height r.height + .zpos .xH) l x r

def LevelTree.bal (l : LevelTree) (x : Level) (r : LevelTree) : LevelTree :=
  let hl := l.height
  let hr := r.height
  if BinInt.ltb (hr + .zpos (.xO .xH)) hl then
    match l with
    | .leaf => create l x r
    | .node _ ll lx lr =>
      if BinInt.leb lr.height ll.height then
        create ll lx (create lr x r)
      else
        match lr with
        | .leaf => create l x r
        | .node _ lrl lrx lrr => create (create ll lx lrl) lrx (create lrr x r)
  else if BinInt.ltb (hl + .zpos (.xO .xH)) hr then
    match r with
    | .leaf => create l x r
    | .node _ rl rx rr =>
      if BinInt.leb rl.height rr.height then
        create (create l x rl) rx rr
      else
        match rl with
        | .leaf => create l x r
        | .node _ rll rlx rlr => create (create l x rll) rlx (create rlr rx rr)
  else
    create l x r

def LevelTree.add (x : Level) : LevelTree → LevelTree
  | .leaf => .node (.zpos .xH) .leaf x .leaf
  | .node h l y r =>
    match Level.compare x y with
    | .eq => .node h l y r
    | .lt => bal (add x l) y r
    | .gt => bal l y (add x r)

def LevelTree.empty : LevelTree := .leaf

def LevelTree.ofList (l : List Level) : LevelTree :=
  l.foldr LevelTree.add LevelTree.empty

/-! ## AVL Tree for Constraint sets -/

/-- AVL tree for sets of `Constraint`. -/
inductive ConstraintTree where
  | leaf : ConstraintTree
  | node : BinInt → ConstraintTree → Constraint → ConstraintTree → ConstraintTree
  deriving Repr, BEq, Inhabited

def ConstraintTree.height : ConstraintTree → BinInt
  | .leaf         => .z0
  | .node h _ _ _ => h

def ConstraintTree.create (l : ConstraintTree) (x : Constraint) (r : ConstraintTree)
    : ConstraintTree :=
  .node (BinInt.max l.height r.height + .zpos .xH) l x r

def ConstraintTree.bal (l : ConstraintTree) (x : Constraint) (r : ConstraintTree)
    : ConstraintTree :=
  let hl := l.height
  let hr := r.height
  if BinInt.ltb (hr + .zpos (.xO .xH)) hl then
    match l with
    | .leaf => create l x r
    | .node _ ll lx lr =>
      if BinInt.leb lr.height ll.height then
        create ll lx (create lr x r)
      else
        match lr with
        | .leaf => create l x r
        | .node _ lrl lrx lrr => create (create ll lx lrl) lrx (create lrr x r)
  else if BinInt.ltb (hl + .zpos (.xO .xH)) hr then
    match r with
    | .leaf => create l x r
    | .node _ rl rx rr =>
      if BinInt.leb rl.height rr.height then
        create (create l x rl) rx rr
      else
        match rl with
        | .leaf => create l x r
        | .node _ rll rlx rlr => create (create l x rll) rlx (create rlr rx rr)
  else
    create l x r

def ConstraintTree.add (x : Constraint) : ConstraintTree → ConstraintTree
  | .leaf => .node (.zpos .xH) .leaf x .leaf
  | .node h l y r =>
    match Constraint.compare x y with
    | .eq => .node h l y r
    | .lt => bal (add x l) y r
    | .gt => bal l y (add x r)

def ConstraintTree.empty : ConstraintTree := .leaf

/-! ## Convenience constants -/

def ConstraintType.lt_ : ConstraintType := .le (.zpos .xH)
def ConstraintType.le0 : ConstraintType := .le .z0

/-! ## JSON serialization -/

-- JSON instances for basic types, mirroring the Haskell ToJSON instances.

-- Positive: generic-style encoding
private partial def Positive.toJson : Positive → Lean.Json
  | .xI p => Lean.Json.mkObj [("tag", "XI"), ("contents", p.toJson)]
  | .xO p => Lean.Json.mkObj [("tag", "XO"), ("contents", p.toJson)]
  | .xH   => Lean.Json.mkObj [("tag", "XH")]

instance : Lean.ToJson Positive where
  toJson := Positive.toJson

instance : Lean.ToJson BinNat where
  toJson
    | .n0     => Lean.Json.mkObj [("tag", "N0")]
    | .npos p => Lean.Json.mkObj [("tag", "Npos"), ("contents", Lean.toJson p)]

instance : Lean.ToJson BinInt where
  toJson
    | .z0     => Lean.Json.mkObj [("tag", "Z0")]
    | .zpos p => Lean.Json.mkObj [("tag", "Zpos"), ("contents", Lean.toJson p)]
    | .zneg p => Lean.Json.mkObj [("tag", "Zneg"), ("contents", Lean.toJson p)]

-- MyString: serialized as a plain JSON string (like the Haskell instance)
instance : Lean.ToJson MyString where
  toJson s := Lean.Json.str s.asString

-- Byte: serialized as {"name": <char>} (matching Haskell instance)
instance : Lean.ToJson Byte where
  toJson b := Lean.Json.mkObj [("name", Lean.Json.str (String.singleton (byteToChar b)))]

instance : Lean.ToJson Comparison where
  toJson
    | .eq => Lean.Json.str "Eq"
    | .lt => Lean.Json.str "Lt"
    | .gt => Lean.Json.str "Gt"

instance : Lean.ToJson Level where
  toJson
    | .lzero    => Lean.Json.mkObj [("tag", "Lzero")]
    | .level s  => Lean.Json.mkObj [("tag", "Level"), ("contents", Lean.toJson s)]
    | .lvar n   => Lean.Json.mkObj [("tag", "Lvar"), ("contents", Lean.Json.num n)]

instance : Lean.ToJson ConstraintType where
  toJson
    | .le z => Lean.Json.mkObj [("tag", "Le"), ("contents", Lean.toJson z)]
    | .eq0  => Lean.Json.mkObj [("tag", "Eq0")]

instance : Lean.ToJson Constraint where
  toJson c := Lean.Json.mkObj [
    ("fst", Lean.toJson c.fst),
    ("ct", Lean.toJson c.ct),
    ("snd", Lean.toJson c.snd)
  ]

instance : Lean.ToJson LevelExpr where
  toJson le := Lean.Json.mkObj [
    ("level", Lean.toJson le.level),
    ("n", Lean.Json.num le.n)
  ]

instance : Lean.ToJson SortFamily where
  toJson
    | .sProp => Lean.Json.str "LSProp"
    | .prop  => Lean.Json.str "LProp"

instance : Lean.ToJson UnivSort where
  toJson
    | .lSProp  => Lean.Json.mkObj [("tag", "LProp0")]
    | .lProp   => Lean.Json.mkObj [("tag", "LSProp0")]
    | .lType s => Lean.Json.mkObj [("tag", "LType"), ("contents", Lean.toJson s)]

private partial def LevelTree.toJson : LevelTree → Lean.Json
  | .leaf => Lean.Json.mkObj [("tag", "Leaf")]
  | .node h l x r => Lean.Json.mkObj [
      ("tag", "Node"),
      ("height", Lean.toJson h),
      ("left", l.toJson),
      ("value", Lean.toJson x),
      ("right", r.toJson)
    ]

instance : Lean.ToJson LevelTree where
  toJson := LevelTree.toJson

private partial def ConstraintTree.toJson : ConstraintTree → Lean.Json
  | .leaf => Lean.Json.mkObj [("tag", "Leaf")]
  | .node h l x r => Lean.Json.mkObj [
      ("tag", "Node"),
      ("height", Lean.toJson h),
      ("left", l.toJson),
      ("value", Lean.toJson x),
      ("right", r.toJson)
    ]

instance : Lean.ToJson ConstraintTree where
  toJson := ConstraintTree.toJson

end MetaCoq
