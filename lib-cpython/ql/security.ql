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
    exists(CPP::Expr expr |
      isDanger(expr)
      and uses(expr, n)
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

predicate taintStep(Node child, Node parent) {
  exists(CPP::Call call, CPP::ArgNode arg |
    call.toString().matches(["%Py%_Get%", "%PyObject_Hash%"])
    and arg.argumentOf(call, 0)
    |
    call = parent.asCppNode().asExpr() and
    arg = child.asCppNode()
  )
  or
  parent.asCppNode().asExpr().(CPP::BinaryOperation).getAnOperand() = child.asCppNode().asExpr()
}

predicate isDanger(CPP::Expr expr) {
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
    and expr.(CPP::Call).toString().matches(funcName)
  )
  or
  exists(expr.(CPP::ArrayExpr))
}

pragma[inline]
predicate uses(CPP::Expr expr, Node n) {
  exists(int i |
    n.asCppNode().(CPP::ArgumentNode).argumentOf(expr, i)
    or
    expr.(CPP::Call).getArgument(i) = n.asCppNode().asExpr().getParent()
  )
  or
  expr.(CPP::ArrayExpr).getArrayOffset() = n.asCppNode().asExpr()
}

from CPP::Expr expr, Node b, MyConfig cfg
where
  isDanger(expr)
  and uses(expr, b)
  and cfg.hasFlow(_, b)
select expr.toString(), b.toString(), expr.getLocation()
