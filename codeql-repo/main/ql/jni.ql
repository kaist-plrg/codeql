module JAVA {
  import java.semmle.code.java.dataflow.DataFlow::DataFlow
}
module CPP {
  import cpp.semmle.code.cpp.dataflow.DataFlow::DataFlow
}
module JNI {
  import jni.DataFlow::DataFlow
}

bindingset [name]
predicate isMyFile(string name) {
  name.matches("%HelloJNI%")
}

class MyConfig extends JNI::Configuration {
  MyConfig() { this = "MyConfig" }

  override predicate isSource(JNI::Node source) {
    isMyFile(source.asJavaNode().asExpr().getFile().toString())
    or
    isMyFile(source.asCppNode().asExpr().getFile().toString())
  }

  override predicate isSink(JNI::Node sink) {
    isMyFile(sink.asJavaNode().asParameter().getFile().toString())
    or
    isMyFile(sink.asCppNode().asParameter().getFile().toString())
  }
}

from MyConfig config, JNI::Node src, JNI::Node sink
where config.hasFlow(src, sink)
select src, sink
