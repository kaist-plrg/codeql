import jni.DataFlow::DataFlow

/*
from JavaClassNode c, JniCallNode n
where jniFindClassStep(c, n)
select c, n, n.getLocation()
*/

from JniCallNode n
where n.toString().matches("%FindClass")
select n, n.getLocation(), count(JavaClassNode c | jniFindClassStep(c, n) | c)
