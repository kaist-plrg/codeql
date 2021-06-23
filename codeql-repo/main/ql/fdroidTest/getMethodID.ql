import jni.DataFlow::DataFlow
import cpp

from
  JniCallNode call
where
  call.getName().matches("%GetMethodID")
select
  call.getName(), call.getLocation(), count(JavaMethodNode method | jniGetMethodIDStep(method, call) | method)
