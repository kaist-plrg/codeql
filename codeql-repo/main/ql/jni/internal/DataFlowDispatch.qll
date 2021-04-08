import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

DataFlowCallable viableCallable(DataFlowCall c) { //modified
  result.asJavaDataFlowCallable() = JAVA::viableCallable(c.asJavaDataFlowCall())
  or
  not exists(JniCallNode callNode | callNode.getCall() = c) and
  result.asCppDataFlowCallable() = CPP::viableCallable(c.asCppDataFlowCall())
  or
  exists(JAVA::Method m, CPP::Function f |
    m = c.asJavaDataFlowCall().(JAVA::MethodAccess).getMethod() and
    f = result.asCppDataFlowCallable() |
    m.isNative() and
    f.toString().matches("Java_%_" + m.toString() + "%")
  )
  or
  exists(JniCallNode callNode, ArgumentNode midNode |
    callNode.getCall() = c and
    callNode.getTarget().toString().matches("Call%Method") and
    midNode.argumentOf(c, -2) and
    result.asJavaDataFlowCallable() = CustomNodeFlow::getJavaMethodNode(midNode).getMethod()
  )
}

DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
  result.asJavaDataFlowCallable() = JAVA::viableImplInCallContext(call.asJavaDataFlowCall(), ctx.asJavaDataFlowCall())
  or
  result.asCppDataFlowCallable() = CPP::viableImplInCallContext(call.asCppDataFlowCall(), ctx.asCppDataFlowCall())
}

predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable callable) {
  JAVA::mayBenefitFromCallContext(call.asJavaDataFlowCall(), callable.asJavaDataFlowCallable())
  or
  CPP::mayBenefitFromCallContext(call.asCppDataFlowCall(), callable.asCppDataFlowCallable())
}
