import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

module CustomNodeFlow {
  /**
   * A configuration for finding flow from custom nodes
   */
  private class CustomNodeConfiguration extends CPP::Impl1::Configuration {
    CustomNodeConfiguration() { this = "CustomNodeConfiguration" }

    override predicate isSource(CPP::Node source) {
      exists(JniCallNode call | call.asCppNode() = source)
    }

    override predicate isSink(CPP::Node sink) {
      sink instanceof CPP::ArgumentNode
    }

    override predicate isAdditionalFlowStep(CPP::Node fromNode, CPP::Node toNode) {
      exists(CPP::GlobalVariable g, CPP::VariableAccess lv |
        lv = fromNode.(CPP::PostUpdateNode).getPreUpdateNode().asExpr()
        and lv.isUsedAsLValue()
        and lv.getTarget() = g
        and toNode.asExpr().(CPP::VariableAccess).getTarget() = g
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
      jniGetMethodIDStep(result, mid) and
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

private import DataFlowImplCommon

JAVA::Type getJavaClass(Node node) {
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
}
