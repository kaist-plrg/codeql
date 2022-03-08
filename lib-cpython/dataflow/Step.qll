import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

/* stroe */
predicate virtualArgStoreStep(ArgNode arg, PYTHON::TupleElementContent c, VirtualArgNode varg) {
  exists(
    DataFlowCall call,
    ArgumentPosition apos
    |
    call = varg.getCall()
    and not arg instanceof VirtualArgNode
    and arg.argumentOf(call, apos)
    and apos.asPythonArgumentPosition() = c.getIndex()
  )
}
predicate buildValueStoreStep(CPP::ArgNode arg, PYTHON::TupleElementContent c, CPP::Node callNode) {
  exists(CPP::Call call, CPP::ArgumentPosition apos |
    call = callNode.asExpr() |
    call.toString().matches("%Py_BuildValue%")
    and arg.argumentOf(call, apos)
    and c.getIndex() = apos - 1
  )
}

predicate pythonTupleObjectReadStep(CPP::Node tup, PYTHON::TupleElementContent c, CPP::Node elem) {
  exists(CPP::Call call |
    // PyArg_ParseTuple
    call.toString().matches("%PyArg_ParseTuple%")
    and tup.asExpr() = call.getArgument(0)
    and elem.(CPP::PostUpdateNode).getPreUpdateNode().asExpr() = call.getArgument(2 + c.getIndex())
  )
}
predicate c2pArgParamReadStep(ArgNode arg, PYTHON::TupleElementContent c, ParamNode param) {
  exists(
    DataFlowCall call,
    DataFlowCallable func,
    ArgumentPosition apos,
    ParameterPosition ppos
    |
    func = c2pViableCallable(call)
    and arg.argumentOf(call, apos)
    and apos.asCppArgumentPosition() = 1
    and param.isParameterOf(func, ppos)
    and ppos.asPythonParameterPosition() = c.getIndex()
  )
}

predicate p2cArgParamJumpStep(VirtualArgNode arg, ParamNode param) {
  exists(
    DataFlowCall call,
    DataFlowCallable func,
    ParameterPosition ppos
    |
    call = arg.getCall()
    and func = p2cViableCallable(call)
    // and func.isvararg()
    and param.isParameterOf(func, ppos)
    and ppos.asCppParameterPosition() = 0
  )
}
