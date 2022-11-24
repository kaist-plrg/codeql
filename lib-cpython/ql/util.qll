import dataflow.DataFlowImpl
private import dataflow.DataFlowImplSpecific::Original

PYTHON::AstNode toAst(PYTHON::ControlFlowNode n) {
  python_py_flow_bb_node(n, result, _, _)
}

string p2string(PYTHON::Node n) {
  exists(PYTHON::AstNode ast | 
    ast = toAst(n.asCfgNode())
    and
    if ast instanceof PYTHON::IntegerLiteral
    then result = ast.(PYTHON::IntegerLiteral).getValue().toString()
    
    else if ast instanceof PYTHON::StrConst
    then result = ast.(PYTHON::StrConst).getText()
    
    else if ast instanceof PYTHON::Call
    then result = "call to " + getFuncName(ast)

    else
    result = ast.toString()
  )
}

string node2string(Node n) {
  result = n.asCppNode().toString()
  or
  result = p2string(n.asPythonNode())
}

string getFuncName(PYTHON::Call call) {
  exists(PYTHON::Expr f|
    f = call.getFunc()
    and
    (
      result = f.(PYTHON::Attribute).getName()
      or
      result = f.toString() and not (f instanceof PYTHON::Attribute)
    )
  )
}
