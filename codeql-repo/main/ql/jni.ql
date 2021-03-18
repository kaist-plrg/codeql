module JAVA {
  import java.semmle.code.java.dataflow.DataFlow::DataFlow
}
module CPP {
  import cpp.semmle.code.cpp.dataflow.DataFlow::DataFlow
}
module JNI {
  import jni.DataFlow::DataFlow
}

from JNI::ExprNode src, JNI::ExprNode sink
where JNI::localFlow(src, sink)
select src, sink
