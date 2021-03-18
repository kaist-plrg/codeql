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
    result.asJavaNode().(JAVA::ExprNode) = JAVA::exprNode(e.asJavaDataFlowExpr())
    or
    result.asCppNode().(CPP::ExprNode) = CPP::exprNode(e.asCppDataFlowExpr())
  }
  predicate simpleLocalFlowStep(Node node1, Node node2) {
    JAVA::simpleLocalFlowStep(node1.asJavaNode(), node2.asJavaNode())
    or
    CPP::simpleLocalFlowStep(node1.asCppNode(), node2.asCppNode())
  }
  predicate localFlowStep(Node node1, Node node2) {
    JAVA::localFlowStep(node1.asJavaNode(), node2.asJavaNode())
    or
    CPP::localFlowStep(node1.asCppNode(), node2.asCppNode())
  }
  predicate localFlow(Node node1, Node node2) {
    JAVA::localFlow(node1.asJavaNode(), node2.asJavaNode())
    or
    CPP::localFlow(node1.asCppNode(), node2.asCppNode())
  }

  /* DataFlowPrivate.qll */
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
  DataFlowType getNodeType(Node n) {
    result.asJavaDataFlowType() = JAVA::getNodeType(n.asJavaNode())
    or
    result.asCppDataFlowType() = CPP::getNodeType(n.asCppNode())
  }
  predicate compatibleTypes(DataFlowType t1, DataFlowType t2) {
    JAVA::compatibleTypes(t1.asJavaDataFlowType(), t2.asJavaDataFlowType())
    or
    CPP::compatibleTypes(t1.asCppDataFlowType(), t2.asCppDataFlowType())
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
  predicate nodeIsHidden(Node n) {
    JAVA::nodeIsHidden(n.asJavaNode())
    or
    CPP::nodeIsHidden(n.asCppNode())
  }
  predicate jumpStep(Node n1, Node n2) {
    JAVA::jumpStep(n1.asJavaNode(), n2.asJavaNode())
    or
    CPP::jumpStep(n1.asCppNode(), n2.asCppNode())
  }
  predicate storeStep(Node node1, Content f, PostUpdateNode node2) {
    JAVA::storeStep(node1.asJavaNode(), f.asJavaContent(), node2.asJavaNode().(JAVA::PostUpdateNode))
    or
    CPP::storeStep(node1.asCppNode(), f.asCppContent(), node2.asCppNode().(CPP::PostUpdateNode))
  }
  predicate readStep(Node node1, Content f, Node node2) {
    JAVA::readStep(node1.asJavaNode(), f.asJavaContent(), node2.asJavaNode())
    or
    CPP::readStep(node1.asCppNode(), f.asCppContent(), node2.asCppNode())
  }
  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
    result.asJavaNode().(JAVA::OutNode) = JAVA::getAnOutNode(call.asJavaDataFlowCall(), kind.asJavaReturnKind())
    or
    result.asCppNode().(CPP::OutNode) = CPP::getAnOutNode(call.asCppDataFlowCall(), kind.asCppReturnKind())
  }

  /* DataFlowDispatch.qll */
  DataFlowCallable viableCallable(DataFlowCall c) {
    result.asJavaDataFlowCallable() = JAVA::viableCallable(c.asJavaDataFlowCall())
    or
    result.asCppDataFlowCallable() = CPP::viableCallable(c.asCppDataFlowCall())
  }
  DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
    result.asJavaDataFlowCallable() = JAVA::viableImplInCallContext(call.asJavaDataFlowCall(), ctx.asJavaDataFlowCall())
    or
    result.asCppDataFlowCallable() = CPP::viableImplInCallContext(call.asCppDataFlowCall(), ctx.asCppDataFlowCall())
  }
  predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable callable) {
    JAVA::mayBenefitFromCallContext(call.asJavaDataFlowCall(), callable.asJavaDataFlowCallable())
    or
    CPP::mayBenefitFromCallContext(call.asCppDataFlowCall(), callable.asCppDataFlowCallable())
  }
}
