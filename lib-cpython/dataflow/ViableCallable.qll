import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

DataFlowCallable p2cViableCallable(DataFlowCall call) {
  exists(string name |
    result.isNativeFunction()
    and name = call.asPythonDataFlowCall().getNode().getNode().(PYTHON::Call).getFunc().toString()
    and exists(PyMethodDef md |
      md.getName() = name
      and md.getMeth() = result.asCppDataFlowCallable()
    )
  )
}

DataFlowCallable c2pViableCallable(DataFlowCall call) {
  exists(
    CPP::ArgNode funcArg
    |
    call.asCppDataFlowCall().toString().matches("%PyObject_Call%")
    and funcArg.argumentOf(call.asCppDataFlowCall(), 0)
    and result.asPythonDataFlowCallable() = getPyFunc(funcArg)
  )
}
