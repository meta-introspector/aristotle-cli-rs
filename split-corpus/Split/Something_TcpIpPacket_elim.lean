import Mathlib

set_option pp.all true
-- spec: Something.TcpIpPacket.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 42) -> (motive Something.TcpIpPacket) -> (motive t)
def Something.TcpIpPacket.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 42) -> (motive Something.TcpIpPacket) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 42) (TcpIpPacket : motive Something.TcpIpPacket) => Something.ctorElim.{u} motive 42 t (Eq.symm.{1} Nat (Something.ctorIdx t) 42 h) (PULift.up.{u, u} (motive Something.TcpIpPacket) TcpIpPacket)
