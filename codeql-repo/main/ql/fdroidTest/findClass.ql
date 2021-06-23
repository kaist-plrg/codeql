import jni.DataFlow::DataFlow

from JniCallNode n
where n.getName().matches("%FindClass")
select n.getName(), n.getLocation(), count(JavaClassNode c | jniFindClassStep(c, n) | c)
