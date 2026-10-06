import Mathlib

set_option pp.all true
-- spec: Lean.instHashableLevelMVarId.hash : Lean.LevelMVarId -> UInt64
def Lean.instHashableLevelMVarId.hash : Lean.LevelMVarId -> UInt64 :=
  fun (x._@.Lean.Level.3927547624._hygCtx._hyg.51 : Lean.LevelMVarId) => _private.Lean.Level.0.Lean.instHashableLevelMVarId.hash.match_1.{1} (fun (x._@.Lean.Level.3927547624._hygCtx.51.Lean.Level.1363585665._hygCtx._hyg.7 : Lean.LevelMVarId) => UInt64) x._@.Lean.Level.3927547624._hygCtx._hyg.51 (fun (a._@.Lean.Level.3927547624._hygCtx._hyg.52 : Lean.Name) => mixHash (OfNat.ofNat.{0} UInt64 0 (UInt64.instOfNat 0)) (Hashable.hash.{1} Lean.Name Lean.instHashableName a._@.Lean.Level.3927547624._hygCtx._hyg.52))
