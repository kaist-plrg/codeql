import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original
private import Signature

DataFlowCallable viableCallable(DataFlowCall c) { //modified
  result.asJavaDataFlowCallable() = JAVA::viableCallable(c.asJavaDataFlowCall())
  or
  not exists(JniCallNode callNode | callNode.getCall() = c) and
  result.asCppDataFlowCallable() = CPP::viableCallable(c.asCppDataFlowCall())
  or
  exists(JAVA::Method m, CPP::Function f, string name |
    m = c.asJavaDataFlowCall().(JAVA::MethodAccess).getMethod() and
    f = result.asCppDataFlowCallable() and
    name = 
      "Java_"
      + m.getDeclaringType().getQualifiedName().replaceAll("_", "_1").replaceAll(".", "_")
      + "_"
      + m.toString() | 
    m.isNative() and
    m.getDeclaringType().fromSource() and
    (
      f.toString() = name
      or
      f.toString() = name + "__" + handleMethodSignature(m.getSignature())
        .replaceAll("_", "_1")
        .replaceAll("/", "_")
        .replaceAll(";", "_2")
        .replaceAll("[", "_3")
    )
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
