import Mathlib

-- spec: recursor ByteArray.utf8DecodeChar?.FirstByte.rec : forall {motive : ByteArray.utf8DecodeChar?.FirstByte -> Sort.{u}}, (motive ByteArray.utf8DecodeChar?.FirstByte.invalid) -> (motive ByteArray.utf8DecodeChar?.FirstByte.done) -> (motive ByteArray.utf8DecodeChar?.FirstByte.oneMore) -> (motive ByteArray.utf8DecodeChar?.FirstByte.twoMore) -> (motive ByteArray.utf8DecodeChar?.FirstByte.threeMore) -> (forall (t : ByteArray.utf8DecodeChar?.FirstByte), motive t)
