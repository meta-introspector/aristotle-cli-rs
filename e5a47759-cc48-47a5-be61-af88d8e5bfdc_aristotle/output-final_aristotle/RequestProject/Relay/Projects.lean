import RequestProject.Relay.Templates
import RequestProject.Solfunmeme.Token.Supply
import RequestProject.Edge.Cf.WasmKernel
import RequestProject.Nix.Tech.Pantograph
import RequestProject.Gvcs.Welds
import RequestProject.Motion.Anim.Gif
import RequestProject.Craft.CCLuaCompile

/-!
# The relay and the developments it connects

Every stage of the relay stands for one of the developments merged into this
repository (`RequestProject.Relay.project` names it).  This module ties the two
together: by importing one module from each development it is a single point
that really does depend on all of them at once.

The `example`s below name one theorem of each development, so that a rename in
any of them is caught here.
-/

namespace RequestProject.Relay

-- `RequestProject.Solfunmeme` — the token ledger
example := @SFM.Token.Book.genesis_issued

-- `RequestProject.Edge` — the deployment kernel
example := @CfDeploy.WasmKernel.deployKernel_wf

-- `RequestProject.Nix` — the self-copying pantograph
example := @Bootstrap.Pantograph.exec_ouroboros

-- `RequestProject.Gvcs` — the weld geometry
example := @LifeTrac.filletThroat_pos

-- `RequestProject.Motion` — the GIF bit codec
example := @Hesper.Gif.valOf_bitsOf

-- `RequestProject.Craft` — the ComputerCraft Lua core
example := @CCLua.toLua_exec

end RequestProject.Relay
