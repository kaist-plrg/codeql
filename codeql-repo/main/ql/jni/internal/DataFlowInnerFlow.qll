import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

/**
 * A configuration for finding flow regarding interaction b/w java and cpp
 */
class JniConfiguration extends CPP::Impl1::Configuration {
  JniConfiguration() { this = "JniConfiguration" }

  override predicate isSource(CPP::Node source) {
    // Jni Function Call
    exists(JniCallNode call | call.asCppNode() = source)
    or
    // Param from Java
    exists(CPP::Function f |
      f.toString().matches("Java_%") |
      source.(CPP::ParameterNode).isParameterOf(f, _)
    )
  }

  override predicate isSink(CPP::Node sink) {
    sink instanceof CPP::ArgumentNode
  }

  override predicate isAdditionalFlowStep(CPP::Node fromNode, CPP::Node toNode) {
    //global
    exists(CPP::GlobalVariable g, CPP::VariableAccess lv |
      lv = fromNode.(CPP::PostUpdateNode).getPreUpdateNode().asExpr()
      and lv.isUsedAsLValue()
      and lv.getTarget() = g
      and toNode.asExpr().(CPP::VariableAccess).getTarget() = g
    )
    or
    //global field
    exists(CPP::GlobalVariable g, CPP::Field f, CPP::ValueFieldAccess fr, CPP::ValueFieldAccess to |
      fr = fromNode.(CPP::PostUpdateNode).getPreUpdateNode().asExpr()
      and to = toNode.asExpr()
      and fr.isUsedAsLValue()
      and f = fr.getTarget()
      and f = to.getTarget()
      and g = fr.getQualifier().(CPP::VariableAccess).getTarget()
      and g = to.getQualifier().(CPP::VariableAccess).getTarget()
    )
    or
    //jni functions
    exists(Node n1, Node n2 |
      n1.asCppNode() = fromNode and
      n2.asCppNode() = toNode |
      jniStringStep(n1, n2)
      or
      jniNewGlobalRefStep(n1, n2)
    )
    or
    // ref / deref
    fromNode.asExpr() = toNode.asExpr().(CPP::PointerDereferenceExpr).getOperand()
    or
    fromNode.asExpr() = toNode.asExpr().(CPP::AddressOfExpr).getOperand()
  }
}

JavaClassNode getJavaClassNode(ArgumentNode arg) {
  exists(JniConfiguration config, Node mid |
    (
      jniGetObjectClassStep(result, mid)
      or
      jniFindClassStep(result, mid)
      or
      exists(
        DataFlowCall call,
        DataFlowCallable callable
        |
        result.(ArgumentNode).argumentOf(call, -1) and
        callable.asCppDataFlowCallable() = viableCallableJ2C(call.asJavaDataFlowCall()) and
        mid.(ParameterNode).isParameterOf(callable, -1)
      )
    )
    and
    config.hasFlow(mid.asCppNode(), arg.asCppNode())
  )
}
JavaMethodNode getJavaMethodNode(ArgumentNode arg) {
  exists(JniConfiguration config, Node mid |
    (
      jniGetMethodIDStep(result, mid)
      or
      jniGetStaticMethodIDStep(result, mid)
    ) and
    config.hasFlow(mid.asCppNode(), arg.asCppNode())
  )
}
JavaFieldNode getJavaFieldNode(ArgumentNode arg) {
  exists(JniConfiguration config, Node mid |
    jniGetFieldIDStep(result, mid) and
    config.hasFlow(mid.asCppNode(), arg.asCppNode())
  )
}
JavaFieldNode getJavaStaticFieldNode(ArgumentNode arg) {
  exists(JniConfiguration config, Node mid |
    jniGetStaticFieldIDStep(result, mid) and
    config.hasFlow(mid.asCppNode(), arg.asCppNode())
  )
}

pragma[nomagic]
private string class2sig(JAVA::Class c) {
  result = "L" + c.getQualifiedName().replaceAll(".", "/") + ";"
}
pragma[nomagic]
private string extractSig(JniCallNode c) {
  c.getName().matches("Get%MethodID") and
  result = StringLiteralFlow::getStringLiteral(c.getArgument(2)).splitAt(")", 1)
}

JAVA::Class getJavaClass(Node node) {
  // obj from argument
  exists(
    JAVA::ArgumentNode argNode,
    CPP::ParameterNode paramNode,
    JAVA::DataFlowCall call,
    CPP::DataFlowCallable callable,
    int i,
    JniConfiguration config
    |
    result = argNode.getType() and
    argNode.argumentOf(call, i) and
    callable = viableCallableJ2C(call) and
    paramNode.isParameterOf(callable, i+2) and
    config.hasFlow(paramNode, node.asCppNode())
  )
  or
  // obj from return
  exists(
    JniCallNode getNode,
    JniCallNode callNode,
    JniConfiguration cfg
    |
    getNode.getName().matches("Get%MethodID") and
    cfg.hasFlow(getNode.asCppNode(), callNode.getArgument(-2).asCppNode()) and
    callNode.getName().matches("Call%ObjectMethod") and
    cfg.hasFlow(callNode.asCppNode(), node.asCppNode()) and
    extractSig(getNode) = class2sig(result)
  )
}

module StringLiteralFlow {
  private predicate myStep(Node fromNode, Node toNode) {
    simpleLocalFlowStep(fromNode, toNode)
    or
    CPP::viableParamArg(_, toNode.asCppNode(), fromNode.asCppNode())
  }

  private predicate myFlow(Node n1, Node n2) = fastTC(myStep/2)(n1, n2)

  pragma[inline]
  string getStringLiteral(ArgumentNode arg) {
    exists (ExprNode stringNode |
      stringNode.asCppNode().asExpr() instanceof CPP::StringLiteral |
      (stringNode = arg or myFlow(stringNode, arg)) and
      result = stringNode.toString()
    )
  }
}
