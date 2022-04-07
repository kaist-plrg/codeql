module PythonFunctionFlow {
  private import dataflow.DataFlowImplSpecific::Original::PYTHON
  private import python.semmle.python.dataflow.new.internal.DataFlowImpl

  private class PythonFunctionFlowConfig extends Configuration {
    PythonFunctionFlowConfig() { this = "PythonFunctionFlowConfig" }

    override predicate isSource(Node n) {
      n.asExpr() instanceof FunctionExpr
      and not n.getLocation().toString().matches("%Library%")
    }

    override predicate isSink(Node n) {
      n instanceof ArgNode
    }
  }

  DataFlowCallable getFunc(ArgNode n) {
    exists(PythonFunctionFlowConfig cfg, Node funcNode |
      cfg.hasFlow(funcNode, n)
      and result.getCallableValue() = funcNode.asExpr().pointsTo()
    )
  }
}
private import PythonFunctionFlow

module CppParamFlow {
  private import dataflow.DataFlowImplSpecific::Original::CPP
  private import cpp.semmle.code.cpp.dataflow.internal.DataFlowImpl

  private class CppParamFlowConfig extends Configuration {
    CppParamFlowConfig() { this = "CppParamFlowConfig" }

    override predicate isSource(Node n) {
      n instanceof ParamNode
      or
      n instanceof PostUpdateNode //parse_tuple(tup, "I", &x);
      // TODO: optimization
    }

    override predicate isSink(Node n) {
      any()
    }
  }

  Node getParam(ArgNode n) {
    exists(CppParamFlowConfig cfg |
      cfg.hasFlow(result, n)
    )
  }
}
private import CppParamFlow

module MergedInnerFlow {
  private import DataFlowImplSpecific::Public
  private import DataFlowImplSpecific::Private
  private import DataFlowImplSpecific::Original

  PYTHON::DataFlowCallable getPyFunc(CPP::ArgNode n) {
    exists(
      ArgNode a,
      VirtualArgNode varg,
      PYTHON::Content c,
      ParamNode p,
      CPP::ArgNode tup,
      CPP::Node elem
      |
      result = getFunc(a.asPythonNode())
      and virtualArgStoreStep(a, c, varg)
      and p2cArgParamJumpStep(varg, p)
      and p.asCppNode() = getParam(tup)
      and pythonTupleObjectReadStep(tup, c, elem)
      and elem = getParam(n)
    )
  }
}
import MergedInnerFlow
