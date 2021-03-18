private newtype TMt = TMkMt()
class Mt extends TMt {
  string toString() { result = "unit" }
}

class Unit = Mt;
class DataFlowCallable = Mt;
class DataFlowCall extends Mt {
  DataFlowCallable getEnclosingCallable() { none() }
}
class DataFlowType = Mt;
class DataFlowExpr = Mt;
class Content = Mt;
class ReturnKind = Mt;

class Node extends Mt {
  DataFlowCallable getEnclosingCallable() { none() }
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    none()
  }
}

class ParameterNode extends Node {
  abstract predicate isParameterOf(DataFlowCallable c, int pos);
}
class ArgumentNode extends Node {
  predicate argumentOf(DataFlowCall call, int pos) { none() }
}
class ReturnNode extends Node {
  ReturnKind getKind() { none() }
}
class PostUpdateNode extends Node {
  abstract Node getPreUpdateNode();
}
class CastNode = Node;
class OutNode = Node;
class ExprNode = Node;

class BarrierGuard extends Mt {
  Node getAGuardedNode() { none() }
}
