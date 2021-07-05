import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original
private import Signature

// jni functions
predicate jniFindClassStep(JavaClassNode classNode, JniCallNode callNode) {
  callNode.getName() = "FindClass" and
  exists(ArgumentNode name |
    name = callNode.getArgument(0) |
    classNode.getClass().getQualifiedName().replaceAll(".", "/") = StringLiteralFlow::getStringLiteral(name).replaceAll("$", "/")
  )
}
predicate jniGetObjectClassStep(JavaClassNode classNode, JniCallNode callNode) {
  callNode.getName() = "GetObjectClass" and
  exists(ArgumentNode obj |
    obj = callNode.getArgument(0) |
    classNode.getClass() = getJavaClass(obj)
  )
}
private int dist(JAVA::Class c1, JAVA::Class c2) {
  if c1 = c2
  then result = 0
  else exists(JAVA::Class c3 |
    c1.extendsOrImplements(c3) and
    result = 1 + dist(c3, c2)
  )
}
predicate jniGetMethodIDStep(JavaMethodNode methodNode, JniCallNode callNode) {
  callNode.getName() = "GetMethodID" and
  exists(ArgumentNode cls, ArgumentNode name, ArgumentNode sig|
    cls = callNode.getArgument(0) and
    name = callNode.getArgument(1) and
    sig = callNode.getArgument(2) |
    methodNode = min(JavaMethodNode m, int d | 
      not m.isStatic() and
      (
        m.getMethod().toString() = StringLiteralFlow::getStringLiteral(name)
        or
        StringLiteralFlow::getStringLiteral(name) = "<init>" and
        m.isConstructor()
      ) and
      StringLiteralFlow::getStringLiteral(sig).replaceAll("$", "/").matches(
        "(" + handleMethodSignature(m.getMethod().getSignature()) + ")%"
      ) and
      if not exists(CustomNodeFlow::getJavaClassNode(cls).getClass())
      then d = -1
      else d = dist(CustomNodeFlow::getJavaClassNode(cls).getClass(), m.getClass())
      |
      m order by d
    )
  )
}
predicate jniGetStaticMethodIDStep(JavaMethodNode methodNode, JniCallNode callNode) {
  callNode.getName() = "GetStaticMethodID" and
  exists(ArgumentNode cls, ArgumentNode name, ArgumentNode sig |
    cls = callNode.getArgument(0) and
    name = callNode.getArgument(1) and
    sig = callNode.getArgument(2) |
    methodNode.isStatic() and
    methodNode.getMethod().toString() = StringLiteralFlow::getStringLiteral(name) and
    StringLiteralFlow::getStringLiteral(sig).replaceAll("$", "/").matches(
      "(" + handleMethodSignature(methodNode.getMethod().getSignature()) + ")%"
    ) and
    (
      not exists(CustomNodeFlow::getJavaClassNode(cls).getClass())
      or
      CustomNodeFlow::getJavaClassNode(cls).getClass() = methodNode.getClass()
    )
  )
}
predicate jniGetFieldIDStep(JavaFieldNode fieldNode, JniCallNode callNode) {
  callNode.getName() = "GetFieldID" and
  exists(ArgumentNode cls, ArgumentNode name |
    cls = callNode.getArgument(0) and
    name = callNode.getArgument(1) |
    fieldNode.getClass() = CustomNodeFlow::getJavaClassNode(cls).getClass() and
    fieldNode.getField().toString() = StringLiteralFlow::getStringLiteral(name)
  )
}
predicate jniGetStaticFieldIDStep(JavaFieldNode fieldNode, JniCallNode callNode) {
  callNode.getName() = "GetStaticFieldID" and
  exists(ArgumentNode cls, ArgumentNode name |
    cls = callNode.getArgument(0) and
    name = callNode.getArgument(1) |
    fieldNode.getClass() = CustomNodeFlow::getJavaClassNode(cls).getClass() and
    fieldNode.getStaticField().toString() = StringLiteralFlow::getStringLiteral(name)
  )
}
predicate jniStringStep(ArgumentNode argNode, JniCallNode callNode) {
  (
    callNode.getName() = "GetStringUTFChars"
    or
    callNode.getName() = "NewStringUTF"
  ) and
  argNode = callNode.getArgument(0)
}
predicate jniNewGlobalRefStep(ArgumentNode argNode, JniCallNode callNode) {
  callNode.getName() = "NewGlobalRef" and
  argNode = callNode.getArgument(0)
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
    callNode.getName().matches("GetStatic%Field") and
    clsNode = callNode.getArgument(0) and
    fidNode = callNode.getArgument(1)
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
    callNode.getName().matches("Set%Field") and
    objNode = callNode.getArgument(0) and
    fidNode = callNode.getArgument(1) and
    valNode = callNode.getArgument(2)
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
    callNode.getName().matches("Get%Field") and
    objNode = callNode.getArgument(0) and
    fidNode = callNode.getArgument(1)
    |
    node1 = objNode and
    f.asJavaContent().(JAVA::FieldContent).getField() = CustomNodeFlow::getJavaFieldNode(fidNode).getField() and
    node2 = callNode
  )
}
