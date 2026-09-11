import RequestProject.MetaCoq.Basic
import RequestProject.MetaCoq.Arith
import RequestProject.MetaCoq.AST

/-!
# MetaCoq AVL Trees and Set Operations

Balanced binary search trees (`Tree`, `Tree0`) and operations used
for universe-level sets and constraint sets.
-/

namespace MetaCoq

/-! ## Tree (set of T_) -/

inductive Tree where
  | Leaf : Tree
  | Node : Z → Tree → T_ → Tree → Tree
  deriving Repr, BEq, Inhabited

abbrev T4 := Tree
abbrev T_0 := T4
abbrev T10 := T_0

/-! ### T_ comparison (compare10) -/

def T_.compare (l1 l2 : T3) : Comparison :=
  match l1, l2 with
  | .Lzero, .Lzero => .Eq
  | .Lzero, _ => .Lt
  | .Level _, .Lzero => .Gt
  | .Level s1, .Level s2 => MyString.compare s1 s2
  | .Level _, .Lvar _ => .Lt
  | .Lvar n, .Lvar m => Nat.my_compare n m
  | .Lvar _, _ => .Gt

-- compare10 = T_.compare
def compare10 : T3 → T3 → Comparison := T_.compare

/-! ### Tree operations -/

def Tree.height : T4 → Z
  | .Leaf => Z._0
  | .Node h _ _ _ => h

def Tree.this (t : T_0) : T4 := t

def Tree.create (l : T4) (x : T_) (r : T4) : Tree :=
  .Node (Z.add (Z.max (Tree.height l) (Tree.height r)) Z._1) l x r

def Tree.assert_false : T4 → T_ → T4 → Tree := Tree.create

def Tree.empty : Tree := .Leaf
def Tree.empty0 : T10 := Tree.empty

def Tree.bal (l : T4) (x : T_) (r : T4) : Tree :=
  let hl := Tree.height l
  let hr := Tree.height r
  match Z.ltb (Z.add hr Z._2) hl with
  | .True =>
    match l with
    | .Leaf => Tree.assert_false l x r
    | .Node _ ll lx lr =>
      match Z.leb (Tree.height lr) (Tree.height ll) with
      | .True => Tree.create ll lx (Tree.create lr x r)
      | .False =>
        match lr with
        | .Leaf => Tree.assert_false l x r
        | .Node _ lrl lrx lrr =>
          Tree.create (Tree.create ll lx lrl) lrx (Tree.create lrr x r)
  | .False =>
    match Z.ltb (Z.add hl Z._2) hr with
    | .True =>
      match r with
      | .Leaf => Tree.assert_false l x r
      | .Node _ rl rx rr =>
        match Z.leb (Tree.height rl) (Tree.height rr) with
        | .True => Tree.create (Tree.create l x rl) rx rr
        | .False =>
          match rl with
          | .Leaf => Tree.assert_false l x r
          | .Node _ rll rlx rlr =>
            Tree.create (Tree.create l x rll) rlx (Tree.create rlr rx rr)
    | .False => Tree.create l x r

def Tree.add3 (x : T_) : Tree → Tree
  | .Leaf => .Node Z._1 .Leaf x .Leaf
  | .Node h l y r =>
    match T_.compare x y with
    | .Eq => .Node h l y r
    | .Lt => Tree.bal (Tree.add3 x l) y r
    | .Gt => Tree.bal l y (Tree.add3 x r)

def Tree.add4 (x : T_) (s : T10) : T10 :=
  Tree.add3 x (Tree.this s)

def Tree.of_list0 (l : List T_) : T10 :=
  List.fold_right Tree.add4 Tree.empty0 l

/-! ## Tree0 (set of T25 = level constraint triples) -/

abbrev T25S := Prod T3 T24
abbrev T25 := Prod T25S T3

inductive Tree0 where
  | Leaf0 : Tree0
  | Node0 : Z → Tree0 → T25 → Tree0 → Tree0
  deriving Repr, BEq, Inhabited

abbrev T26 := Tree0
abbrev T_4 := T26
abbrev T32 := T_4
abbrev T35 := Prod T10 T32

def Tree0.empty3 : Tree0 := .Leaf0
def Tree0.empty4 : T32 := Tree0.empty3

def Tree0.this1 (t : T_4) : T26 := t

def Tree0.height0 : T26 → Z
  | .Leaf0 => Z._0
  | .Node0 h _ _ _ => h

/-! ### T24 comparison (compare27) -/

def T24.compare (x y : T24) : Comparison :=
  match x, y with
  | .Le n, .Le m => Z.compare n m
  | .Le _, .Eq0 => .Lt
  | .Eq0, .Le _ => .Gt
  | .Eq0, .Eq0 => .Eq

-- compare27 = T24.compare
def compare27 : T24 → T24 → Comparison := T24.compare

/-! ### T25 comparison (compare30) -/

def T25.compare (pat pat0 : T25) : Comparison :=
  match pat, pat0 with
  | .Pair (.Pair l1 t) l2, .Pair (.Pair l1' t') l2' =>
    match T_.compare l1 l1' with
    | .Eq => match T24.compare t t' with
      | .Eq => T_.compare l2 l2'
      | x => x
    | x => x

-- compare30 = T25.compare
def compare30 : T25 → T25 → Comparison := T25.compare

/-! ### Tree0 operations -/

def Tree0.create0 (l : T26) (x : T25) (r : T26) : Tree0 :=
  .Node0 (Z.add (Z.max (Tree0.height0 l) (Tree0.height0 r)) Z._1) l x r

def Tree0.assert_false0 : T26 → T25 → T26 → Tree0 := Tree0.create0

def Tree0.bal0 (l : T26) (x : T25) (r : T26) : Tree0 :=
  let hl := Tree0.height0 l
  let hr := Tree0.height0 r
  match Z.ltb (Z.add hr Z._2) hl with
  | .True =>
    match l with
    | .Leaf0 => Tree0.assert_false0 l x r
    | .Node0 _ ll lx lr =>
      match Z.leb (Tree0.height0 lr) (Tree0.height0 ll) with
      | .True => Tree0.create0 ll lx (Tree0.create0 lr x r)
      | .False =>
        match lr with
        | .Leaf0 => Tree0.assert_false0 l x r
        | .Node0 _ lrl lrx lrr =>
          Tree0.create0 (Tree0.create0 ll lx lrl) lrx (Tree0.create0 lrr x r)
  | .False =>
    match Z.ltb (Z.add hl Z._2) hr with
    | .True =>
      match r with
      | .Leaf0 => Tree0.assert_false0 l x r
      | .Node0 _ rl rx rr =>
        match Z.leb (Tree0.height0 rl) (Tree0.height0 rr) with
        | .True => Tree0.create0 (Tree0.create0 l x rl) rx rr
        | .False =>
          match rl with
          | .Leaf0 => Tree0.assert_false0 l x r
          | .Node0 _ rll rlx rlr =>
            Tree0.create0 (Tree0.create0 l x rll) rlx (Tree0.create0 rlr rx rr)
    | .False => Tree0.create0 l x r

def Tree0.add8 (x : T25) : Tree0 → Tree0
  | .Leaf0 => .Node0 Z._1 .Leaf0 x .Leaf0
  | .Node0 h l y r =>
    match T25.compare x y with
    | .Eq => .Node0 h l y r
    | .Lt => Tree0.bal0 (Tree0.add8 x l) y r
    | .Gt => Tree0.bal0 l y (Tree0.add8 x r)

def Tree0.add9 (x : T25) (s : T32) : T32 :=
  Tree0.add8 x (Tree0.this1 s)

/-! ## Sorted list set for T14 (level expression pairs) -/

def T14.compare (x y : T14) : Comparison :=
  match x, y with
  | .Pair l1 b1, .Pair l2 b2 =>
    match T_.compare l1 l2 with
    | .Eq => Nat.my_compare b1 b2
    | c => c

def List.add5 (x : T14) : List T14 → List T14
  | .Nil => .Cons x .Nil
  | .Cons y l =>
    match T14.compare x y with
    | .Eq => .Cons y l  -- already present
    | .Lt => .Cons x (.Cons y l)
    | .Gt => .Cons y (List.add5 x l)

def List.add6 (x : Elt2) (s : T21) : T21 :=
  List.add5 x s

def List.singleton1 (x : Elt1) : List Elt1 :=
  .Cons x .Nil

def List.singleton2 : Elt2 → T21 := List.singleton1
def List.singleton3 : T14 → NonEmptyLevelExprSet := List.singleton2

/-! ## Level expression construction helpers -/

def make (l : T3) : T14 := .Pair l .O
def make' (l : T3) : NonEmptyLevelExprSet := List.singleton3 (make l)

def make1 : T14 → T22 := List.singleton3
def make2 (l1 : T3) (ct : T24) (l2 : T3) : T25 := .Pair (.Pair l1 ct) l2

-- t_set :: NonEmptyLevelExprSet -> T21 ; t_set n = n
def t_set (n : NonEmptyLevelExprSet) : T21 := n

-- this0 :: T_1 -> T18 ; this0 t = t
def this0 (t : T_1) : T18 := t

-- add7 e u = add6 e (t_set u)
def add7 (e : T14) (u : NonEmptyLevelExprSet) : NonEmptyLevelExprSet :=
  List.add6 e (t_set u)

def add_list (es : List T14) (u : NonEmptyLevelExprSet) : NonEmptyLevelExprSet :=
  List.fold_left (fun u' e => add7 e u') es u

def from_kernel_repr (e : Prod T3 Bool) : T14 :=
  .Pair (Prod.fst e) (match Prod.snd e with | .True => .S .O | .False => .O)

def from_kernel_repr1 (e : Prod T3 Bool) (es : List (Prod T3 Bool)) : T23 :=
  .LType (add_list (List.my_map from_kernel_repr es) (make1 (from_kernel_repr e)))

def of_levels (l : Sum T13 T3) : T23 :=
  match l with
  | .Inl .LSProp => .LSProp0
  | .Inl .LProp => .LProp0
  | .Inr l0 => .LType (make' l0)

/-! ## Global environment -/

inductive Global_env where
  | Mk_global_env : T35 → Global_declarations → T37 → Global_env

abbrev BigMama := Prod Global_env Term

end MetaCoq
