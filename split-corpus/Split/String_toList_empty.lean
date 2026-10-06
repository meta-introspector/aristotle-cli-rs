import Mathlib

-- spec: theorem String.toList_empty : Eq.{1} (List.{0} Char) (String.toList "") (List.nil.{0} Char)
theorem String.toList_empty : Eq.{1} (List.{0} Char) (String.toList "") (List.nil.{0} Char) :=
  of_eq_true (Eq.{1} (List.{0} Char) (String.toList "") (List.nil.{0} Char)) (Eq.trans.{1} Prop (Eq.{1} (List.{0} Char) (String.toList "") (List.nil.{0} Char)) (Eq.{1} (List.{0} Char) (List.nil.{0} Char) (List.nil.{0} Char)) True (congrFun'.{1, 1} (List.{0} Char) Prop (Eq.{1} (List.{0} Char) (String.toList "")) (Eq.{1} (List.{0} Char) (List.nil.{0} Char)) (congrArg.{1, 1} (List.{0} Char) ((List.{0} Char) -> Prop) (String.toList "") (List.nil.{0} Char) (Eq.{1} (List.{0} Char)) (congrArg.{1, 1} (Array.{0} Char) (List.{0} Char) (String.Internal.toArray "") (List.toArray.{0} Char (List.nil.{0} Char)) (Array.toList.{0} Char) String.Internal.toArray_empty)) (List.nil.{0} Char)) (eq_self.{1} (List.{0} Char) (List.nil.{0} Char)))
