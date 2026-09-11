/-
# Urania §5 — vouching, taint, decay, contagion and the sybil budget

Trust is neither permanent nor binary.  A pseudonym is admitted by a
vouch from an existing member; a *taint* (a concrete, logged event, never
an opinion) lowers its tier for a cooldown window and lowers its **direct
voucher's** tier for a shorter one; deeper hops are unaffected; taints
expire by themselves, so recovery is automatic.

Two design points from the spec are load-bearing here:

* **Taints live in the durable chain, not in the bounded ring log**
  (§5, correcting §7's mapping).  A tier computed from a log that has
  silently rolled over is not the tier every other node computes, and
  contagion depends on universal agreement about which taints exist.  So
  the substrate of this module is a plain `TrustLog` — append-only,
  replayable, never dropping.  The ring buffer is used only for QoS
  (`Kant.Urania.Qos`).
* **Keys are per-room / per-topic pseudonyms** (§5's privacy note), not a
  global identity.  Nothing in this module links two pseudonyms; that is
  the point.

Proved here:

* `tier_prefix_agree` — nodes holding the same log prefix compute the
  same tiers (the client-side analogue of transcript agreement, §3.3);
* `contagion_depth_one` — a tier depends on nothing but the key's own
  taints, the keys it vouched for, and *their* taints: contagion stops at
  one hop;
* `selfTaint_expires`, `voucheeTaint_expires`, `tier_eventually_full` —
  every taint expires, and a quiet member returns to full standing;
* `tier_recovery_monotone` — with no new events, standing only improves
  as time passes;
* `admitted_reachable` — every member is reachable from a founding key by
  a chain of logged vouches;
* `budget_respected` — no member's vouches inside one window exceed `k`,
  once the client-side admission rule is applied.
-/
import Mathlib
import RequestProject.Kant.Urania.Chain

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Urania

/-! ## The log -/

/-- An event of the trust graph.  Both kinds are durable, signed chain
entries: a vouch admits a pseudonym, a taint is a concrete incident
(content rejected for cause, a host's ToS strike, a detected abuse
pattern) recorded against one. -/
inductive TrustEvent where
  /-- `voucher` vouched for `target` at time `time`. -/
  | vouch (voucher target : Key) (time : Nat)
  /-- `subject` was tainted at time `time`. -/
  | taint (subject : Key) (time : Nat)
deriving DecidableEq, Repr

/-- The trust log, **newest first**: `e :: rest` means `e` happened after
everything in `rest`. -/
abbrev TrustLog := List TrustEvent

/-- Tunable constants (§9 leaves the numbers open; the shape is fixed). -/
structure TrustParams where
  /-- How long a key's own taint holds it down. -/
  selfWindow : Nat
  /-- How long a taint holds its voucher down — shorter, by design. -/
  voucherWindow : Nat
  /-- `k`: how many vouches one key may issue inside a window. -/
  budget : Nat
  /-- The width of that window. -/
  budgetWindow : Nat
deriving DecidableEq, Repr

/-- When an event happened. -/
def eventTime : TrustEvent → Nat
  | .vouch _ _ t => t
  | .taint _ t => t

/-- Standing, worst to best. -/
inductive Tier where
  /-- Not admitted at all. -/
  | outside
  /-- Tainted itself: on cooldown. -/
  | probation
  /-- Clean, but somebody this key vouched for is tainted: one-hop
  contagion. -/
  | reduced
  /-- Full standing. -/
  | full
deriving DecidableEq, Repr

/-- Numeric standing, for monotonicity statements. -/
def Tier.rank : Tier → Nat
  | .outside => 0
  | .probation => 1
  | .reduced => 2
  | .full => 3

/-! ## Reading the log -/

/-- The keys that have vouched for `k`. -/
def vouchers (L : TrustLog) (k : Key) : List Key :=
  L.filterMap (fun e => match e with
    | .vouch v t _ => if t = k then some v else none
    | _ => none)

/-- The keys `v` has vouched for.  Contagion runs *this* way: a taint on
one of them costs `v`, its voucher, some standing (§5). -/
def vouchees (L : TrustLog) (v : Key) : List Key :=
  L.filterMap (fun e => match e with
    | .vouch w t _ => if w = v then some t else none
    | _ => none)

/-- The times at which `k` was tainted. -/
def taintsOf (L : TrustLog) (k : Key) : List Nat :=
  L.filterMap (fun e => match e with
    | .taint s time => if s = k then some time else none
    | _ => none)

/-- The vouches issued by `v`, as times. -/
def vouchesBy (L : TrustLog) (v : Key) : List Nat :=
  L.filterMap (fun e => match e with
    | .vouch w _ time => if w = v then some time else none
    | _ => none)

/-- Admission: a founder, or vouched for by somebody. -/
def admitted (founders : List Key) (L : TrustLog) (k : Key) : Bool :=
  (k ∈ founders : Bool) || !(vouchers L k).isEmpty

/-- Is `k` inside its own cooldown window? -/
def selfTainted (P : TrustParams) (L : TrustLog) (k : Key) (now : Nat) : Bool :=
  (taintsOf L k).any (fun t => now < t + P.selfWindow)

/-- Is one of the keys `k` vouched for inside the (shorter) contagion
window?  This is the one-hop propagation of §5: vouching for somebody who
is later tainted costs the voucher standing, briefly. -/
def voucheeTainted (P : TrustParams) (L : TrustLog) (k : Key) (now : Nat) : Bool :=
  (vouchees L k).any (fun x => (taintsOf L x).any (fun t => now < t + P.voucherWindow))

/-- The tier a client computes for a key, from the log alone.  Note there
is no relay input: `GET /trust/:pubkey` is a non-authoritative cache of
exactly this function (§3.3). -/
def tier (P : TrustParams) (founders : List Key) (L : TrustLog) (k : Key) (now : Nat) : Tier :=
  if admitted founders L k then
    (if selfTainted P L k now then .probation
     else if voucheeTainted P L k now then .reduced
     else .full)
  else .outside

/-! ## What the tier does and does not depend on -/

/-- **Nodes holding the same log prefix compute the same tiers.** -/
theorem tier_prefix_agree {P : TrustParams} {F : List Key} {L L' : TrustLog} {n : Nat}
    (h : L.take n = L'.take n) (k : Key) (now : Nat) :
    tier P F (L.take n) k now = tier P F (L'.take n) k now := by
  rw [h]

/-- **Contagion is exactly one hop deep.**  Two logs that agree on `k`'s
admission, on whom `k` vouched for, on `k`'s own taints and on the taints
of those direct vouchees give `k` the same tier — whatever else differs
two hops away. -/
theorem contagion_depth_one {P : TrustParams} {F : List Key} {L L' : TrustLog} {k : Key}
    {now : Nat}
    (hadm : admitted F L k = admitted F L' k)
    (hv : vouchees L k = vouchees L' k)
    (hk : taintsOf L k = taintsOf L' k)
    (hvt : ∀ x ∈ vouchees L k, taintsOf L x = taintsOf L' x) :
    tier P F L k now = tier P F L' k now := by
  have hself : selfTainted P L k now = selfTainted P L' k now := by
    simp [selfTainted, hk]
  have hvouch : voucheeTainted P L k now = voucheeTainted P L' k now := by
    rw [Bool.eq_iff_iff]
    simp only [voucheeTainted, ← hv, List.any_eq_true]
    constructor
    · rintro ⟨v, hmem, hany⟩; exact ⟨v, hmem, by rwa [← hvt v hmem]⟩
    · rintro ⟨v, hmem, hany⟩; exact ⟨v, hmem, by rwa [hvt v hmem]⟩
  simp [tier, hadm, hself, hvouch]

/-! ## Decay and recovery -/

/-- **A taint expires.**  Once every taint of `k` is older than the
cooldown, `k` is no longer on probation. -/
theorem selfTaint_expires {P : TrustParams} {L : TrustLog} {k : Key} {now : Nat}
    (h : ∀ t ∈ taintsOf L k, t + P.selfWindow ≤ now) : selfTainted P L k now = false := by
  rw [Bool.eq_false_iff, ne_eq, selfTainted, List.any_eq_true]
  rintro ⟨t, ht, hlt⟩
  have := h t ht
  simp only [decide_eq_true_eq] at hlt
  omega

/-- And so does the one-hop contagion. -/
theorem voucheeTaint_expires {P : TrustParams} {L : TrustLog} {k : Key} {now : Nat}
    (h : ∀ x ∈ vouchees L k, ∀ t ∈ taintsOf L x, t + P.voucherWindow ≤ now) :
    voucheeTainted P L k now = false := by
  rw [Bool.eq_false_iff, ne_eq, voucheeTainted, List.any_eq_true]
  rintro ⟨v, hv, hany⟩
  rw [List.any_eq_true] at hany
  obtain ⟨t, ht, hlt⟩ := hany
  have := h v hv t ht
  simp only [decide_eq_true_eq] at hlt
  omega

/-- **Recovery is automatic**: an admitted key whose taints, and whose
vouchers' taints, have all expired is back at full standing — no appeal,
no unban. -/
theorem tier_eventually_full {P : TrustParams} {F : List Key} {L : TrustLog} {k : Key}
    {now : Nat} (hadm : admitted F L k = true)
    (hself : ∀ t ∈ taintsOf L k, t + P.selfWindow ≤ now)
    (hvouch : ∀ x ∈ vouchees L k, ∀ t ∈ taintsOf L x, t + P.voucherWindow ≤ now) :
    tier P F L k now = .full := by
  simp [tier, hadm, selfTaint_expires hself, voucheeTaint_expires hvouch]

/-- **Standing only improves with time**, if nothing new is logged. -/
theorem tier_recovery_monotone {P : TrustParams} {F : List Key} {L : TrustLog} {k : Key}
    {now now' : Nat} (h : now ≤ now') :
    (tier P F L k now).rank ≤ (tier P F L k now').rank := by
  have hself : selfTainted P L k now' = true → selfTainted P L k now = true := by
    simp only [selfTainted, List.any_eq_true, decide_eq_true_eq]
    rintro ⟨t, ht, hlt⟩
    exact ⟨t, ht, by omega⟩
  have hvouch : voucheeTainted P L k now' = true → voucheeTainted P L k now = true := by
    simp only [voucheeTainted, List.any_eq_true, decide_eq_true_eq]
    rintro ⟨v, hv, t, ht, hlt⟩
    exact ⟨v, hv, t, ht, by omega⟩
  unfold tier
  by_cases hadm : admitted F L k = true
  · rw [if_pos hadm, if_pos hadm]
    by_cases h1' : selfTainted P L k now' = true
    · rw [if_pos (hself h1'), if_pos h1']
    · rw [if_neg h1']
      by_cases h2' : voucheeTainted P L k now' = true
      · rw [if_pos h2']
        by_cases h1 : selfTainted P L k now = true
        · rw [if_pos h1]; simp [Tier.rank]
        · rw [if_neg h1, if_pos (hvouch h2')]
      · rw [if_neg h2']
        by_cases h1 : selfTainted P L k now = true
        · rw [if_pos h1]; simp [Tier.rank]
        · rw [if_neg h1]
          by_cases h2 : voucheeTainted P L k now = true
          · rw [if_pos h2]; simp [Tier.rank]
          · rw [if_neg h2]
  · rw [if_neg hadm, if_neg hadm]

/-! ## Admission: everybody comes from a founder

A well-formed log only contains vouches issued by keys that were already
admitted when the vouch was made. -/

/-- Every vouch in the log was issued by a key already admitted by the
*earlier* part of the log. -/
def WellFormed (F : List Key) : TrustLog → Prop
  | [] => True
  | .vouch v _ _ :: rest => admitted F rest v = true ∧ WellFormed F rest
  | .taint _ _ :: rest => WellFormed F rest

/-- `k` is `n` logged vouches away from a founding key. -/
inductive VouchedFrom (F : List Key) (L : TrustLog) : Key → Nat → Prop where
  /-- A founder is at distance zero. -/
  | founder {k : Key} (h : k ∈ F) : VouchedFrom F L k 0
  /-- One more logged vouch, one more hop. -/
  | step {v k : Key} {n time : Nat} (hv : VouchedFrom F L v n)
      (h : TrustEvent.vouch v k time ∈ L) : VouchedFrom F L k (n + 1)

/-- Reachability survives seeing more of the log. -/
theorem VouchedFrom.mono {F : List Key} {L L' : TrustLog} (hsub : ∀ e ∈ L, e ∈ L')
    {k : Key} {n : Nat} (h : VouchedFrom F L k n) : VouchedFrom F L' k n := by
  induction h with
  | founder hk => exact .founder hk
  | step _ hmem ih => exact .step ih (hsub _ hmem)

@[simp] theorem vouchers_cons_vouch (v t : Key) (time : Nat) (L : TrustLog) (k : Key) :
    vouchers (.vouch v t time :: L) k =
      (if t = k then [v] else []) ++ vouchers L k := by
  by_cases h : t = k <;> simp [vouchers, h]

@[simp] theorem vouchers_cons_taint (s : Key) (time : Nat) (L : TrustLog) (k : Key) :
    vouchers (.taint s time :: L) k = vouchers L k := by
  simp [vouchers]

/-- **Every member is reachable from a founding key** by a bounded chain
of logged vouches. -/
theorem admitted_reachable {F : List Key} {L : TrustLog} {k : Key}
    (hwf : WellFormed F L) (h : admitted F L k = true) :
    ∃ n, n ≤ L.length ∧ VouchedFrom F L k n := by
  induction L generalizing k with
  | nil =>
    refine ⟨0, le_refl _, .founder ?_⟩
    simpa [admitted, vouchers] using h
  | cons e rest ih =>
    have hmono : ∀ x ∈ rest, x ∈ e :: rest := fun x hx => List.mem_cons_of_mem _ hx
    by_cases hF : k ∈ F
    · exact ⟨0, Nat.zero_le _, .founder hF⟩
    · have hnotF : (decide (k ∈ F)) = false := by simpa using hF
      match e with
      | .taint sub time =>
        have hwf' : WellFormed F rest := hwf
        have hrest : admitted F rest k = true := by
          simpa [admitted, hnotF] using h
        obtain ⟨n, hn, hvf⟩ := ih hwf' hrest
        exact ⟨n, by simp; omega, hvf.mono hmono⟩
      | .vouch v tgt time =>
        have hwf1 : admitted F rest v = true := hwf.1
        have hwf2 : WellFormed F rest := hwf.2
        by_cases htk : tgt = k
        · subst htk
          obtain ⟨n, hn, hvf⟩ := ih hwf2 hwf1
          refine ⟨n + 1, by simp; omega, ?_⟩
          exact .step (hvf.mono hmono) (List.mem_cons_self ..)
        · have hrest : admitted F rest k = true := by
            simpa [admitted, hnotF, htk] using h
          obtain ⟨n, hn, hvf⟩ := ih hwf2 hrest
          exact ⟨n, by simp; omega, hvf.mono hmono⟩

/-! ## The sybil budget

Nothing above stops one member minting keys faster than contagion can
price them down, so the client-side admission rule caps how many vouches
a key may issue in a window (§5, `k`). -/

/-- The vouches `v` issued with time in `[a, a + P.budgetWindow)`. -/
def vouchesInWindow (P : TrustParams) (L : TrustLog) (v : Key) (a : Nat) : List Nat :=
  (vouchesBy L v).filter (fun t => a ≤ t && t < a + P.budgetWindow)

/-- The budget invariant: no key's vouches inside any window exceed `k`. -/
def BudgetOk (P : TrustParams) (L : TrustLog) : Prop :=
  ∀ v a, (vouchesInWindow P L v a).length ≤ P.budget

/-- The client-side rule applied to each new event as it is replayed: a
vouch is admissible only if its issuer has fewer than `k` vouches in the
window that ends with it. -/
def admissible (P : TrustParams) (L : TrustLog) : TrustEvent → Bool
  | .vouch v _ time =>
      ((vouchesBy L v).filter (fun t => time < t + P.budgetWindow && t ≤ time)).length < P.budget
  | .taint _ _ => true

/-- Replaying a stream of events (oldest first), keeping only the
admissible ones.  The result is newest-first, like every `TrustLog`. -/
def enforce (P : TrustParams) : List TrustEvent → TrustLog
  | [] => []
  | e :: rest =>
      let L := enforce P rest
      if admissible P L e then e :: L else L

@[simp] theorem vouchesBy_cons_vouch (v tgt : Key) (time : Nat) (L : TrustLog) (w : Key) :
    vouchesBy (.vouch v tgt time :: L) w =
      (if v = w then [time] else []) ++ vouchesBy L w := by
  by_cases h : v = w <;> simp [vouchesBy, h]

@[simp] theorem vouchesBy_cons_taint (sub : Key) (time : Nat) (L : TrustLog) (w : Key) :
    vouchesBy (.taint sub time :: L) w = vouchesBy L w := by
  simp [vouchesBy]

/-- A time in `vouchesBy L v` comes from a vouch event of `L`. -/
theorem mem_vouchesBy {L : TrustLog} {v : Key} {t : Nat} (h : t ∈ vouchesBy L v) :
    ∃ e ∈ L, eventTime e = t := by
  induction L with
  | nil => simp [vouchesBy] at h
  | cons e rest ih =>
    match e with
    | .taint sub time =>
      obtain ⟨e', he', ht⟩ := ih (by simpa using h)
      exact ⟨e', List.mem_cons_of_mem _ he', ht⟩
    | .vouch w tgt time =>
      by_cases hw : w = v
      · subst hw
        rw [vouchesBy_cons_vouch, if_pos rfl, List.singleton_append, List.mem_cons] at h
        rcases h with rfl | h
        · exact ⟨.vouch w tgt t, List.mem_cons_self .., rfl⟩
        · obtain ⟨e', he', ht⟩ := ih h
          exact ⟨e', List.mem_cons_of_mem _ he', ht⟩
      · obtain ⟨e', he', ht⟩ := ih (by simpa [hw] using h)
        exact ⟨e', List.mem_cons_of_mem _ he', ht⟩

/-- Enforcement only ever drops events. -/
theorem enforce_sublist (P : TrustParams) (es : List TrustEvent) :
    (enforce P es).Sublist es := by
  induction es with
  | nil => simp [enforce]
  | cons e rest ih =>
    rw [enforce]
    by_cases hadm : admissible P (enforce P rest) e
    · simpa [hadm] using ih.cons₂ e
    · simpa [hadm] using ih.cons e

/-- **No member's vouches in a window exceed `k`.** -/
theorem budget_respected (P : TrustParams) (es : List TrustEvent)
    (hchron : List.Pairwise (fun a b => eventTime b ≤ eventTime a) es) :
    BudgetOk P (enforce P es) := by
  induction es with
  | nil => intro v a; simp [enforce, vouchesInWindow, vouchesBy]
  | cons e rest ih =>
    obtain ⟨hhead, htail⟩ := List.pairwise_cons.mp hchron
    have ihrest := ih htail
    rw [enforce]
    by_cases hadm : admissible P (enforce P rest) e
    · simp only [hadm, if_pos]
      match e with
      | .taint sub time =>
        intro w a
        simpa [vouchesInWindow] using ihrest w a
      | .vouch v tgt time =>
        intro w a
        by_cases hw : v = w
        · subst hw
          rw [vouchesInWindow, vouchesBy_cons_vouch, if_pos rfl, List.singleton_append,
            List.filter_cons]
          by_cases hwin : (decide (a ≤ time) && decide (time < a + P.budgetWindow)) = true
          · rw [if_pos hwin]
            simp only [List.length_cons]
            -- the admissibility check counted at least the window's other vouches
            have hadm' :
                ((vouchesBy (enforce P rest) v).filter
                  (fun t => decide (time < t + P.budgetWindow) && decide (t ≤ time))).length
                  < P.budget := by
              simpa [admissible] using hadm
            have hle :
                ((vouchesBy (enforce P rest) v).filter
                    (fun t => decide (a ≤ t) && decide (t < a + P.budgetWindow))).length ≤
                  ((vouchesBy (enforce P rest) v).filter
                    (fun t => decide (time < t + P.budgetWindow) && decide (t ≤ time))).length := by
              rw [← List.countP_eq_length_filter, ← List.countP_eq_length_filter]
              refine List.countP_mono_left ?_
              intro t ht hpt
              obtain ⟨e', he', hte'⟩ := mem_vouchesBy ht
              have hmem : e' ∈ rest := (enforce_sublist P rest).mem he'
              have hchr : eventTime e' ≤ time := hhead e' hmem
              simp only [Bool.and_eq_true, decide_eq_true_eq] at hpt ⊢
              simp only [Bool.and_eq_true, decide_eq_true_eq] at hwin
              omega
            omega
          · rw [if_neg hwin]
            simpa [vouchesInWindow] using ihrest v a
        · simpa [vouchesInWindow, hw] using ihrest w a
    · simp only [hadm, Bool.false_eq_true, if_false]
      exact ihrest

end Kant.Urania
