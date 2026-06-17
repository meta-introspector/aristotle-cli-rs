import Split.Task
import Split.BaseIO_asTask
import Split.EIO
import Split.Task_Priority
import Split.Task_Priority_default
import Split.EIO_toBaseIO
import Split.optParam
import Split.Except
import Split.BaseIO

-- EIO.asTask from environment
-- def EIO.asTask : forall {ε : Type} {α : Type}, (EIO ε α) -> (optParam.{1} Task.Priority Task.Priority.default) -> (BaseIO (Task.{0} (Except.{0, 0} ε α)))
-- (definition body omitted)

-- Stub: this file represents the declaration `EIO.asTask`.
-- In a full split, the body would be extracted from the environment.
