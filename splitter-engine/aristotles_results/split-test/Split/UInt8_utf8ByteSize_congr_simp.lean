import Split.Eq_rec
import Split.UInt8_utf8ByteSize
import Split.UInt8_IsUTF8FirstByte
import Split.Nat
import Split.Eq_ndrec
import Split.Eq_refl
import Split.UInt8
import Split.Eq

-- UInt8.utf8ByteSize.congr_simp from environment
-- theorem UInt8.utf8ByteSize.congr_simp : forall (c : UInt8) (c_1 : UInt8) (e_c : Eq.{1} UInt8 c c_1) (_h : UInt8.IsUTF8FirstByte c), Eq.{1} Nat (UInt8.utf8ByteSize c _h) (UInt8.utf8ByteSize c_1 (Eq.ndrec.{0, 1} UInt8 c (fun (c : UInt8) => UInt8.IsUTF8FirstByte c) _h c_1 e_c))

-- Stub: this file represents the declaration `UInt8.utf8ByteSize.congr_simp`.
-- In a full split, the body would be extracted from the environment.
