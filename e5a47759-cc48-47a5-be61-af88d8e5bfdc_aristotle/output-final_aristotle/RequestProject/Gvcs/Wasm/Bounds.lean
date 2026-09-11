import RequestProject.Gvcs.Wasm.Correct

/-!
# Overflow: what has to be true for the `Int` semantics to be the machine's

`RequestProject/Wasm/Ir.lean` gives the target language an *unbounded* integer
semantics: `Instr.add` really adds, `Instr.mul` really multiplies.  A real
WebAssembly engine computes on 64-bit words instead, and wraps.  This file is
the bridge between the two.

* `wrap` is the machine's reading of an integer — reduction modulo `2^64` into
  the signed range — and `Fits` says an integer survives it untouched.
  `wrap_add`, `wrap_sub`, `wrap_mul` say `wrap` is a ring homomorphism, so the
  machine computes `wrap` of what `Wasm.exec` computes, always; and
  `wrap_of_fits` says the two agree exactly as long as nothing overflows.
* `Bounded s B` bounds every number in a runtime position by `B`, and
  `bounded_rstep` says one move grows that bound by an *additive* amount fixed
  by the largest constant in the game's tables (`TBL`) and by the size of the
  quantity the player typed.  Growth is additive, not multiplicative, so
  `bounded_rrun` bounds a whole script linearly in its length.
* `fits_of_play` is the payoff: any script of at most a thousand moves whose
  quantities are at most a hundred thousand units stays inside the signed
  64-bit range, so on such a play the emitted module's arithmetic is the
  arithmetic the correctness proofs of `RequestProject/Wasm/Correct.lean` are
  stated about.

Nothing here bounds an *arbitrary* play, and nothing can: farming is
profitable, so a long enough script makes the player arbitrarily rich.  The
honest statement is the conditional one.
-/

namespace LifeTrac
namespace Wasm

open Build Runtime

/-! ## The machine's reading of an integer -/

/-- What a 64-bit machine makes of an integer: its residue modulo `2^64`, taken
in the signed range. -/
def wrap (x : ℤ) : ℤ := (BitVec.ofInt 64 x).toInt

/-- An integer a 64-bit word can hold. -/
def Fits (x : ℤ) : Prop := -2 ^ 63 ≤ x ∧ x < 2 ^ 63

theorem fits_wrap (x : ℤ) : Fits (wrap x) := by
  have h1 := BitVec.toInt_lt (x := BitVec.ofInt 64 x)
  have h2 := BitVec.le_toInt (x := BitVec.ofInt 64 x)
  simp only [Fits, wrap]
  norm_num at h1 h2 ⊢
  omega

/-- Anything in range the machine reads back unchanged. -/
theorem wrap_of_fits {x : ℤ} (h : Fits x) : wrap x = x := by
  obtain ⟨h1, h2⟩ := h
  unfold wrap
  rw [BitVec.toInt_ofInt_eq_self] <;> omega

theorem wrap_eq_self_iff {x : ℤ} : wrap x = x ↔ Fits x :=
  ⟨fun h => h ▸ fits_wrap x, wrap_of_fits⟩

/-- The machine's addition is the machine's reading of the true sum. -/
theorem wrap_add (a b : ℤ) : wrap (wrap a + wrap b) = wrap (a + b) := by
  unfold wrap
  rw [BitVec.ofInt_add, BitVec.ofInt_toInt, BitVec.ofInt_toInt, BitVec.ofInt_add]

/-- The machine's subtraction is the machine's reading of the true difference. -/
theorem wrap_sub (a b : ℤ) : wrap (wrap a - wrap b) = wrap (a - b) := by
  unfold wrap
  simp only [sub_eq_add_neg, BitVec.ofInt_add, BitVec.ofInt_neg, BitVec.ofInt_toInt]

/-- The machine's multiplication is the machine's reading of the true product. -/
theorem wrap_mul (a b : ℤ) : wrap (wrap a * wrap b) = wrap (a * b) := by
  unfold wrap
  rw [BitVec.ofInt_mul, BitVec.ofInt_toInt, BitVec.ofInt_toInt, BitVec.ofInt_mul]

/-- A convenient sufficient condition: everything below `2^62` in absolute value
fits. -/
theorem fits_of_abs_le {x B : ℤ} (hB : B ≤ 2 ^ 62) (h : |x| ≤ B) : Fits x := by
  rw [abs_le] at h
  exact ⟨by omega, by omega⟩

/-! ## How big the constants of the game are -/

/-- A round bound on every constant in the game's tables: ten thousand million
micro units, i.e. ten thousand units of money, fuel, days or stock.  The largest
entry is the order price of a whole LifeTrac, 9 551 000 000. -/
def TBL : ℤ := 10 ^ 10

theorem TBL_pos : (0:ℤ) < TBL := by norm_num [TBL]

theorem abs_SCALE_le : |SCALE| ≤ TBL := by norm_num [SCALE, TBL]

theorem abs_fuelPriceM_le : |fuelPriceM| ≤ TBL := by norm_num [fuelPriceM, TBL]

theorem abs_costM_le (m : Material) : |costM m| ≤ TBL := by
  cases m <;> norm_num [costM, TBL]

theorem abs_salvageM_le (m : Material) : |salvageM m| ≤ TBL := by
  cases m <;> norm_num [salvageM, TBL]

theorem abs_partCost_le (a : RPart) : |a.cost| ≤ TBL := by
  cases a <;> norm_num [RPart.cost, TBL]

theorem abs_partLabor_le (a : RPart) : |a.laborCost| ≤ TBL := by
  cases a <;> norm_num [RPart.laborCost, TBL]

theorem abs_partDays_le (a : RPart) : |a.days| ≤ TBL := by
  cases a <;> norm_num [RPart.days, TBL]

theorem abs_partReq_le (a : RPart) (m : Material) : |a.req m| ≤ TBL := by
  cases a <;> cases m <;> norm_num [RPart.req, TBL]

theorem abs_cropSeed_le (c : RCrop) : |c.seed| ≤ TBL := by
  cases c; norm_num [RCrop.seed, TBL]

theorem abs_cropRevenue_le (c : RCrop) : |c.revenue| ≤ TBL := by
  cases c; norm_num [RCrop.revenue, TBL]

theorem abs_cropFuel_le (c : RCrop) : |c.fuelHa| ≤ TBL := by
  cases c; norm_num [RCrop.fuelHa, TBL]

theorem abs_cropDays_le (c : RCrop) : |c.daysHa| ≤ TBL := by
  cases c; norm_num [RCrop.daysHa, TBL]

/-! ## How big a position can get -/

/-- Every number in a position is at most `B`. -/
structure Bounded (s : RState) (B : ℤ) : Prop where
  /-- Cash. -/
  cash : |s.cash| ≤ B
  /-- Fuel in the tank. -/
  fuel : |s.fuel| ≤ B
  /-- The calendar. -/
  day : |s.day| ≤ B
  /-- Hectares farmed. -/
  hect : |s.hect| ≤ B
  /-- Every shelf. -/
  stock : ∀ m, |s.stock m| ≤ B
  /-- How much has been built. -/
  built : (s.built.length : ℤ) ≤ B

theorem Bounded.mono {s : RState} {B C : ℤ} (h : Bounded s B) (hBC : B ≤ C) :
    Bounded s C :=
  ⟨h.cash.trans hBC, h.fuel.trans hBC, h.day.trans hBC, h.hect.trans hBC,
    fun m => (h.stock m).trans hBC, h.built.trans hBC⟩

/-- The quantity the player typed. -/
def qty : RAction → ℤ
  | .buy _ q => q
  | .sell _ q => q
  | .refuel l => l
  | .farm _ area => area
  | .order _ => 0
  | .fabricate _ => 0

/-- How much one move can add to the bound: two products of a typed quantity
with a table entry, plus one table entry. -/
def growth (A : ℤ) : ℤ := 2 * (A * TBL) + TBL

theorem growth_nonneg {A : ℤ} (hA : 0 ≤ A) : 0 ≤ growth A := by
  have h : 0 ≤ A * TBL := mul_nonneg hA TBL_pos.le
  simp only [growth]; linarith [TBL_pos]

theorem le_growth₁ {A : ℤ} (hA : 0 ≤ A) : A * TBL ≤ growth A := by
  have h : 0 ≤ A * TBL := mul_nonneg hA TBL_pos.le
  simp only [growth]; linarith [TBL_pos]

theorem le_growth₂ (A : ℤ) : 2 * (A * TBL) ≤ growth A := by
  simp only [growth]; linarith [TBL_pos]

theorem le_growthT {A : ℤ} (hA : 0 ≤ A) : TBL ≤ growth A := by
  have h : 0 ≤ A * TBL := mul_nonneg hA TBL_pos.le
  simp only [growth]; linarith

/-- The product of a typed quantity with a table entry is small. -/
theorem abs_mul_le {q c A : ℤ} (hq : |q| ≤ A) (hc : |c| ≤ TBL) : |q * c| ≤ A * TBL := by
  rw [abs_mul]
  exact mul_le_mul hq hc (abs_nonneg c) ((abs_nonneg q).trans hq)

private theorem abs_add_le' {x y B G : ℤ} (hx : |x| ≤ B) (hy : |y| ≤ G) :
    |x + y| ≤ B + G := by
  rw [abs_le] at *; omega

private theorem abs_sub_le' {x y B G : ℤ} (hx : |x| ≤ B) (hy : |y| ≤ G) :
    |x - y| ≤ B + G := by
  rw [abs_le] at *; omega

/-- **One move grows the bound by a fixed amount.**  Playing a move whose typed
quantity is at most `A` from a position bounded by `B` lands on a position
bounded by `B + growth A` — additively, not multiplicatively. -/
theorem bounded_rstep {s t : RState} {a : RAction} {A B : ℤ}
    (hA : 0 ≤ A) (hs : Bounded s B) (ha : |qty a| ≤ A) (h : rstep s a = some t) :
    Bounded t (B + growth A) := by
  have hg0 : (0:ℤ) ≤ growth A := growth_nonneg hA
  have h1 : B + A * TBL ≤ B + growth A := by linarith [le_growth₁ hA]
  have h2 : B + A * TBL + A * TBL ≤ B + growth A := by
    have := le_growth₂ A; linarith
  have hT : B + TBL ≤ B + growth A := by linarith [le_growthT hA]
  have hmono : ∀ {x : ℤ}, |x| ≤ B → |x| ≤ B + growth A := fun hx => by linarith
  have hmb : (s.built.length : ℤ) ≤ B + growth A := by linarith [hs.built]
  cases a with
  | buy m q =>
      simp only [qty] at ha
      simp only [rstep] at h
      split at h
      · obtain rfl := Option.some.inj h
        refine ⟨?_, hmono hs.fuel, hmono hs.day, hmono hs.hect, ?_, hmb⟩
        · exact (abs_sub_le' hs.cash (abs_mul_le ha (abs_costM_le m))).trans h1
        · intro x
          by_cases hx : x = m
          · simp only [hx, if_true]
            exact (abs_add_le' (hs.stock m) (abs_mul_le ha abs_SCALE_le)).trans h1
          · simpa [hx] using hmono (hs.stock x)
      · exact absurd h (by simp)
  | sell m q =>
      simp only [qty] at ha
      simp only [rstep] at h
      split at h
      · obtain rfl := Option.some.inj h
        refine ⟨?_, hmono hs.fuel, hmono hs.day, hmono hs.hect, ?_, hmb⟩
        · exact (abs_add_le' hs.cash (abs_mul_le ha (abs_salvageM_le m))).trans h1
        · intro x
          by_cases hx : x = m
          · simp only [hx, if_true]
            exact (abs_sub_le' (hs.stock m) (abs_mul_le ha abs_SCALE_le)).trans h1
          · simpa [hx] using hmono (hs.stock x)
      · exact absurd h (by simp)
  | order p =>
      simp only [rstep] at h
      split at h
      · obtain rfl := Option.some.inj h
        refine ⟨(abs_sub_le' hs.cash (abs_partCost_le p)).trans hT, hmono hs.fuel,
          hmono hs.day, hmono hs.hect, fun x => ?_, hmb⟩
        exact (abs_add_le' (hs.stock x) (abs_partReq_le p x)).trans hT
      · exact absurd h (by simp)
  | fabricate p =>
      simp only [rstep] at h
      split at h
      · obtain rfl := Option.some.inj h
        refine ⟨(abs_sub_le' hs.cash (abs_partLabor_le p)).trans hT, hmono hs.fuel,
          (abs_add_le' hs.day (abs_partDays_le p)).trans hT, hmono hs.hect,
          fun x => (abs_sub_le' (hs.stock x) (abs_partReq_le p x)).trans hT, ?_⟩
        have hb := hs.built
        have : (1:ℤ) ≤ growth A := le_trans (by norm_num [TBL]) (le_growthT hA)
        simp only [List.length_cons]
        push_cast
        linarith
      · exact absurd h (by simp)
  | refuel l =>
      simp only [qty] at ha
      simp only [rstep] at h
      split at h
      · obtain rfl := Option.some.inj h
        exact ⟨(abs_sub_le' hs.cash (abs_mul_le ha abs_fuelPriceM_le)).trans h1,
          (abs_add_le' hs.fuel (abs_mul_le ha abs_SCALE_le)).trans h1,
          hmono hs.day, hmono hs.hect, fun x => hmono (hs.stock x),
          hmb⟩
      · exact absurd h (by simp)
  | farm c area =>
      simp only [qty] at ha
      simp only [rstep] at h
      split at h
      · obtain rfl := Option.some.inj h
        exact ⟨(abs_sub_le' (abs_add_le' hs.cash (abs_mul_le ha (abs_cropRevenue_le c)))
            (abs_mul_le ha (abs_cropSeed_le c))).trans h2,
          (abs_sub_le' hs.fuel (abs_mul_le ha (abs_cropFuel_le c))).trans h1,
          (abs_add_le' hs.day (abs_mul_le ha (abs_cropDays_le c))).trans h1,
          (abs_add_le' hs.hect (abs_mul_le ha abs_SCALE_le)).trans h1,
          fun x => hmono (hs.stock x), hmb⟩
      · exact absurd h (by simp)

/-- **A whole script grows the bound linearly in its length.** -/
theorem bounded_rrun {A : ℤ} (hA : 0 ≤ A) :
    ∀ (script : List RAction) (s t : RState) (B : ℤ), Bounded s B →
      (∀ a ∈ script, |qty a| ≤ A) → rrun s script = some t →
      Bounded t (B + script.length * growth A) := by
  intro script
  induction script with
  | nil =>
      intro s t B hs _ h
      simp only [rrun] at h
      obtain rfl := Option.some.inj h
      exact hs.mono (by simp)
  | cons a as ih =>
      intro s t B hs harg h
      simp only [rrun] at h
      cases hstep : rstep s a with
      | none => rw [hstep] at h; simp at h
      | some u =>
          rw [hstep] at h
          simp only [Option.bind] at h
          have hu := bounded_rstep hA hs (harg a (by simp)) hstep
          refine (ih u t (B + growth A) hu (fun b hb => harg b (by simp [hb])) h).mono ?_
          simp only [List.length_cons]
          push_cast
          ring_nf
          exact le_refl _

/-! ## The payoff -/

theorem bounded_rstart : Bounded rstart (15000 * SCALE) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> simp [rstart, SCALE]

/-- **A reasonable play never overflows.**  Play at most a thousand moves, each
typing a quantity of at most a hundred thousand units, and every number in the
position reached — and so every cell the module writes — is a number a 64-bit
word holds.  On such a play the unbounded-integer semantics that
`RequestProject/Wasm/Correct.lean` reasons about is exactly what the machine
does. -/
theorem fits_of_play (script : List RAction) (t : RState)
    (hlen : script.length ≤ 1000) (hq : ∀ a ∈ script, |qty a| ≤ 10 ^ 5)
    (h : rrun rstart script = some t) :
    Fits t.cash ∧ Fits t.fuel ∧ Fits t.day ∧ Fits t.hect ∧
      (∀ m, Fits (t.stock m)) ∧ ∀ p, Fits (t.built.count p) := by
  have hA : (0:ℤ) ≤ 10 ^ 5 := by norm_num
  have hb := bounded_rrun hA script rstart t (15000 * SCALE) bounded_rstart hq h
  have hlen' : (script.length : ℤ) ≤ 1000 := by exact_mod_cast hlen
  have hgv : growth (10 ^ 5) = 2000010000000000 := by norm_num [growth, TBL]
  rw [hgv] at hb
  have hbound : 15000 * SCALE + (script.length : ℤ) * 2000010000000000 ≤ 2 ^ 62 := by
    have hmul : (script.length : ℤ) * 2000010000000000 ≤ 1000 * 2000010000000000 :=
      mul_le_mul_of_nonneg_right hlen' (by norm_num)
    have hs0 : (15000:ℤ) * SCALE = 15000000000 := by norm_num [SCALE]
    have h62 : (2:ℤ) ^ 62 = 4611686018427387904 := by norm_num
    rw [hs0, h62]
    linarith
  refine ⟨fits_of_abs_le hbound hb.cash, fits_of_abs_le hbound hb.fuel,
    fits_of_abs_le hbound hb.day, fits_of_abs_le hbound hb.hect,
    fun m => fits_of_abs_le hbound (hb.stock m), fun p => fits_of_abs_le hbound ?_⟩
  have hc : (t.built.count p : ℤ) ≤ (t.built.length : ℤ) := by
    exact_mod_cast List.count_le_length (a := p) (l := t.built)
  rw [abs_of_nonneg (by positivity)]
  exact hc.trans hb.built

/-- The intermediate products the generated code forms on such a play are in
range too: a typed quantity of at most a hundred thousand units times any table
entry is at most `10^15`. -/
theorem fits_product {q c : ℤ} (hq : |q| ≤ 10 ^ 5) (hc : |c| ≤ TBL) : Fits (q * c) :=
  fits_of_abs_le (by norm_num [TBL]) (abs_mul_le hq hc)

end Wasm
end LifeTrac
