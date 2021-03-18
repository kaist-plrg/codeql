module CPP {
  import cpp.semmle.code.cpp.dataflow.internal.DataFlowUtil
  import cpp.semmle.code.cpp.dataflow.internal.DataFlowPrivate
  import cpp.semmle.code.cpp.dataflow.internal.DataFlowDispatch
}

module JAVA {
  import java.semmle.code.java.dataflow.internal.DataFlowUtil
  import java.semmle.code.java.dataflow.internal.DataFlowPrivate
  import java.semmle.code.java.dataflow.internal.DataFlowDispatch
}

module JNI {
  class Unit = JAVA::Unit;
  class DataFlowCallable = JAVA::DataFlowCallable;

  /*
  class DataFlowCall extends Mt {
    DataFlowCallable getEnclosingCallable() { none() }
  }*/
  class DataFlowCall = JAVA::DataFlowCall;
  class DataFlowType = JAVA::DataFlowType;
  class DataFlowExpr = JAVA::DataFlowExpr;
  class Content = JAVA::Content;
  class ReturnKind = JAVA::ReturnKind;

  /*
  class Node extends Mt {
    DataFlowCallable getEnclosingCallable() { none() }
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      none()
    }
  }
  */
  class Node = JAVA::Node;

  /*
  class ParameterNode extends Node {
    abstract predicate isParameterOf(DataFlowCallable c, int pos);
  }
  */
  class ParameterNode = JAVA::ParameterNode;

  /*
  class ArgumentNode extends Node {
    predicate argumentOf(DataFlowCall call, int pos) { none() }
  }
  */
  class ArgumentNode = JAVA::ArgumentNode;

  /*
  class ReturnNode extends Node {
    ReturnKind getKind() { none() }
  }
  */
  class ReturnNode = JAVA::ReturnNode;

  /*
  class PostUpdateNode extends Node {
    abstract Node getPreUpdateNode();
  }
  */
  class PostUpdateNode = JAVA::PostUpdateNode;

  class CastNode = JAVA::CastNode;
  class OutNode = JAVA::OutNode;
  class ExprNode = JAVA::ExprNode;

  /*
  class BarrierGuard extends Mt {
    Node getAGuardedNode() { none() }
  }
  */
  class BarrierGuard = JAVA::BarrierGuard;
}
