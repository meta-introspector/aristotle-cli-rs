/-
# Cloudflare API permissions as a lattice of capabilities

A Cloudflare API token is a list of *policies*; each policy names a set of
*permission groups* ("Pages Write", "Zone Cache Purge", …) and a set of
*resources* (a user, an account, or a zone).  The deployment tool in this
project mints one token per action, carrying exactly the permissions that
action needs, so the token model has to be precise enough to state and
prove "exactly the permissions needed".

This module gives that model:

* `Capability` — the family of a Cloudflare permission group (Pages,
  Workers Scripts, Workers KV, R2, cache purge, DNS, …);
* `Verb` — `read` or `edit`, the two grades every family comes in;
* `Scope` — the resource the grant is attached to: the user, an account,
  or a single zone of an account;
* `Perm` — one grant, and `Perm.covers` the "at least as permissive as"
  preorder on grants;
* `PermSet` — a set of grants, with `grants`/`covers` and a *reduction*
  that removes redundant grants.

The two facts everything downstream rests on are proved here:
`Perm.covers` is a partial order (reflexive, transitive, antisymmetric),
and `PermSet.reduce` produces an antichain that grants exactly what the
original set granted.

Mathlib-free by design: this module is part of the compute-only core that
is extracted to JavaScript and WebAssembly.
-/

namespace CfDeploy

/-! ## Verbs -/

/-- The grade of a permission group: Cloudflare ships every family in a
`Read` and an `Edit` (write) variant. -/
inductive Verb
  | read
  | edit
  deriving DecidableEq, Repr, Inhabited

namespace Verb

/-- `read ≤ edit`: an edit grant subsumes the corresponding read grant. -/
def le : Verb → Verb → Bool
  | .read, _ => true
  | .edit, .edit => true
  | .edit, .read => false

/-- The Cloudflare spelling of a verb, as it appears in permission-group names. -/
def name : Verb → String
  | .read => "Read"
  | .edit => "Edit"

@[simp] theorem le_refl (v : Verb) : le v v = true := by cases v <;> rfl

theorem le_trans {a b c : Verb} (h₁ : le a b = true) (h₂ : le b c = true) : le a c = true := by
  cases a <;> cases b <;> cases c <;> simp_all [le]

theorem le_antisymm {a b : Verb} (h₁ : le a b = true) (h₂ : le b a = true) : a = b := by
  cases a <;> cases b <;> simp_all [le]

end Verb

/-! ## Capabilities -/

/-- The permission-group families the deployment workflows use.  Each
constructor corresponds to a real Cloudflare permission group, whose
`Read`/`Edit` names are given by `Capability.groupName`. -/
inductive Capability
  | pages
  | workersScripts
  | workersKv
  | workersR2
  | workersRoutes
  | cachePurge
  | dns
  | accountSettings
  | zoneSettings
  | apiTokens
  | userDetails
  deriving DecidableEq, Repr, Inhabited

namespace Capability

/-- The Cloudflare permission-group name of a capability at a given verb.
These are the human-readable names returned by
`GET /client/v4/user/tokens/permission_groups`; the tool resolves them to
permission-group ids at run time rather than hard-coding ids. -/
def groupName : Capability → Verb → String
  | .pages, v => "Pages " ++ (match v with | .read => "Read" | .edit => "Write")
  | .workersScripts, v => "Workers Scripts " ++ v.name
  | .workersKv, v => "Workers KV Storage " ++ v.name
  | .workersR2, v => "Workers R2 Storage " ++ v.name
  | .workersRoutes, v => "Workers Routes " ++ v.name
  | .cachePurge, _ => "Cache Purge"
  | .dns, v => "DNS " ++ v.name
  | .accountSettings, v => "Account Settings " ++ v.name
  | .zoneSettings, v => "Zone Settings " ++ v.name
  | .apiTokens, v => "API Tokens " ++ v.name
  | .userDetails, v => "User Details " ++ v.name

/-- Which kind of resource a capability can be attached to.  `false` means
account-level (or user-level), `true` means the capability is a zone
capability. -/
def isZoneLevel : Capability → Bool
  | .cachePurge => true
  | .dns => true
  | .zoneSettings => true
  | _ => false

/-- Capabilities that live on the user, not on an account or zone. -/
def isUserLevel : Capability → Bool
  | .apiTokens => true
  | .userDetails => true
  | _ => false

end Capability

/-! ## Scopes -/

/-- The resource a grant is attached to. -/
inductive Scope
  /-- the calling user itself (`com.cloudflare.api.user.<id>`) -/
  | user
  /-- a whole account (`com.cloudflare.api.account.<id>`) -/
  | account (id : String)
  /-- a single zone of an account (`com.cloudflare.api.account.zone.<id>`) -/
  | zone (account : String) (id : String)
  deriving DecidableEq, Repr, Inhabited

namespace Scope

/-- `s.covers t`: a grant on `s` also applies to the resource `t`.  An
account-scoped grant reaches every zone of that account, which is exactly
Cloudflare's `com.cloudflare.api.account.<id>` → `*` resource rule. -/
def covers : Scope → Scope → Bool
  | .user, .user => true
  | .account a, .account b => a == b
  | .account a, .zone b _ => a == b
  | .zone a z, .zone b w => a == b && z == w
  | _, _ => false

/-- The Cloudflare resource key of a scope, as used in a token policy.
The user id is supplied by the caller because it is not part of the scope. -/
def resourceKey (userId : String) : Scope → String
  | .user => "com.cloudflare.api.user." ++ userId
  | .account a => "com.cloudflare.api.account." ++ a
  | .zone _ z => "com.cloudflare.api.account.zone." ++ z

@[simp] theorem covers_refl (s : Scope) : covers s s = true := by
  cases s <;> simp [covers]

theorem covers_trans {a b c : Scope} (h₁ : covers a b = true) (h₂ : covers b c = true) :
    covers a c = true := by
  cases a <;> cases b <;> cases c <;> simp_all [covers]

theorem covers_antisymm {a b : Scope} (h₁ : covers a b = true) (h₂ : covers b a = true) :
    a = b := by
  cases a <;> cases b <;> simp_all [covers]

end Scope

/-! ## Single grants -/

/-- One grant: a capability, at a verb, on a resource. -/
structure Perm where
  cap : Capability
  verb : Verb
  scope : Scope
  deriving DecidableEq, Repr, Inhabited

namespace Perm

/-- `q.covers p`: holding `q` is at least as permissive as holding `p`. -/
def covers (q p : Perm) : Bool :=
  q.cap == p.cap && p.verb.le q.verb && q.scope.covers p.scope

@[simp] theorem covers_refl (p : Perm) : covers p p = true := by
  simp [covers]

theorem covers_trans {a b c : Perm} (h₁ : covers a b = true) (h₂ : covers b c = true) :
    covers a c = true := by
  simp only [covers, Bool.and_eq_true, beq_iff_eq] at h₁ h₂ ⊢
  exact ⟨⟨h₁.1.1.trans h₂.1.1, Verb.le_trans h₂.1.2 h₁.1.2⟩,
    Scope.covers_trans h₁.2 h₂.2⟩

theorem covers_antisymm {a b : Perm} (h₁ : covers a b = true) (h₂ : covers b a = true) :
    a = b := by
  simp only [covers, Bool.and_eq_true, beq_iff_eq] at h₁ h₂
  cases a; cases b
  simp only [Perm.mk.injEq]
  exact ⟨h₁.1.1, Verb.le_antisymm h₂.1.2 h₁.1.2, Scope.covers_antisymm h₁.2 h₂.2⟩

/-- The Cloudflare permission-group name of a grant. -/
def groupName (p : Perm) : String := p.cap.groupName p.verb

end Perm

/-! ## Sets of grants -/

/-- A set of grants; the payload of an API token. -/
abbrev PermSet := List Perm

namespace PermSet

/-- Does the set grant `p`? -/
def grants (s : PermSet) (p : Perm) : Bool := s.any (fun q => q.covers p)

/-- Does `s` grant everything `t` grants? -/
def covers (s t : PermSet) : Bool := t.all (fun p => s.grants p)

theorem grants_of_mem {s : PermSet} {p : Perm} (h : p ∈ s) : s.grants p = true := by
  simpa [grants] using List.any_eq_true.mpr ⟨p, h, by simp⟩

theorem grants_mono {s t : PermSet} {p : Perm}
    (hst : covers t s = true) (hp : s.grants p = true) : t.grants p = true := by
  obtain ⟨q, hq, hqp⟩ := List.any_eq_true.mp hp
  have := List.all_eq_true.mp hst q hq
  obtain ⟨r, hr, hrq⟩ := List.any_eq_true.mp this
  exact List.any_eq_true.mpr ⟨r, hr, Perm.covers_trans hrq hqp⟩

@[simp] theorem covers_refl (s : PermSet) : covers s s = true :=
  List.all_eq_true.mpr fun _ hp => grants_of_mem hp

theorem covers_trans {s t u : PermSet} (h₁ : covers s t = true) (h₂ : covers t u = true) :
    covers s u = true :=
  List.all_eq_true.mpr fun p hp =>
    grants_mono h₁ (List.all_eq_true.mp h₂ p hp)

theorem covers_append_left (s t : PermSet) : covers (s ++ t) s = true :=
  List.all_eq_true.mpr fun _ hp => grants_of_mem (List.mem_append_left _ hp)

theorem covers_append_right (s t : PermSet) : covers (s ++ t) t = true :=
  List.all_eq_true.mpr fun _ hp => grants_of_mem (List.mem_append_right _ hp)

theorem covers_append {s t u : PermSet} (h₁ : covers u s = true) (h₂ : covers u t = true) :
    covers u (s ++ t) = true := by
  refine List.all_eq_true.mpr fun p hp => ?_
  rcases List.mem_append.mp hp with h | h
  · exact List.all_eq_true.mp h₁ p h
  · exact List.all_eq_true.mp h₂ p h

/-- Remove the grants that other grants of the set already imply.  The
result is the *minimal* set with the same effect (`grants_reduce`,
`reduce_antichain`). -/
def reduce : PermSet → PermSet
  | [] => []
  | p :: rest =>
      let r := reduce rest
      if r.any (fun q => q.covers p) then r
      else p :: r.filter (fun q => !p.covers q)

theorem reduce_subset : ∀ (s : PermSet), ∀ p ∈ reduce s, p ∈ s
  | [], p, hp => by simp [reduce] at hp
  | q :: rest, p, hp => by
      rw [reduce] at hp
      split at hp
      · exact List.mem_cons_of_mem _ (reduce_subset rest p hp)
      · rcases List.mem_cons.mp hp with h | h
        · exact h ▸ List.mem_cons_self
        · exact List.mem_cons_of_mem _
            (reduce_subset rest p ((List.mem_filter.mp h).1))

/-- Reduction does not change what is granted. -/
theorem grants_reduce : ∀ (s : PermSet) (p : Perm), (reduce s).grants p = s.grants p
  | [], p => by simp [reduce]
  | q :: rest, p => by
      rw [reduce]
      by_cases hq : (reduce rest).any (fun x => x.covers q) = true
      · rw [if_pos hq]
        apply Bool.eq_iff_iff.mpr
        constructor
        · intro h
          obtain ⟨x, hx, hxp⟩ := List.any_eq_true.mp h
          exact List.any_eq_true.mpr ⟨x, List.mem_cons_of_mem _ (reduce_subset rest x hx), hxp⟩
        · intro h
          obtain ⟨x, hx, hxp⟩ := List.any_eq_true.mp h
          rcases List.mem_cons.mp hx with rfl | hx
          · obtain ⟨y, hy, hyx⟩ := List.any_eq_true.mp hq
            exact List.any_eq_true.mpr ⟨y, hy, Perm.covers_trans hyx hxp⟩
          · have : (reduce rest).grants p = true := by
              rw [grants_reduce rest p]
              exact List.any_eq_true.mpr ⟨x, hx, hxp⟩
            exact this
      · rw [if_neg hq]
        apply Bool.eq_iff_iff.mpr
        constructor
        · intro h
          obtain ⟨x, hx, hxp⟩ := List.any_eq_true.mp h
          rcases List.mem_cons.mp hx with rfl | hx
          · exact List.any_eq_true.mpr ⟨x, List.mem_cons_self, hxp⟩
          · exact List.any_eq_true.mpr
              ⟨x, List.mem_cons_of_mem _ (reduce_subset rest x ((List.mem_filter.mp hx).1)), hxp⟩
        · intro h
          obtain ⟨x, hx, hxp⟩ := List.any_eq_true.mp h
          rcases List.mem_cons.mp hx with rfl | hx
          · exact List.any_eq_true.mpr ⟨x, List.mem_cons_self, hxp⟩
          · have hred : (reduce rest).grants p = true := by
              rw [grants_reduce rest p]
              exact List.any_eq_true.mpr ⟨x, hx, hxp⟩
            obtain ⟨y, hy, hyp⟩ := List.any_eq_true.mp hred
            by_cases hcov : q.covers y = true
            · exact List.any_eq_true.mpr
                ⟨q, List.mem_cons_self, Perm.covers_trans hcov hyp⟩
            · refine List.any_eq_true.mpr ⟨y, List.mem_cons_of_mem _ ?_, hyp⟩
              exact List.mem_filter.mpr ⟨hy, by simpa using hcov⟩

/-- The reduced set contains no redundancy: no grant of the set is implied
by a different grant of the set. -/
theorem reduce_antichain : ∀ (s : PermSet), ∀ p ∈ reduce s, ∀ q ∈ reduce s,
    q.covers p = true → q = p
  | [], p, hp, _, _, _ => by simp [reduce] at hp
  | x :: rest, p, hp, q, hq, hqp => by
      rw [reduce] at hp hq
      split at hp
      · next h =>
        rw [if_pos h] at hq
        exact reduce_antichain rest p hp q hq hqp
      · next h =>
        rw [if_neg h] at hq
        rcases List.mem_cons.mp hp with rfl | hp' <;> rcases List.mem_cons.mp hq with rfl | hq'
        · rfl
        · exact absurd (List.any_eq_true.mpr
            ⟨q, (List.mem_filter.mp hq').1, hqp⟩) h
        · have hqf := List.mem_filter.mp hp'
          have : ¬ (q.covers p = true) := by
            have := hqf.2
            simpa using this
          exact absurd hqp this
        · exact reduce_antichain rest p ((List.mem_filter.mp hp').1) q
            ((List.mem_filter.mp hq').1) hqp

/-- Reduction produces a duplicate-free list. -/
theorem reduce_nodup : ∀ (s : PermSet), (reduce s).Nodup
  | [] => by simp [reduce]
  | p :: rest => by
      rw [reduce]
      split
      · exact reduce_nodup rest
      · next h =>
        refine List.nodup_cons.mpr ⟨?_, (reduce_nodup rest).filter _⟩
        intro hmem
        exact h (List.any_eq_true.mpr ⟨p, (List.mem_filter.mp hmem).1, by simp⟩)

/-- The reduced set is covered by the original one and covers it back. -/
theorem covers_reduce (s : PermSet) : covers s (reduce s) = true :=
  List.all_eq_true.mpr fun p hp => grants_of_mem (reduce_subset s p hp)

theorem reduce_covers (s : PermSet) : covers (reduce s) s = true :=
  List.all_eq_true.mpr fun p hp => by
    rw [grants_reduce]; exact grants_of_mem hp

/-- **Least privilege, one grant at a time.**  In a reduced set, dropping
any single grant really loses that grant: nothing else in the set implies
it. -/
theorem reduce_erase_not_grants (s : PermSet) (p : Perm) (hp : p ∈ reduce s) :
    grants ((reduce s).erase p) p = false := by
  cases hcon : grants ((reduce s).erase p) p with
  | false => rfl
  | true =>
    obtain ⟨q, hq, hqp⟩ := List.any_eq_true.mp hcon
    have hqmem : q ∈ reduce s := List.mem_of_mem_erase hq
    have hqp' : q = p := reduce_antichain s p hp q hqmem hqp
    subst hqp'
    exact absurd hq (List.Nodup.not_mem_erase (reduce_nodup s))

end PermSet

end CfDeploy
