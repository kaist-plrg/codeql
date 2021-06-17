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

  //TODO: StringLiteral from java?

  pragma[inline]
  string getStringLiteral(ArgumentNode arg) {
    exists (ExprNode stringNode |
      stringNode.asCppNode().asExpr() instanceof CPP::StringLiteral |
      (stringNode = arg or simpleLocalFlow(stringNode, arg)) and
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

/**
 * A configuration for finding flow from AttathCurrentThread
 */
private class AttachCurrentThreadConfiguration extends CPP::Impl2::Configuration {
  AttachCurrentThreadConfiguration() { this = "AttachCurrentThreadConfiguration" }

  override predicate isSource(CPP::Node source) {
    exists(CPP::Call call |
     call.toString().matches("%AttachCurrentThread") |
     call.getArgument(0) = source.(CPP::DefinitionByReferenceOrIteratorNode).getArgument()
    )
  }

  override predicate isSink(CPP::Node sink) { any() }
}

pragma[inline]
predicate isJniEnv(CPP::Node node) {
  exists(JniParameterConfiguration config, CPP::ParameterNode paramNode |
    paramNode.isParameterOf(_, 0) and
    config.hasFlow(paramNode, node)
  )
  or
  exists(AttachCurrentThreadConfiguration config | config.hasFlow(_, node))
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

