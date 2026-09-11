import Mathlib
import RequestProject.GodelBrainrot
import RequestProject.MoonshineCorpus
import RequestProject.MonsterMoonshine

open scoped BigOperators

/-!
# Integration — wiring the three Gödel-Brainrot layers together

This module is the **integration layer**.  The project is built in three stacked
pieces:

* `RequestProject.GodelBrainrot` — the *visible game UI*: meme phrases encoded as
  Gödel numbers, the stealing mechanic, the Cambridge vault and the Colosseum.
* `RequestProject.MoonshineCorpus` — the *hidden CRT backend*: the 15 supersingular
  (Ogg) primes, the Chinese-Remainder moonshine encoding, the Clifford blade
  space, and `RichBrainrot` which staples a moonshine payload onto each visible
  brainrot.
* `RequestProject.MonsterMoonshine` — the *Monster layer*: `MonsterIrrep` /
  `CRTAddress` (cardinality `196883`), the `j`-function arithmetic and the
  geometric product on the Oggioral blades.

Here we *integrate* them: a single `IntegratedBrainrot` value that carries the
visible Gödel code, the hidden CRT code, and a Monster CRT address all at once,
together with theorems showing the three coordinates are **consistent** — the one
CRT integer of `MoonshineCorpus`, when read inside the Monster irrep coordinate
ring of `MonsterMoonshine`, recovers exactly the Monster address sampled from the
game payload.  The headline `integrated_vault_always_incomplete` carries the
Gödel incompleteness theorem all the way up through the fully integrated stack.

Everything compiles and every `theorem` is fully proved (no `sorry`).
-/

namespace Moonshine

open GodelBrainrot

/-! ## The Monster address of a rich brainrot -/

/-- The Monster CRT address attached to a rich brainrot: sample its hidden
moonshine payload at the three deep supersingular primes `47, 59, 71`. -/
def monsterAddress (rb : RichBrainrot) : CRTAddress := payloadAddress rb.payload

/-! ## Consistency of the CRT code with the Monster address

The `MoonshineCorpus` packs the whole supersingular register into the single
integer `crtEncode`.  Reading that integer inside each Monster coordinate ring
`ZMod 47`, `ZMod 59`, `ZMod 71` must recover the corresponding coordinate of the
Monster address.  These three lemmas are the bridge that *integrates* the
CRT-backend layer with the Monster layer. -/

/-- The CRT code, read in `ZMod 47`, equals the payload's `47`-residue. -/
theorem crtEncode_cast_47 (payload : Payload) :
    ((crtEncode payload : ZMod 47)) = (payload 47 : ZMod 47) := by
  rw [ZMod.natCast_eq_natCast_iff]
  exact crtEncode_modEq payload 47 (by decide)

/-- The CRT code, read in `ZMod 59`, equals the payload's `59`-residue. -/
theorem crtEncode_cast_59 (payload : Payload) :
    ((crtEncode payload : ZMod 59)) = (payload 59 : ZMod 59) := by
  rw [ZMod.natCast_eq_natCast_iff]
  exact crtEncode_modEq payload 59 (by decide)

/-- The CRT code, read in `ZMod 71`, equals the payload's `71`-residue. -/
theorem crtEncode_cast_71 (payload : Payload) :
    ((crtEncode payload : ZMod 71)) = (payload 71 : ZMod 71) := by
  rw [ZMod.natCast_eq_natCast_iff]
  exact crtEncode_modEq payload 71 (by decide)

/-- **Integration of the CRT backend with the Monster layer.**  The single
moonshine integer `crtEncode`, decoded across the three Monster coordinate rings,
reproduces exactly the Monster address sampled from the payload. -/
theorem monsterAddress_eq_crtEncode_residues (rb : RichBrainrot) :
    monsterAddress rb =
      ((crtEncode rb.payload : ZMod 47),
       (crtEncode rb.payload : ZMod 59),
       (crtEncode rb.payload : ZMod 71)) := by
  simp only [monsterAddress, payloadAddress,
    crtEncode_cast_47, crtEncode_cast_59, crtEncode_cast_71]

/-- The identity payload (all ones) lands on the all-ones Monster address, and its
CRT code is `1` — the three layers agree on the identity element. -/
theorem identity_consistent :
    monsterAddress ⟨⟨[]⟩, fun _ => 1⟩ = (1, 1, 1)
      ∧ crtEncode (fun _ => 1) = 1 := by
  exact ⟨payloadAddress_one, crtEncode_one⟩

/-! ## The fully integrated brainrot record -/

/-- An **integrated brainrot** bundles all three layers at once: the visible game
phrase, the hidden moonshine payload, and (derived) the Monster CRT address. -/
structure IntegratedBrainrot where
  /-- The visible Gödel-Brainrot meme phrase (game UI layer). -/
  rich : RichBrainrot

/-- The visible Gödel code of an integrated brainrot (game UI layer). -/
def IntegratedBrainrot.uiCode (ib : IntegratedBrainrot) : Nat :=
  encodeBrainrot ib.rich.ui

/-- The hidden CRT moonshine code (backend layer). -/
def IntegratedBrainrot.crtCode (ib : IntegratedBrainrot) : Nat :=
  crtEncode ib.rich.payload

/-- The Monster CRT address (Monster layer). -/
def IntegratedBrainrot.address (ib : IntegratedBrainrot) : CRTAddress :=
  monsterAddress ib.rich

/-- The combined total code carried up from the moonshine backend. -/
def IntegratedBrainrot.totalCode (ib : IntegratedBrainrot) : Nat :=
  Moonshine.totalCode ib.rich

/-- The three layers of any integrated brainrot are mutually consistent: its
Monster address is the residue triple of its CRT code, and its total code
dominates its visible UI code. -/
theorem IntegratedBrainrot.layers_consistent (ib : IntegratedBrainrot) :
    ib.address =
      ((ib.crtCode : ZMod 47), (ib.crtCode : ZMod 59), (ib.crtCode : ZMod 71))
    ∧ ib.uiCode ≤ ib.totalCode := by
  refine ⟨monsterAddress_eq_crtEncode_residues ib.rich, ?_⟩
  exact encode_le_totalCode ib.rich

/-! ## Incompleteness, lifted through the whole integrated stack -/

/-- **Integrated incompleteness.**  Even with the full stack wired together — the
visible Gödel UI, the supersingular CRT backend, and the Monster address layer —
no finite vault can imprison all integrated brainrot.  This carries
`GodelBrainrot.vault_always_incomplete` and `richVault_always_incomplete` all the
way up to the integrated record. -/
theorem integrated_vault_always_incomplete (prisoners : List IntegratedBrainrot) :
    ∃ ib : IntegratedBrainrot,
      ib.totalCode ∉ prisoners.map IntegratedBrainrot.totalCode := by
  obtain ⟨rb, hrb⟩ := richVault_always_incomplete (prisoners.map IntegratedBrainrot.rich)
  refine ⟨⟨rb⟩, fun hmem => hrb ?_⟩
  obtain ⟨ib, hib, hcode⟩ := List.mem_map.mp hmem
  exact List.mem_map.mpr ⟨ib.rich, List.mem_map_of_mem hib, hcode⟩

/-- The integrated dimension count is preserved: the Monster address space of the
integrated layer still has cardinality `196883`, the dimension of the smallest
faithful Monster irrep. -/
theorem integrated_address_card :
    Fintype.card CRTAddress = monsterIrrepDim := by
  rw [card_CRTAddress, monsterIrrepDim_eq]

end Moonshine
