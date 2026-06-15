import Split.Inhabited_default
import Split.IO_Process_StdioConfig_stdin
import Split.IO_Process_StdioConfig_stderr
import Split.IO_Process_StdioConfig
import Split.instInhabitedError
import Split.IO_Process_StdioConfig_mk
import Split.IO
import Split.instInhabitedEIO
import Split.Pi_instInhabited
import Split.IO_Process_Stdio_null
import Split.IO_Process_Child
import Split.IO_Error
import Split.Prod
import Split.IO_Process_Stdio_toHandleType
import Split.IO_Process_StdioConfig_stdout

-- IO.Process.Child.takeStdin from environment
-- opaque IO.Process.Child.takeStdin : forall {cfg : [mdata borrowed:1 IO.Process.StdioConfig]}, (IO.Process.Child cfg) -> (IO (Prod.{0, 0} (IO.Process.Stdio.toHandleType (IO.Process.StdioConfig.stdin cfg)) (IO.Process.Child (IO.Process.StdioConfig.mk IO.Process.Stdio.null (IO.Process.StdioConfig.stdout cfg) (IO.Process.StdioConfig.stderr cfg)))))

-- Stub: this file represents the declaration `IO.Process.Child.takeStdin`.
-- In a full split, the body would be extracted from the environment.
