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
  private class StringLiteralConfiguration extends CPP::Impl2::Configuration {
    StringLiteralConfiguration() { this = "StringLiteralConfiguration" }

    override predicate isSource(CPP::Node source) {
      source.asExpr() instanceof CPP::StringLiteral
    }

    override predicate isSink(CPP::Node sink) {
      sink instanceof CPP::ArgumentNode
    }
  }

  //TODO: StringLiteral from java?

  string getStringLiteral(ArgumentNode arg) {
    exists (StringLiteralConfiguration config, ExprNode stringNode |
      config.hasFlow(stringNode.asCppNode(), arg.asCppNode()) and
      result = stringNode.toString()
    )
  }
}

module JniParameterFlow {
  /**
   * A configuration for finding flow from special parameter of jni function (env / obj)
   */
  private class JniParameterConfiguration extends CPP::Impl2::Configuration {
    JniParameterConfiguration() { this = "JniParameterConfiguration" }

    override predicate isSource(CPP::Node source) {
      exists(CPP::Function f |
        f.toString().matches("Java_%") |
        source.(CPP::ParameterNode).isParameterOf(f, 0)
        or
        source.(CPP::ParameterNode).isParameterOf(f, 1)
      )
    }

    override predicate isSink(CPP::Node sink) { any() }
  }
  
  /**
   * A configuration for finding flow from class instantiation
   */
  private class JavaObjectConfiguration extends JAVA::Configuration {
    JavaObjectConfiguration() { this = "JavaObjectConfiguration" }

    override predicate isSource(JAVA::Node source) {
      source instanceof JAVA::NewExpr
    }

    override predicate isSink(JAVA::Node sink) {
      sink instanceof JAVA::ArgumentNode
    }
  }

  predicate isJniEnv(CPP::Node node) {
    exists(JniParameterConfiguration config, CPP::ParameterNode paramNode |
      paramNode.isParameterOf(_, 0) and
      config.hasFlow(paramNode, node)
    )
  }

  private import DataFlowImplCommon

  JAVA::NewExpr getJavaNewExpr(Node node) {
    exists(
      JavaObjectConfiguration config1,
      ArgumentNode argNode,
      ParameterNode paramNode,
      JniParameterConfiguration config2
      |
      config1.hasFlow(result, argNode.asJavaNode()) and
      viableParamArg(_, paramNode, argNode) and
      config2.hasFlow(paramNode.asCppNode(), node.asCppNode())
    )
  }
}

