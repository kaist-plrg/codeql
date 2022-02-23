import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

private newtype TMyType = TMyConstructor()
private newtype TUnit =
  TPythonUnit(PYTHON::Unit c)
  or
  TCppUnit(CPP::Unit c)
class Unit extends TUnit {
  PYTHON::Unit asPythonUnit() { this = TPythonUnit(result) }
  CPP::Unit asCppUnit() { this = TCppUnit(result) }

  string toString() {
    result = asPythonUnit().toString()
    or
    result = asCppUnit().toString()
  }

  /* member predicates for Unit */
}
private newtype TContent =
  TPythonContent(PYTHON::Content c)
  or
  TCppContent(CPP::Content c)
class Content extends TContent {
  PYTHON::Content asPythonContent() { this = TPythonContent(result) }
  CPP::Content asCppContent() { this = TCppContent(result) }

  string toString() {
    result = asPythonContent().toString()
    or
    result = asCppContent().toString()
  }

  /* member predicates for Content */
}
private newtype TDataFlowCall =
  TPythonDataFlowCall(PYTHON::DataFlowCall c)
  or
  TCppDataFlowCall(CPP::DataFlowCall c)
class DataFlowCall extends TDataFlowCall {
  PYTHON::DataFlowCall asPythonDataFlowCall() { this = TPythonDataFlowCall(result) }
  CPP::DataFlowCall asCppDataFlowCall() { this = TCppDataFlowCall(result) }

  string toString() {
    result = asPythonDataFlowCall().toString()
    or
    result = asCppDataFlowCall().toString()
  }

  /* member predicates for DataFlowCall */
  DataFlowCallable getEnclosingCallable() {
    result.asPythonDataFlowCallable() = asPythonDataFlowCall().getEnclosingCallable()
    or
    result.asCppDataFlowCallable() = asCppDataFlowCall().getEnclosingCallable()
  }
}
private newtype TDataFlowType =
  TPythonDataFlowType(PYTHON::DataFlowType c)
  or
  TCppDataFlowType(CPP::DataFlowType c)
class DataFlowType extends TDataFlowType {
  PYTHON::DataFlowType asPythonDataFlowType() { this = TPythonDataFlowType(result) }
  CPP::DataFlowType asCppDataFlowType() { this = TCppDataFlowType(result) }

  string toString() {
    result = asPythonDataFlowType().toString()
    or
    result = asCppDataFlowType().toString()
  }

  /* member predicates for DataFlowType */
}
private newtype TDataFlowCallable =
  TPythonDataFlowCallable(PYTHON::DataFlowCallable c)
  or
  TCppDataFlowCallable(CPP::DataFlowCallable c)
class DataFlowCallable extends TDataFlowCallable {
  PYTHON::DataFlowCallable asPythonDataFlowCallable() { this = TPythonDataFlowCallable(result) }
  CPP::DataFlowCallable asCppDataFlowCallable() { this = TCppDataFlowCallable(result) }

  string toString() {
    result = asPythonDataFlowCallable().toString()
    or
    result = asCppDataFlowCallable().toString()
  }

  /* member predicates for DataFlowCallable */
  predicate isNativeFunction() {
    exists(PyMethodDef md |
      asCppDataFlowCallable() = md.getMeth()
      )
  }
}
private newtype TParameterPosition =
  TPythonParameterPosition(PYTHON::ParameterPosition c)
  or
  TCppParameterPosition(CPP::ParameterPosition c)
class ParameterPosition extends TParameterPosition {
  PYTHON::ParameterPosition asPythonParameterPosition() { this = TPythonParameterPosition(result) }
  CPP::ParameterPosition asCppParameterPosition() { this = TCppParameterPosition(result) }

  string toString() {
    result = asPythonParameterPosition().toString()
    or
    result = asCppParameterPosition().toString()
  }

  /* member predicates for ParameterPosition */
}
private newtype TNode =
  TPythonNode(PYTHON::Node c)
  or
  TCppNode(CPP::Node c)
class Node extends TNode {
  PYTHON::Node asPythonNode() { this = TPythonNode(result) }
  CPP::Node asCppNode() { this = TCppNode(result) }

  string toString() {
    result = asPythonNode().toString()
    or
    result = asCppNode().toString()
  }

  /* member predicates for Node */
  predicate hasLocationInfo(string p0, int p1, int p2, int p3, int p4) {
    asPythonNode().hasLocationInfo(p0, p1, p2, p3, p4)
    or
    asCppNode().hasLocationInfo(p0, p1, p2, p3, p4)
  }
}
private newtype TArgumentPosition =
  TPythonArgumentPosition(PYTHON::ArgumentPosition c)
  or
  TCppArgumentPosition(CPP::ArgumentPosition c)
class ArgumentPosition extends TArgumentPosition {
  PYTHON::ArgumentPosition asPythonArgumentPosition() { this = TPythonArgumentPosition(result) }
  CPP::ArgumentPosition asCppArgumentPosition() { this = TCppArgumentPosition(result) }

  string toString() {
    result = asPythonArgumentPosition().toString()
    or
    result = asCppArgumentPosition().toString()
  }

  /* member predicates for ArgumentPosition */
}
private newtype TBarrierGuard =
  TPythonBarrierGuard(PYTHON::BarrierGuard c)
  or
  TCppBarrierGuard(CPP::BarrierGuard c)
class BarrierGuard extends TBarrierGuard {
  PYTHON::BarrierGuard asPythonBarrierGuard() { this = TPythonBarrierGuard(result) }
  CPP::BarrierGuard asCppBarrierGuard() { this = TCppBarrierGuard(result) }

  string toString() {
    result = asPythonBarrierGuard().toString()
    or
    result = asCppBarrierGuard().toString()
  }

  /* member predicates for BarrierGuard */
  Node getAGuardedNode() {
    result.asPythonNode() = asPythonBarrierGuard().getAGuardedNode()
    or
    result.asCppNode() = asCppBarrierGuard().getAGuardedNode()
  }
}
private newtype TDataFlowExpr =
  TPythonDataFlowExpr(PYTHON::DataFlowExpr c)
  or
  TCppDataFlowExpr(CPP::DataFlowExpr c)
class DataFlowExpr extends TDataFlowExpr {
  PYTHON::DataFlowExpr asPythonDataFlowExpr() { this = TPythonDataFlowExpr(result) }
  CPP::DataFlowExpr asCppDataFlowExpr() { this = TCppDataFlowExpr(result) }

  string toString() {
    result = asPythonDataFlowExpr().toString()
    or
    result = asCppDataFlowExpr().toString()
  }

  /* member predicates for DataFlowExpr */
}
private newtype TReturnKind =
  TPythonReturnKind(PYTHON::ReturnKind c)
  or
  TCppReturnKind(CPP::ReturnKind c)
class ReturnKind extends TReturnKind {
  PYTHON::ReturnKind asPythonReturnKind() { this = TPythonReturnKind(result) }
  CPP::ReturnKind asCppReturnKind() { this = TCppReturnKind(result) }

  string toString() {
    result = asPythonReturnKind().toString()
    or
    result = asCppReturnKind().toString()
  }

  /* member predicates for ReturnKind */
}
class ReturnNode extends Node {
  ReturnNode() {
    asPythonNode() instanceof PYTHON::ReturnNode
    or
    asCppNode() instanceof CPP::ReturnNode
  }

  PYTHON::ReturnNode asPythonReturnNode() { result = asPythonNode() }
  CPP::ReturnNode asCppReturnNode() { result = asCppNode() }

  /* member predicates for ReturnNode */
  ReturnKind getKind() {
    result.asPythonReturnKind() = asPythonReturnNode().getKind()
    or
    result.asCppReturnKind() = asCppReturnNode().getKind()
  }
}
class OutNode extends Node {
  OutNode() {
    asPythonNode() instanceof PYTHON::OutNode
    or
    asCppNode() instanceof CPP::OutNode
  }

  PYTHON::OutNode asPythonOutNode() { result = asPythonNode() }
  CPP::OutNode asCppOutNode() { result = asCppNode() }

  /* member predicates for OutNode */
}
private newtype TLambdaCallKind =
  TPythonLambdaCallKind(PYTHON::LambdaCallKind c)
  or
  TCppLambdaCallKind(CPP::LambdaCallKind c)
class LambdaCallKind extends TLambdaCallKind {
  PYTHON::LambdaCallKind asPythonLambdaCallKind() { this = TPythonLambdaCallKind(result) }
  CPP::LambdaCallKind asCppLambdaCallKind() { this = TCppLambdaCallKind(result) }

  string toString() {
    result = asPythonLambdaCallKind().toString()
    or
    result = asCppLambdaCallKind().toString()
  }

  /* member predicates for LambdaCallKind */
}
class PostUpdateNode extends Node {
  PostUpdateNode() {
    asPythonNode() instanceof PYTHON::PostUpdateNode
    or
    asCppNode() instanceof CPP::PostUpdateNode
  }

  PYTHON::PostUpdateNode asPythonPostUpdateNode() { result = asPythonNode() }
  CPP::PostUpdateNode asCppPostUpdateNode() { result = asCppNode() }

  /* member predicates for PostUpdateNode */
  Node getPreUpdateNode() {
    result.asPythonNode() = asPythonPostUpdateNode().getPreUpdateNode()
    or
    result.asCppNode() = asCppPostUpdateNode().getPreUpdateNode()
  }
}
class CastNode extends Node {
  CastNode() {
    asPythonNode() instanceof PYTHON::CastNode
    or
    asCppNode() instanceof CPP::CastNode
  }

  PYTHON::CastNode asPythonCastNode() { result = asPythonNode() }
  CPP::CastNode asCppCastNode() { result = asCppNode() }

  /* member predicates for CastNode */
}
predicate compatibleTypes(DataFlowType p0, DataFlowType p1) {
  PYTHON::compatibleTypes(p0.asPythonDataFlowType(), p1.asPythonDataFlowType())
  or
  CPP::compatibleTypes(p0.asCppDataFlowType(), p1.asCppDataFlowType())
  or
  exists(p0.asPythonDataFlowType()) and exists(p1.asCppDataFlowType())
  or
  exists(p0.asCppDataFlowType()) and exists(p1.asPythonDataFlowType())
}
string ppReprType(DataFlowType p0) {
  result = PYTHON::ppReprType(p0.asPythonDataFlowType())
  or
  result = CPP::ppReprType(p0.asCppDataFlowType())
}
int accessPathLimit() {
  result = PYTHON::accessPathLimit()
  or
  result = CPP::accessPathLimit()
}
predicate parameterMatch(ParameterPosition p0, ArgumentPosition p1) {
  PYTHON::parameterMatch(p0.asPythonParameterPosition(), p1.asPythonArgumentPosition())
  or
  CPP::parameterMatch(p0.asCppParameterPosition(), p1.asCppArgumentPosition())
}
Node exprNode(DataFlowExpr p0) {
  result.asPythonNode() = PYTHON::exprNode(p0.asPythonDataFlowExpr())
  or
  result.asCppNode() = CPP::exprNode(p0.asCppDataFlowExpr())
}
DataFlowCallable viableCallable(DataFlowCall p0) {
  result.asPythonDataFlowCallable() = PYTHON::viableCallable(p0.asPythonDataFlowCall())
  or
  result.asCppDataFlowCallable() = CPP::viableCallable(p0.asCppDataFlowCall())
  or
  result = p2cViableCallable(p0)
}
OutNode getAnOutNode(DataFlowCall p0, ReturnKind p1) {
  result.asPythonOutNode() = PYTHON::getAnOutNode(p0.asPythonDataFlowCall(), p1.asPythonReturnKind())
  or
  result.asCppOutNode() = CPP::getAnOutNode(p0.asCppDataFlowCall(), p1.asCppReturnKind())
}
predicate lambdaCall(DataFlowCall p0, LambdaCallKind p1, Node p2) {
  PYTHON::lambdaCall(p0.asPythonDataFlowCall(), p1.asPythonLambdaCallKind(), p2.asPythonNode())
  or
  CPP::lambdaCall(p0.asCppDataFlowCall(), p1.asCppLambdaCallKind(), p2.asCppNode())
}
predicate simpleLocalFlowStep(Node p0, Node p1) {
  PYTHON::simpleLocalFlowStep(p0.asPythonNode(), p1.asPythonNode())
  or
  CPP::simpleLocalFlowStep(p0.asCppNode(), p1.asCppNode())
}
predicate additionalLambdaFlowStep(Node p0, Node p1, boolean p2) {
  PYTHON::additionalLambdaFlowStep(p0.asPythonNode(), p1.asPythonNode(), p2)
  or
  CPP::additionalLambdaFlowStep(p0.asCppNode(), p1.asCppNode(), p2)
}
predicate mayBenefitFromCallContext(DataFlowCall p0, DataFlowCallable p1) {
  PYTHON::mayBenefitFromCallContext(p0.asPythonDataFlowCall(), p1.asPythonDataFlowCallable())
  or
  CPP::mayBenefitFromCallContext(p0.asCppDataFlowCall(), p1.asCppDataFlowCallable())
}
DataFlowCallable viableImplInCallContext(DataFlowCall p0, DataFlowCall p1) {
  result.asPythonDataFlowCallable() = PYTHON::viableImplInCallContext(p0.asPythonDataFlowCall(), p1.asPythonDataFlowCall())
  or
  result.asCppDataFlowCallable() = CPP::viableImplInCallContext(p0.asCppDataFlowCall(), p1.asCppDataFlowCall())
}
DataFlowCallable nodeGetEnclosingCallable(Node p0) {
  result.asPythonDataFlowCallable() = PYTHON::nodeGetEnclosingCallable(p0.asPythonNode())
  or
  result.asCppDataFlowCallable() = CPP::nodeGetEnclosingCallable(p0.asCppNode())
}
DataFlowType getNodeType(Node p0) {
  result.asPythonDataFlowType() = PYTHON::getNodeType(p0.asPythonNode())
  or
  result.asCppDataFlowType() = CPP::getNodeType(p0.asCppNode())
}
predicate jumpStep(Node p0, Node p1) {
  PYTHON::jumpStep(p0.asPythonNode(), p1.asPythonNode())
  or
  CPP::jumpStep(p0.asCppNode(), p1.asCppNode())
}
predicate clearsContent(Node p0, Content p1) {
  PYTHON::clearsContent(p0.asPythonNode(), p1.asPythonContent())
  or
  CPP::clearsContent(p0.asCppNode(), p1.asCppContent())
}
predicate isUnreachableInCall(Node p0, DataFlowCall p1) {
  PYTHON::isUnreachableInCall(p0.asPythonNode(), p1.asPythonDataFlowCall())
  or
  CPP::isUnreachableInCall(p0.asCppNode(), p1.asCppDataFlowCall())
}
predicate nodeIsHidden(Node p0) {
  PYTHON::nodeIsHidden(p0.asPythonNode())
  or
  CPP::nodeIsHidden(p0.asCppNode())
}
predicate isParameterNode(Node p0, DataFlowCallable p1, ParameterPosition p2) {
  PYTHON::isParameterNode(p0.asPythonNode(), p1.asPythonDataFlowCallable(), p2.asPythonParameterPosition())
  or
  if p1.isNativeFunction()
  then CPP::isParameterNode(p0.asCppNode(), p1.asCppDataFlowCallable(), p2.asCppParameterPosition() + 1)
  else CPP::isParameterNode(p0.asCppNode(), p1.asCppDataFlowCallable(), p2.asCppParameterPosition())
}
predicate isArgumentNode(Node p0, DataFlowCall p1, ArgumentPosition p2) {
  PYTHON::isArgumentNode(p0.asPythonNode(), p1.asPythonDataFlowCall(), p2.asPythonArgumentPosition())
  or
  CPP::isArgumentNode(p0.asCppNode(), p1.asCppDataFlowCall(), p2.asCppArgumentPosition())
}
predicate lambdaCreation(Node p0, LambdaCallKind p1, DataFlowCallable p2) {
  PYTHON::lambdaCreation(p0.asPythonNode(), p1.asPythonLambdaCallKind(), p2.asPythonDataFlowCallable())
  or
  CPP::lambdaCreation(p0.asCppNode(), p1.asCppLambdaCallKind(), p2.asCppDataFlowCallable())
}
predicate storeStep(Node p0, Content p1, Node p2) {
  PYTHON::storeStep(p0.asPythonNode(), p1.asPythonContent(), p2.asPythonNode())
  or
  CPP::storeStep(p0.asCppNode(), p1.asCppContent(), p2.asCppNode())
}
predicate readStep(Node p0, Content p1, Node p2) {
  PYTHON::readStep(p0.asPythonNode(), p1.asPythonContent(), p2.asPythonNode())
  or
  CPP::readStep(p0.asCppNode(), p1.asCppContent(), p2.asCppNode())
}
predicate allowParameterReturnInSelf(ParamNode p0) {
  PYTHON::allowParameterReturnInSelf(p0.asPythonNode().(PYTHON::ParamNode))
  or
  CPP::allowParameterReturnInSelf(p0.asCppNode().(CPP::ParamNode))
}
predicate forceHighPrecision(Content p0) {
  PYTHON::forceHighPrecision(p0.asPythonContent())
  or
  CPP::forceHighPrecision(p0.asCppContent())
}


