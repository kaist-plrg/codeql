module JAVA {
  import java.semmle.code.java.dataflow.internal.DataFlowUtil
  import java.semmle.code.java.dataflow.internal.DataFlowPrivate
  import java.semmle.code.java.dataflow.internal.DataFlowDispatch
}

module CPP {
  import cpp.semmle.code.cpp.dataflow.internal.DataFlowUtil
  import cpp.semmle.code.cpp.dataflow.internal.DataFlowPrivate
  import cpp.semmle.code.cpp.dataflow.internal.DataFlowDispatch
}

module JNI {
  private newtype TUnit =
    TJavaUnit(JAVA::Unit u)
    or
    TCppUnit(CPP::Unit u)
  class Unit extends TUnit {
    JAVA::Unit asJavaUnit() { this = TJavaUnit(result) }
    CPP::Unit asCppUnit() { this = TCppUnit(result) }

    string toString() {
      result = this.asJavaUnit().toString()
      or
      result = this.asCppUnit().toString()
    }
  }

  private newtype TDataFlowCallable =
    TJavaDataFlowCallable(JAVA::DataFlowCallable c)
    or
    TCppDataFlowCallable(CPP::DataFlowCallable c)
  class DataFlowCallable extends TDataFlowCallable {
    JAVA::DataFlowCallable asJavaDataFlowCallable() { this = TJavaDataFlowCallable(result) }
    CPP::DataFlowCallable asCppDataFlowCallable() { this = TCppDataFlowCallable(result) }

    string toString() {
      result = this.asJavaDataFlowCallable().toString()
      or
      result = this.asCppDataFlowCallable().toString()
    }
  }


  private newtype TDataFlowCall =
    TJavaDataFlowCall(JAVA::DataFlowCall c)
    or
    TCppDataFlowCall(CPP::DataFlowCall c)
  class DataFlowCall extends TDataFlowCall {
    JAVA::DataFlowCall asJavaDataFlowCall() { this = TJavaDataFlowCall(result) }
    CPP::DataFlowCall asCppDataFlowCall() { this = TCppDataFlowCall(result) }

    string toString() {
      result = this.asJavaDataFlowCall().toString()
      or
      result = this.asCppDataFlowCall().toString()
    }

    DataFlowCallable getEnclosingCallable() {
      result.asJavaDataFlowCallable() = this.asJavaDataFlowCall().getEnclosingCallable()
      or
      result.asCppDataFlowCallable() = this.asCppDataFlowCall().getEnclosingCallable()
    }
  }

  private newtype TDataFlowType =
    TJavaDataFlowType(JAVA::DataFlowType t)
    or
    TCppDataFlowType(CPP::DataFlowType t)
  class DataFlowType extends TDataFlowType {
    JAVA::DataFlowType asJavaDataFlowType() { this = TJavaDataFlowType(result) }
    CPP::DataFlowType asCppDataFlowType() { this = TCppDataFlowType(result) }

    string toString() {
      result = this.asJavaDataFlowType().toString()
      or
      result = this.asCppDataFlowType().toString()
    }
  }

  private newtype TDataFlowExpr =
    TJavaDataFlowExpr(JAVA::DataFlowExpr e)
    or
    TCppDataFlowExpr(CPP::DataFlowExpr e)
  class DataFlowExpr extends TDataFlowExpr {
    JAVA::DataFlowExpr asJavaDataFlowExpr() { this = TJavaDataFlowExpr(result) }
    CPP::DataFlowExpr asCppDataFlowExpr() { this = TCppDataFlowExpr(result) }

    string toString() {
      result = this.asJavaDataFlowExpr().toString()
      or
      result = this.asCppDataFlowExpr().toString()
    }
  }

  private newtype TContent =
    TJavaContent(JAVA::Content c)
    or
    TCppContent(CPP::Content c)
  class Content extends TContent {
    JAVA::Content asJavaContent() { this = TJavaContent(result) }
    CPP::Content asCppContent() { this = TCppContent(result) }

    string toString() {
      result = this.asJavaContent().toString()
      or
      result = this.asCppContent().toString()
    }
  }

  private newtype TReturnKind =
    TJavaReturnKind(JAVA::ReturnKind k)
    or
    TCppReturnKind(CPP::ReturnKind k)
  class ReturnKind extends TReturnKind {
    JAVA::ReturnKind asJavaReturnKind() { this = TJavaReturnKind(result) }
    CPP::ReturnKind asCppReturnKind() { this = TCppReturnKind(result) }

    string toString() {
      result = this.asJavaReturnKind().toString()
      or
      result = this.asCppReturnKind().toString()
    }
  }


  private newtype TNode =
    TJavaNode(JAVA::Node n)
    or
    TCppNode(CPP::Node n)
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
  }

  class ParameterNode extends Node {
    ParameterNode() {
      this.asJavaNode() instanceof JAVA::ParameterNode
      or
      this.asCppNode() instanceof CPP::ParameterNode
    }

    predicate isParameterOf(DataFlowCallable c, int pos){
      this.asJavaNode().(JAVA::ParameterNode).isParameterOf(c.asJavaDataFlowCallable(), pos)
      or
      this.asCppNode().(CPP::ParameterNode).isParameterOf(c.asCppDataFlowCallable(), pos)
    }
  }

  class ArgumentNode extends Node {
    ArgumentNode() {
      this.asJavaNode() instanceof JAVA::ArgumentNode
      or
      this.asCppNode() instanceof CPP::ArgumentNode
    }

    predicate argumentOf(DataFlowCall call, int pos) {
      this.asJavaNode().(JAVA::ArgumentNode).argumentOf(call.asJavaDataFlowCall(), pos)
      or
      this.asCppNode().(CPP::ArgumentNode).argumentOf(call.asCppDataFlowCall(), pos)
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

  class ExprNode extends Node {
    ExprNode() {
      this.asJavaNode() instanceof JAVA::ExprNode
      or
      this.asCppNode() instanceof CPP::ExprNode
    }
  }

  newtype TBarrierGuard =
    TJavaBarrierGuard(JAVA::BarrierGuard g)
    or
    TCppBarrierGuard(CPP::BarrierGuard g)

  class BarrierGuard extends TBarrierGuard {
    JAVA::BarrierGuard asJavaBarrierGuard() { this = TJavaBarrierGuard(result) }
    CPP::BarrierGuard asCppBarrierGuard() { this = TCppBarrierGuard(result) }

    string toString() {
      result = this.asJavaBarrierGuard().toString()
      or
      result = this.asCppBarrierGuard().toString()
    }
    
    Node getAGuardedNode() {
      result.asJavaNode() = this.asJavaBarrierGuard().getAGuardedNode()
      or
      result.asCppNode() = this.asCppBarrierGuard().getAGuardedNode()
    }
  }
}
