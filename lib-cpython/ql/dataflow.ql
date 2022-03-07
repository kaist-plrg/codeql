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

/*
from int n, string stage, int nodes, int fields, int conscand, int states, int tuples, MyConfig cfg
where stageStats(n, stage, nodes, fields, conscand, states, tuples, cfg)
select n, stage, nodes, fields, conscand, states, tuples
*/

from MyConfig cfg, Node src, Node sink
where
  cfg.hasFlow(src, sink)
select src, sink
