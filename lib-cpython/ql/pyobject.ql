import dataflow.DataFlowImpl
private import dataflow.DataFlowImplSpecific::Private
private import dataflow.DataFlowImplSpecific::Original

predicate isNew(CPP::Call call) {
    call.getTarget().toString() = [
      "PyList_New",
      "PyTuple_New",
      "PyDict_New",
      "_PyObject_GC_New",
      "_PyObject_New",
      "tp_alloc"
    ]
}

predicate isApiFunctionCall(CPP::Call call) {
  exists (string pattern |
    pattern = "%PyObject_%"
    or pattern = "%PyArg_%"
    or pattern = "%PyTuple_%"
    or pattern = "%PyList_%"
    or pattern = "%PyDict_%"
    |
    call.getTarget().toString().matches(pattern)
    and not isNew(call)
  )
}
predicate isPyArg(CPP::Expr e) {
  e = any(CPP::Call call | isApiFunctionCall(call)).getArgument(0)
  and not e.getLocation().toString().matches("%/Library/%")
  and not e instanceof CPP::AddressOfExpr
}

class MyConfig extends Configuration {
  MyConfig() { this = "MyConfig" }

  override predicate isSource(Node n) {
    n instanceof VirtualArgNode
    or
    (
      exists(n.asPythonNode())
      and not exists(Node p | simpleLocalFlowStep(p, n))
    )
    or
    isNew(n.asCppNode().asExpr())
  }

  override predicate isSink(Node n) {
    isPyArg(n.asCppNode().asExpr())
  }

  override predicate isBarrier(Node n) {
    n.getLocation().toString().matches("%/Library/%")
  }
}

//from Node src, Node sink, MyConfig cfg
//where cfg.hasFlow(src, sink)
//select src, src.getLocation(), sink, sink.getLocation()

predicate getPyObj(CPP::Expr arg, Node obj) {
  exists(Node sink, MyConfig config |
    config.hasFlow(obj, sink)
    and sink.asCppNode().asExpr() = arg
  )
}

from CPP::Expr arg, CPP::Call call
where isPyArg(arg) and arg = call.getArgument(_)
select arg, call, arg.getLocation(), count(Node obj | getPyObj(arg, obj))
