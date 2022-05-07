import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original
private import Signature

// jni functions
predicate jniFindClassStep(JavaClassNode classNode, JniCallNode callNode) {
  callNode.getName() = "FindClass" and
  exists(ArgNode name |
    name = callNode.getArgument(0) |
    classNode.getClass().getQualifiedName().replaceAll(".", "/").replaceAll("$","/")  = StringLiteralFlow::getStringLiteral(name).replaceAll("$", "/")
  )
}
predicate jniGetObjectClassStep(JavaClassNode classNode, JniCallNode callNode) {
  callNode.getName() = "GetObjectClass" and
  exists(ArgNode obj |
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
  exists(ArgNode cls, ArgNode name, ArgNode sig|
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
        "(" + getHandledSignature(m.getMethod()) + ")%"
      ) and
      if not exists(getJavaClassNode(cls).getClass())
      then d = -1
      else d = dist(getJavaClassNode(cls).getClass(), m.getClass())
      |
      m order by d
    )
  )
}
predicate jniGetWrongMethodIDStep(JavaMethodNode methodNode, JniCallNode callNode) {
  callNode.getName() = "GetMethodID" and
  exists(ArgNode cls, ArgNode name, ArgNode sig|
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
      exists(StringLiteralFlow::getStringLiteral(sig)) and
      if not exists(getJavaClassNode(cls).getClass())
      then d = -1
      else d = dist(getJavaClassNode(cls).getClass(), m.getClass())
      |
      m order by d
    )
  )
}
predicate jniGetStaticMethodIDStep(JavaMethodNode methodNode, JniCallNode callNode) {
  callNode.getName() = "GetStaticMethodID" and
  exists(ArgNode cls, ArgNode name, ArgNode sig |
    cls = callNode.getArgument(0) and
    name = callNode.getArgument(1) and
    sig = callNode.getArgument(2) |
    methodNode.isStatic() and
    methodNode.getMethod().toString() = StringLiteralFlow::getStringLiteral(name) and
    StringLiteralFlow::getStringLiteral(sig).replaceAll("$", "/").matches(
      "(" + getHandledSignature(methodNode.getMethod()) + ")%"
    ) and
    (
      not exists(getJavaClassNode(cls).getClass())
      or
      getJavaClassNode(cls).getClass() = methodNode.getClass()
    )
  )
}
predicate jniGetWrongStaticMethodIDStep(JavaMethodNode methodNode, JniCallNode callNode) {
  callNode.getName() = "GetStaticMethodID" and
  exists(Node cls, ArgNode name, ArgNode sig |
    cls = callNode.getArgument(0) and
    name = callNode.getArgument(1) and
    sig = callNode.getArgument(2) |
    methodNode.isStatic() and
    methodNode.getMethod().toString() = StringLiteralFlow::getStringLiteral(name) and
    exists(StringLiteralFlow::getStringLiteral(sig)) and
    (
      not exists(getJavaClassNode(cls).getClass())
      or
      getJavaClassNode(cls).getClass() = methodNode.getClass()
    )
  )
}
predicate jniGetFieldIDStep(JavaFieldNode fieldNode, JniCallNode callNode) {
  callNode.getName() = "GetFieldID" and
  exists(ArgNode cls, ArgNode name, ArgNode sig |
    cls = callNode.getArgument(0) and
    name = callNode.getArgument(1) and
    sig = callNode.getArgument(2) |
    (
      not exists(getJavaClassNode(cls).getClass())
      or
      exists(dist(getJavaClassNode(cls).getClass(), fieldNode.getClass()))
    )
    and fieldNode.getField().toString() = StringLiteralFlow::getStringLiteral(name)
    and (
      not exists(fieldNode.getField().getType())
      or
      fieldNode.getField().getType().getTypeDescriptor()
        = StringLiteralFlow::getStringLiteral(sig)
    )
  )
}
predicate jniGetStaticFieldIDStep(JavaFieldNode fieldNode, JniCallNode callNode) {
  callNode.getName() = "GetStaticFieldID" and
  exists(ArgNode cls, ArgNode name, ArgNode sig |
    cls = callNode.getArgument(0) and
    name = callNode.getArgument(1) and
    sig = callNode.getArgument(2) |
    (
      not exists(getJavaClassNode(cls).getClass())
      or
      exists(dist(getJavaClassNode(cls).getClass(), fieldNode.getClass()))
    )
    and fieldNode.getStaticField().toString() = StringLiteralFlow::getStringLiteral(name)
    and (
      not exists(fieldNode.getField().getType())
      or
      fieldNode.getField().getType().getTypeDescriptor()
        = StringLiteralFlow::getStringLiteral(sig)
    )
  )
}
predicate jniStringStep(ArgNode argNode, JniCallNode callNode) {
  (
    callNode.getName() = "GetStringUTFChars"
    or
    callNode.getName() = "NewStringUTF"
  ) and
  argNode = callNode.getArgument(0)
}
predicate jniNewGlobalRefStep(ArgNode argNode, JniCallNode callNode) {
  callNode.getName() = "NewGlobalRef" and
  argNode = callNode.getArgument(0)
}

predicate customJumpStep(Node n1, Node n2) {
  jniGetObjectClassStep(n1.(JavaClassNode), n2.(JniCallNode))
  or
  jniGetMethodIDStep(n1.(JavaMethodNode), n2.(JniCallNode))
  or
  jniGetFieldIDStep(n1.(JavaFieldNode), n2.(JniCallNode))
  or
  jniGetStaticFieldIDStep(n1.(JavaFieldNode), n2.(JniCallNode))
  or
  //static field read
  exists(JniCallNode callNode, ArgNode clsNode, ArgNode fidNode, JAVA::Field f |
    callNode.getName().matches("GetStatic%Field") and
    clsNode = callNode.getArgument(0) and
    fidNode = callNode.getArgument(1)
    |
    f = getJavaStaticFieldNode(fidNode).getStaticField() and
    f.getDeclaringType() = getJavaClassNode(clsNode).getClass() and
    n1.asJavaNode().asExpr() = f.getAnAssignedValue() and
    n2 = callNode
  )
}

predicate customStoreStep(Node node1, Content f, PostUpdateNode node2) {
  //jni field set
  exists(JniCallNode callNode, Node objNode, Node fidNode, Node valNode |
    callNode.getName().matches("Set%Field") and
    objNode = callNode.getArgument(0) and
    fidNode = callNode.getArgument(1) and
    valNode = callNode.getArgument(2)
    |
    node1 = valNode and
    f.asJavaContent().(JAVA::FieldContent).getField() = getJavaFieldNode(fidNode).getField() and
    node2.getPreUpdateNode() = objNode
  )
  //TODO: SetStaticField?
}

predicate customReadStep(Node node1, Content f, Node node2) {
  //jni field get
  exists(JniCallNode callNode, ArgNode objNode, ArgNode fidNode |
    callNode.getName().matches("Get%Field") and
    objNode = callNode.getArgument(0) and
    fidNode = callNode.getArgument(1)
    |
    node1 = objNode and
    f.asJavaContent().(JAVA::FieldContent).getField() = getJavaFieldNode(fidNode).getField() and
    node2 = callNode
  )
}

predicate customSimpleLocalFlowStep(Node node1, Node node2) {
  jniStringStep(node1, node2)
  or
  jniNewGlobalRefStep(node1, node2)
}
