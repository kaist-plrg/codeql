import dataflow.DataFlowImpl
import python
import cpp

class MyConfig extends Configuration {
  MyConfig() { this = "MyConfig" }

  override predicate isSource(Node n) {
    node2string(n) = "42"
  }

  override predicate isSink(Node n) {
    any()
  }
}

string p2string(PYTHON::Node n) {
  exists(PYTHON::AstNode ast | 
    python_py_flow_bb_node(n.asCfgNode(), ast, _, _)
    and
    if ast instanceof PYTHON::IntegerLiteral
    then result = ast.(PYTHON::IntegerLiteral).getValue().toString()
    
    else if ast instanceof PYTHON::StrConst
    then result = ast.(PYTHON::StrConst).getText()

    else
    result = ast.toString()
  )
}

string node2string(Node n) {
  result = n.asCppNode().toString()
  or
  result = p2string(n.asPythonNode())
}

from MyConfig cfg, Node src, Node sink, string tag
where
  cfg.hasFlow(src, sink)
  and (tag = "cpp" and exists(src.asCppNode()) or tag = "python" and exists(src.asPythonNode()))
select tag, node2string(src), node2string(sink)
