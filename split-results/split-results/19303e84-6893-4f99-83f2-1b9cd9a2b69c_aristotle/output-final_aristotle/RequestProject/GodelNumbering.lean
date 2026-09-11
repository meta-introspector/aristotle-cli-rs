import RequestProject.Main

open scoped Classical

set_option relaxedAutoImplicit false
set_option autoImplicit false

open Lean

/-!
# Grounding `SimpleExpr` in pure number theory (Gödel numbering)

This file makes precise the philosophical claim that the self-hosting object language
`SimpleExpr` — the small meta-language reconstructed in `RequestProject.Main` — is, in the
end, *no bigger than the natural numbers*: its entire universe of syntax trees embeds
**injectively into `ℕ`**.  This is the formal content of "the meta-language is built on
number theory, which is smaller".

The argument is a literal "shrinking layer cake".  Each layer the syntax depends on is
shown to embed into a previously-grounded layer, until everything bottoms out at `ℕ`:

```
  UInt32  ↪ ℕ           (machine words are numbers)
  Char    ↪ UInt32      (a character is its code point)
  String  ↪ List Char   (a string is its list of characters)
  Name    ↪ (built from ℕ, String, Name)     -- structurally finite trees of the above
  Level   ↪ (built from ℕ, Name, LMVarId)    -- ditto
  SimpleExpr ↪ (built from ℕ, Name, Level, List Level, BinderInfo)
             ↪ ℕ                              -- the final anchor
```

Every arrow `↪` is a genuine injection, so each type is `Countable`; countability is
preserved by the inductive constructions (finite products, sums, lists, and W-types over
countable data).  Composing the chain yields a single injection `SimpleExpr ↪ ℕ`, i.e. a
**Gödel numbering** `SimpleExpr.toNat : SimpleExpr → ℕ` that is injective.

We build the chain explicitly so that the dependency tower is visible in the code, rather
than hidden inside one opaque `deriving` call.
-/

namespace SimpleExpr

/-! ## The base layers: machine words, characters, strings -/

/-- A 32-bit machine word is just a natural number (its `toNat` value). -/
instance instCountableUInt32 : Countable UInt32 :=
  Function.Injective.countable (f := UInt32.toNat) (fun _ _ h => UInt32.toNat_inj.mp h)

/-- A character is determined by its code point, a `UInt32`. -/
instance instCountableChar : Countable Char :=
  Function.Injective.countable (f := Char.val) (fun _ _ h => Char.ext h)

/-- A string is determined by its list of characters. -/
instance instCountableString : Countable String :=
  Function.Injective.countable (f := String.toList) (fun _ _ h => String.toList_inj.mp h)

/-! ## The metaprogramming layers: names, universe levels -/

/- `Name` is a finite inductive tree over `ℕ` and `String`, hence countable. -/
deriving instance Countable for Name

/-- A level metavariable id is just a wrapped `Name`. -/
instance instCountableLevelMVarId : Countable LevelMVarId :=
  Function.Injective.countable (f := LevelMVarId.name)
    (fun a b h => by cases a; cases b; simp_all)

/- `Level` is a finite inductive tree over `Name` and `LMVarId`, hence countable. -/
deriving instance Countable for Level

/- `BinderInfo` is a finite enumeration, hence countable. -/
deriving instance Countable for BinderInfo

/-! ## The object language and its Gödel numbering -/

/- `SimpleExpr` is a finite inductive tree over `ℕ`, `Name`, `Level`, `List Level`, and
`BinderInfo` — all countable — hence countable itself. -/
deriving instance Countable for SimpleExpr

/-- **Gödel numbering.** A function assigning to every `SimpleExpr` syntax tree a natural
number, obtained from the embedding `SimpleExpr ↪ ℕ` established by the layer-cake of
injections above.  It is noncomputable only because it is extracted abstractly from
countability; its *existence* is the mathematically meaningful content. -/
noncomputable def toNat : SimpleExpr → ℕ :=
  Classical.choose (Countable.exists_injective_nat SimpleExpr)

/-- The Gödel numbering is injective: distinct syntax trees receive distinct numbers, so
no information is lost when the whole language is compressed into `ℕ`. -/
theorem toNat_injective : Function.Injective toNat :=
  Classical.choose_spec (Countable.exists_injective_nat SimpleExpr)

/-- **The object language embeds into pure number theory.**  There is an injection from the
entire syntax of `SimpleExpr` into `ℕ`; equivalently, `SimpleExpr` is countable.  This is
the formal statement of "the meta-language is grounded in number theory, which is smaller". -/
theorem embeds_in_nat : ∃ f : SimpleExpr → ℕ, Function.Injective f :=
  ⟨toNat, toNat_injective⟩

/-- Two syntax trees are equal iff they share the same Gödel number — the numbering is a
faithful name for syntax. -/
theorem eq_iff_toNat_eq {e₁ e₂ : SimpleExpr} : e₁ = e₂ ↔ toNat e₁ = toNat e₂ :=
  ⟨fun h => h ▸ rfl, fun h => toNat_injective h⟩

/-- The self-application term `selfApp` of `RequestProject.Main` — the interpreter applied
to its own type — also lives in number theory: it is named by the single natural number
`toNat selfApp`. -/
theorem selfApp_has_godel_number : ∃ n : ℕ, toNat selfApp = n :=
  ⟨toNat selfApp, rfl⟩

end SimpleExpr
