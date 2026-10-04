import Mathlib

set_option pp.all true
-- spec: String.Slice.pos! : forall (s : String.Slice), String.Pos.Raw -> (String.Slice.Pos s)
def String.Slice.pos! : forall (s : String.Slice), String.Pos.Raw -> (String.Slice.Pos s) :=
  fun (s : String.Slice) (off : String.Pos.Raw) => dite.{1} (String.Slice.Pos s) (Eq.{1} Bool (String.Pos.Raw.isValidForSlice s off) Bool.true) (instDecidableEqBool (String.Pos.Raw.isValidForSlice s off) Bool.true) (fun (h : Eq.{1} Bool (String.Pos.Raw.isValidForSlice s off) Bool.true) => String.Slice.pos s off (String.Slice.pos?._proof_1 s off h)) (fun (h : Not (Eq.{1} Bool (String.Pos.Raw.isValidForSlice s off) Bool.true)) => panicWithPosWithDecl.{1} (String.Slice.Pos s) (String.instInhabitedPos_1 s) "Init.Data.String.Basic" "String.Slice.pos!" (OfNat.ofNat.{0} Nat 1669 (instOfNatNat 1669)) (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) "Offset is not at a valid UTF-8 character boundary")
