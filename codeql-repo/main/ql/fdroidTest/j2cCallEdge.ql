import jni.DataFlow::DataFlow
import java

from
   DataFlowCall call, JAVA::Callable callee
where
  callee = call.asJavaDataFlowCall().getCallee()
  and callee.isNative()
  and callee.getDeclaringType().fromSource()
select
  call, count(DataFlowCallable f | callEdge(call, f) | f.asCppDataFlowCallable())
