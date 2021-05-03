import jni.DataFlow::DataFlow

//import java
/*
from JniCallNode call, DataFlowCallable method
where
call.toString().matches("%Call%Method")
and callEdge(call.getCall(), method)
select call, method
*/

from
   DataFlowCall call
where
  call.asJavaDataFlowCall().getCallee().isNative()
select
  call, call.asJavaDataFlowCall().getLocation().getFile().getAbsolutePath(), count(DataFlowCallable f | callEdge(call, f) | f.asCppDataFlowCallable())
