import Split.Exists
import Split.Eq_rec
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Exists_choose
import Split.Eq

-- Exists.choose.congr_simp from environment
-- theorem Exists.choose.congr_simp : forall {α : Sort.{u_1}} {p : α -> Prop} {p_1 : α -> Prop} (e_p : Eq.{max 1 u_1} (α -> Prop) p p_1) (P : Exists.{u_1} α (fun (a : α) => p a)), Eq.{u_1} α (Exists.choose.{u_1} α p P) (Exists.choose.{u_1} α p_1 (Eq.ndrec.{0, max 1 u_1} (α -> Prop) p (fun {p : α -> Prop} => Exists.{u_1} α (fun (a : α) => p a)) P p_1 e_p))

-- Stub: this file represents the declaration `Exists.choose.congr_simp`.
-- In a full split, the body would be extracted from the environment.
