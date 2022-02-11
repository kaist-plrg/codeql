module Private {
  import DataFlowMerged
}

module Public {
  import DataFlowImplCommon
}

module Original {
  module CPP {
    import cpp.cpp
    import cpp.semmle.code.cpp.dataflow.internal.DataFlowImplSpecific::Public
    import cpp.semmle.code.cpp.dataflow.internal.DataFlowImplSpecific::Private
    import cpp.semmle.code.cpp.dataflow.internal.DataFlowImplCommon
  }

  module JAVA {
    import java.java
    import java.semmle.code.java.dataflow.internal.DataFlowImplSpecific::Public
    import java.semmle.code.java.dataflow.internal.DataFlowImplSpecific::Private
    import java.semmle.code.java.dataflow.internal.DataFlowImplCommon
  }
}
