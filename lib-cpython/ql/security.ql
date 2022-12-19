import dataflow.DataFlowImpl
private import dataflow.DataFlowImplSpecific::Private
private import dataflow.DataFlowImplSpecific::Original
import util

class MyConfig extends Configuration {
  MyConfig() { this = "MyConfig" }

  override predicate isSource(Node n) {
    exists(n.asPythonNode())
    and not exists(Node p | simpleLocalFlowStep(p, n))
  }

  override predicate isSink(Node n) {
    exists(CPP::Call call |
      isDangerCall(call)
      and includesAsArg(call, n)
    )
  }

  override predicate isAdditionalFlowStep(Node a, Node b) {
    fileReadStep(a, b)
    or
    sizeStep(a, b)
    or
    taintStep(a, b)
  }

  override predicate isBarrier(Node n) {
    not is_my_node(n)
  }
}

predicate is_my_node(Node n) {
  n.getLocation().matches("%cpython-large%")
}

predicate fileReadStep(Node reader, Node callNode) {
  exists(PYTHON::Call call, PYTHON::Attribute attr |
    call = callNode.asPythonNode().asExpr() and
    attr = call.getFunc() |
    attr.getName() = "read" and
    attr.getValue() = reader.asPythonNode().asExpr()
  )
  or
  exists(CPP::Call call, CPP::ArgNode file, CPP::ArgNode read |
    call.toString().matches("%PyObject_CallMethod%")
    and file.argumentOf(call, 0)
    and read.argumentOf(call, 1)
    |
    call = callNode.asCppNode().asExpr() and
    file = reader.asCppNode() and
    read.toString() = "read"
  )
}

predicate sizeStep(Node obj, Node size) {
  // size is obtained by calling macro
  size.toString() = "ob_size"
  and
  exists(CPP::MacroInvocation m |
    obj.asCppNode().asExpr() = m.getAnAffectedElement()
    and size.asCppNode().asExpr() = m.getAnAffectedElement()
  )
}

predicate taintStep(Node obj, Node callNode) {
  exists(CPP::Call call, CPP::ArgNode arg |
    call.toString().matches("%Py%_Get%")
    and arg.argumentOf(call, 0)
    |
    call = callNode.asCppNode().asExpr() and
    arg = obj.asCppNode()
  )
}

predicate isDangerCall(CPP::Call call) {
  exists(string funcName |
    funcName = [
      "%memcpy%",
      "%strcmp%",
      "%strncmp%",
      "%strcpy%",
      "%strncpy%",
      "%sprintf%",
      "%malloc%",
      "%calloc%"
    ]
    and call.toString().matches(funcName)
  )
}

pragma[inline]
predicate includesAsArg(CPP::Call call, Node n) {
  exists(int i |
    n.asCppNode().(CPP::ArgumentNode).argumentOf(call, i)
    or
    call.getArgument(i) = n.asCppNode().asExpr().getParent()
  )
}

from CPP::Call call, Node b, MyConfig cfg
where
  isDangerCall(call)
  and includesAsArg(call, b)
  and cfg.hasFlow(_, b)
select call.toString(), b.toString(), call.getLocation()
