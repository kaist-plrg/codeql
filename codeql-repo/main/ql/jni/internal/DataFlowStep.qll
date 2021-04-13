import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original
private import Signature

// jni functions
predicate jniFindClassStep(JavaClassNode classNode, JniCallNode callNode) {
  callNode.getTarget().toString() = "FindClass" and
  exists(ArgumentNode name |
    name.argumentOf(callNode.getCall(), 0) |
    classNode.getClass().getQualifiedName().replaceAll(".", "/") = StringLiteralFlow::getStringLiteral(name) 
  )
}
predicate jniGetObjectClassStep(JavaClassNode classNode, JniCallNode callNode) {
  callNode.getTarget().toString() = "GetObjectClass" and
  exists(ArgumentNode obj |
    obj.argumentOf(callNode.getCall(), 0) |
    classNode.getClass() = JniParameterFlow::getJavaNewExpr(obj).asExpr().getType()
  )
}
//TODO: Static method?
predicate jniGetMethodIDStep(JavaMethodNode methodNode, JniCallNode callNode) {
  callNode.getTarget().toString() = "GetMethodID" and
  exists(ArgumentNode cls, ArgumentNode name, ArgumentNode sig|
    cls.argumentOf(callNode.getCall(), 0) and
    name.argumentOf(callNode.getCall(), 1) and
    sig.argumentOf(callNode.getCall(), 2) |
    methodNode.getClass() = CustomNodeFlow::getJavaClassNode(cls).getClass() and
    methodNode.getMethod().toString() = StringLiteralFlow::getStringLiteral(name) and
    StringLiteralFlow::getStringLiteral(sig).matches(
      "(" + handleMethodSignature(methodNode.getMethod().getSignature()) + ")%"
    )
  )
}
predicate jniGetFieldIDStep(JavaFieldNode fieldNode, JniCallNode callNode) {
  callNode.getTarget().toString() = "GetFieldID" and
  exists(ArgumentNode cls, ArgumentNode name |
    cls.argumentOf(callNode.getCall(), 0) and
    name.argumentOf(callNode.getCall(), 1) |
    fieldNode.getClass() = CustomNodeFlow::getJavaClassNode(cls).getClass() and
    fieldNode.getField().toString() = StringLiteralFlow::getStringLiteral(name)
  )
}
predicate jniGetStaticFieldIDStep(JavaFieldNode fieldNode, JniCallNode callNode) {
  callNode.getTarget().toString() = "GetStaticFieldID" and
  exists(ArgumentNode cls, ArgumentNode name |
    cls.argumentOf(callNode.getCall(), 0) and
    name.argumentOf(callNode.getCall(), 1) |
    fieldNode.getClass() = CustomNodeFlow::getJavaClassNode(cls).getClass() and
    fieldNode.getStaticField().toString() = StringLiteralFlow::getStringLiteral(name)
  )
}
predicate jniStringStep(ArgumentNode argNode, JniCallNode callNode) {
  (
    callNode.getTarget().toString() = "GetStringUTFChars"
    or
    callNode.getTarget().toString() = "NewStringUTF"
  ) and
  argNode.argumentOf(callNode.getCall(), 0)
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
  or
  jniGetStaticFieldIDStep(n1.(JavaFieldNode), n2.(JniCallNode))
  or
  //static field read
  exists(JniCallNode callNode, ArgumentNode clsNode, ArgumentNode fidNode, JAVA::Field f |
    callNode.getTarget().toString().matches("GetStatic%Field") and
    clsNode.argumentOf(callNode.getCall(), 0) and
    fidNode.argumentOf(callNode.getCall(), 1)
    |
    f = CustomNodeFlow::getJavaStaticFieldNode(fidNode).getStaticField() and
    f.getDeclaringType() = CustomNodeFlow::getJavaClassNode(clsNode).getClass() and
    n1.asJavaNode().asExpr() = f.getAnAssignedValue() and
    n2 = callNode
  )
}

predicate storeStep(Node node1, Content f, PostUpdateNode node2) {
  JAVA::storeStep(node1.asJavaNode(), f.asJavaContent(), node2.asJavaNode().(JAVA::PostUpdateNode))
  or
  CPP::storeStep(node1.asCppNode(), f.asCppContent(), node2.asCppNode().(CPP::PostUpdateNode))
  or
  //jni field set
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
  //TODO: SetStaticField?
}

predicate readStep(Node node1, Content f, Node node2) {
  JAVA::readStep(node1.asJavaNode(), f.asJavaContent(), node2.asJavaNode())
  or
  CPP::readStep(node1.asCppNode(), f.asCppContent(), node2.asCppNode())
  or
  //jni field get
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
