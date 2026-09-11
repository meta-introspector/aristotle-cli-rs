/-
# `@[cf_site]` — deployment profiles declared in Lean

A `cfdeploy.toml` is the portable way to record a hostname; this is the
*Lean* way.  Tag a `CfDeploy.Config.Profile` with `@[cf_site]` and it
joins the tool's table of profiles:

```lean
@[cf_site] def prod : Config.Profile :=
  { name := "prod", about := "the live site"
    doc := Config.layer (host := some "cf.example.net") (subdir := some "web") }
```

`cf_profiles%` elaborates to the list of every profile registered this
way in the current file and in everything it imports, so the CLI's
`--profile` and `cfdeploy profiles` see them without anyone maintaining
a list by hand.  The attribute checks the declaration's type, so a
mistyped profile is a compile error rather than a silently missing
hostname.
-/
import Lean
import RequestProject.Edge.Cf.Config

open Lean Elab Term Meta

namespace CfDeploy
namespace Config

/-- The declarations tagged `@[cf_site]`, in declaration order. -/
initialize cfSiteExt : SimplePersistentEnvExtension Name (Array Name) ←
  registerSimplePersistentEnvExtension
    { addEntryFn := Array.push
      addImportedFn := fun as => as.foldl (fun acc a => acc ++ a) #[] }

initialize registerBuiltinAttribute {
  name := `cf_site
  descr := "register this `CfDeploy.Config.Profile` as a deployment profile"
  applicationTime := .afterCompilation
  add := fun decl _stx kind => do
    unless kind == AttributeKind.global do
      throwError "`cf_site` must be a global attribute"
    let env ← getEnv
    let some info := env.find? decl
      | throwError "unknown declaration {decl}"
    let ty := info.type
    unless ty.isConstOf ``CfDeploy.Config.Profile do
      throwError "`cf_site` expects a `CfDeploy.Config.Profile`, but {decl} has type {ty}"
    modifyEnv fun env => cfSiteExt.addEntry env decl
}

/-- Every profile registered with `@[cf_site]`, as a `List Profile`. -/
elab "cf_profiles%" : term => do
  let env ← getEnv
  let names := cfSiteExt.getState env ++
    (cfSiteExt.toEnvExtension.getState env).importedEntries.foldl (fun acc a => acc ++ a) #[]
  let mut es : List Expr := []
  for n in names.toList.eraseDups.reverse do
    es := mkConst n :: es
  mkListLit (mkConst ``CfDeploy.Config.Profile) es

end Config
end CfDeploy
