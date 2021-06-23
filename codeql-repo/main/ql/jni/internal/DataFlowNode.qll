import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

private newtype TNode =
  TJavaNode(JAVA::Node n)
  or
  TCppNode(CPP::Node n)
  or
  TJavaMethodNode(JAVA::Callable c)
  or
  TJavaClassNode(JAVA::Class c)
  or
  TJavaFieldNode(JAVA::Field f)

class Node extends TNode {
  JAVA::Node asJavaNode() { this = TJavaNode(result) }
  CPP::Node asCppNode() { this = TCppNode(result) }

  string toString() {
    result = this.asJavaNode().toString()
    or
    result = this.asCppNode().toString()
  }

  DataFlowCallable getEnclosingCallable() {
    result.asJavaDataFlowCallable() = this.asJavaNode().getEnclosingCallable()
    or
    result.asCppDataFlowCallable() = this.asCppNode().getEnclosingCallable()
  }
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.asJavaNode().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    or
    this.asCppNode().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
  Location getLocation() {
    result.asJavaLocation() = this.asJavaNode().getLocation()
    or
    result.asCppLocation() = this.asCppNode().getLocation()
  }
  DataFlowType getType() {
    none()
  }
  DataFlowExpr asExpr() {
    result.asJavaDataFlowExpr() = this.asJavaNode().asExpr()
    or
    result.asCppDataFlowExpr() = this.asCppNode().asExpr()
  }
}

class ParameterNode extends Node {
  ParameterNode() {
    this.asJavaNode() instanceof JAVA::ParameterNode
    or
    this.asCppNode() instanceof CPP::ParameterNode
  }

  predicate isParameterOf(DataFlowCallable c, int pos){ //modified
    this.asJavaNode().(JAVA::ParameterNode).isParameterOf(c.asJavaDataFlowCallable(), pos)
    or
    (
      if c.isJniFunction()
      then this.asCppNode().(CPP::ParameterNode).isParameterOf(c.asCppDataFlowCallable(), pos + 2) 
      else this.asCppNode().(CPP::ParameterNode).isParameterOf(c.asCppDataFlowCallable(), pos)
    )
  }
}

class ArgumentNode extends Node {
  ArgumentNode() {
    this.asJavaNode() instanceof JAVA::ArgumentNode
    or
    this.asCppNode() instanceof CPP::ArgumentNode
  }

  predicate argumentOf(DataFlowCall call, int pos) { //modified
    this.asJavaNode().(JAVA::ArgumentNode).argumentOf(call.asJavaDataFlowCall(), pos)
    or
    (
      if
        exists(JniCallNode n | n.getCall() = call | this = n.getArgument(pos))
      then
        any()
      else
        this.asCppNode().(CPP::ArgumentNode).argumentOf(call.asCppDataFlowCall(), pos)
    )
  }
}

class ReturnNode extends Node {
  ReturnNode() {
    this.asJavaNode() instanceof JAVA::ReturnNode
    or
    this.asCppNode() instanceof CPP::ReturnNode
  }
  
  ReturnKind getKind() {
    result.asJavaReturnKind() = this.asJavaNode().(JAVA::ReturnNode).getKind()
    or
    result.asCppReturnKind() = this.asCppNode().(CPP::ReturnNode).getKind()
  }
}

class PostUpdateNode extends Node {
  PostUpdateNode() {
    this.asJavaNode() instanceof JAVA::PostUpdateNode
    or
    this.asCppNode() instanceof CPP::PostUpdateNode
  }

  Node getPreUpdateNode() {
    result.asJavaNode() = this.asJavaNode().(JAVA::PostUpdateNode).getPreUpdateNode()
    or
    result.asCppNode() = this.asCppNode().(CPP::PostUpdateNode).getPreUpdateNode()
  }
}

class CastNode extends Node {
  CastNode() {
    this.asJavaNode() instanceof JAVA::CastNode
    or
    this.asCppNode() instanceof CPP::CastNode
  }
}

class OutNode extends Node {
  OutNode() {
    this.asJavaNode() instanceof JAVA::OutNode
    or
    this.asCppNode() instanceof CPP::OutNode
  }
}
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { //modified
  result.asJavaNode().(JAVA::OutNode) = JAVA::getAnOutNode(call.asJavaDataFlowCall(), kind.asJavaReturnKind())
  or
  result.asCppNode().(CPP::OutNode) = CPP::getAnOutNode(call.asCppDataFlowCall(), kind.asCppReturnKind())
  or
  result = call.getNode() and kind.isNormalReturnKind()
}

class ExprNode extends Node {
  ExprNode() {
    this.asJavaNode() instanceof JAVA::ExprNode
    or
    this.asCppNode() instanceof CPP::ExprNode
  }
}
ExprNode exprNode(DataFlowExpr e) {
  result.asJavaNode().(JAVA::ExprNode) = JAVA::exprNode(e.asJavaDataFlowExpr())
  or
  result.asCppNode().(CPP::ExprNode) = CPP::exprNode(e.asCppDataFlowExpr())
}

/* custom classes */

private predicate isJniEnv(CPP::Expr e) {
  e.getType().toString() = "JNIEnv *"
}

class JniCallNode extends ExprNode {
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

  ArgumentNode getArgument(int pos) {
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
      is_cpp = true and result.asCppNode().(CPP::ArgumentNode).argumentOf(call, i)
      or
      is_cpp = false and result.asCppNode().(CPP::ArgumentNode).argumentOf(call, i + 1)
    )
  }
}

class JavaClassNode extends Node, TJavaClassNode {
  JAVA::Class clazz;

  JavaClassNode() { this = TJavaClassNode(clazz) }

  override string toString() { result = clazz.toString() }

  JAVA::Class getClass() { result = clazz }
  
  override DataFlowType getType() { result.asJavaDataFlowType() = clazz }

  override Location getLocation() { result.asJavaLocation() = clazz.getLocation() }
}

class JavaMethodNode extends Node, TJavaMethodNode {
  JAVA::Callable callable;
  JAVA::Class clazz;

  JavaMethodNode() {
    this = TJavaMethodNode(callable) and
    clazz = callable.getDeclaringType()
  }

  predicate isConstructor() { callable instanceof JAVA::Constructor }

  override string toString() { result = callable.toString() }

  JAVA::Callable getMethod() { result = callable }
  JAVA::Class getClass() { result = clazz }

  override DataFlowType getType() { result.asJavaDataFlowType() = clazz }

  override Location getLocation() { result.asJavaLocation() = callable.getLocation() }
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
  
  override DataFlowType getType() { result.asJavaDataFlowType() = clazz }
  
  override Location getLocation() { result.asJavaLocation() = field.getLocation() }
}
