import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

private newtype TUnit =
  TJavaUnit(JAVA::Unit u)
  or
  TCppUnit(CPP::Unit u)
class Unit extends TUnit {
  JAVA::Unit asJavaUnit() { this = TJavaUnit(result) }
  CPP::Unit asCppUnit() { this = TCppUnit(result) }

  string toString() {
    result = this.asJavaUnit().toString()
    or
    result = this.asCppUnit().toString()
  }
}

private newtype TFile =
  TJavaFile(JAVA::File u)
  or
  TCppFile(CPP::File u)
class File extends TFile {
  JAVA::File asJavaFile() { this = TJavaFile(result) }
  CPP::File asCppFile() { this = TCppFile(result) }

  string toString() {
    result = this.asJavaFile().getAbsolutePath()
    or
    result = this.asCppFile().toString()
  }
}

private newtype TLocation =
  TJavaLocation(JAVA::Location u)
  or
  TCppLocation(CPP::Location u)
class Location extends TLocation {
  JAVA::Location asJavaLocation() { this = TJavaLocation(result) }
  CPP::Location asCppLocation() { this = TCppLocation(result) }

  string toString() {
    result = this.asJavaLocation().toString()
    or
    result = this.asCppLocation().toString()
  }

  File getFile() {
    result.asJavaFile() = this.asJavaLocation().getFile()
    or
    result.asCppFile() = this.asCppLocation().getFile()
  }
}

private newtype TContent =
  TJavaContent(JAVA::Content c)
  or
  TCppContent(CPP::Content c)
class Content extends TContent {
  JAVA::Content asJavaContent() { this = TJavaContent(result) }
  CPP::Content asCppContent() { this = TCppContent(result) }

  string toString() {
    result = this.asJavaContent().toString()
    or
    result = this.asCppContent().toString()
  }
}

private newtype TReturnKind =
  TJavaReturnKind(JAVA::ReturnKind k)
  or
  TCppReturnKind(CPP::ReturnKind k)
class ReturnKind extends TReturnKind {
  JAVA::ReturnKind asJavaReturnKind() { this = TJavaReturnKind(result) }
  CPP::ReturnKind asCppReturnKind() { this = TCppReturnKind(result) }

  string toString() {
    result = this.asJavaReturnKind().toString()
    or
    result = this.asCppReturnKind().toString()
  }

  predicate isNormalReturnKind() { //modified
    this.toString() = "return"
  }
}

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

DataFlowType getNodeType(Node n) { //modified
  result.asJavaDataFlowType() = JAVA::getNodeType(n.asJavaNode())
  or
  result.asCppDataFlowType() = CPP::getNodeType(n.asCppNode())
  or
  result = n.getType()
}

predicate nodeIsHidden(Node n) {
  JAVA::nodeIsHidden(n.asJavaNode())
  or
  CPP::nodeIsHidden(n.asCppNode())
}

predicate clearsContent(Node n, Content c) {
  JAVA::clearsContent(n.asJavaNode(), c.asJavaContent())
  or
  CPP::clearsContent(n.asCppNode(), c.asCppContent())
}

predicate isUnreachableInCall(Node n, DataFlowCall call) {
  JAVA::isUnreachableInCall(n.asJavaNode(), call.asJavaDataFlowCall())
  or
  CPP::isUnreachableInCall(n.asCppNode(), call.asCppDataFlowCall())
}

private predicate compatibleJavaCppTypes(JAVA::Type jt, CPP::Type ct) {
  // Currently, implementation for cpp is stub
  jt = jt and ct.toString() = "void"
}

pragma[inline]
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { //modified
  JAVA::compatibleTypes(t1.asJavaDataFlowType(), t2.asJavaDataFlowType())
  or
  CPP::compatibleTypes(t1.asCppDataFlowType(), t2.asCppDataFlowType())
  or
  compatibleJavaCppTypes(t1.asJavaDataFlowType(), t2.asCppDataFlowType())
  or
  compatibleJavaCppTypes(t2.asJavaDataFlowType(), t1.asCppDataFlowType())
}

string ppReprType(DataFlowType t) {
  result = JAVA::ppReprType(t.asJavaDataFlowType())
  or
  result = CPP::ppReprType(t.asCppDataFlowType())
}

int accessPathLimit() {
  result = JAVA::accessPathLimit()
  or
  result = CPP::accessPathLimit()
}
