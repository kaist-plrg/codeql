import dataflow.DataFlowImpl
private import dataflow.DataFlowImplSpecific::Private
private import dataflow.DataFlowImplSpecific::Original
import util

class MyConfig extends Configuration {
  MyConfig() { this = "MyConfig" }

  override predicate isSource(Node n) {
    /*
    is_input_file(n)
    or
    is_input_func(n)
    */
    (
      exists(n.asPythonNode())
      and not exists(Node p | simpleLocalFlowStep(p, n))
    )
  }

  override predicate isSink(Node n) {
    exists(CPP::Call call, string funcName, int i |
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
      and
      call.toString().matches(funcName)
      and
      (
        n.asCppNode().(CPP::ArgumentNode).argumentOf(call, i)
        or
        call.getArgument(i) = n.asCppNode().asExpr().getParent()
      )
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

predicate is_input_file(Node n) {
  exists(PYTHON::Call call |
    call.getFunc().toString() = "open"
    and call.getArg(1).(PYTHON::StrConst).getText().matches("%r%") |
    n.asPythonNode().asExpr() = call
  )
}

predicate is_input_func(Node n) {
  exists(string name |
    name = [
      "%getenv%",
      "%fgetc%",
      "%_IO_getc%",
      "%fread%",
      "%fgets%",
      "%fscanf%",
      "%getchar%",
      "%receive%",
      "%recv%",
      "%Info%",
      "%set_mode%",
      "%load_image%",
      "%get_fg%",
      "read%"
    ]
    and (
      exists(CPP::Call call | 
        call.toString().matches(name)
        and call = n.asCppNode().asExpr()
      )
      or
      exists(PYTHON::Call call |
        call = n.asPythonNode().asExpr()
        and getFuncName(call).matches(name)
      )
    )
  )
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
    arg = reader.asCppNode() and
  )
}

from Node a, Node b, MyConfig cfg
where cfg.hasFlow(a, b)
select a, b, b.getLocation()
