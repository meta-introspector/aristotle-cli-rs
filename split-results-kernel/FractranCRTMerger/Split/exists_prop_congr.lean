import Split.Iff_mpr
import Split.Exists
import Split.Iff
import Split.Iff_intro
import Split.Exists_intro
import Split.Iff_mp

-- exists_prop_congr from environment
-- theorem exists_prop_congr : forall {p : Prop} {p' : Prop} {q : p -> Prop} {q' : p -> Prop}, (forall (h : p), Iff (q h) (q' h)) -> (forall (hp : Iff p p'), Iff (Exists.{0} p q) (Exists.{0} p' (fun (h : p') => q' (Iff.mpr p p' hp h))))

-- Stub: this file represents the declaration `exists_prop_congr`.
-- In a full split, the body would be extracted from the environment.
