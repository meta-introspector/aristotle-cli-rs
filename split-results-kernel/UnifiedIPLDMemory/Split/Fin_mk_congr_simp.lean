import Split.Eq_rec
import Split.Fin_mk
import Split.Nat
import Split.LT_lt
import Split.Eq_ndrec
import Split.Eq_refl
import Split.instLTNat
import Split.Fin
import Split.Eq

-- Fin.mk.congr_simp from environment
-- theorem Fin.mk.congr_simp : forall {n : Nat} (val : Nat) (val_1 : Nat) (e_val : Eq.{1} Nat val val_1) (isLt : LT.lt.{0} Nat instLTNat val n), Eq.{1} (Fin n) (Fin.mk n val isLt) (Fin.mk n val_1 (Eq.ndrec.{0, 1} Nat val (fun (val : Nat) => LT.lt.{0} Nat instLTNat val n) isLt val_1 e_val))

-- Stub: this file represents the declaration `Fin.mk.congr_simp`.
-- In a full split, the body would be extracted from the environment.
