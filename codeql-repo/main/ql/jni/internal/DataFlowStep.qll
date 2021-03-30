import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

// jni get-methods
predicate jniGetObjectClassStep(JavaClassNode classNode, JniCallNode callNode) {
  /*
  callNode.getTarget().toString() = "GetObjectClass"
  and
  exists(ExprNode nameNode, ArgumentNode argNode |
    methodNode.getMethod().toString() = nameNode.toString() and
    StringLiteralFlow::stringLiteralFlow(nameNode, argNode) and
    argNode.argumentOf(callNode.asExpr(), 1)
  )
  */
  none()
}
predicate jniGetMethodIDStep(JavaMethodNode methodNode, JniCallNode callNode) {
  callNode.getTarget().toString() = "GetMethodID" and
  exists(ArgumentNode argNode |
    methodNode.getMethod().toString() = StringLiteralFlow::getStringLiteral(argNode) and
    argNode.argumentOf(callNode.asExpr(), 1)
  )
}
predicate jniGetFieldIDStep(JavaFieldNode fieldNode, JniCallNode callNode) {
  callNode.getTarget().toString() = "GetFieldID" and
  exists(ArgumentNode argNode |
    fieldNode.getField().toString() = StringLiteralFlow::getStringLiteral(argNode) and
    argNode.argumentOf(callNode.asExpr(), 1)
  )
}

predicate jumpStep(Node n1, Node n2) { //modified
  JAVA::jumpStep(n1.asJavaNode(), n2.asJavaNode())
  or
  CPP::jumpStep(n1.asCppNode(), n2.asCppNode())
  or
  jniGetObjectClassStep(n1.(JavaClassNode), n2.(JniCallNode))
  or
  jniGetMethodIDStep(n1.(JavaMethodNode), n2.(JniCallNode))
  or
  jniGetFieldIDStep(n1.(JavaFieldNode), n2.(JniCallNode))
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
