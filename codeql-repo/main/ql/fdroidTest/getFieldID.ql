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
  call.toString().matches("%Get%FieldID")
select
  call,
  concat(int i, string arg | arg = call.getCall().asCppDataFlowCall().(CPP::Call).getArgument(i).toString() | arg, ","),
  call.getLocation(),
  count(JavaFieldNode f | jniGetFieldIDStep(f, call) or jniGetStaticFieldIDStep(f, call) | f)
