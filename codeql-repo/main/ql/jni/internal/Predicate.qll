module CPP {
  import cpp.semmle.code.cpp.dataflow.internal.DataFlowUtil
  import cpp.semmle.code.cpp.dataflow.internal.DataFlowPrivate
  import cpp.semmle.code.cpp.dataflow.internal.DataFlowDispatch
}

module JAVA {
  import java.semmle.code.java.dataflow.internal.DataFlowUtil
  import java.semmle.code.java.dataflow.internal.DataFlowPrivate
  import java.semmle.code.java.dataflow.internal.DataFlowDispatch
}

module JNI {
  import Class::JNI

  /* DataFlowUtil.qll */
  ExprNode exprNode(DataFlowExpr e) {
    result = JAVA::exprNode(e)
  }
  predicate simpleLocalFlowStep(Node node1, Node node2) {
    JAVA::simpleLocalFlowStep(node1, node2)
  }

  /* DataFlowPrivate.qll */
  predicate clearsContent(Node n, Content c) {
    JAVA::clearsContent(n, c)
  }
  predicate isUnreachableInCall(Node n, DataFlowCall call) {
    JAVA::isUnreachableInCall(n, call)
  }
  DataFlowType getNodeType(Node n) {
    result = JAVA::getNodeType(n)
  }
  predicate compatibleTypes(DataFlowType t1, DataFlowType t2) {
    JAVA::compatibleTypes(t1, t2)
  }
  string ppReprType(DataFlowType t) {
    result = JAVA::ppReprType(t)
  }
  int accessPathLimit() {
    result = JAVA::accessPathLimit()
  }
  predicate nodeIsHidden(Node n) {
    JAVA::nodeIsHidden(n)
  }
  predicate jumpStep(Node n1, Node n2) {
    JAVA::jumpStep(n1, n2)
  }
  predicate storeStep(Node node1, Content f, PostUpdateNode node2) {
    JAVA::storeStep(node1, f, node2)
  }
  predicate readStep(Node node1, Content f, Node node2) {
    JAVA::readStep(node1, f, node2)
  }
  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
    result = JAVA::getAnOutNode(call, kind)
  }

  /* DataFlowDispatch.qll */
  DataFlowCallable viableCallable(DataFlowCall c) {
    result = JAVA::viableCallable(c)
  }
  DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
    result = JAVA::viableImplInCallContext(call, ctx)
  }
  predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable callable) {
    JAVA::mayBenefitFromCallContext(call, callable)
  }
}
