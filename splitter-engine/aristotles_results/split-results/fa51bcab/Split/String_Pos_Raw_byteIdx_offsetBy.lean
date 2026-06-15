import Split.String_Pos_Raw
import Split.instHAdd
import Split.String_Pos_Raw_offsetBy
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.String_Pos_Raw_byteIdx
import Split.Eq
import Split.rfl

-- String.Pos.Raw.byteIdx_offsetBy from environment
-- theorem String.Pos.Raw.byteIdx_offsetBy : forall {p : String.Pos.Raw} {offset : String.Pos.Raw}, Eq.{1} Nat (String.Pos.Raw.byteIdx (String.Pos.Raw.offsetBy p offset)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (String.Pos.Raw.byteIdx offset) (String.Pos.Raw.byteIdx p))

-- Stub: this file represents the declaration `String.Pos.Raw.byteIdx_offsetBy`.
-- In a full split, the body would be extracted from the environment.
