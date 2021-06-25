/**
 * Provides jni-specific definitions for use in the data flow library.
 */
module Private {
  import DataFlowDispatch
  import DataFlowPrivate
  import DataFlowStep
  import DataFlowType
  import DataFlowInnerFlow
}

module Public {
  import DataFlowUtil
  import DataFlowNode

  import DataFlowStep
  import DataFlowType
}

module Original {
  module CPP {
    import cpp.cpp
    import cpp.semmle.code.cpp.dataflow.internal.DataFlowUtil
    import cpp.semmle.code.cpp.dataflow.internal.DataFlowPrivate
    import cpp.semmle.code.cpp.dataflow.internal.DataFlowDispatch
    module Impl1 {
      import cpp.semmle.code.cpp.dataflow.internal.DataFlowImpl
    }
    module Impl2 {
      import cpp.semmle.code.cpp.dataflow.internal.DataFlowImpl2
    }
    import cpp.semmle.code.cpp.dataflow.internal.DataFlowImplCommon
  }

  module JAVA {
    import java.java
    import java.semmle.code.java.dataflow.internal.DataFlowUtil
    import java.semmle.code.java.dataflow.internal.DataFlowPrivate
    import java.semmle.code.java.dataflow.internal.DataFlowDispatch
    import java.semmle.code.java.dataflow.internal.DataFlowImpl
  }
}
