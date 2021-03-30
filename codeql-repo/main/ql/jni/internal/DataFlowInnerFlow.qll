import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

module JavaMethodFlow {
  /**
   * A configuration for finding flow from custom nodes
   */
  private class JavaMethodConfiguration extends CPP::Impl1::Configuration {
    JavaMethodConfiguration() { this = "JavaMethodConfiguration" }

    override predicate isSource(CPP::Node source) {
      exists(JavaMethodNode method, JniCallNode call |
        call.asCppNode() = source and jniGetMethodIDStep(method, call)
      )
    }

    override predicate isSink(CPP::Node sink) { any() }
  }

  predicate javaMethodFlow(Node node1, Node node2) {
    exists(JavaMethodConfiguration config, Node mid |
      jniGetMethodIDStep(node1, mid) and
      config.hasFlow(mid.asCppNode(), node2.asCppNode())
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

    override predicate isSink(CPP::Node sink) { any() }
  }

  //TODO: StringLiteral from java?

  predicate stringLiteralFlow(Node node1, Node node2) {
    exists (StringLiteralConfiguration config |
      config.hasFlow(node1.asCppNode(), node2.asCppNode())
    )
  }
}
