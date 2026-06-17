import Mathlib

set_option pp.all true
-- spec: ByteArray.IsValidUTF8.casesOn : forall {b : ByteArray} {motive : (ByteArray.IsValidUTF8 b) -> Prop} (t : ByteArray.IsValidUTF8 b), (forall (m : List.{0} Char) (hm : Eq.{1} ByteArray b (List.utf8Encode m)), motive (ByteArray.IsValidUTF8.intro b m hm)) -> (motive t)
def ByteArray.IsValidUTF8.casesOn : forall {b : ByteArray} {motive : (ByteArray.IsValidUTF8 b) -> Prop} (t : ByteArray.IsValidUTF8 b), (forall (m : List.{0} Char) (hm : Eq.{1} ByteArray b (List.utf8Encode m)), motive (ByteArray.IsValidUTF8.intro b m hm)) -> (motive t) :=
  fun {b : ByteArray} {motive : (ByteArray.IsValidUTF8 b) -> Prop} (t : ByteArray.IsValidUTF8 b) (intro : forall (m : List.{0} Char) (hm : Eq.{1} ByteArray b (List.utf8Encode m)), motive (ByteArray.IsValidUTF8.intro b m hm)) => ByteArray.IsValidUTF8.rec b motive (fun (m : List.{0} Char) (hm : Eq.{1} ByteArray b (List.utf8Encode m)) => intro m hm) t
