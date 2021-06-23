import jni.DataFlow::DataFlow

from
  JniCallNode call
where
  call.getName().matches("%Get%FieldID")
select
  call.getName(), call.getLocation(), count(JavaFieldNode f | jniGetFieldIDStep(f, call) or jniGetStaticFieldIDStep(f, call) | f)
