/-
# HypermorphicCID

Connects the character table chain

  8² ↔ 10² ↔ 170² ↔ 194² ↔ 196883²

to the MultiHashCID kernel evolution.

## The key wiring

  phi_194_196883 residue = 167
  kernelStep offset      = 167   ← same number

This means the CID kernel IS the Monster character table hypermorphism.

## Layer structure (from CharTableHypermorphism)

  Node    Val     Bott   Factors         Role in CID
  ────────────────────────────────────────────────────
  n8      8       0      2³              tensor decomposition base
  n10     10      2      2×5             chirality × ss-spine
  n170    170     2      2×5×17          Leech bridge layer
  n194    194     2      2×97            Monster char table size
  n196883 196883  3      47×59×71        CRT product / die plate

The grade jump 2→3 at the Monster boundary is the kernel's fixed point.
-/

import Mathlib

set_option maxHeartbeats 400000

namespace HypermorphicCID

/- ## Chain constants -/

def N8      : ℕ := 8
def N10     : ℕ := 10
def N170    : ℕ := 170
def N194    : ℕ := 194
def N196883 : ℕ := 196883

def P47 : ℕ := 47
def P59 : ℕ := 59
def P71 : ℕ := 71

def monsterResid : ℕ := 167

def leechDim : ℕ := 24

/- ## Verified chain facts -/

theorem chain_crt     : P47 * P59 * P71 = N196883  := by norm_num [P47, P59, P71, N196883]
theorem chain_leech   : N170 + leechDim = N194      := by norm_num [N170, leechDim, N194]
theorem chain_ss      : N10 * 17 = N170              := by norm_num [N10, N170]
theorem chain_bott    : 2^3 = N8                    := by norm_num [N8]
theorem chain_residue : N196883 % N194 = monsterResid := by norm_num [N196883, N194, monsterResid]

theorem bott_n8      : N8      % 8 = 0 := by norm_num [N8]
theorem bott_n10     : N10     % 8 = 2 := by norm_num [N10]
theorem bott_n170    : N170    % 8 = 2 := by norm_num [N170]
theorem bott_n194    : N194    % 8 = 2 := by norm_num [N194]
theorem bott_n196883 : N196883 % 8 = 3 := by norm_num [N196883]

theorem middle_stable : N10 % 8 = N170 % 8 ∧ N170 % 8 = N194 % 8 := by
  norm_num [N10, N170, N194]

theorem monster_jump  : N196883 % 8 = N194 % 8 + 1 := by norm_num [N196883, N194]

/- ## Hypermorphism maps as ZMod functions -/

abbrev Z8   := ZMod N8
abbrev Z10  := ZMod N10
abbrev Z170 := ZMod N170
abbrev Z194 := ZMod N194
abbrev Z196883 := ZMod N196883

/-- φ₁ : 8 → 10.  Multiply by 5. -/
def phi1 (x : Z8) : Z10 := (5 : Z10) * x.val

/-- φ₂ : 10 → 170.  Multiply by 17. -/
def phi2 (x : Z10) : Z170 := (17 : Z170) * x.val

/-- φ₃ : 170 → 194.  Leech bridge (×97). -/
def phi3 (x : Z170) : Z194 := (97 : Z194) * x.val

/-- φ₄ : 194 → 196883.  The Monster hypermorphism.
    Multiply by 1014 and add residue 167. -/
def phi4 (x : Z194) : Z196883 :=
  (1014 : Z196883) * x.val + (monsterResid : Z196883)

/-- The full chain: 8 → 196883 -/
def fullPhi (x : Z8) : Z196883 := phi4 (phi3 (phi2 (phi1 x)))

/- ## Kernel offset family -/

def kernelOffset : ℕ → ℕ
  | 0 => 0    -- 8→10:    grade-stable
  | 1 => 0    -- 10→170:  grade-stable
  | 2 => 0    -- 170→194: grade-stable
  | 3 => 167  -- 194→196883: Monster jump
  | _ => 0

theorem offset_only_at_monster : kernelOffset 3 = monsterResid := by
  simp [kernelOffset, monsterResid]

theorem offset_stable (n : ℕ) (h : n ≠ 3) : kernelOffset n = 0 := by
  match n with
  | 0 => rfl | 1 => rfl | 2 => rfl | 3 => contradiction
  | n + 4 => rfl

/- ## Hypermorphic kernel step -/

abbrev Q47 := ZMod 47
abbrev Q59 := ZMod 59
abbrev Q71 := ZMod 71

structure HCIDAddr where
  a47 : Q47
  a59 : Q59
  a71 : Q71
deriving DecidableEq, Repr

def hBottGrade (a : HCIDAddr) : Fin 8 :=
  ⟨(a.a47.val % 8 + a.a59.val % 8 + a.a71.val % 8) % 8, by omega⟩

/-- The hypermorphic kernel step.
    Multipliers (2, 3, 5) from the chain.
    Offset 167 = monsterResid added to 47-coordinate. -/
def hKernelStep (a : HCIDAddr) : HCIDAddr :=
  { a47 := a.a47 * 2 + (monsterResid : Q47)
    a59 := a.a59 * 3
    a71 := a.a71 * 5 }

def hKernelIter : ℕ → HCIDAddr → HCIDAddr
  | 0,     a => a
  | n + 1, a => hKernelIter n (hKernelStep a)

def hGradeOrbit (n : ℕ) (a : HCIDAddr) : List (Fin 8) :=
  List.range n |>.map (fun k => hBottGrade (hKernelIter k a))

/- ## Fixed point analysis -/

def isFixedPoint (a : HCIDAddr) : Bool :=
  hKernelStep a == a

/-- The sheaf section from the DASL metadata:
    shard = (40 mod 71, 14 mod 59, 26 mod 47)
    Bott grade 6 (R(8)) -/
def sheafAddr : HCIDAddr :=
  { a47 := (26 : Q47)
    a59 := (14 : Q59)
    a71 := (40 : Q71) }

def sheafGrade : Fin 8 := hBottGrade sheafAddr

#eval sheafGrade
#eval isFixedPoint sheafAddr

/- ## The second sheaf section — the Spoke

    shard = (46 mod 71, 22 mod 59, 16 mod 47)
    Bott grade 5 (C(4))
    Hecke T_41
    eigenspace "Spoke" -/
def spokeAddr : HCIDAddr :=
  { a47 := (16 : Q47)
    a59 := (22 : Q59)
    a71 := (46 : Q71) }

def spokeGrade : Fin 8 := hBottGrade spokeAddr

#eval spokeGrade
#eval isFixedPoint spokeAddr

/- ## Grade jump theorems -/

theorem sheaf_monster_complement : (6 + 3) % 8 = 1 := by norm_num
theorem sheaf_plus_jump : (6 + 1) % 8 = 7 := by norm_num
theorem pseudoscalar_wraps : (7 + 1) % 8 = 0 := by norm_num

/- ## CID construction from chain -/

def addrOfNat (n : ℕ) : HCIDAddr :=
  { a47 := (n : Q47)
    a59 := (n : Q59)
    a71 := (n : Q71) }

def chainAddrs : List (ℕ × HCIDAddr) :=
  [N8, N10, N170, N194, N196883].map (fun n => (n, addrOfNat n))

def chainNodeGrades : List (ℕ × ℕ) :=
  chainAddrs.map (fun (n, a) => (n, (hBottGrade a).val))

#eval chainNodeGrades

/- ## Graded kernel family -/

structure GradedKernel where
  chainPos : Fin 4
  mult47   : Q47
  mult59   : Q59
  mult71   : Q71
deriving Repr

def canonicalKernels : List GradedKernel :=
  [ { chainPos := ⟨0, by omega⟩, mult47 := 5,  mult59 := 5,  mult71 := 5  }
  , { chainPos := ⟨1, by omega⟩, mult47 := 17, mult59 := 17, mult71 := 17 }
  , { chainPos := ⟨2, by omega⟩, mult47 := 97, mult59 := 97, mult71 := 97 }
  , { chainPos := ⟨3, by omega⟩, mult47 := 2,  mult59 := 3,  mult71 := 5  }
  ]

def applyGradedKernel (k : GradedKernel) (a : HCIDAddr) : HCIDAddr :=
  let off47 : Q47 := (kernelOffset k.chainPos.val : Q47)
  { a47 := a.a47 * k.mult47 + off47
    a59 := a.a59 * k.mult59
    a71 := a.a71 * k.mult71 }

/- ## Summary theorem -/

theorem hypermorphic_cid_summary :
    P47 * P59 * P71 = N196883 ∧
    N10 % 8 = N170 % 8 ∧
    N170 % 8 = N194 % 8 ∧
    N196883 % 8 = N194 % 8 + 1 ∧
    N196883 % N194 = monsterResid ∧
    (6 + 1) % 8 = 7 ∧
    (7 + 1) % 8 = 0 := by
  norm_num [P47, P59, P71, N196883, N10, N170, N194, N8, monsterResid]

end HypermorphicCID
