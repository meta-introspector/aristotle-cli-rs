import Split.outParam
import Split.Prod
import Split.Std_Stream
import Split.Option

-- Std.Stream.next? from environment
-- def Std.Stream.next? : forall {stream : Type.{u}} {value : outParam.{succ (succ v)} Type.{v}} [self : Std.Stream.{u, v} stream value], stream -> (Option.{max u v} (Prod.{v, u} value stream))
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.Stream.next?`.
-- In a full split, the body would be extracted from the environment.
