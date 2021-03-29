import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

private module StringLiteralFlow {
  /**
   * A configuration for finding StringLiteralFlow
   */
  private class StringLiteralConfiguration extends CPP::Impl2::Configuration {
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

predicate jniGetObjectClassStep(JavaClassNode classNode, JniCallNode callNode) {
  /*
  exists(ClassInstacneExpr newExpr | newExpr = callNode.asCppNode().asExpr().

  callNode.getTarget().toString = "GetObjectClass"
  and
  */
  none()
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
