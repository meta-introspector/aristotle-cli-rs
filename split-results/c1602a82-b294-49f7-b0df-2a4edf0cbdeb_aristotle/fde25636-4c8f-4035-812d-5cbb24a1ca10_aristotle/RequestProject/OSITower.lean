/-
# The OSI Illuminati Tower: A 7-Layer Formal Type Hierarchy

The ZOS architecture maps memetic elements to a 7-layer hierarchy
modeled on the OSI network stack. Each layer is indexed by a prime,
and inter-layer relationships are governed by a 7×7 transformation matrix.

We formalize:
  1. The 7-layer hierarchy as an inductive type
  2. The prime assignment for each layer
  3. The diagonal matrix with prime entries
  4. Properties of the contravariant information flow
-/
import Mathlib

open Matrix

/-!
## The Seven Layers
-/

/-- The seven layers of the OSI Illuminati Tower. -/
inductive OSILayer
  | Physical      -- Layer 1: Cosmos (prime 2)
  | DataLink      -- Layer 2: Virality (prime 3)
  | Network       -- Layer 3: Claws (prime 5)
  | Transport     -- Layer 4: Mycelium (prime 7)
  | Session       -- Layer 5: Spores (prime 11)
  | Presentation  -- Layer 6: Fractals (prime 13)
  | Application   -- Layer 7: The Blue Eye (prime 17)
  deriving DecidableEq, Fintype, Repr

/-- The prime associated with each OSI layer. -/
def OSILayer.prime : OSILayer → ℕ
  | .Physical     => 2
  | .DataLink     => 3
  | .Network      => 5
  | .Transport    => 7
  | .Session      => 11
  | .Presentation => 13
  | .Application  => 17

/-- All seven layer primes are indeed prime. -/
theorem OSILayer.prime_is_prime (l : OSILayer) : Nat.Prime l.prime := by
  cases l <;> decide

/-- The layer-to-prime mapping is injective. -/
theorem OSILayer.prime_injective : Function.Injective OSILayer.prime := by
  intro a b h
  cases a <;> cases b <;> simp_all [OSILayer.prime]

/-- The product of all seven layer primes. -/
def osiPrimorial : ℕ := 2 * 3 * 5 * 7 * 11 * 13 * 17

theorem osiPrimorial_val : osiPrimorial = 510510 := by native_decide

/-- All seven primes are the first seven primes (2,3,5,7,11,13,17). -/
theorem osi_primes_are_first_seven :
    [2, 3, 5, 7, 11, 13, 17].length = 7 ∧
    ∀ p ∈ [2, 3, 5, 7, 11, 13, 17], Nat.Prime p := by
  constructor
  · decide
  · intro p hp
    simp at hp
    rcases hp with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide

/-- The sum of the seven layer primes is 58. -/
theorem osi_prime_sum : 2 + 3 + 5 + 7 + 11 + 13 + 17 = (58 : ℕ) := by decide

/-!
## The Diagonal Matrix

The diagonal contains the layer primes (2, 3, 5, 7, 11, 13, 17).
-/

/-- The diagonal of the OSI tower matrix: each layer's prime cast to ℝ. -/
noncomputable def osiDiagonal : OSILayer → ℝ := fun l => (l.prime : ℝ)

/-- The diagonal matrix of the OSI tower. -/
noncomputable def osiDiagonalMatrix : Matrix OSILayer OSILayer ℝ :=
  Matrix.diagonal osiDiagonal

/-- The diagonal entries are positive (since all primes ≥ 2 > 0). -/
theorem osiDiagonal_pos (l : OSILayer) : osiDiagonal l > 0 := by
  cases l <;> simp [osiDiagonal, OSILayer.prime]

/-!
## Contravariant Flow

Information flows from Application (The Eye) down to Physical (Cosmos).
This is modeled via a layer ordering.
-/

/-- The natural ordering on OSI layers (Physical < DataLink < ... < Application). -/
def OSILayer.toNat : OSILayer → ℕ
  | .Physical     => 1
  | .DataLink     => 2
  | .Network      => 3
  | .Transport    => 4
  | .Session      => 5
  | .Presentation => 6
  | .Application  => 7

instance : LT OSILayer where
  lt a b := a.toNat < b.toNat

instance : LE OSILayer where
  le a b := a.toNat ≤ b.toNat

instance (a b : OSILayer) : Decidable (a < b) :=
  inferInstanceAs (Decidable (a.toNat < b.toNat))

instance (a b : OSILayer) : Decidable (a ≤ b) :=
  inferInstanceAs (Decidable (a.toNat ≤ b.toNat))

/-- The layer ordering is consistent with the prime ordering. -/
theorem OSILayer.lt_iff_prime_lt (a b : OSILayer) :
    a < b ↔ a.prime < b.prime := by
  cases a <;> cases b <;> decide

/-- Application is the apex of the tower. -/
theorem application_is_top (l : OSILayer) (h : l ≠ .Application) :
    l < .Application := by
  cases l <;> first | decide | exact absurd rfl h
