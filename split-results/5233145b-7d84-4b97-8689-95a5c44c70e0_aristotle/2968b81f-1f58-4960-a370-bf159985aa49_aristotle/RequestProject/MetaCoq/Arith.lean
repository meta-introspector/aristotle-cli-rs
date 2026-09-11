import RequestProject.MetaCoq.Basic
import RequestProject.MetaCoq.ByteN

/-!
# MetaCoq Arithmetic and Comparison Functions
-/

namespace MetaCoq

/-! ## Nat arithmetic -/

def Nat.add : Nat → Nat → Nat
  | .O, m => m
  | .S p, m => .S (Nat.add p m)

def foldNat : Nat → _root_.Int
  | .O => 0
  | .S n => 1 + foldNat n

/-! ## Positive arithmetic -/

def Positive.my_succ : Positive → Positive
  | .XI p => .XO (Positive.my_succ p)
  | .XO p => .XI p
  | .XH => .XO .XH

def Positive.pred_double : Positive → Positive
  | .XI p => .XI (.XO p)
  | .XO p => .XI (Positive.pred_double p)
  | .XH => .XH

-- Mutually recursive: add and add_carry
mutual
def Positive.add : Positive → Positive → Positive
  | .XI p, .XI q => .XO (Positive.add_carry p q)
  | .XI p, .XO q => .XI (Positive.add p q)
  | .XI p, .XH => .XO (Positive.my_succ p)
  | .XO p, .XI q => .XI (Positive.add p q)
  | .XO p, .XO q => .XO (Positive.add p q)
  | .XO p, .XH => .XI p
  | .XH, .XI q => .XO (Positive.my_succ q)
  | .XH, .XO q => .XI q
  | .XH, .XH => .XO .XH

def Positive.add_carry : Positive → Positive → Positive
  | .XI p, .XI q => .XI (Positive.add_carry p q)
  | .XI p, .XO q => .XO (Positive.add_carry p q)
  | .XI p, .XH => .XI (Positive.my_succ p)
  | .XO p, .XI q => .XO (Positive.add_carry p q)
  | .XO p, .XO q => .XI (Positive.add p q)
  | .XO p, .XH => .XO (Positive.my_succ p)
  | .XH, .XI q => .XI (Positive.my_succ q)
  | .XH, .XO q => .XO (Positive.my_succ q)
  | .XH, .XH => .XI .XH
end

/-! ## Positive comparison -/

def Positive.compare_cont : Comparison → Positive → Positive → Comparison
  | r, .XI p, .XI q => Positive.compare_cont r p q
  | _, .XI p, .XO q => Positive.compare_cont .Gt p q
  | _, .XI _, .XH => .Gt
  | _, .XO p, .XI q => Positive.compare_cont .Lt p q
  | r, .XO p, .XO q => Positive.compare_cont r p q
  | _, .XO _, .XH => .Gt
  | r, .XH, .XH => r
  | _, .XH, _ => .Lt

def Positive.compare : Positive → Positive → Comparison :=
  Positive.compare_cont .Eq

/-! ## Nat comparison -/

def Nat.my_compare : Nat → Nat → Comparison
  | .O, .O => .Eq
  | .O, .S _ => .Lt
  | .S _, .O => .Gt
  | .S n', .S m' => Nat.my_compare n' m'

/-! ## Positive iteration -/

def iterOp (op : α → α → α) : Positive → α → α
  | .XI p0, a => op a (iterOp op p0 (op a a))
  | .XO p0, a => iterOp op p0 (op a a)
  | .XH, a => a

def toNat (x : Positive) : Nat :=
  iterOp Nat.add x (.S .O)

/-! ## N comparison -/

def N.compare : N → N → Comparison
  | .N0, .N0 => .Eq
  | .N0, .Npos _ => .Lt
  | .Npos _, .N0 => .Gt
  | .Npos n', .Npos m' => Positive.compare n' m'

def getNpos : N → Positive
  | .N0 => .XH
  | .Npos x => x

/-! ## Comparison helpers -/

def Comparison.compOpp : Comparison → Comparison
  | .Eq => .Eq
  | .Lt => .Gt
  | .Gt => .Lt

/-! ## Z arithmetic -/

def Z.double : Z → Z
  | .Z0 => .Z0
  | .Zpos p => .Zpos (.XO p)
  | .Zneg p => .Zneg (.XO p)

def Z.succ_double : Z → Z
  | .Z0 => .Zpos .XH
  | .Zpos p => .Zpos (.XI p)
  | .Zneg p => .Zneg (Positive.pred_double p)

def Z.pred_double : Z → Z
  | .Z0 => .Zneg .XH
  | .Zpos p => .Zpos (Positive.pred_double p)
  | .Zneg p => .Zneg (.XI p)

def Z.pos_sub : Positive → Positive → Z
  | .XI p, .XI q => Z.double (Z.pos_sub p q)
  | .XI p, .XO q => Z.succ_double (Z.pos_sub p q)
  | .XI p, .XH => .Zpos (.XO p)
  | .XO p, .XI q => Z.pred_double (Z.pos_sub p q)
  | .XO p, .XO q => Z.double (Z.pos_sub p q)
  | .XO p, .XH => .Zpos (Positive.pred_double p)
  | .XH, .XI q => .Zneg (.XO q)
  | .XH, .XO q => .Zneg (Positive.pred_double q)
  | .XH, .XH => .Z0

def Z.add : Z → Z → Z
  | .Z0, y => y
  | x, .Z0 => x
  | .Zpos x', .Zpos y' => .Zpos (Positive.add x' y')
  | .Zpos x', .Zneg y' => Z.pos_sub x' y'
  | .Zneg x', .Zpos y' => Z.pos_sub y' x'
  | .Zneg x', .Zneg y' => .Zneg (Positive.add x' y')

def Z.compare : Z → Z → Comparison
  | .Z0, .Z0 => .Eq
  | .Z0, .Zpos _ => .Lt
  | .Z0, .Zneg _ => .Gt
  | .Zpos _, .Z0 => .Gt
  | .Zpos x', .Zpos y' => Positive.compare x' y'
  | .Zpos _, .Zneg _ => .Gt
  | .Zneg _, .Z0 => .Lt
  | .Zneg _, .Zpos _ => .Lt
  | .Zneg x', .Zneg y' => Comparison.compOpp (Positive.compare x' y')

def Z.max (n m : Z) : Z :=
  match Z.compare n m with
  | .Lt => m
  | _ => n

def Z.ltb (x y : Z) : Bool :=
  match Z.compare x y with
  | .Lt => .True
  | _ => .False

def Z.leb (x y : Z) : Bool :=
  match Z.compare x y with
  | .Gt => .False
  | _ => .True

/-! ## Z constants -/

def Z._0 : Z := .Z0
def Z._1 : Z := .Zpos .XH
def Z._2 : Z := .Zpos (.XO .XH)

/-! ## Byte/String comparison -/

def Byte.compare (x y : Byte) : Comparison :=
  N.compare (toN x) (toN y)

def MyString.compare : MyString → MyString → Comparison
  | .EmptyString, .EmptyString => .Eq
  | .EmptyString, .String _ _ => .Lt
  | .String _ _, .EmptyString => .Gt
  | .String x xs, .String y ys =>
    match Byte.compare x y with
    | .Eq => MyString.compare xs ys
    | c => c

/-! ## String conversion -/

def Byte.toChar (x : Byte) : Char :=
  Char.ofNat (foldNat (toNat (getNpos (toN x)))).toNat

def MyString.concatChars : MyString → _root_.String
  | .EmptyString => ""
  | .String byte rest => Char.toString (Byte.toChar byte) ++ MyString.concatChars rest

/-! ## Generic list operations -/

def List.fold_right (f : α → β → β) (a0 : β) : List α → β
  | .Nil => a0
  | .Cons b t => f b (List.fold_right f a0 t)

def List.fold_left (f : β → α → β) : List α → β → β
  | .Nil, a0 => a0
  | .Cons b t, a0 => List.fold_left f t (f a0 b)

def List.my_map (f : α → β) : List α → List β
  | .Nil => .Nil
  | .Cons a t => .Cons (f a) (List.my_map f t)

def option_map (f : α → β) : Option α → Option β
  | .Some a => .Some (f a)
  | .None => .None

/-! ## Haskell-original aliases

These are trivial wrappers / aliases present in the Haskell source.
-/

abbrev T0 := Z

-- add1 = Z.add (the actual implementation)
def add1 : Z → Z → Z := Z.add
-- add2 = add1
def add2 : Z → Z → Z := add1

-- compare0 = Positive.compare
def compare0 : Positive → Positive → Comparison := Positive.compare
-- compare1 = N.compare
def compare1 : N → N → Comparison := N.compare
-- compare2 = Z.compare
def compare2 : Z → Z → Comparison := Z.compare
-- compare3 = Byte.compare
def compare3 : Byte → Byte → Comparison := Byte.compare
-- compare4 = MyString.compare
def compare4 : MyString → MyString → Comparison := MyString.compare
-- compare5 = compare4
def compare5 : MyString → MyString → Comparison := compare4

-- ltb0 = Z.ltb
def ltb0 : Z → Z → Bool := Z.ltb
-- leb1 = Z.leb
def leb1 : Z → Z → Bool := Z.leb
-- leb0 = Z.leb
def leb0 : Z → Z → Bool := Z.leb
-- max1 = Z.max
def max1 : Z → Z → Z := Z.max
-- max0 = Z.max
def max0 : Z → Z → Z := Z.max

-- fold_right2 :: (MyString -> [Char] -> [Char]) -> List MyString -> [Char]
def fold_right2 (f : MyString → _root_.String → _root_.String) : List MyString → _root_.String
  | .Nil => ""
  | .Cons b t => f b (fold_right2 f t)

-- toString = Byte.toChar
def toString' (x : Byte) : Char := Byte.toChar x

end MetaCoq
