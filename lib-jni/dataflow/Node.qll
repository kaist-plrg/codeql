import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

private predicate isJniEnv(CPP::Expr e) {
  e.getType().toString() = "JNIEnv *"
}

class JniCallNode extends Node {
  CPP::Call call;
  boolean is_cpp;

  JniCallNode() {
    call = this.asCppNode().asExpr() and
    (
      is_cpp = true and
      isJniEnv(call.(CPP::FunctionCall).getQualifier())
      or
      is_cpp = false and
      isJniEnv(call.(CPP::ExprCall).getArgument(0))
    )
  }

  DataFlowCall getCall() { result.asCppDataFlowCall() = call }

  string getName() {
    if is_cpp = true
    then result = call.getTarget().toString()
    else result = call.(CPP::ExprCall).getExpr().toString()
  }

  Node getArgument(int pos) {
    exists(int i
      | 
      if getName().matches("Call%Method")
      then (
        pos = -2 and i = 1
        or
        pos = -1 and i = 0
        or
        pos >= 0 and i = pos + 2
      )
      else (
        pos = i and pos >= 0
      )
      |
      is_cpp = true and CPP::isArgumentNode(result.asCppNode(), call, i)
      or
      is_cpp = false and CPP::isArgumentNode(result.asCppNode(), call, i + 1)
    )
  }
}

class JavaClassNode extends Node, TJavaClassNode {
  JAVA::Class clazz;

  JavaClassNode() { this = TJavaClassNode(clazz) }

  override string toString() { result = clazz.toString() }

  JAVA::Class getClass() { result = clazz }
  
  //override DataFlowType getType() { result.asJavaDataFlowType() = clazz }

  override string getLocation() { result = clazz.getLocation().toString() }
}

class JavaMethodNode extends Node, TJavaMethodNode {
  JAVA::Callable callable;
  JAVA::Class clazz;

  JavaMethodNode() {
    this = TJavaMethodNode(callable) and
    clazz = callable.getDeclaringType()
  }

  override string toString() { result = callable.toString() }

  //override DataFlowType getType() { result.asJavaDataFlowType() = clazz }

  override string getLocation() { result = callable.getLocation().toString() }
  
  JAVA::Callable getMethod() { result = callable }
  JAVA::Class getClass() { result = clazz }
  predicate isConstructor() { callable instanceof JAVA::Constructor }
  predicate isStatic() { callable.isStatic() }
}

class JavaFieldNode extends Node, TJavaFieldNode {
  JAVA::Field field;
  JAVA::Class clazz;

  JavaFieldNode() {
    this = TJavaFieldNode(field) and
    clazz = field.getDeclaringType()
  }

  override string toString() { result = field.toString() }

  JAVA::InstanceField getField() { result = field.(JAVA::InstanceField) }
  JAVA::Field getStaticField() { result = field and field.isStatic() }
  JAVA::Class getClass() { result = clazz }
  
  //override DataFlowType getType() { result.asJavaDataFlowType() = clazz }
  
  override string getLocation() { result = field.getLocation().toString() }
}
