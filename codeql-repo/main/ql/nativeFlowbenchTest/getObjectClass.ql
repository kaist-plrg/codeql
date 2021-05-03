import jni.DataFlow::DataFlow

/*
from JavaClassNode c, JniCallNode n
where jniGetObjectClassStep(c, n)
select n, n.getLocation() as loc, c, c.getClass().getFile().getAbsolutePath()
order by loc
*/

from JniCallNode n 
where n.toString().matches("%GetObjectClass")
select n, n.getLocation() as loc, count(JavaClassNode c | jniGetObjectClassStep(c, n) | c)
order by loc

