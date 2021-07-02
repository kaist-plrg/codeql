import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original
private import Signature

pragma[inline]
CPP::DataFlowCallable viableCallableJ2C(JAVA::DataFlowCall c) {
  exists(JAVA::Method m, string name |
    m = c.(JAVA::MethodAccess).getMethod() and
    m.isNative() and
    m.getDeclaringType().fromSource() and
    name = 
      "Java_"
      + m.getDeclaringType().getQualifiedName().replaceAll("_", "_1").replaceAll(".", "_").replaceAll("$", "_00024")
      + "_"
      + m.toString().replaceAll("_", "_1") | 
    (
      result.toString() = name
      or
      result.toString().matches(name + "__%") and 
      result.toString().matches("%__" + handleMethodSignature(m.getSignature())
        .replaceAll("_", "_1")
        .replaceAll("/", "_")
        .replaceAll(";", "_2")
        .replaceAll("[", "_3")
      )
    )
  )
}
pragma[inline]
JAVA::DataFlowCallable viableCallableC2J(CPP::DataFlowCall c) {
  exists(JniCallNode callNode, ArgumentNode midNode |
    callNode.getCall().asCppDataFlowCall() = c and
    callNode.getName().matches("Call%Method") and
    midNode = callNode.getArgument(-2) and
    result = CustomNodeFlow::getJavaMethodNode(midNode).getMethod()
  )
}
pragma[inline]
DataFlowCallable viableCallable(DataFlowCall c) { //modified
  result.asJavaDataFlowCallable() = JAVA::viableCallable(c.asJavaDataFlowCall())
  or
  not exists(JniCallNode callNode | callNode.getCall() = c) and
  result.asCppDataFlowCallable() = CPP::viableCallable(c.asCppDataFlowCall())
  or
  result.asCppDataFlowCallable() = viableCallableJ2C(c.asJavaDataFlowCall())
  or
  result.asJavaDataFlowCallable() = viableCallableC2J(c.asCppDataFlowCall())
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
