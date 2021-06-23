import jni.DataFlow::DataFlow

from JniCallNode n 
where n.getName().matches("%GetObjectClass")
select n, n.getLocation() as loc, count(JavaClassNode c | jniGetObjectClassStep(c, n) | c)
order by loc

