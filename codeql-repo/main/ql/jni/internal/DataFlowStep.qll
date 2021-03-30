import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

// jni get-methods
predicate jniGetObjectClassStep(JavaClassNode classNode, JniCallNode callNode) {
  callNode.getTarget().toString() = "GetObjectClass" and
  exists(ArgumentNode argNode |
    argNode.argumentOf(callNode.getCall(), 0) |
    classNode.getClass() = JniParameterFlow::getJavaNewExpr(argNode).asExpr().getType()
  )
}
predicate jniGetMethodIDStep(JavaMethodNode methodNode, JniCallNode callNode) {
  callNode.getTarget().toString() = "GetMethodID" and
  exists(ArgumentNode argNode |
    argNode.argumentOf(callNode.getCall(), 1) |
    methodNode.getMethod().toString() = StringLiteralFlow::getStringLiteral(argNode)
  )
}
predicate jniGetFieldIDStep(JavaFieldNode fieldNode, JniCallNode callNode) {
  callNode.getTarget().toString() = "GetFieldID" and
  exists(ArgumentNode argNode |
    argNode.argumentOf(callNode.getCall(), 1) |
    fieldNode.getField().toString() = StringLiteralFlow::getStringLiteral(argNode)
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
  or
  exists(JniCallNode callNode, ArgumentNode objNode, ArgumentNode fidNode, ArgumentNode valNode |
    callNode.getTarget().toString().matches("Set%Field") and
    objNode.argumentOf(callNode.getCall(), 0) and
    fidNode.argumentOf(callNode.getCall(), 1) and
    valNode.argumentOf(callNode.getCall(), 2)
    |
    node1 = valNode and
    f.asJavaContent().(JAVA::FieldContent).getField() = CustomNodeFlow::getJavaFieldNode(fidNode).getField() and
    node2.getPreUpdateNode() = objNode
  )
}

predicate readStep(Node node1, Content f, Node node2) {
  JAVA::readStep(node1.asJavaNode(), f.asJavaContent(), node2.asJavaNode())
  or
  CPP::readStep(node1.asCppNode(), f.asCppContent(), node2.asCppNode())
  or
  exists(JniCallNode callNode, ArgumentNode objNode, ArgumentNode fidNode |
    callNode.getTarget().toString().matches("Get%Field") and
    objNode.argumentOf(callNode.getCall(), 0) and
    fidNode.argumentOf(callNode.getCall(), 1)
    |
    node1 = objNode and
    f.asJavaContent().(JAVA::FieldContent).getField() = CustomNodeFlow::getJavaFieldNode(fidNode).getField() and
    node2 = callNode
  )
}
