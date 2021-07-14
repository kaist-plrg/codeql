import jni.DataFlow::DataFlow
import cpp

from
  JniCallNode call
where
  call.getName().matches("%GetStaticMethodID")
select
  call.getName(), call.getLocation(), count(JavaMethodNode method | jniGetStaticMethodIDStep(method, call) | method)
