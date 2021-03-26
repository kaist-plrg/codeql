private module CPP {
  import cpp.cpp
  module IMPL1 {
    import cpp.semmle.code.cpp.dataflow.internal.DataFlowImpl
  }
  module IMPL2 {
    import cpp.semmle.code.cpp.dataflow.internal.DataFlowImpl2
  }
  import cpp.semmle.code.cpp.dataflow.internal.DataFlowUtil
  import cpp.semmle.code.cpp.dataflow.internal.DataFlowPrivate
  import cpp.semmle.code.cpp.dataflow.internal.DataFlowDispatch
}

private module JAVA {
  import java.java
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
  predicate localFlow(Node node1, Node node2) = fastTC(localFlowStep/2)(node1, node2)

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
  DataFlowType getNodeType(Node n) { //modified
    result.asJavaDataFlowType() = JAVA::getNodeType(n.asJavaNode())
    or
    result.asCppDataFlowType() = CPP::getNodeType(n.asCppNode())
    or
    result = n.(JavaMethodNode).getType()
  }
  predicate compatibleTypes(DataFlowType t1, DataFlowType t2) {
    JAVA::compatibleTypes(t1.asJavaDataFlowType(), t2.asJavaDataFlowType())
    or
    CPP::compatibleTypes(t1.asCppDataFlowType(), t2.asCppDataFlowType())
    or
    exists(JAVA::Type jt, CPP::Type ct |
      (
        (jt = t1.asJavaDataFlowType() and ct = t2.asCppDataFlowType())
        or
        (jt = t2.asJavaDataFlowType() and ct = t1.asCppDataFlowType())
      )
    )
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
  predicate jniGetObjectClassStep(JavaClassNode classNode, JniCallNode callNode) {
    /*
    exists(ClassInstacneExpr newExpr | newExpr = callNode.asCppNode().asExpr().

    callNode.getTarget().toString = "GetObjectClass"
    and
    */
    none()
  }
  private module StringLiteralFlow {
    /**
     * A configuration for finding StringLiteralFlow
     */
    private class StringLiteralConfiguration extends CPP::IMPL2::Configuration {
      StringLiteralConfiguration() { this = "StringLiteralConfiguration" }

      override predicate isSource(CPP::Node source) {
        source.asExpr() instanceof CPP::StringLiteral
      }

      override predicate isSink(CPP::Node sink) { any() }
    }

    //TODO: StringLiteral from java?

    predicate stringLiteralFlow(Node node1, Node node2) {
      exists (StringLiteralConfiguration config |
        config.hasFlow(node1.asCppNode(), node2.asCppNode())
      )
    }
  }
  predicate jniGetMethodIDStep(JavaMethodNode methodNode, JniCallNode callNode) {
    callNode.getTarget().toString() = "GetMethodID"
    and
    exists(ExprNode nameNode, ArgumentNode argNode |
      methodNode.getMethod().toString() = nameNode.toString() and
      StringLiteralFlow::stringLiteralFlow(nameNode, argNode) and
      argNode.argumentOf(callNode.asExpr(), 1)
    )
  }
  predicate jumpStep(Node n1, Node n2) { //modified
    JAVA::jumpStep(n1.asJavaNode(), n2.asJavaNode())
    or
    CPP::jumpStep(n1.asCppNode(), n2.asCppNode())
    or
    jniGetMethodIDStep(n1.(JavaMethodNode), n2.(JniCallNode))
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
  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { //modified
    result.asJavaNode().(JAVA::OutNode) = JAVA::getAnOutNode(call.asJavaDataFlowCall(), kind.asJavaReturnKind())
    or
    result.asCppNode().(CPP::OutNode) = CPP::getAnOutNode(call.asCppDataFlowCall(), kind.asCppReturnKind())
    or
    result = call.getNode() and kind.isNormalReturnKind()
  }

  
  /* DataFlowDispatch.qll */
  private module JavaMethodFlow {
    /**
     * A configuration for finding java method -> mid flow
     */
    private class JavaMethodConfiguration extends CPP::IMPL1::Configuration {
      JavaMethodConfiguration() { this = "JavaMethodConfiguration" }

      override predicate isSource(CPP::Node source) {
        exists(JavaMethodNode method, JniCallNode call |
          call.asCppNode() = source and jniGetMethodIDStep(method, call)
        )
      }

      override predicate isSink(CPP::Node sink) { any() }
    }

    predicate javaMethodFlow(Node node1, Node node2) {
      exists(JavaMethodConfiguration config, Node mid |
        jniGetMethodIDStep(node1, mid) and
        config.hasFlow(mid.asCppNode(), node2.asCppNode())
      )
    }
  }

  DataFlowCallable viableCallable(DataFlowCall c) { //modified
    result.asJavaDataFlowCallable() = JAVA::viableCallable(c.asJavaDataFlowCall())
    or
    result.asCppDataFlowCallable() = CPP::viableCallable(c.asCppDataFlowCall())
    or
    exists(JAVA::Method m, CPP::Function f |
      m = c.asJavaDataFlowCall().(JAVA::MethodAccess).getMethod() and
      f = result.asCppDataFlowCallable() |
      m.isNative() and
      f.toString().matches("Java_%_" + m.toString() + "%")
    )
    or
    exists(JniCallNode callNode, JavaMethodNode methodNode, ArgumentNode midNode |
      callNode.getCall() = c and
      callNode.getTarget().toString().matches("Call%Method") and
      JavaMethodFlow::javaMethodFlow(methodNode, midNode) and
      result.asJavaDataFlowCallable() = methodNode.getMethod() and
      midNode.argumentOf(c, -2)
    )
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
