import dataflow.DataFlowImpl
import python
import cpp

class MyConfig extends Configuration {
  MyConfig() { this = "MyConfig" }

  override predicate isSource(Node n) {
    n.toString() = [
      "call to SOURCE",
      "call to NOSOURCE",
      "ControlFlowNode for SOURCE()",
      "ControlFlowNode for NOSOURCE()"
    ]
  }

  override predicate isSink(Node n) {
    exists(DataFlowCall call |
      n.(ArgNode).argumentOf(call,_)
      and call.toString().matches("%SINK%")
    )
  }
}

from MyConfig cfg, Node src, Node sink
where
  cfg.hasFlow(src, sink)
select src, sink, src.getLocation(), sink.getLocation()
