import Mathlib

set_option pp.all true
-- spec: Std.Stream.next? : forall {stream : Type.{u}} {value : outParam.{succ (succ v)} Type.{v}} [self : Std.Stream.{u, v} stream value], stream -> (Option.{max u v} (Prod.{v, u} value stream))
def Std.Stream.next? : forall {stream : Type.{u}} {value : outParam.{succ (succ v)} Type.{v}} [self : Std.Stream.{u, v} stream value], stream -> (Option.{max u v} (Prod.{v, u} value stream)) :=
  fun (stream : Type.{u}) {value : outParam.{succ (succ v)} Type.{v}} [self : Std.Stream.{u, v} stream value] => self.1
