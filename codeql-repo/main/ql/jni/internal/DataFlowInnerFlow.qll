import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

module CustomNodeFlow {
  /**
   * A configuration for finding flow from custom nodes
   */
  class CustomNodeConfiguration extends CPP::Impl1::Configuration {
    CustomNodeConfiguration() { this = "CustomNodeConfiguration" }

    override predicate isSource(CPP::Node source) {
      exists(JniCallNode call | call.asCppNode() = source)
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
      //jni functions
      exists(Node n1, Node n2 |
        n1.asCppNode() = fromNode and
        n2.asCppNode() = toNode |
        jniStringStep(n1, n2)
        or
        jniNewGlobalRefStep(n1, n2)
      )
    }
  }

  JavaClassNode getJavaClassNode(ArgumentNode arg) {
    exists(CustomNodeConfiguration config, Node mid |
      (
        jniGetObjectClassStep(result, mid)
        or
        jniFindClassStep(result, mid)
      )
      and
      config.hasFlow(mid.asCppNode(), arg.asCppNode())
    )
  }
  JavaMethodNode getJavaMethodNode(ArgumentNode arg) {
    exists(CustomNodeConfiguration config, Node mid |
      (
        jniGetMethodIDStep(result, mid)
        or
        jniGetStaticMethodIDStep(result, mid)
      ) and
      config.hasFlow(mid.asCppNode(), arg.asCppNode())
    )
  }
  JavaFieldNode getJavaFieldNode(ArgumentNode arg) {
    exists(CustomNodeConfiguration config, Node mid |
      jniGetFieldIDStep(result, mid) and
      config.hasFlow(mid.asCppNode(), arg.asCppNode())
    )
  }
  JavaFieldNode getJavaStaticFieldNode(ArgumentNode arg) {
    exists(CustomNodeConfiguration config, Node mid |
      jniGetStaticFieldIDStep(result, mid) and
      config.hasFlow(mid.asCppNode(), arg.asCppNode())
    )
  }
}

module StringLiteralFlow {
  /**
   * A configuration for finding flow of string literal
   */
   /*
  private class StringLiteralConfiguration extends CPP::Impl2::Configuration {
    StringLiteralConfiguration() { this = "StringLiteralConfiguration" }

    override predicate isSource(CPP::Node source) {
      source.asExpr() instanceof CPP::StringLiteral
    }

    override predicate isSink(CPP::Node sink) {
      sink instanceof CPP::ArgumentNode
    }
  }
  */

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
      //config.hasFlow(stringNode.asCppNode(), arg.asCppNode()) and
      result = stringNode.toString()
    )
  }
}

/**
 * A configuration for finding flow from parameter of jni function
 */
private class JniParameterConfiguration extends CPP::Impl2::Configuration {
  JniParameterConfiguration() { this = "JniParameterConfiguration" }

  override predicate isSource(CPP::Node source) {
    exists(CPP::Function f |
      f.toString().matches("Java_%") |
      source.(CPP::ParameterNode).isParameterOf(f, _)
    )
  }

  override predicate isSink(CPP::Node sink) { any() }
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
    JniParameterConfiguration config
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
    CustomNodeFlow::CustomNodeConfiguration cfg
    |
    getNode.getName().matches("Get%MethodID") and
    cfg.hasFlow(getNode.asCppNode(), callNode.getArgument(-2).asCppNode()) and
    callNode.getName().matches("Call%ObjectMethod") and
    cfg.hasFlow(callNode.asCppNode(), node.asCppNode()) and
    extractSig(getNode) = class2sig(result)
  )
}
