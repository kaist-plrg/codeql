import jni.DataFlow::DataFlow
import java
import cpp

bindingset[jt, ct]
predicate compatibleBaseJavaCppType(string jt, string ct) {
  if jt = "void"
  then ct = "void"
  
  else if jt in ["boolean", "byte", "char", "short", "int", "long", "float", "double"]
  then (
    ct = "j"+jt
    or
    ct = jt
    or
    ct + "ean" = jt //boolean
  )

  else (
    jt = "String" and ct="jstring"
    or
    ct = "jobject"
  )
}

bindingset[jt, ct]
predicate compatibleJavaCppType(string jt, string ct) {
  compatibleBaseJavaCppType(jt, ct)
  or
  exists(string basejt, string basect |
    compatibleBaseJavaCppType(basejt, basect)
    and
    (
      jt = basejt + "[]" and ct = basect + "Array"
      or
      jt = basejt and ct = "const " + basect
    )
  )
  or
  jt.matches("%[]") and ct = "jarray"
  or
  ct = jt+"Type"
}

from
   DataFlowCall call, JAVA::Callable m, DataFlowCallable f, string t1, string t2, string ty
where
  m = call.asJavaDataFlowCall().getCallee()
  and m.isNative()
  and m.getDeclaringType().fromSource()
  and callEdge(call, f)
  and
  (
    ty="return" 
    and t1 = m.getReturnType().toString()
    and t2 = f.asCppDataFlowCallable().getType().toString()
    and not compatibleJavaCppType(t1, t2)
    or
    ty="arg"
    and exists(int i, JAVA::Parameter p1, CPP::ParameterNode p2 |
      p1.getCallable() = m
      and p1.getPosition() = i
      and p2.isParameterOf(f.asCppDataFlowCallable(), i+2)
      and t1=p1.getType().toString()
      and t2=p2.getType().toString()
      and not compatibleJavaCppType(t1, t2)
    )
  )
select
  ty, m, t1, f, t2
