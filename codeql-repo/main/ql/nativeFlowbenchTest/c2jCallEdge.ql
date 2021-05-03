import jni.DataFlow::DataFlow

/*
from JniCallNode call, DataFlowCallable method
where
call.toString().matches("%Call%Method")
and callEdge(call.getCall(), method)
select call, method
*/

from
  JniCallNode call
where
  call.toString().matches("%Call%Method")
select
  call, call.getLocation(), count(DataFlowCallable method | callEdge(call.getCall(), method) | method)
