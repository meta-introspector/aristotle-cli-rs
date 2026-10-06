import Mathlib

-- spec: theorem AddressType.ofNat_ctorIdx : forall (x : AddressType), Eq.{1} AddressType (AddressType.ofNat (AddressType.ctorIdx x)) x
theorem AddressType.ofNat_ctorIdx : forall (x : AddressType), Eq.{1} AddressType (AddressType.ofNat (AddressType.ctorIdx x)) x :=
  fun (x : AddressType) => AddressType.casesOn.{0} (fun (x : AddressType) => Eq.{1} AddressType (AddressType.ofNat (AddressType.ctorIdx x)) x) x (Eq.refl.{1} AddressType AddressType.monsterWalk) (Eq.refl.{1} AddressType AddressType.astNode) (Eq.refl.{1} AddressType AddressType.protocol) (Eq.refl.{1} AddressType AddressType.nestedCID) (Eq.refl.{1} AddressType AddressType.harmonicPath) (Eq.refl.{1} AddressType AddressType.shardId) (Eq.refl.{1} AddressType AddressType.eigenspace) (Eq.refl.{1} AddressType AddressType.hauptmodul)
