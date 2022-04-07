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

  module PYTHON {
    import python.python
    import python.semmle.python.dataflow.new.internal.DataFlowImplSpecific::Public
    import python.semmle.python.dataflow.new.internal.DataFlowImplSpecific::Private
    import python.semmle.python.dataflow.new.internal.DataFlowImplCommon
  }
}
