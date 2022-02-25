import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

predicate p2cArgParamStoreStep(ArgNode arg, PYTHON::TupleElementContent c, ParamNode param) {
  exists(
    DataFlowCall call,
    DataFlowCallable func,
    ArgumentPosition apos,
    ParameterPosition ppos
    |
    func = p2cViableCallable(call)
    and arg.argumentOf(call, apos)
    and apos.asPythonArgumentPosition() = c.getIndex()
    and param.isParameterOf(func, ppos)
    and ppos.asCppParameterPosition() = 1
  )
}

predicate pythonTupleObjectReadStep(CPP::Node tup, PYTHON::TupleElementContent c, CPP::Node elem) {
  exists(CPP::Call call |
    // PyLong_AsUnsignedLong
    call.toString().matches("%PyLong_AsUnsignedLong%")
    and tup.asExpr() = call.getArgument(0)
    and c.getIndex() = 0
    and elem.asExpr() = call
    or
    // PyArg_ParseTuple
    call.toString().matches("%PyArg_ParseTuple%")
    and tup.asExpr() = call.getArgument(0)
    and elem.(CPP::PostUpdateNode).getPreUpdateNode().asExpr() = call.getArgument(2 + c.getIndex())
  )
}
