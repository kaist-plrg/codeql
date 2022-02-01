module Private {
  import DataFlowMerged
}

module Public {
  import DataFlowImplCommon
}

module Original {
  module LANG1 {
    import lang1.lang1
    import lang1.path.to.dataflow.internal.DataFlowImplSpecific::Public
    import lang1.path.to.dataflow.internal.DataFlowImplSpecific::Private
    import lang1.path.to.dataflow.internal.DataFlowImplCommon
  }

  module LANG2 {
    import lang2.lang2
    import lang2.path.to.dataflow.internal.DataFlowImplSpecific::Public
    import lang2.path.to.dataflow.internal.DataFlowImplSpecific::Private
    import lang2.path.to.dataflow.internal.DataFlowImplCommon
  }
}
