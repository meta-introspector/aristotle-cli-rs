/-
# The deployment profiles, in Lean

This is the file to edit when you want a hostname to have a name.  Each
`@[cf_site]` declaration below is a *profile*: a layer of configuration
that `--profile NAME` puts underneath your command line and on top of
the built-in defaults.  `cfdeploy profiles` lists them, `cfdeploy config
--profile NAME` shows what they resolve to.

Nothing here is privileged: a profile sets exactly the same keys a
`cfdeploy.toml` sets (`Config.layer` names them), and the resolution
order is defaults → profile → the bundle's own `cfdeploy.toml` →
`./cfdeploy.toml` (or `--config`) → the command line.

The attribute checks the type, `cf_profiles%` collects them, and
`profiles_have_distinct_names` is a compile-time check that no two
profiles answer to the same name.
-/
import RequestProject.Edge.Cf.ProfileAttr

namespace CfDeploy
namespace Config

/-- The stock profile: publish the site directory of a bundle, prune
everything a Lean project drags along, and leave the hostname to be
given on the command line. -/
@[cf_site] def siteDirProfile : Profile :=
  { name := "site"
    about := "publish the bundle's own site directory (auto-detected), Lean sources pruned"
    doc := layer (subdir := some "auto") }

/-- Publish the `web/` directory of a bundle, the convention this
project itself follows. -/
@[cf_site] def webDirProfile : Profile :=
  { name := "web"
    about := "publish web/ and nothing else"
    doc := layer (subdir := some "web") }

/-- Publish the `dist/` directory: what a build step usually leaves
behind. -/
@[cf_site] def distDirProfile : Profile :=
  { name := "dist"
    about := "publish dist/ and nothing else"
    doc := layer (subdir := some "dist") }

/-- Publish the `public/` directory. -/
@[cf_site] def publicDirProfile : Profile :=
  { name := "public"
    about := "publish public/ and nothing else"
    doc := layer (subdir := some "public") }

/-- The Pages recipe rather than the Worker one, with the production
branch named. -/
@[cf_site] def pagesProfile : Profile :=
  { name := "pages"
    about := "the Pages direct-upload recipe, production branch `main`"
    doc := layer (pages := some true) (branch := some "main") }

/-- Publish the whole bundle — every directory, not just the detected
site one — with the usual pruning still in force. -/
@[cf_site] def wholeBundleProfile : Profile :=
  { name := "whole"
    about := "publish every directory of the bundle, Lean sources still pruned"
    doc := layer (subdir := some "") }

/-- Publish everything in the bundle, exactly as it is — the escape
hatch when the pruning is in the way.  It clears the site directory too,
so `everything` really does mean every file. -/
@[cf_site] def everythingProfile : Profile :=
  { name := "everything"
    about := "no pruning at all: publish the bundle exactly as it is"
    doc := layer (subdir := some "") (noPrune := some true) }

/-- **Every profile registered with `@[cf_site]`.** -/
def registered : List Profile := cf_profiles%

/-- The names `--profile` accepts. -/
def registeredNames : List String := registered.map (·.name)

-- every profile is reachable by name, and no two share one
#guard registeredNames.eraseDups.length == registeredNames.length
#guard registeredNames.all (fun n => (findProfile registered n).isSome)
#guard registeredNames.contains "site"
#guard registeredNames.contains "web"

-- the stock profile really does select the site directory
#guard (resolve [siteDirProfile.doc]).subdir == "auto"
#guard (resolve [webDirProfile.doc]).selection.subdir == "web"
#guard (resolve [everythingProfile.doc]).selection.excludes == []
#guard (resolve [everythingProfile.doc]).selection.subdir == ""
#guard (resolve [wholeBundleProfile.doc]).selection.subdir == ""
#guard (resolve []).subdir == "auto"

/-- No two registered profiles answer to the same name. -/
theorem profiles_have_distinct_names : registeredNames.eraseDups = registeredNames := by
  decide

end Config
end CfDeploy
