import jni.DataFlow::DataFlow
import jni.internal.DataFlowInnerFlow
import cpp

from
  CPP::Location loc, string name
where
  exists(JniCallNode call |
    loc = call.getLocation().asCppLocation()
    and name = call.getName()
    and name.matches("_et%Field")
  )
select
  name,
  loc,
  count(ArgumentNode f |
    exists(JniCallNode call |
      f = call.getArgument(1)
      and loc = call.getLocation().asCppLocation()
      and (
        exists(getJavaFieldNode(f))
        or
        exists(getJavaStaticFieldNode(f))
      )
    )
  )

/*
from
  JniCallNode call, string name
where
  name = call.getName()
  and name.matches("_et%Field")
select
  name,
  count(ArgumentNode f |
    f = call.getArgument(1) and
    (
      exists(getJavaFieldNode(f))
      or
      exists(getJavaStaticFieldNode(f))
    )
  )
*/
