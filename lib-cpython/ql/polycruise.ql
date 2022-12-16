import dataflow.DataFlowImpl
import util
private import dataflow.DataFlowImplSpecific::Original

class MyConfig extends Configuration {
  MyConfig() { this = "MyConfig" }

  private predicate is_benchmark_file(Node n) {
    n.getLocation().toString().matches("%cpython-polycruise%")
  }

  override predicate isSource(Node n) {
    is_benchmark_file(n)
    and
    node2string(n) = [
      "call to getenv",
    ]
  }

  override predicate isSink(Node n) {
    is_benchmark_file(n)/*
    and
    exists(DataFlowCall call |
      n.(ArgNode).argumentOf(call,_)
      and (
        getFuncName(toAst(call.asPythonDataFlowCall().getNode())) = "print"
        or
        call.toString() = "call to printf"
      )
    )*/
  }

  override predicate isAdditionalFlowStep(Node src, Node sink) {
    is_benchmark_file(src) and is_benchmark_file(sink) and
    (
      // taint by binary operator
      exists(
        PYTHON::BinaryExpr binop |
        binop = sink.asPythonNode().asExpr() |
        src.asPythonNode().asExpr() = binop.getASubExpression()
        //and binop.getOp() instanceof PYTHON::Add
      )
      or
      exists(
        CPP::BinaryOperation binop |
        binop = sink.asCppNode().asExpr() |
        src.asCppNode().asExpr() = binop.getAnOperand()
        // and binop.getOperator() = "<<"
      )
      or
      // taint by sprintf
      exists(
        CPP::FunctionCall call |
        call.getTarget().toString() = [
          "__builtin___sprintf_chk",
          "__builtin___strcpy_chk",
          "__builtin___strcat_chk",
        ] and
        call.getArgument(0) = sink.asCppNode().(CPP::PostUpdateNode).getPreUpdateNode().asExpr() and
        call.getAnArgument() = src.asCppNode().asExpr()
      )
    )
  }
}

from MyConfig cfg, Node src, Node sink
where
  cfg.hasFlow(src, sink)
select src, sink, sink.getLocation()//, src.getLocation(), sink.getLocation()
