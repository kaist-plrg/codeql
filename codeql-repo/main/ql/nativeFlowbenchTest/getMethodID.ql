import jni.DataFlow::DataFlow
import cpp

/*
from
  JavaMethodNode method, JniCallNode call
where
  call.toString().matches("%GetMethodID") and
  jniGetMethodIDStep(method, call)
select
  method, call
*/

from
  JniCallNode call
where
  call.toString().matches("%GetMethodID")
select
  call, concat(call.getCall().asCppDataFlowCall().(CPP::Call).getAnArgument().toString(), ","), call.getLocation(), count(JavaMethodNode method | jniGetMethodIDStep(method, call) | method)
