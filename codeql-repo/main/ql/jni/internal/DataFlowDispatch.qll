import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original
private import Signature

predicate nameConventionMethod(JAVA::Method m, CPP::DataFlowCallable f) {
  m.isNative() and
  m.getDeclaringType().fromSource() and
  exists(string name | 
    name = 
      "Java_"
      + m.getDeclaringType().getQualifiedName().replaceAll("_", "_1").replaceAll(".", "_").replaceAll("$", "_00024")
      + "_"
      + m.toString().replaceAll("_", "_1")
    | 
    f.toString() = name
    or
    f.toString().matches(name + "__%") and 
    f.toString().matches("%__" + getHandledSignature(m)
      .replaceAll("_", "_1")
      .replaceAll("/", "_")
      .replaceAll(";", "_2")
      .replaceAll("[", "_3")
    )
  )
}
//TODO: Consider class 
predicate registeredMethod(string name, string sig, CPP::DataFlowCallable f) {
  /*
  exists(JniCallNode call, ArgumentNode classNode, ArgumentNode listNode |
    call.getName() = "RegisterNatives"
    and classNode = call.getArgument(0)
    and listNode = call.getArgument(1) |
    c = getClassNode(classNode) and
    exists
  )
  */
  exists(
    CPP::GlobalVariable g,
    CPP::ClassAggregateLiteral info,
    CPP::Field fname,
    CPP::Field fsig,
    CPP::Field fptr |
    g.getType().toString()="JNINativeMethod[]"
    and info = g.getInitializer().getExpr().(CPP::ArrayAggregateLiteral).getElementExpr(_)
    and fname.toString() = "name"
    and fsig.toString() = "signature"
    and fptr.toString() = "fnPtr"
    |
    name = info.getFieldExpr(fname).toString()
    and sig = info.getFieldExpr(fsig).toString()
    and f.toString() = info.getFieldExpr(fptr).toString()
  )
}
CPP::DataFlowCallable viableCallableJ2C(JAVA::DataFlowCall c) {
  exists(JAVA::Method m |
    m = c.(JAVA::MethodAccess).getMethod() and
    m.isNative() and
    m.getDeclaringType().fromSource()
    |
    nameConventionMethod(m, result)
    or
    exists(string sig |
      sig.matches("(" + getHandledSignature(m) + ")%") |
      registeredMethod(m.toString(), sig, result)
    ) and
    not exists(CPP::DataFlowCallable f | nameConventionMethod(m, f))
  )
}
JAVA::DataFlowCallable viableCallableC2J(CPP::DataFlowCall c) {
  exists(JniCallNode callNode, ArgumentNode midNode |
    callNode.getCall().asCppDataFlowCall() = c and
    callNode.getName().matches("Call%Method") and
    midNode = callNode.getArgument(-2) and
    result = getJavaMethodNode(midNode).getMethod()
  )
}
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
