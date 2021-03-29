import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

private newtype TNode =
  TJavaNode(JAVA::Node n)
  or
  TCppNode(CPP::Node n)
  or
  TJavaMethodNode(JAVA::Method m)
  or
  TJavaClassNode(JAVA::Class c)

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
      if (
        exists(JniCallNode n | n.getCall() = call) and
        call.asCppDataFlowCall().(CPP::Call).getTarget().toString().matches("Call%Method")
      ) then (
        pos = -2 and this.asCppNode().(CPP::ArgumentNode).argumentOf(call.asCppDataFlowCall(), 1)
        or
        pos = -1 and this.asCppNode().(CPP::ArgumentNode).argumentOf(call.asCppDataFlowCall(), 0)
        or
        pos >= 0 and this.asCppNode().(CPP::ArgumentNode).argumentOf(call.asCppDataFlowCall(), pos + 2)
      )
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

class JniCallNode extends ExprNode {
  CPP::FunctionCall call;

  JniCallNode() {
    exists(
      DataFlowCallable jni_function,
      ParameterNode param, //TOOD: Extract this as special param?
      Node qualifier |
      jni_function.isJniFunction() and
      param.isParameterOf(jni_function, -2) and
      call = this.asCppNode().asExpr() and
      localFlow(param, qualifier) and //TODO: make this global flow
      qualifier.asCppNode().asExpr() = call.getQualifier()
    )
  }

  DataFlowCall getCall() { result.asCppDataFlowCall() = call }

  CPP::Function getTarget() { result = call.getTarget() }
}

class JavaMethodNode extends Node, TJavaMethodNode {
  JAVA::Method method;

  JavaMethodNode() { this = TJavaMethodNode(method) }

  override string toString() { result = method.toString() }

  JAVA::Method getMethod() { result = method }

  DataFlowType getType() { result.asJavaDataFlowType() = method.getDeclaringType() }

  override Location getLocation() { result.asJavaLocation() = method.getLocation() }
}

class JavaClassNode extends Node, TJavaClassNode {
  JAVA::Class clazz;

  JavaClassNode() { this = TJavaClassNode(clazz) }

  override string toString() { result = clazz.toString() }

  JAVA::Class getClass() { result = clazz }
}