import Split.UnifiedIPLDMemory_DASLType
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_IPLDCodec
import Split.String
import Split.instSizeOfDefault
import Split.instOfNatNat
import Split.ZMod
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.Bool
import Split.UnifiedIPLDMemory_SheafSection_mk
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq
import Split.UnifiedIPLDMemory_SheafSection
import Split.UnifiedIPLDMemory_BottClass

-- UnifiedIPLDMemory.SheafSection.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.SheafSection.mk.sizeOf_spec : forall (cid : String) (shard : FiberedUniverse.S_ss) (encoding : UnifiedIPLDMemory.IPLDCodec) (bottClass : UnifiedIPLDMemory.BottClass) (heckeIndex : Nat) (eigenspace : String) (daslType : UnifiedIPLDMemory.DASLType) (isPrime : Bool) (daslAddr : Nat), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.SheafSection UnifiedIPLDMemory.SheafSection._sizeOf_inst (UnifiedIPLDMemory.SheafSection.mk cid shard encoding bottClass heckeIndex eigenspace daslType isPrime daslAddr)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst cid)) (SizeOf.sizeOf.{1} FiberedUniverse.S_ss (Prod._sizeOf_inst.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)))) (Prod._sizeOf_inst.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59)))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))))) shard)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDCodec UnifiedIPLDMemory.IPLDCodec._sizeOf_inst encoding)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.BottClass UnifiedIPLDMemory.BottClass._sizeOf_inst bottClass)) (SizeOf.sizeOf.{1} Nat instSizeOfNat heckeIndex)) (SizeOf.sizeOf.{1} String String._sizeOf_inst eigenspace)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.DASLType UnifiedIPLDMemory.DASLType._sizeOf_inst daslType)) (SizeOf.sizeOf.{1} Bool Bool._sizeOf_inst isPrime)) (SizeOf.sizeOf.{1} Nat instSizeOfNat daslAddr))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.SheafSection.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
