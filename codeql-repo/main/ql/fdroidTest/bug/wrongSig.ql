import jni.DataFlow::DataFlow
import jni.internal.DataFlowInnerFlow
import jni.internal.DataFlowImplSpecific::Original

DataFlowCallable wrongViableCallable(DataFlowCall c) {
  exists(JniCallNode callNode, ArgumentNode midNode |
    callNode.getCall() = c and
    callNode.getName().matches("Call%Method") and
    midNode = callNode.getArgument(-2) and
    result.asJavaDataFlowCallable() = getWrongJavaMethodNode(midNode).getMethod()
  )
}

from
  CPP::Location loc, string name, int cnt1, int cnt2
where
  exists(JniCallNode call |
    loc = call.getLocation().asCppLocation()
    and name = call.getName()
    and name.matches("Call%Method")
  )
  and cnt1 = count(DataFlowCallable method |
    exists(JniCallNode call | loc = call.getLocation().asCppLocation() and callEdge(call.getCall(), method))
  )
  and cnt1 = 0
  and cnt2 = count(DataFlowCallable method |
    exists(JniCallNode call | loc = call.getLocation().asCppLocation() and method = wrongViableCallable(call.getCall()))
  )
  and cnt2 > 0
select
  name,
  loc,
  cnt2
