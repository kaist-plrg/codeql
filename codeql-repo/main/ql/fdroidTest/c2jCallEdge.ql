import jni.DataFlow::DataFlow
import cpp

from
  CPP::Location loc, string name
where
  exists(JniCallNode call |
    loc = call.getLocation().asCppLocation()
    and name = call.getName()
    and name.matches("Call%Method")
  )
select
  name,
  loc,
  count(DataFlowCallable method |
    exists(JniCallNode call | loc = call.getLocation().asCppLocation() and callEdge(call.getCall(), method))
  )
