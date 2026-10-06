import Mathlib

set_option pp.all true
-- spec: Std.ToStream.toStream : forall {collection : Type.{u}} {stream : outParam.{succ (succ u)} Type.{u}} [self : Std.ToStream.{u} collection stream], collection -> stream
def Std.ToStream.toStream : forall {collection : Type.{u}} {stream : outParam.{succ (succ u)} Type.{u}} [self : Std.ToStream.{u} collection stream], collection -> stream :=
  fun (collection : Type.{u}) {stream : outParam.{succ (succ u)} Type.{u}} [self : Std.ToStream.{u} collection stream] => self.1
