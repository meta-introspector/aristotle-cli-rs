import Split.GetElem
import Split.Eq_rec
import Split.GetElem_getElem
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Eq

-- GetElem.getElem.congr_simp from environment
-- theorem GetElem.getElem.congr_simp : forall {coll : Type.{u}} {idx : Type.{v}} {elem : Type.{w}} {valid : coll -> idx -> Prop} [self : GetElem.{u, v, w} coll idx elem valid] (xs : coll) (xs_1 : coll) (e_xs : Eq.{succ u} coll xs xs_1) (i : idx) (i_1 : idx) (e_i : Eq.{succ v} idx i i_1) (h : valid xs i), Eq.{succ w} elem (GetElem.getElem.{u, v, w} coll idx elem valid self xs i h) (GetElem.getElem.{u, v, w} coll idx elem valid self xs_1 i_1 (Eq.ndrec.{0, succ u} coll xs (fun (xs : coll) => valid xs i_1) (Eq.ndrec.{0, succ v} idx i (fun (i : idx) => valid xs i) h i_1 e_i) xs_1 e_xs))

-- Stub: this file represents the declaration `GetElem.getElem.congr_simp`.
-- In a full split, the body would be extracted from the environment.
