import jni.DataFlow::DataFlow
import cpp
import java

class LeakConfig extends Configuration {
  LeakConfig() { this = "LeakConfig" }

  override predicate isSource(Node source) {
    exists(DataFlowCallable m |
      m.asJavaDataFlowCallable().getName() = "getDeviceId" and
      (
        callEdge(source.asExpr(), m)
        or
        source.asJavaNode().asExpr().(JAVA::Call).getCallee() = m.asJavaDataFlowCallable()
      )
    )
  }

  override predicate isSink(Node sink) {
    exists(CPP::Call call |
      call.toString().matches("%__android_log_print%") |
      sink.asCppNode().asExpr() = call.getAnArgument()
    )
    or
    exists(JAVA::Call call |
      call.getQualifier().toString() = "Log" |
      sink.asJavaNode().asExpr() = call.getAnArgument()
    )
  }
}

from LeakConfig leakConfig, Node src, ArgumentNode sink, DataFlowCall call
where
  leakConfig.hasFlow(src, sink) and
  sink.argumentOf(call, _)
select src, src.getLocation(), call, sink.getLocation()
