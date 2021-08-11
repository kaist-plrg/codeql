import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

private newtype TBarrierGuard =
  TJavaBarrierGuard(JAVA::BarrierGuard g)
  or
  TCppBarrierGuard(CPP::BarrierGuard g)
class BarrierGuard extends TBarrierGuard {
  JAVA::BarrierGuard asJavaBarrierGuard() { this = TJavaBarrierGuard(result) }
  CPP::BarrierGuard asCppBarrierGuard() { this = TCppBarrierGuard(result) }

  string toString() {
    result = this.asJavaBarrierGuard().toString()
    or
    result = this.asCppBarrierGuard().toString()
  }
  
  Node getAGuardedNode() {
    result.asJavaNode() = this.asJavaBarrierGuard().getAGuardedNode()
    or
    result.asCppNode() = this.asCppBarrierGuard().getAGuardedNode()
  }
}
