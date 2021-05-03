import jni.DataFlow::DataFlow
import cpp

from DataFlowCall call
where
  call.asCppDataFlowCall().(CPP::Call).getQualifier().toString().matches("%env%")
  and
  not exists(JniCallNode n | n.getLocation().asCppLocation() = call.asCppDataFlowCall().getLocation())
select call, call.asCppDataFlowCall().getLocation()
