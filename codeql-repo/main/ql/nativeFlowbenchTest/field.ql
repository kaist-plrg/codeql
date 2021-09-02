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
  count(JavaFieldNode f |
    exists(JniCallNode call, ArgumentNode arg |
      arg = call.getArgument(1)
      and loc = call.getLocation().asCppLocation()
      and (
        f = getJavaFieldNode(arg)
        or
        f = getJavaStaticFieldNode(arg)
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
