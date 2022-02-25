import dataflow.DataFlowImpl
import python
import cpp

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
