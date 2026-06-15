import Split.Task
import Split.EIO_asTask
import Split.IO
import Split.Task_Priority
import Split.Task_Priority_default
import Split.IO_Error
import Split.optParam
import Split.Except
import Split.BaseIO

-- IO.asTask from environment
-- def IO.asTask : forall {α : Type}, (IO α) -> (optParam.{1} Task.Priority Task.Priority.default) -> (BaseIO (Task.{0} (Except.{0, 0} IO.Error α)))
-- (definition body omitted)

-- Stub: this file represents the declaration `IO.asTask`.
-- In a full split, the body would be extracted from the environment.
