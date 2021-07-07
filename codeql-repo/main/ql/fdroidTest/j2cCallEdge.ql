import jni.DataFlow::DataFlow
import java
import cpp

from
   DataFlowCall call, JAVA::Callable callee
where
  callee = call.asJavaDataFlowCall().getCallee()
  and callee.isNative()
  and callee.getDeclaringType().fromSource()
select
  call,
  count(CPP::Location loc |
    exists(DataFlowCallable f | callEdge(call, f) and loc = f.asCppDataFlowCallable().getLocation())
  )
