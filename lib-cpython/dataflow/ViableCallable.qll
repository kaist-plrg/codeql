import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

DataFlowCallable p2cViableCallable(DataFlowCall call) {
  exists(
    PYTHON::Expr f,
    string name |
    f = call.asPythonDataFlowCall().getNode().getNode().(PYTHON::Call).getFunc()
    and ( f.toString() = name or f.(PYTHON::Attribute).getName() = name )
    and (
      exists(PyMethodDef md |
        md.getName() = name
        and md.getMeth() = result.asCppDataFlowCallable()
      )
      or
      // __init__ and __new__
      exists(PyTypeObject ty |
        ty.getName() = name
        and [ty.getNewMeth(), ty.getInitMeth()] = result.asCppDataFlowCallable()
      )
    )
  )
}

DataFlowCallable c2pViableCallable(DataFlowCall call) {
  exists(
    CPP::ArgNode funcArg
    |
    // function call
    call.asCppDataFlowCall().toString().matches("%PyObject_CalliObject%")
    and funcArg.argumentOf(call.asCppDataFlowCall(), 0)
    and result.asPythonDataFlowCallable() = getPyFunc(funcArg)
    or
    // method call
    call.asCppDataFlowCall().toString().matches("%PyObject_CallMethod%")
    and funcArg.argumentOf(call.asCppDataFlowCall(), 1)
    and result.asPythonDataFlowCallable().getName() = funcArg.toString()
  )
}
