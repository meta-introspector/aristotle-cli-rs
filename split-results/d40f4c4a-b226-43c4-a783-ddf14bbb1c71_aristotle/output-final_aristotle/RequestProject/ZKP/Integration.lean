import Mathlib
import RequestProject.Permission
import RequestProject.ZKP.Constraint
import RequestProject.ZKP.Certification

/-!
# ZKP Integration with Permission System

Integrates the ZKP plugin certification framework with the existing
permission evaluation system and RBAC policy engine.

## Components:
- `CertifiedPermissionEval` : Permission evaluation that requires ZKP certification
- `PluginRegistry` : Registry of certified plugins with trust management
- `PolicyWithCertification` : RBAC policy extended with certification requirements

## Key Properties:
- Uncertified plugins are always denied
- Certified plugins follow normal permission evaluation
- Revoking certification immediately denies access
- Certification does not bypass deny rules
-/

namespace ZKP.Integration

open ZKP.Constraint
open ZKP.Certification

-- ============================================================================
-- Plugin Registry
-- ============================================================================

/-- A plugin entry in the registry. -/
structure PluginEntry where
  name : String
  binaryHash : String
  certification : Option CertifiedPlugin
  deriving Repr

/-- A registry of plugins with their certification status. -/
structure PluginRegistry where
  plugins : List PluginEntry
  verificationConfig : VerificationConfig
  deriving Repr

/-- Look up a plugin by name. -/
def PluginRegistry.findPlugin (reg : PluginRegistry) (name : String) : Option PluginEntry :=
  reg.plugins.find? (·.name == name)

/-- Check if a plugin is certified and currently valid. -/
def PluginRegistry.isCertified (reg : PluginRegistry) (name : String) : Bool :=
  match reg.findPlugin name with
  | some entry =>
    match entry.certification with
    | some cp => cp.isValid reg.verificationConfig
    | none => false
  | none => false

/-- Register a new certified plugin. -/
def PluginRegistry.registerCertified (reg : PluginRegistry) (entry : PluginEntry) : PluginRegistry :=
  { reg with plugins := reg.plugins ++ [entry] }

/-- Revoke certification for a plugin by name. -/
def PluginRegistry.revokeCertification (reg : PluginRegistry) (name : String) : PluginRegistry :=
  { reg with plugins := reg.plugins.map fun e =>
    if e.name == name then { e with certification := none } else e }

-- ============================================================================
-- Certified Permission Evaluation
-- ============================================================================

/-- Extended permission result that includes certification status. -/
inductive CertifiedPermResult where
  | Allow
  | Ask
  | Deny (reasons : List String)
  | DenyUncertified (pluginName : String)
  deriving DecidableEq, Repr

/-- Evaluate permissions with certification requirement.
    Uncertified plugins are always denied, regardless of other permissions. -/
def certifiedEvalPerm (agent : Agent) (registry : PluginRegistry)
    (toolName : String) (arg : String) : CertifiedPermResult :=
  -- First check certification
  if ¬(registry.isCertified toolName) then
    .DenyUncertified toolName
  else
    -- If certified, fall through to normal permission evaluation
    match evalPerm agent toolName arg with
    | .Allow => .Allow
    | .Ask => .Ask
    | .Deny reasons => .Deny reasons

-- ============================================================================
-- Properties
-- ============================================================================

/-- Uncertified plugins are always denied. -/
theorem uncertified_always_denied (agent : Agent) (registry : PluginRegistry)
    (toolName arg : String)
    (hNotCert : registry.isCertified toolName = false) :
    certifiedEvalPerm agent registry toolName arg = .DenyUncertified toolName := by
  simp [certifiedEvalPerm, hNotCert]

/-- Certification does not bypass deny rules: if the base evaluation
    denies, the certified evaluation also denies. -/
theorem certification_respects_deny (agent : Agent) (registry : PluginRegistry)
    (toolName arg : String) (reasons : List String)
    (hCert : registry.isCertified toolName = true)
    (hDeny : evalPerm agent toolName arg = .Deny reasons) :
    certifiedEvalPerm agent registry toolName arg = .Deny reasons := by
  simp [certifiedEvalPerm, hCert, hDeny]

/-- Certified + allowed in base → allowed in certified evaluation. -/
theorem certified_and_allowed (agent : Agent) (registry : PluginRegistry)
    (toolName arg : String)
    (hCert : registry.isCertified toolName = true)
    (hAllow : evalPerm agent toolName arg = .Allow) :
    certifiedEvalPerm agent registry toolName arg = .Allow := by
  simp [certifiedEvalPerm, hCert, hAllow]

/-
Revoking certification for a plugin that was the only entry
    causes it to become uncertified.
-/
theorem revoke_makes_uncertified (reg : PluginRegistry) (name : String)
    (hFound : (reg.findPlugin name).isSome = true)
    (_hOnly : ∀ e ∈ reg.plugins, e.name == name = true →
              ∀ e' ∈ reg.plugins, e'.name == name = true → e = e') :
    (reg.revokeCertification name).isCertified name = false := by
  grind +locals

/-
Result trichotomy for certified evaluation.
-/
theorem certified_eval_trichotomy (agent : Agent) (registry : PluginRegistry)
    (toolName arg : String) :
    (certifiedEvalPerm agent registry toolName arg = .Allow) ∨
    (certifiedEvalPerm agent registry toolName arg = .Ask) ∨
    (∃ reasons, certifiedEvalPerm agent registry toolName arg = .Deny reasons) ∨
    (certifiedEvalPerm agent registry toolName arg = .DenyUncertified toolName) := by
  unfold certifiedEvalPerm;
  split_ifs <;> aesop

-- ============================================================================
-- Compliance Check Integration
-- ============================================================================

/-- Check if a plugin binary satisfies a compliance profile. -/
def checkCompliance (plugin : PluginBinary) (profile : ComplianceProfile) : Bool :=
  let model := profile.toModel
  let σ := plugin.toAssignment
  model.isSatisfiedBy σ

/-
A compliant plugin has size within bounds.
-/
theorem compliant_size_bounded (plugin : PluginBinary) (profile : ComplianceProfile)
    (hCompliant : checkCompliance plugin profile = true) :
    plugin.binarySize ≤ profile.maxBinarySize := by
  contrapose! hCompliant;
  simp +decide [ checkCompliance, ConstraintModel.isSatisfiedBy ];
  simp +decide [ ComplianceProfile.toModel ];
  simp +decide [ ConstraintOp.satisfiedBy, PluginBinary.toAssignment ];
  exact Or.inl hCompliant

/-
A compliant plugin has no type violations.
-/
theorem compliant_type_safe (plugin : PluginBinary) (profile : ComplianceProfile)
    (hCompliant : checkCompliance plugin profile = true) :
    plugin.typeViolations = 0 := by
  unfold checkCompliance at hCompliant;
  unfold ConstraintModel.isSatisfiedBy at hCompliant;
  unfold ZKP.Constraint.ConstraintOp.satisfiedBy at hCompliant; simp_all +decide [ ZKP.Constraint.ComplianceProfile.toModel ] ;
  unfold PluginBinary.toAssignment at hCompliant; aesop;

/-
A compliant plugin has cycles within bounds.
-/
theorem compliant_cycles_bounded (plugin : PluginBinary) (profile : ComplianceProfile)
    (hCompliant : checkCompliance plugin profile = true) :
    plugin.worstCaseCycles ≤ profile.maxInstructionCycles := by
  unfold checkCompliance at hCompliant;
  unfold ConstraintModel.isSatisfiedBy at hCompliant;
  unfold ComplianceProfile.toModel at hCompliant; simp_all +decide [ List.all ] ;
  unfold ConstraintOp.satisfiedBy at hCompliant; simp_all +decide [ PluginBinary.toAssignment ] ;

end ZKP.Integration