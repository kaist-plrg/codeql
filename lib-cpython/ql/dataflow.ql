import dataflow.DataFlowImpl
import python
import cpp
import util

class MyConfig extends Configuration {
  MyConfig() { this = "MyConfig" }

  override predicate isSource(Node n) {
    node2string(n) = "42"
  }

  override predicate isSink(Node n) {
    n.getLocation().matches("%cmodule%")
    or
    n.getLocation().matches("%cpython.py%")
  }
}

from MyConfig cfg, Node src, Node sink
where
  cfg.hasFlow(src, sink)
select src, sink
