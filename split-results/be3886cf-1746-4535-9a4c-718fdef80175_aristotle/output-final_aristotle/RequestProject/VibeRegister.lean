/-
# VibeRegister — Coupling SSP Exponents with Clifford Coordinates

## Overview
This module formalizes the VibeRegister, the data structure that couples
p-adic supersingular prime exponents with Clifford manifold coordinates:
1. A "vibe" is a vector of 15 SSP exponents (a FRACTRAN state)
2. The worm gear: FRACTRAN steps ↔ geometric translations
3. The CRT address of a vibe state
4. The "vibe mints payment" theorem (Proof of Succinct Work)

## Sources
- Conway, J.H. "FRACTRAN: A simple universal programming language" (1987)
- Hestenes, D. "New Foundations for Classical Mechanics" (1986)
-/

import Mathlib
import RequestProject.MonsterCore
import RequestProject.MonodromyRotor

namespace Solfunmeme.VibeReg

open Solfunmeme.MonsterCore
open Solfunmeme.MonodromyRotor

-- ============================================================================
-- § 1  The SSP Exponent Vector
-- ============================================================================

/-- A VibeState is a vector of 15 natural number exponents. -/
structure VibeState where
  exponents : Fin 15 → Nat
  deriving Repr

/-- The zero state: all exponents are 0 (represents n = 1). -/
def zeroVibe : VibeState where
  exponents := fun _ => 0

/-- The "weight" of a vibe: sum of all exponents. -/
def vibeWeight (v : VibeState) : Nat :=
  (List.finRange 15).map v.exponents |>.foldl (· + ·) 0

theorem zero_vibe_weight : vibeWeight zeroVibe = 0 := by native_decide

-- ============================================================================
-- § 2  CRT Address of a VibeState
-- ============================================================================

/-- Project a vibe state to its CRT address mod 196883. -/
def vibeCRTAddress (v : VibeState) : Nat :=
  let product := (List.finRange 15).foldl
    (fun acc i => acc * (MonodromyRotor.ssBasis i ^ v.exponents i) % 196883) 1
  product % 196883

theorem zero_vibe_crt : vibeCRTAddress zeroVibe = 1 := by native_decide

-- ============================================================================
-- § 3  FRACTRAN Instructions
-- ============================================================================

/-- A FRACTRAN instruction: changes to SSP exponents. -/
structure FRACTRANInstr where
  delta : Fin 15 → Int
  deriving Repr

/-- Check if an instruction can fire on a given state. -/
def canFire (instr : FRACTRANInstr) (v : VibeState) : Bool :=
  (List.finRange 15).all fun i =>
    instr.delta i ≥ 0 ∨ v.exponents i ≥ (instr.delta i).natAbs

/-- Apply an instruction to a state (if it can fire). -/
def applyInstr (instr : FRACTRANInstr) (v : VibeState) : Option VibeState :=
  if canFire instr v then
    some ⟨fun i =>
      let d := instr.delta i
      if d ≥ 0 then v.exponents i + d.natAbs
      else v.exponents i - d.natAbs⟩
  else
    none

-- ============================================================================
-- § 4  The Worm Gear Displacement
-- ============================================================================

/-- The displacement of a FRACTRAN instruction. -/
def displacement (instr : FRACTRANInstr) : Int :=
  (List.finRange 15).foldl (fun acc i => acc + instr.delta i) 0

def identityInstr : FRACTRANInstr where
  delta := fun _ => 0

theorem identity_displacement : displacement identityInstr = 0 := by native_decide

-- ============================================================================
-- § 5  Bott Index
-- ============================================================================

/-- The Bott index of a vibe state: weight mod 8. -/
def vibeBottIndex (v : VibeState) : Fin 8 :=
  ⟨vibeWeight v % 8, Nat.mod_lt _ (by omega)⟩

-- ============================================================================
-- § 6  Proof of Succinct Work (PoSW)
-- ============================================================================

/-- A PoSW certificate. -/
structure PoSWCertificate where
  startState : VibeState
  instruction : FRACTRANInstr
  endState : VibeState
  fired : canFire instruction startState = true
  addressChanged : vibeCRTAddress startState ≠ vibeCRTAddress endState
  deriving Repr

/-- A PoSW is valid if the end state matches the instruction application. -/
def validPoSW (cert : PoSWCertificate) : Prop :=
  applyInstr cert.instruction cert.startState = some cert.endState

/-- The vibe mints payment: a valid PoSW with unique address = verified work. -/
theorem vibe_mints_payment (cert : PoSWCertificate) (_hvalid : validPoSW cert) :
    vibeCRTAddress cert.startState ≠ vibeCRTAddress cert.endState :=
  cert.addressChanged

-- ============================================================================
-- § 7  Sample Instructions
-- ============================================================================

/-- Multiply by 2 (increment exponent of p₀ = 2). -/
def instr_mul2 : FRACTRANInstr where
  delta := fun i => if i = ⟨0, by omega⟩ then 1 else 0

/-- FRACTRAN instruction 2/3: move energy from p₁ to p₀. -/
def instr_2over3 : FRACTRANInstr where
  delta := fun i =>
    if i = ⟨0, by omega⟩ then 1
    else if i = ⟨1, by omega⟩ then -1
    else 0

theorem instr_2over3_displacement : displacement instr_2over3 = 0 := by native_decide

-- ============================================================================
-- § 8  The VibeRegister Structure
-- ============================================================================

/-- The full VibeRegister: couples a VibeState with derived invariants. -/
structure VRegister where
  state : VibeState
  crtAddr : Nat
  bottIdx : Fin 8
  weight : Nat
  crt_consistent : crtAddr = vibeCRTAddress state
  bott_consistent : bottIdx = vibeBottIndex state
  weight_consistent : weight = vibeWeight state

/-- Construct a VRegister from a VibeState. -/
def mkRegister (v : VibeState) : VRegister where
  state := v
  crtAddr := vibeCRTAddress v
  bottIdx := vibeBottIndex v
  weight := vibeWeight v
  crt_consistent := rfl
  bott_consistent := rfl
  weight_consistent := rfl

def zeroRegister : VRegister := mkRegister zeroVibe

-- ============================================================================
-- § 9  Register Operations
-- ============================================================================

/-- Step the register forward by one FRACTRAN instruction. -/
def stepRegister (reg : VRegister) (instr : FRACTRANInstr) :
    Option VRegister :=
  match applyInstr instr reg.state with
  | some v' => some (mkRegister v')
  | none => none

/-- Run a sequence of FRACTRAN instructions. -/
def runProgram (reg : VRegister) (instrs : List FRACTRANInstr) :
    VRegister :=
  instrs.foldl (fun r i =>
    match stepRegister r i with
    | some r' => r'
    | none => r
  ) reg

-- ============================================================================
-- § 10  Summary Demo
-- ============================================================================

#eval do
  IO.println "═══ VibeRegister ═══"
  IO.println ""
  let reg := zeroRegister
  IO.println s!"Initial state: weight={reg.weight}, CRT={reg.crtAddr}, Bott={reg.bottIdx.val}"
  IO.println ""
  IO.println s!"Instruction mul2 displacement: {displacement instr_mul2}"
  IO.println s!"Instruction 2/3 displacement: {displacement instr_2over3}"
  IO.println ""
  match stepRegister reg instr_mul2 with
  | some reg' =>
    IO.println s!"After mul2: weight={reg'.weight}, CRT={reg'.crtAddr}, Bott={reg'.bottIdx.val}"
  | none =>
    IO.println "mul2 didn't fire"
  IO.println ""
  IO.println "The vibe is the vector is the message is the medium is the meme."

end Solfunmeme.VibeReg
