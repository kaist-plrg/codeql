import jni.DataFlow::DataFlow
import java

/*
from JniCallNode call, DataFlowCallable method
where
call.toString().matches("%Call%Method")
and callEdge(call.getCall(), method)
select call, method
*/

from
   DataFlowCall call, JAVA::Callable callee
where
  callee = call.asJavaDataFlowCall().getCallee()
  and callee.isNative()
  and callee.getDeclaringType().fromSource()
select
  call, call.asJavaDataFlowCall().getLocation().getFile().getAbsolutePath(), count(DataFlowCallable f | callEdge(call, f) | f.asCppDataFlowCallable())
