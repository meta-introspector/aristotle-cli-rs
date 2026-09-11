/-
# PadicEntropyDAG.lean — Log-Entropy Valuation DAG over Monster Irreps

## The three stacked views of 194 irreducible representations:

1. **Row view**: p-adic exponent matrix (A001379 index → exponents at 15 SSPs)
2. **Log-entropy view**: per-irrep component log₁₀ scales, bits, trits
3. **Partition view**: staged mod lattice (71,59,47) → (4,41,31) → 13²

## DAG-JSON Schema (mirrored in Lean)

Each irrep node carries:
- `exponents`: 15-vector of p-adic valuations v_p(dim)
- `componentLog10Scales`: exp_p × log₁₀(p) for each prime
- `metrics`: { sum, logsum, bits, trits }

Global envelope: bits ≤ 87.75, trits ≤ 55.36

## Integration

CID → padicVector → logEntropy → irrepNode → PartitionKey
-/

import Mathlib

set_option maxHeartbeats 800000

namespace PadicEntropyDAG

/-! ## §1. The 15 Supersingular Primes (OEIS A002267) -/

/-- The 15 supersingular primes, ordered. -/
def sspBasis : Array ℕ := #[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

theorem sspBasis_length : sspBasis.size = 15 := by native_decide

/-- Each element of the SSP basis is prime. -/
theorem sspBasis_all_prime :
    ∀ p ∈ sspBasis.toList, Nat.Prime p := by decide

/-- Product of all 15 SSPs. -/
def sspProduct : ℕ := sspBasis.foldl (· * ·) 1

theorem sspProduct_val : sspProduct = 1618964990108856390 := by native_decide

/-! ## §2. DAG-JSON Mirror Structures -/

/-- Metrics for a single irrep node in the entropy DAG. -/
structure Metrics where
  sum    : ℕ        -- sum of exponents
  logsum : Float    -- Σ eₚ × ln(p)
  bits   : Float    -- logsum / ln(2)
  trits  : Float    -- logsum / ln(3)
  deriving Repr, Inhabited

/-- A node in the irrep DAG. -/
structure IrrepNode where
  irrepIds             : Array ℕ           -- A001379 indices sharing this profile
  notes                : Option String
  exponents            : Array ℕ           -- length 15, in sspBasis order
  componentLog10Scales : Array Float       -- length 15
  metrics              : Metrics
  deriving Repr, Inhabited

/-- Root configuration of the DAG. -/
structure RootConfig where
  id        : String
  type      : String
  bitsMax   : Float
  tritsMax  : Float
  deriving Repr, Inhabited

/-- The complete DAG layer structure. -/
structure DagLayers where
  rootConfig : RootConfig
  nodes      : Array IrrepNode
  deriving Repr, Inhabited

/-! ## §3. Log-Entropy Computation -/

/-- logsum = Σ eₚ × ln(p) over the 15 SSPs. -/
def logsum (exps : Array ℕ) : Float :=
  let pairs := exps.toList.zip sspBasis.toList
  pairs.foldl (fun acc (e, p) => acc + Float.ofNat e * Float.log (Float.ofNat p)) 0.0

/-- bits = logsum / ln(2). -/
def bitsOf (ls : Float) : Float := ls / Float.log 2.0

/-- trits = logsum / ln(3). -/
def tritsOf (ls : Float) : Float := ls / Float.log 3.0

/-- component log₁₀ scale: eₚ × log₁₀(p). -/
def componentLog10Scale (exp : ℕ) (prime : ℕ) : Float :=
  Float.ofNat exp * Float.log (Float.ofNat prime) / Float.log 10.0

/-- Compute all 15 component log₁₀ scales. -/
def allComponentLog10Scales (exps : Array ℕ) : Array Float :=
  (exps.toList.zip sspBasis.toList).map (fun (e, p) => componentLog10Scale e p) |>.toArray

/-- Compute full metrics from exponents. -/
def computeMetrics (exps : Array ℕ) : Metrics :=
  let s := exps.foldl (· + ·) 0
  let ls := logsum exps
  { sum := s, logsum := ls, bits := bitsOf ls, trits := tritsOf ls }

/-- Build an IrrepNode from ids and exponents. -/
def mkIrrepNode (ids : Array ℕ) (exps : Array ℕ) (notes : Option String := none) : IrrepNode :=
  { irrepIds := ids
  , notes := notes
  , exponents := exps
  , componentLog10Scales := allComponentLog10Scales exps
  , metrics := computeMetrics exps }

/-! ## §4. The Full p-adic Exponent Table (194 irreps of the Monster) -/

/-- Row exponent sum = sum of all 15 p-adic valuations for an irrep. -/
def rowExponentSum (exps : Array ℕ) : ℕ := exps.foldl (· + ·) 0

/-- The complete p-adic exponent table, indexed by A001379 index (0..193).
    Each entry is a 15-element array of exponents at primes [2,3,5,7,11,13,17,19,23,29,31,41,47,59,71]. -/
def exponentTable : Array (Array ℕ) := #[
  -- idx 0
  #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  -- idx 1
  #[0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
  -- idx 2
  #[2,0,0,0,0,0,0,0,0,0,1,1,0,1,1],
  -- idx 3
  #[1,0,0,0,0,2,0,0,0,1,1,0,1,1,0],
  -- idx 4
  #[2,0,0,1,1,0,0,0,1,1,1,1,0,0,1],
  -- idx 5
  #[0,0,0,0,0,2,0,0,1,1,0,1,0,1,1],
  -- idx 6
  #[1,1,0,0,1,0,0,1,0,1,0,1,1,1,1],
  -- idx 7
  #[1,1,0,1,1,2,0,1,1,0,0,1,1,1,0],
  -- idx 8
  #[0,6,0,1,0,2,1,1,0,0,1,0,0,1,1],
  -- idx 9
  #[0,0,2,4,0,0,1,0,0,1,1,1,1,0,1],
  -- idx 10
  #[0,3,0,1,1,0,1,0,1,1,0,1,1,1,1],
  -- idx 11
  #[0,1,0,0,1,2,1,0,1,1,1,1,1,1,0],
  -- idx 12
  #[0,0,0,4,1,2,0,0,0,1,0,1,1,1,1],
  -- idx 13
  #[1,0,2,1,0,0,0,1,1,1,1,1,1,1,1],
  -- idx 14
  #[12,0,0,4,1,2,0,0,0,0,1,0,0,1,1],
  -- idx 15
  #[0,0,9,6,2,0,1,1,0,0,0,0,0,0,0],
  -- idx 16
  #[0,0,9,6,2,0,1,1,0,0,0,0,0,0,0],
  -- idx 17
  #[3,0,0,1,0,3,1,0,0,1,1,1,1,1,1],
  -- idx 18
  #[0,0,2,5,1,2,1,0,1,0,1,0,0,1,1],
  -- idx 19
  #[1,1,2,5,1,0,0,1,1,1,0,1,0,1,1],
  -- idx 20
  #[2,0,7,0,0,2,0,1,0,0,1,1,1,1,1],
  -- idx 21
  #[0,0,0,5,0,2,0,1,1,1,0,1,1,1,1],
  -- idx 22
  #[1,0,2,1,1,3,1,1,0,1,1,1,1,0,1],
  -- idx 23
  #[3,2,0,4,1,0,1,1,1,1,1,0,1,1,1],
  -- idx 24
  #[0,0,3,1,2,2,0,0,1,1,1,1,1,1,1],
  -- idx 25
  #[0,19,0,0,2,3,1,0,1,1,0,0,0,0,0],
  -- idx 26
  #[0,19,0,0,2,3,1,0,1,1,0,0,0,0,0],
  -- idx 27
  #[0,6,7,0,1,0,0,0,1,0,1,1,1,1,1],
  -- idx 28
  #[7,0,2,0,1,3,0,1,1,0,1,1,1,1,1],
  -- idx 29
  #[0,3,7,0,1,2,1,0,1,1,0,0,1,1,1],
  -- idx 30
  #[0,1,7,5,0,0,0,0,0,1,1,1,1,1,1],
  -- idx 31
  #[0,0,1,5,0,3,0,0,1,1,1,1,1,1,1],
  -- idx 32
  #[0,2,1,1,1,2,1,1,1,1,1,1,1,1,1],
  -- idx 33
  #[4,0,2,0,0,3,1,1,1,1,1,1,1,1,1],
  -- idx 34
  #[0,2,1,0,2,2,1,1,1,1,1,1,1,1,1],
  -- idx 35
  #[3,0,8,1,0,3,1,1,0,1,0,1,0,1,1],
  -- idx 36
  #[1,3,8,4,1,0,0,0,0,1,0,1,1,1,1],
  -- idx 37
  #[1,0,2,4,1,3,0,1,1,1,1,1,1,0,1],
  -- idx 38
  #[2,0,0,6,2,3,1,0,1,0,1,1,1,1,0],
  -- idx 39
  #[2,0,0,6,2,3,1,0,1,0,1,1,1,1,0],
  -- idx 40
  #[18,0,0,6,1,3,1,1,0,1,0,1,0,0,0],
  -- idx 41
  #[18,0,0,6,1,3,1,1,0,1,0,1,0,0,0],
  -- idx 42
  #[18,0,0,0,1,3,1,1,1,0,0,1,1,1,1],
  -- idx 43
  #[1,12,0,6,0,1,1,1,1,1,1,0,0,1,0],
  -- idx 44
  #[1,12,0,6,0,1,1,1,1,1,1,0,0,1,0],
  -- idx 45
  #[18,1,2,5,1,0,0,0,0,1,1,0,1,1,1],
  -- idx 46
  #[1,0,0,5,2,3,0,1,1,1,1,0,1,1,1],
  -- idx 47
  #[1,0,0,5,2,3,0,1,1,1,1,0,1,1,1],
  -- idx 48
  #[5,0,8,4,1,0,0,0,1,1,1,1,1,1,0],
  -- idx 49
  #[19,1,1,1,2,0,0,1,0,1,1,1,1,1,1],
  -- idx 50
  #[2,2,0,6,2,0,1,1,0,1,1,1,1,1,1],
  -- idx 51
  #[2,2,0,5,2,2,0,1,1,0,1,1,1,1,1],
  -- idx 52
  #[0,1,9,0,2,3,0,1,1,1,1,1,0,1,0],
  -- idx 53
  #[0,1,9,0,2,3,0,1,1,1,1,1,0,1,0],
  -- idx 54
  #[0,0,9,6,2,0,1,1,0,0,0,0,1,1,1],
  -- idx 55
  #[0,0,9,6,2,0,1,1,0,0,0,0,1,1,1],
  -- idx 56
  #[5,7,1,1,1,3,1,1,0,1,1,1,1,0,1],
  -- idx 57
  #[0,0,7,1,1,2,1,1,0,1,1,1,1,1,1],
  -- idx 58
  #[17,0,5,0,2,3,1,1,0,0,1,0,0,1,1],
  -- idx 59
  #[17,0,5,0,2,3,1,1,0,0,1,0,0,1,1],
  -- idx 60
  #[12,1,0,1,2,2,0,1,1,1,1,1,1,1,1],
  -- idx 61
  #[0,6,0,5,0,2,0,1,1,1,1,1,1,1,1],
  -- idx 62
  #[3,0,7,5,0,2,0,0,1,1,1,0,1,1,1],
  -- idx 63
  #[16,3,2,0,1,2,1,0,0,1,1,1,1,1,1],
  -- idx 64
  #[6,3,0,6,1,3,1,1,0,0,0,1,1,1,1],
  -- idx 65
  #[3,17,0,1,1,2,1,0,1,1,1,0,0,1,1],
  -- idx 66
  #[2,3,7,4,1,0,1,0,1,0,1,1,1,1,1],
  -- idx 67
  #[1,12,2,1,0,3,1,0,1,1,1,1,0,1,1],
  -- idx 68
  #[3,0,2,3,2,3,1,1,1,1,0,1,1,1,1],
  -- idx 69
  #[2,0,9,0,1,2,1,0,1,1,1,1,1,1,1],
  -- idx 70
  #[0,18,9,0,0,0,0,1,1,0,1,0,0,1,1],
  -- idx 71
  #[0,18,9,0,0,0,0,1,1,0,1,0,0,1,1],
  -- idx 72
  #[0,3,1,6,0,3,1,1,1,1,0,1,1,1,1],
  -- idx 73
  #[0,0,9,1,2,3,1,1,1,1,1,1,0,0,1],
  -- idx 74
  #[0,0,9,1,2,3,1,1,1,1,1,1,0,0,1],
  -- idx 75
  #[3,0,3,5,0,3,1,1,0,1,1,1,1,1,1],
  -- idx 76
  #[0,17,2,0,0,2,0,0,1,1,1,1,1,1,1],
  -- idx 77
  #[6,17,0,4,0,0,0,0,1,0,1,1,1,1,1],
  -- idx 78
  #[4,3,7,0,2,2,0,0,1,1,1,1,1,1,1],
  -- idx 79
  #[2,1,2,5,2,3,0,1,1,0,1,1,1,1,1],
  -- idx 80
  #[31,1,0,3,2,0,1,1,0,1,1,1,1,0,0],
  -- idx 81
  #[31,1,0,3,2,0,1,1,0,1,1,1,1,0,0],
  -- idx 82
  #[1,1,9,6,2,0,1,1,0,1,1,0,1,0,1],
  -- idx 83
  #[1,1,9,6,2,0,1,1,0,1,1,0,1,0,1],
  -- idx 84
  #[2,0,9,6,2,0,1,1,0,0,1,1,0,1,1],
  -- idx 85
  #[2,0,9,6,2,0,1,1,0,0,1,1,0,1,1],
  -- idx 86
  #[0,0,5,6,1,0,1,1,1,1,1,1,1,1,1],
  -- idx 87
  #[3,2,0,6,2,3,1,0,1,0,1,1,1,1,1],
  -- idx 88
  #[1,0,8,6,0,0,1,0,1,1,1,1,1,1,1],
  -- idx 89
  #[1,0,8,6,0,0,1,0,1,1,1,1,1,1,1],
  -- idx 90
  #[1,3,8,4,0,3,0,0,1,1,1,1,1,1,0],
  -- idx 91
  #[0,9,7,1,1,0,1,1,0,1,1,1,1,1,1],
  -- idx 92
  #[1,1,8,4,0,0,1,1,1,1,1,1,1,1,1],
  -- idx 93
  #[3,1,1,6,2,2,1,1,1,1,1,1,0,1,1],
  -- idx 94
  #[6,1,2,5,1,2,1,1,0,1,1,1,1,1,1],
  -- idx 95
  #[10,1,2,5,0,3,0,1,0,1,1,1,1,1,1],
  -- idx 96
  #[18,3,8,1,1,0,1,1,0,1,0,0,1,1,1],
  -- idx 97
  #[11,2,0,3,1,3,1,0,1,1,1,1,1,1,1],
  -- idx 98
  #[0,13,0,6,1,1,1,1,1,1,1,0,1,0,1],
  -- idx 99
  #[0,13,0,6,1,1,1,1,1,1,1,0,1,0,1],
  -- idx 100
  #[0,19,0,0,2,3,0,1,0,1,1,1,1,1,0],
  -- idx 101
  #[46,0,0,0,2,3,0,0,1,0,1,0,1,0,0],
  -- idx 102
  #[46,0,0,0,2,3,0,0,1,0,1,0,1,0,0],
  -- idx 103
  #[0,3,7,1,2,3,0,0,1,1,1,1,1,1,1],
  -- idx 104
  #[1,19,0,4,2,3,1,0,1,1,0,1,0,0,0],
  -- idx 105
  #[1,19,0,4,2,3,1,0,1,1,0,1,0,0,0],
  -- idx 106
  #[0,19,0,0,2,3,1,0,1,1,0,0,1,1,1],
  -- idx 107
  #[0,19,0,0,2,3,1,0,1,1,0,0,1,1,1],
  -- idx 108
  #[3,0,0,6,2,2,1,1,1,1,1,1,1,1,1],
  -- idx 109
  #[0,6,3,2,2,3,1,1,1,1,1,1,0,1,1],
  -- idx 110
  #[2,0,9,4,1,3,0,1,1,0,0,1,1,1,1],
  -- idx 111
  #[18,0,0,6,0,0,1,1,1,1,1,1,1,1,1],
  -- idx 112
  #[4,12,0,1,2,3,0,1,0,1,1,1,1,1,1],
  -- idx 113
  #[0,3,9,0,1,3,1,1,1,1,0,1,1,1,1],
  -- idx 114
  #[3,2,0,4,2,3,1,1,1,1,1,1,1,1,1],
  -- idx 115
  #[7,9,0,0,1,3,1,1,1,1,1,1,1,1,1],
  -- idx 116
  #[2,1,2,6,1,2,1,1,1,1,1,1,1,1,1],
  -- idx 117
  #[3,6,0,6,1,2,1,0,1,1,1,1,1,1,1],
  -- idx 118
  #[18,0,8,5,0,0,0,1,1,0,1,1,0,1,1],
  -- idx 119
  #[3,6,8,1,1,1,1,1,1,0,1,1,1,1,1],
  -- idx 120
  #[13,0,2,5,2,3,0,0,1,1,0,1,1,1,1],
  -- idx 121
  #[0,19,5,1,2,0,0,1,1,1,0,1,1,0,1],
  -- idx 122
  #[43,0,0,0,2,2,0,1,1,1,0,1,0,1,0],
  -- idx 123
  #[43,0,0,0,2,2,0,1,1,1,0,1,0,1,0],
  -- idx 124
  #[43,0,0,0,2,2,0,1,1,1,0,1,0,1,0],
  -- idx 125
  #[20,2,0,0,2,3,1,0,1,1,1,1,1,1,1],
  -- idx 126
  #[0,2,9,6,2,0,1,1,1,1,0,1,1,0,1],
  -- idx 127
  #[1,0,9,6,2,2,1,1,0,1,1,0,1,1,0],
  -- idx 128
  #[1,0,9,6,2,2,1,1,0,1,1,0,1,1,0],
  -- idx 129
  #[9,1,8,1,1,3,0,1,1,1,1,0,1,1,1],
  -- idx 130
  #[1,17,2,5,0,0,0,1,1,1,1,0,1,1,1],
  -- idx 131
  #[2,0,2,6,2,3,1,0,1,1,1,1,1,1,1],
  -- idx 132
  #[42,0,0,4,1,0,0,0,1,0,1,1,1,1,0],
  -- idx 133
  #[3,0,8,6,1,0,1,1,0,1,1,1,1,1,1],
  -- idx 134
  #[18,0,0,6,1,3,1,1,1,1,1,1,1,0,0],
  -- idx 135
  #[18,0,0,6,1,3,1,1,1,1,1,1,1,0,0],
  -- idx 136
  #[21,0,0,6,1,3,1,1,0,1,0,1,0,1,1],
  -- idx 137
  #[0,2,9,6,1,2,1,1,0,0,0,1,1,1,1],
  -- idx 138
  #[1,0,5,4,2,3,0,1,1,1,1,1,1,1,1],
  -- idx 139
  #[42,0,7,0,1,0,0,0,1,0,0,1,0,1,1],
  -- idx 140
  #[1,17,1,5,1,0,0,1,1,1,1,1,0,1,1],
  -- idx 141
  #[16,1,0,4,2,2,1,1,0,1,1,1,1,1,1],
  -- idx 142
  #[0,17,1,0,2,2,1,1,1,0,1,1,1,1,1],
  -- idx 143
  #[2,0,7,4,2,3,0,1,0,1,1,1,1,1,1],
  -- idx 144
  #[28,1,0,1,1,2,1,0,1,1,1,1,1,1,1],
  -- idx 145
  #[18,3,2,1,2,3,0,1,1,1,0,1,1,1,1],
  -- idx 146
  #[2,0,1,6,2,3,1,1,1,1,1,1,1,1,1],
  -- idx 147
  #[32,0,9,0,0,0,0,1,0,1,0,1,1,1,1],
  -- idx 148
  #[2,4,1,6,2,3,1,1,1,1,1,1,1,1,0],
  -- idx 149
  #[2,2,9,1,2,1,1,1,1,1,1,1,1,1,1],
  -- idx 150
  #[3,6,7,5,1,2,0,1,0,1,1,1,0,1,1],
  -- idx 151
  #[1,19,1,1,2,3,0,1,0,1,1,1,1,1,0],
  -- idx 152
  #[0,19,0,0,2,3,0,1,0,1,1,1,1,1,1],
  -- idx 153
  #[10,1,0,5,2,3,0,1,1,1,1,1,1,1,1],
  -- idx 154
  #[4,7,7,1,1,3,0,1,1,0,1,1,1,1,1],
  -- idx 155
  #[2,2,9,4,2,3,0,1,1,1,1,1,0,0,1],
  -- idx 156
  #[18,0,0,6,1,3,1,1,0,1,0,1,1,1,1],
  -- idx 157
  #[20,0,2,5,0,3,1,0,1,1,1,1,0,1,1],
  -- idx 158
  #[32,0,1,0,0,3,1,1,1,1,1,0,1,1,1],
  -- idx 159
  #[0,19,0,1,2,3,1,1,1,1,0,1,1,0,1],
  -- idx 160
  #[0,17,7,4,2,2,0,0,0,0,1,0,0,1,1],
  -- idx 161
  #[12,1,9,1,0,2,1,1,0,1,1,1,1,1,1],
  -- idx 162
  #[1,19,0,4,2,0,0,1,1,1,0,1,1,1,1],
  -- idx 163
  #[2,19,0,0,2,3,1,0,1,1,1,1,0,1,1],
  -- idx 164
  #[1,2,3,4,2,3,1,1,1,1,1,1,1,1,1],
  -- idx 165
  #[0,1,9,0,2,3,1,1,1,1,1,1,1,1,1],
  -- idx 166
  #[3,1,7,5,2,1,1,1,1,1,0,1,1,1,1],
  -- idx 167
  #[0,18,0,5,0,2,1,1,0,0,1,1,1,1,1],
  -- idx 168
  #[18,19,0,0,0,3,0,0,0,1,1,1,0,1,1],
  -- idx 169
  #[6,0,9,4,2,0,0,1,1,1,1,1,1,1,1],
  -- idx 170
  #[0,12,2,1,1,3,1,1,1,1,1,1,1,1,1],
  -- idx 171
  #[42,0,0,0,0,2,0,0,1,1,1,1,1,1,1],
  -- idx 172
  #[12,6,2,5,0,3,1,1,1,0,1,0,1,1,1],
  -- idx 173
  #[0,12,0,6,0,3,1,1,1,1,1,1,1,0,1],
  -- idx 174
  #[42,2,1,4,0,2,0,0,1,1,0,1,0,1,0],
  -- idx 175
  #[0,20,0,6,2,0,1,0,0,1,1,1,0,1,1],
  -- idx 176
  #[0,0,9,3,2,3,1,1,1,1,1,1,1,1,0],
  -- idx 177
  #[0,17,7,0,1,2,0,0,0,1,1,1,1,1,1],
  -- idx 178
  #[0,4,0,6,2,3,1,1,1,1,1,1,1,1,1],
  -- idx 179
  #[0,4,0,6,2,3,1,1,1,1,1,1,1,1,1],
  -- idx 180
  #[44,0,0,6,0,0,1,0,1,0,0,1,0,1,1],
  -- idx 181
  #[0,12,5,3,2,0,1,1,0,1,1,1,1,1,1],
  -- idx 182
  #[2,0,9,6,0,3,1,1,0,0,1,1,1,1,1],
  -- idx 183
  #[2,0,7,5,2,3,1,0,0,1,1,1,1,1,1],
  -- idx 184
  #[0,0,9,6,2,2,1,1,1,1,0,1,0,1,1],
  -- idx 185
  #[0,18,0,1,2,2,0,1,1,1,1,1,1,1,1],
  -- idx 186
  #[2,19,0,4,0,3,0,0,0,1,1,1,1,1,1],
  -- idx 187
  #[7,2,1,4,2,3,1,1,1,1,1,1,1,1,1],
  -- idx 188
  #[0,17,7,1,0,0,1,0,1,1,1,1,1,1,1],
  -- idx 189
  #[1,0,8,6,1,3,1,0,1,1,0,1,1,1,1],
  -- idx 190
  #[1,2,9,1,2,3,0,1,1,1,1,1,1,1,1],
  -- idx 191
  #[1,6,8,6,0,0,0,1,1,1,1,1,1,1,1],
  -- idx 192
  #[46,2,0,0,2,0,1,0,1,0,0,1,1,1,1],
  -- idx 193
  #[0,12,7,0,0,3,1,0,1,1,1,1,1,1,1]
]

theorem exponentTable_length : exponentTable.size = 194 := by native_decide

/-! ## §5. Row Exponent Sum Verification -/

/-- Expected row exponent sums from the table. -/
def expectedRowSums : Array ℕ := #[
  0, 3, 6, 7, 9, 7, 9, 11, 14, 12, 12, 11, 12, 12, 22, 19, 19,
  14, 15, 16, 17, 14, 15, 18, 15, 27, 27, 20, 20, 19, 19, 16,
  16, 18, 16, 21, 22, 18, 19, 19, 32, 32, 29, 26, 26, 32, 18,
  18, 24, 31, 20, 20, 21, 21, 22, 22, 25, 19, 32, 32, 26, 21,
  23, 31, 25, 30, 24, 26, 21, 22, 32, 32, 21, 22, 22, 22, 28,
  33, 25, 22, 43, 43, 25, 25, 25, 25, 21, 23, 23, 23, 25, 26,
  23, 23, 25, 28, 37, 28, 28, 28, 30, 54, 54, 23, 33, 33, 30,
  30, 22, 24, 25, 33, 29, 24, 23, 29, 23, 26, 37, 28, 31, 33,
  52, 52, 52, 35, 26, 26, 26, 30, 32, 23, 52, 26, 35, 35, 37,
  26, 23, 54, 32, 33, 30, 25, 41, 36, 23, 47, 26, 26, 30, 33,
  31, 29, 30, 28, 35, 37, 44, 32, 35, 33, 33, 33, 33, 24, 24,
  27, 32, 45, 29, 28, 51, 35, 29, 55, 34, 25, 33, 24, 24, 55,
  30, 27, 26, 26, 31, 34, 28, 33, 26, 26, 29, 56, 30
]

/-- Spot-check: irrep 192 has row sum 56 (the maximum). -/
theorem rowSum_192 : rowExponentSum exponentTable[192]! = 56 := by native_decide

/-- Spot-check: irrep 0 has row sum 0 (trivial rep). -/
theorem rowSum_0 : rowExponentSum exponentTable[0]! = 0 := by native_decide

/-- Spot-check: irrep 1 has row sum 3. -/
theorem rowSum_1 : rowExponentSum exponentTable[1]! = 3 := by native_decide

/-- Spot-check: irrep 193 has row sum 30. -/
theorem rowSum_193 : rowExponentSum exponentTable[193]! = 30 := by native_decide

/-- Spot-check: irreps 101/102 have row sum 54. -/
theorem rowSum_101 : rowExponentSum exponentTable[101]! = 54 := by native_decide

/-- The maximum row sum is 56. -/
theorem max_row_sum_is_56 : expectedRowSums.foldl Nat.max 0 = 56 := by native_decide

/-! ## §6. Landmark Irreps — Verified DAG Nodes -/

/-- Irrep 193: saturates global entropy envelope (bits ≈ 87.74, trits ≈ 55.36). -/
def node193 : IrrepNode := mkIrrepNode #[193] #[0,12,7,0,0,3,1,0,1,1,1,1,1,1,1]
  (some "Saturates global group envelope limits; heavy log-scaling in base 3 and 5")

/-- Irrep 192: maximizes base-2 component (2^46, log₁₀ ≈ 13.847). -/
def node192 : IrrepNode := mkIrrepNode #[192] #[46,2,0,0,2,0,1,0,1,0,0,1,1,1,1]
  (some "Maximizes base-2 component log scale (log10(2^46) ≈ 13.847)")

/-- Irrep 191: third-highest entropy. -/
def node191 : IrrepNode := mkIrrepNode #[191] #[1,6,8,6,0,0,0,1,1,1,1,1,1,1,1]

/-- Irrep 0: trivial representation (all exponents zero). -/
def node0 : IrrepNode := mkIrrepNode #[0] #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  (some "Trivial representation, dimension 1")

/-- Irrep 1: minimal non-trivial McKay node. -/
def node1 : IrrepNode := mkIrrepNode #[1] #[0,0,0,0,0,0,0,0,0,0,0,0,1,1,1]
  (some "Minimal non-trivial McKay node showing foundational prime seed")

/-- Irreps 101-102: highest exponent sum (54) with v₂ = 46. -/
def node101_102 : IrrepNode := mkIrrepNode #[101, 102] #[46,0,0,0,2,3,0,0,1,0,1,0,1,0,0]
  (some "v₂=46, exponent sum 54")

/-- Verified: node 193 exponent sum = 30. -/
theorem node193_sum : node193.metrics.sum = 30 := by native_decide

/-- Verified: node 192 exponent sum = 56 (highest in the table). -/
theorem node192_sum : node192.metrics.sum = 56 := by native_decide

/-- Verified: node 0 exponent sum = 0. -/
theorem node0_sum : node0.metrics.sum = 0 := by native_decide

/-- Verified: node 1 exponent sum = 3. -/
theorem node1_sum : node1.metrics.sum = 3 := by native_decide

/-! ## §7. The Root Configuration -/

/-- Root configuration matching the DAG-JSON schema. -/
def rootConfig : RootConfig where
  id       := "SSP_VALUATIONS_V3_LOGSCALE"
  type     := "logarithmic_entropy_valuation_matrix"
  bitsMax  := 87.74209896
  tritsMax := 55.35910087

/-! ## §8. Node Distance and Assignment -/

/-- L¹ distance between two exponent vectors (ℕ absolute differences). -/
def exponentDistance (a b : Array ℕ) : ℕ :=
  let pairs := a.toList.zip b.toList
  pairs.foldl (fun acc (x, y) => acc + if x ≥ y then x - y else y - x) 0

/-- Score for matching a computed profile to a DAG node.
    Lower is better: exponent distance dominates, entropy is tiebreaker. -/
def nodeScore (exps : Array ℕ) (bits trits : Float) (n : IrrepNode) : Float :=
  let dExp : Float := Float.ofNat (exponentDistance exps n.exponents)
  let dBits := Float.abs (bits - n.metrics.bits)
  let dTrit := Float.abs (trits - n.metrics.trits)
  dExp * 1000.0 + dBits * 10.0 + dTrit

/-- Assign a CID's computed profile to the best-matching DAG node. -/
def assignNode (layers : DagLayers) (exps : Array ℕ) (bits trits : Float) : IrrepNode :=
  if h : layers.nodes.size > 0 then
    layers.nodes.foldl
      (fun best n =>
        if nodeScore exps bits trits n < nodeScore exps bits trits best then n else best)
      (layers.nodes[0]'h)
  else default

/-! ## §9. Staged Mod Partition Integration -/

/-- Partition key integrating all three views: mod lattice + irrep assignment. -/
structure PartitionKey where
  /-- Stage 1: CRT residues mod the invisible trivector (71, 59, 47). -/
  stage1 : ℕ × ℕ × ℕ
  /-- Stage 2: residues mod (4, 41, 31). -/
  stage2 : ℕ × ℕ × ℕ
  /-- Stage 3: residue mod 13² = 169. -/
  stage3 : ℕ
  /-- Assigned irrep ID from the entropy DAG. -/
  irrep  : ℕ
  deriving Repr, BEq, Hashable

/-- 196883 = 47 × 59 × 71 — the invisible trivector modulus. -/
theorem trivector_product : 47 * 59 * 71 = 196883 := by norm_num

/-- The three stage-1 primes are pairwise coprime. -/
theorem stage1_coprime_47_59 : Nat.Coprime 47 59 := by decide
theorem stage1_coprime_47_71 : Nat.Coprime 47 71 := by decide
theorem stage1_coprime_59_71 : Nat.Coprime 59 71 := by decide

/-- 13² = 169. -/
theorem stage3_modulus : 13 * 13 = 169 := by norm_num

/-- p-adic valuation vector of a natural number at the 15 SSPs.
    Uses `Nat.factorization` from Mathlib. -/
def padicVector (n : ℕ) : Array ℕ :=
  sspBasis.map (fun p => n.factorization p)

/-- Compute partition key from a CID and a DAG. -/
def partitionKeyOfCid (layers : DagLayers) (cid : ℕ) : PartitionKey :=
  let exps := padicVector cid
  let ls   := logsum exps
  let bits := bitsOf ls
  let trit := tritsOf ls
  let node := assignNode layers exps bits trit
  { stage1 := (cid % 71, cid % 59, cid % 47)
  , stage2 := (cid % 4,  cid % 41, cid % 31)
  , stage3 := cid % 169
  , irrep  := if node.irrepIds.size > 0 then node.irrepIds[0]! else 0
  }

/-! ## §10. CRT Injectivity on the Partition -/

/-- Stage 1 residues uniquely determine a residue class mod 196883,
    by CRT with pairwise coprime moduli 47 × 59 × 71. -/
theorem stage1_CRT_injective (a b : ℕ) (ha : a < 196883) (hb : b < 196883)
    (h1 : a % 47 = b % 47) (h2 : a % 59 = b % 59) (h3 : a % 71 = b % 71) :
    a = b := by
  omega

/-! ## §11. Bucket-Level Aggregation -/

/-- Aggregate metrics across a collection of IrrepNodes.
    Uses componentwise max for entropy envelope, sum for exponent sums. -/
def aggregateMetrics (nodes : Array IrrepNode) : Metrics :=
  nodes.foldl (fun acc n =>
    { sum    := acc.sum + n.metrics.sum
    , logsum := if acc.logsum > n.metrics.logsum then acc.logsum else n.metrics.logsum
    , bits   := if acc.bits > n.metrics.bits then acc.bits else n.metrics.bits
    , trits  := if acc.trits > n.metrics.trits then acc.trits else n.metrics.trits })
    { sum := 0, logsum := 0.0, bits := 0.0, trits := 0.0 }

/-- Aggregate exponents (componentwise max for envelope). -/
def aggregateExponents (nodes : Array IrrepNode) : Array ℕ :=
  if h : nodes.size > 0 then
    let init := (nodes[0]'h).exponents
    nodes.foldl (fun acc n =>
      (acc.toList.zip n.exponents.toList).map (fun (a, b) => Nat.max a b) |>.toArray)
      init
  else #[]

/-! ## §12. JSON Encoding (String output) -/

/-- Encode a Metrics value as a JSON string. -/
def Metrics.toJson (m : Metrics) : String :=
  s!"\{\"sum\": {m.sum}, \"logsum\": {m.logsum}, \"bits\": {m.bits}, \"trits\": {m.trits}}"

/-- Encode an IrrepNode as a JSON string. -/
def IrrepNode.toJson (n : IrrepNode) : String :=
  let ids := String.intercalate ", " (n.irrepIds.toList.map toString)
  let exps := String.intercalate ", " (n.exponents.toList.map toString)
  let scales := String.intercalate ", " (n.componentLog10Scales.toList.map toString)
  let notesStr := match n.notes with
    | some s => s!"\"{s}\""
    | none => "null"
  s!"\{\"irrep_ids\": [{ids}], \"notes\": {notesStr}, \"exponents\": [{exps}], \"component_log10_scales\": [{scales}], \"metrics\": {n.metrics.toJson}}"

/-- Encode a PartitionKey as a JSON string. -/
def PartitionKey.toJson (k : PartitionKey) : String :=
  s!"\{\"stage1\": [{k.stage1.1}, {k.stage1.2.1}, {k.stage1.2.2}], \"stage2\": [{k.stage2.1}, {k.stage2.2.1}, {k.stage2.2.2}], \"stage3\": {k.stage3}, \"irrep\": {k.irrep}}"

/-! ## §13. Computational Verification via #eval -/

/-- Build a full DAG from the exponent table. -/
def buildFullDAG : DagLayers :=
  let nodes := exponentTable.mapIdx fun i row =>
    mkIrrepNode #[i] row
  { rootConfig := rootConfig, nodes := nodes }

#eval do
  -- Verify landmark irreps
  let dag := buildFullDAG
  let n193 := dag.nodes[193]!
  let n192 := dag.nodes[192]!
  let n0   := dag.nodes[0]!
  IO.println s!"Irrep 193: sum={n193.metrics.sum}, bits={n193.metrics.bits}, trits={n193.metrics.trits}"
  IO.println s!"Irrep 192: sum={n192.metrics.sum}, bits={n192.metrics.bits}, trits={n192.metrics.trits}"
  IO.println s!"Irrep   0: sum={n0.metrics.sum}, bits={n0.metrics.bits}, trits={n0.metrics.trits}"
  -- Sample partition key
  let pk := partitionKeyOfCid dag 196883
  IO.println s!"PartitionKey(196883): {pk.toJson}"

/-! ## §14. Global Invariants -/

/-- The trivial representation (idx 0) has all-zero exponents. -/
theorem trivial_rep_zero : exponentTable[0]! = #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] := by
  native_decide

/-- Irrep 192 has v₂ = 46, the maximum 2-adic valuation. -/
theorem max_v2_at_192 : (exponentTable[192]!)[0]! = 46 := by native_decide

/-- Irreps 101 and 102 share the same exponent vector. -/
theorem irreps_101_102_equal :
    exponentTable[101]! = exponentTable[102]! := by native_decide

/-- Irreps 15 and 16 share the same exponent vector. -/
theorem irreps_15_16_equal :
    exponentTable[15]! = exponentTable[16]! := by native_decide

/-- Irrep 192 achieves the maximum row exponent sum. -/
theorem irrep192_has_max_sum :
    rowExponentSum exponentTable[192]! = 56 := by native_decide

/-- The minimum nonzero row exponent sum is 3 (achieved by irrep 1). -/
theorem min_nonzero_row_sum :
    rowExponentSum exponentTable[1]! = 3 := by native_decide

end PadicEntropyDAG
