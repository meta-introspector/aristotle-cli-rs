import Split.Task
import Split.Monad_toApplicative
import Split.Task_pure
import Split.Task_Priority
import Split.Task_Priority_default
import Split.instMonadBaseIO
import Split.Applicative_toFunctor
import Split.optParam
import Split.BaseIO
import Split.Functor_map

-- BaseIO.asTask from environment
-- opaque BaseIO.asTask : forall {α : Type}, (BaseIO α) -> (optParam.{1} Task.Priority Task.Priority.default) -> (BaseIO (Task.{0} α))

-- Stub: this file represents the declaration `BaseIO.asTask`.
-- In a full split, the body would be extracted from the environment.
