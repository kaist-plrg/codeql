import semmle.code.cpp.dataflow.DataFlow

/*
class Config extends DataFlow::Configuration {
  Config() { this = "MyDataFlowConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    ...
  }

  override predicate isSink(DataFlow::Node sink) {
    ...
  }
}
*/

from FunctionCall call, StringLiteral name, StringLiteral sig
where
  call.getTarget().getName().matches("getMethodID")
and
  exists(DataFlow::Node source, DataFlow::Node sink |
    DataFlow::localFlow(source, sink)
    and
    source.asExpr() = name
    and
    sink.asExpr() = call.getArgument(2)
  )
and
  exists(DataFlow::Node source, DataFlow::Node sink |
    DataFlow::localFlow(source, sink)
    and
    source.asExpr() = sig
    and
    sink.asExpr() = call.getArgument(3)
  )
select call.getFile().getBaseName(), call.getLocation().getStartLine(), name, sig
