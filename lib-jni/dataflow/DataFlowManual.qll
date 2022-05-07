import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

private newtype TMyType = TMyConstructor()
private newtype TUnit =
  TJavaUnit(JAVA::Unit c)
  or
  TCppUnit(CPP::Unit c)
class Unit extends TUnit {
  JAVA::Unit asJavaUnit() { this = TJavaUnit(result) }
  CPP::Unit asCppUnit() { this = TCppUnit(result) }

  string toString() {
    result = asJavaUnit().toString()
    or
    result = asCppUnit().toString()
  }

  /* member predicates for Unit */
}
private newtype TContent =
  TJavaContent(JAVA::Content c)
  or
  TCppContent(CPP::Content c)
class Content extends TContent {
  JAVA::Content asJavaContent() { this = TJavaContent(result) }
  CPP::Content asCppContent() { this = TCppContent(result) }

  string toString() {
    result = asJavaContent().toString()
    or
    result = asCppContent().toString()
  }

  /* member predicates for Content */
}
private newtype TDataFlowCall =
  TJavaDataFlowCall(JAVA::DataFlowCall c)
  or
  TCppDataFlowCall(CPP::DataFlowCall c)
class DataFlowCall extends TDataFlowCall {
  JAVA::DataFlowCall asJavaDataFlowCall() { this = TJavaDataFlowCall(result) }
  CPP::DataFlowCall asCppDataFlowCall() { this = TCppDataFlowCall(result) }

  string toString() {
    result = asJavaDataFlowCall().toString()
    or
    result = asCppDataFlowCall().toString()
  }

  /* member predicates for DataFlowCall */
  DataFlowCallable getEnclosingCallable() {
    result.asJavaDataFlowCallable() = asJavaDataFlowCall().getEnclosingCallable()
    or
    result.asCppDataFlowCallable() = asCppDataFlowCall().getEnclosingCallable()
  }
}
private newtype TDataFlowType =
  TJavaDataFlowType(JAVA::DataFlowType c)
  or
  TCppDataFlowType(CPP::DataFlowType c)
class DataFlowType extends TDataFlowType {
  JAVA::DataFlowType asJavaDataFlowType() { this = TJavaDataFlowType(result) }
  CPP::DataFlowType asCppDataFlowType() { this = TCppDataFlowType(result) }

  string toString() {
    result = asJavaDataFlowType().toString()
    or
    result = asCppDataFlowType().toString()
  }

  /* member predicates for DataFlowType */
}
private newtype TDataFlowCallable =
  TJavaDataFlowCallable(JAVA::DataFlowCallable c)
  or
  TCppDataFlowCallable(CPP::DataFlowCallable c)
class DataFlowCallable extends TDataFlowCallable {
  JAVA::DataFlowCallable asJavaDataFlowCallable() { this = TJavaDataFlowCallable(result) }
  CPP::DataFlowCallable asCppDataFlowCallable() { this = TCppDataFlowCallable(result) }

  string toString() {
    result = asJavaDataFlowCallable().toString()
    or
    result = asCppDataFlowCallable().toString()
  }

  /* member predicates for DataFlowCallable */
  predicate isJniFunction() {
    this.asCppDataFlowCallable().toString().matches("Java_%")
    or
    registeredMethod(_, _, this.asCppDataFlowCallable())
  }
}
//newtype TParameterPosition =
//  TJavaParameterPosition(JAVA::ParameterPosition c)
//  or
//  TCppParameterPosition(CPP::ParameterPosition c)
//class ParameterPosition extends TParameterPosition {
//  JAVA::ParameterPosition asJavaParameterPosition() { this = TJavaParameterPosition(result) }
//  CPP::ParameterPosition asCppParameterPosition() { this = TCppParameterPosition(result) }
//
//  string toString() {
//    result = asJavaParameterPosition().toString()
//    or
//    result = asCppParameterPosition().toString()
//  }
//
//  /* member predicates for ParameterPosition */
//}

class ParameterPosition extends int {
  ParameterPosition() { this = [-2 .. 10] }
  JAVA::ParameterPosition asJavaParameterPosition() { this = result }
  CPP::ParameterPosition asCppParameterPosition() { this = result }

  /* member predicates for ParameterPosition */
}

newtype TNode =
  TJavaNode(JAVA::Node c)
  or
  TCppNode(CPP::Node c)
  or
  TJavaMethodNode(JAVA::Callable c)
  or
  TJavaClassNode(JAVA::Class c)
  or
  TJavaFieldNode(JAVA::Field f)
class Node extends TNode {
  JAVA::Node asJavaNode() { this = TJavaNode(result) }
  CPP::Node asCppNode() { this = TCppNode(result) }

  string toString() {
    result = asJavaNode().toString()
    or
    result = asCppNode().toString()
  }

  /* member predicates for Node */
  predicate hasLocationInfo(string p0, int p1, int p2, int p3, int p4) {
    asJavaNode().hasLocationInfo(p0, p1, p2, p3, p4)
    or
    asCppNode().hasLocationInfo(p0, p1, p2, p3, p4)
  }

  string getLocation() {
    result = asJavaNode().getLocation().toString()
    or
    result = asCppNode().getLocation().toString()
  }
}

//newtype TArgumentPosition =
//  TJavaArgumentPosition(JAVA::ArgumentPosition c)
//  or
//  TCppArgumentPosition(CPP::ArgumentPosition c)
//class ArgumentPosition extends TArgumentPosition {
//  JAVA::ArgumentPosition asJavaArgumentPosition() { this = TJavaArgumentPosition(result) }
//  CPP::ArgumentPosition asCppArgumentPosition() { this = TCppArgumentPosition(result) }
//
//  string toString() {
//    result = asJavaArgumentPosition().toString()
//    or
//    result = asCppArgumentPosition().toString()
//  }
//
//  /* member predicates for ArgumentPosition */
//}
class ArgumentPosition extends int {
  ArgumentPosition() { this = [-2 .. 10] }

  JAVA::ArgumentPosition asJavaArgumentPosition() { this = result }
  CPP::ArgumentPosition asCppArgumentPosition() { this = result }

  /* member predicates for ParameterPosition */
}

private newtype TBarrierGuard =
  TJavaBarrierGuard(JAVA::BarrierGuard c)
  or
  TCppBarrierGuard(CPP::BarrierGuard c)
class BarrierGuard extends TBarrierGuard {
  JAVA::BarrierGuard asJavaBarrierGuard() { this = TJavaBarrierGuard(result) }
  CPP::BarrierGuard asCppBarrierGuard() { this = TCppBarrierGuard(result) }

  string toString() {
    result = asJavaBarrierGuard().toString()
    or
    result = asCppBarrierGuard().toString()
  }

  /* member predicates for BarrierGuard */
  Node getAGuardedNode() {
    result.asJavaNode() = asJavaBarrierGuard().getAGuardedNode()
    or
    result.asCppNode() = asCppBarrierGuard().getAGuardedNode()
  }
}
private newtype TDataFlowExpr =
  TJavaDataFlowExpr(JAVA::DataFlowExpr c)
  or
  TCppDataFlowExpr(CPP::DataFlowExpr c)
class DataFlowExpr extends TDataFlowExpr {
  JAVA::DataFlowExpr asJavaDataFlowExpr() { this = TJavaDataFlowExpr(result) }
  CPP::DataFlowExpr asCppDataFlowExpr() { this = TCppDataFlowExpr(result) }

  string toString() {
    result = asJavaDataFlowExpr().toString()
    or
    result = asCppDataFlowExpr().toString()
  }

  /* member predicates for DataFlowExpr */
}
private newtype TReturnKind =
  TJavaReturnKind(JAVA::ReturnKind c)
  or
  TCppReturnKind(CPP::ReturnKind c)
class ReturnKind extends TReturnKind {
  JAVA::ReturnKind asJavaReturnKind() { this = TJavaReturnKind(result) }
  CPP::ReturnKind asCppReturnKind() { this = TCppReturnKind(result) }

  string toString() {
    result = asJavaReturnKind().toString()
    or
    result = asCppReturnKind().toString()
  }

  /* member predicates for ReturnKind */
}
class ReturnNode extends Node {
  ReturnNode() {
    asJavaNode() instanceof JAVA::ReturnNode
    or
    asCppNode() instanceof CPP::ReturnNode
  }

  JAVA::ReturnNode asJavaReturnNode() { result = asJavaNode() }
  CPP::ReturnNode asCppReturnNode() { result = asCppNode() }

  /* member predicates for ReturnNode */
  ReturnKind getKind() {
    result.asJavaReturnKind() = asJavaReturnNode().getKind()
    or
    result.asCppReturnKind() = asCppReturnNode().getKind()
  }
}
class OutNode extends Node {
  OutNode() {
    asJavaNode() instanceof JAVA::OutNode
    or
    asCppNode() instanceof CPP::OutNode
  }

  JAVA::OutNode asJavaOutNode() { result = asJavaNode() }
  CPP::OutNode asCppOutNode() { result = asCppNode() }

  /* member predicates for OutNode */
}
private newtype TLambdaCallKind =
  TJavaLambdaCallKind(JAVA::LambdaCallKind c)
  or
  TCppLambdaCallKind(CPP::LambdaCallKind c)
class LambdaCallKind extends TLambdaCallKind {
  JAVA::LambdaCallKind asJavaLambdaCallKind() { this = TJavaLambdaCallKind(result) }
  CPP::LambdaCallKind asCppLambdaCallKind() { this = TCppLambdaCallKind(result) }

  string toString() {
    result = asJavaLambdaCallKind().toString()
    or
    result = asCppLambdaCallKind().toString()
  }

  /* member predicates for LambdaCallKind */
}
class PostUpdateNode extends Node {
  PostUpdateNode() {
    asJavaNode() instanceof JAVA::PostUpdateNode
    or
    asCppNode() instanceof CPP::PostUpdateNode
  }

  JAVA::PostUpdateNode asJavaPostUpdateNode() { result = asJavaNode() }
  CPP::PostUpdateNode asCppPostUpdateNode() { result = asCppNode() }

  /* member predicates for PostUpdateNode */
  Node getPreUpdateNode() {
    result.asJavaNode() = asJavaPostUpdateNode().getPreUpdateNode()
    or
    result.asCppNode() = asCppPostUpdateNode().getPreUpdateNode()
  }
}
class CastNode extends Node {
  CastNode() {
    asJavaNode() instanceof JAVA::CastNode
    or
    asCppNode() instanceof CPP::CastNode
  }

  JAVA::CastNode asJavaCastNode() { result = asJavaNode() }
  CPP::CastNode asCppCastNode() { result = asCppNode() }

  /* member predicates for CastNode */
}
predicate compatibleTypes(DataFlowType p0, DataFlowType p1) {
  JAVA::compatibleTypes(p0.asJavaDataFlowType(), p1.asJavaDataFlowType())
  or
  CPP::compatibleTypes(p0.asCppDataFlowType(), p1.asCppDataFlowType())
  or
  exists(p0.asJavaDataFlowType()) and exists(p1.asCppDataFlowType())
  or
  exists(p0.asCppDataFlowType()) and exists(p1.asJavaDataFlowType())
}
string ppReprType(DataFlowType p0) {
  result = JAVA::ppReprType(p0.asJavaDataFlowType())
  or
  result = CPP::ppReprType(p0.asCppDataFlowType())
}
int accessPathLimit() {
  result = JAVA::accessPathLimit()
  or
  result = CPP::accessPathLimit()
}
predicate parameterMatch(ParameterPosition p0, ArgumentPosition p1) {
  JAVA::parameterMatch(p0.asJavaParameterPosition(), p1.asJavaArgumentPosition())
  or
  CPP::parameterMatch(p0.asCppParameterPosition(), p1.asCppArgumentPosition())
}
Node exprNode(DataFlowExpr p0) {
  result.asJavaNode() = JAVA::exprNode(p0.asJavaDataFlowExpr())
  or
  result.asCppNode() = CPP::exprNode(p0.asCppDataFlowExpr())
}
DataFlowCallable viableCallable(DataFlowCall p0) {
  result.asJavaDataFlowCallable() = JAVA::viableCallable(p0.asJavaDataFlowCall())
  or
  not exists(JniCallNode callNode | callNode.getCall() = p0) and
  result.asCppDataFlowCallable() = CPP::viableCallable(p0.asCppDataFlowCall())
  or
  result.asCppDataFlowCallable() = viableCallableJ2C(p0.asJavaDataFlowCall())
  or
  result.asJavaDataFlowCallable() = viableCallableC2J(p0.asCppDataFlowCall())
}
OutNode getAnOutNode(DataFlowCall p0, ReturnKind p1) {
  result.asJavaOutNode() = JAVA::getAnOutNode(p0.asJavaDataFlowCall(), p1.asJavaReturnKind())
  or
  result.asCppOutNode() = CPP::getAnOutNode(p0.asCppDataFlowCall(), p1.asCppReturnKind())
  or
  exists (ReturnKind rk |
    rk.toString() = p1.toString()
    |
    result.asJavaOutNode() = JAVA::getAnOutNode(p0.asJavaDataFlowCall(), rk.asJavaReturnKind())
    or
    result.asCppOutNode() = CPP::getAnOutNode(p0.asCppDataFlowCall(), rk.asCppReturnKind())
  )
}
predicate lambdaCall(DataFlowCall p0, LambdaCallKind p1, Node p2) {
  JAVA::lambdaCall(p0.asJavaDataFlowCall(), p1.asJavaLambdaCallKind(), p2.asJavaNode())
  or
  CPP::lambdaCall(p0.asCppDataFlowCall(), p1.asCppLambdaCallKind(), p2.asCppNode())
}
predicate simpleLocalFlowStep(Node p0, Node p1) {
  JAVA::simpleLocalFlowStep(p0.asJavaNode(), p1.asJavaNode())
  or
  CPP::simpleLocalFlowStep(p0.asCppNode(), p1.asCppNode())
}
predicate additionalLambdaFlowStep(Node p0, Node p1, boolean p2) {
  JAVA::additionalLambdaFlowStep(p0.asJavaNode(), p1.asJavaNode(), p2)
  or
  CPP::additionalLambdaFlowStep(p0.asCppNode(), p1.asCppNode(), p2)
}
predicate mayBenefitFromCallContext(DataFlowCall p0, DataFlowCallable p1) {
  JAVA::mayBenefitFromCallContext(p0.asJavaDataFlowCall(), p1.asJavaDataFlowCallable())
  or
  CPP::mayBenefitFromCallContext(p0.asCppDataFlowCall(), p1.asCppDataFlowCallable())
}
DataFlowCallable viableImplInCallContext(DataFlowCall p0, DataFlowCall p1) {
  result.asJavaDataFlowCallable() = JAVA::viableImplInCallContext(p0.asJavaDataFlowCall(), p1.asJavaDataFlowCall())
  or
  result.asCppDataFlowCallable() = CPP::viableImplInCallContext(p0.asCppDataFlowCall(), p1.asCppDataFlowCall())
}
DataFlowCallable nodeGetEnclosingCallable(Node p0) {
  result.asJavaDataFlowCallable() = JAVA::nodeGetEnclosingCallable(p0.asJavaNode())
  or
  result.asCppDataFlowCallable() = CPP::nodeGetEnclosingCallable(p0.asCppNode())
}
DataFlowType getNodeType(Node p0) {
  result.asJavaDataFlowType() = JAVA::getNodeType(p0.asJavaNode())
  or
  result.asCppDataFlowType() = CPP::getNodeType(p0.asCppNode())
}
predicate jumpStep(Node p0, Node p1) {
  JAVA::jumpStep(p0.asJavaNode(), p1.asJavaNode())
  or
  CPP::jumpStep(p0.asCppNode(), p1.asCppNode())
}
predicate clearsContent(Node p0, Content p1) {
  JAVA::clearsContent(p0.asJavaNode(), p1.asJavaContent())
  or
  CPP::clearsContent(p0.asCppNode(), p1.asCppContent())
}
predicate isUnreachableInCall(Node p0, DataFlowCall p1) {
  JAVA::isUnreachableInCall(p0.asJavaNode(), p1.asJavaDataFlowCall())
  or
  CPP::isUnreachableInCall(p0.asCppNode(), p1.asCppDataFlowCall())
}
predicate nodeIsHidden(Node p0) {
  JAVA::nodeIsHidden(p0.asJavaNode())
  or
  CPP::nodeIsHidden(p0.asCppNode())
}
predicate isParameterNode(Node p0, DataFlowCallable p1, ParameterPosition p2) {
  JAVA::isParameterNode(p0.asJavaNode(), p1.asJavaDataFlowCallable(), p2.asJavaParameterPosition())
  or
  if p1.isJniFunction()
  then CPP::isParameterNode(p0.asCppNode(), p1.asCppDataFlowCallable(), p2.asCppParameterPosition() + 2)
  else CPP::isParameterNode(p0.asCppNode(), p1.asCppDataFlowCallable(), p2.asCppParameterPosition())
}
predicate isArgumentNode(Node p0, DataFlowCall p1, ArgumentPosition p2) {
  JAVA::isArgumentNode(p0.asJavaNode(), p1.asJavaDataFlowCall(), p2.asJavaArgumentPosition())
  or
  //CppArg
  (
    if
      exists(JniCallNode n | n.getCall() = p1 | p0 = n.getArgument(p2.asCppArgumentPosition()))
    then
      any()
    else
      CPP::isArgumentNode(p0.asCppNode(), p1.asCppDataFlowCall(), p2.asCppArgumentPosition())
  )
  or
  //jni Class Arg
  p0.(JavaClassNode).getClass() = p1.asJavaDataFlowCall().asCall().(JAVA::StaticMethodAccess).getReceiverType() and
  p2.asCppArgumentPosition() = -1
}
predicate lambdaCreation(Node p0, LambdaCallKind p1, DataFlowCallable p2) {
  JAVA::lambdaCreation(p0.asJavaNode(), p1.asJavaLambdaCallKind(), p2.asJavaDataFlowCallable())
  or
  CPP::lambdaCreation(p0.asCppNode(), p1.asCppLambdaCallKind(), p2.asCppDataFlowCallable())
}
predicate storeStep(Node p0, Content p1, Node p2) {
  JAVA::storeStep(p0.asJavaNode(), p1.asJavaContent(), p2.asJavaNode())
  or
  CPP::storeStep(p0.asCppNode(), p1.asCppContent(), p2.asCppNode())
}
predicate readStep(Node p0, Content p1, Node p2) {
  JAVA::readStep(p0.asJavaNode(), p1.asJavaContent(), p2.asJavaNode())
  or
  CPP::readStep(p0.asCppNode(), p1.asCppContent(), p2.asCppNode())
  or
  customReadStep(p0, p1, p2)
}
predicate allowParameterReturnInSelf(ParamNode p0) {
  JAVA::allowParameterReturnInSelf(p0.asJavaNode().(JAVA::ParamNode))
  or
  CPP::allowParameterReturnInSelf(p0.asCppNode().(CPP::ParamNode))
}
predicate forceHighPrecision(Content p0) {
  JAVA::forceHighPrecision(p0.asJavaContent())
  or
  CPP::forceHighPrecision(p0.asCppContent())
}


