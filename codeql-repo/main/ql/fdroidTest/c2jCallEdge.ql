import jni.DataFlow::DataFlow

from
  JniCallNode call
where
  call.getName().matches("%Call%Method")
select
  call.getName(), call.getLocation(), count(DataFlowCallable method | callEdge(call.getCall(), method) | method)
