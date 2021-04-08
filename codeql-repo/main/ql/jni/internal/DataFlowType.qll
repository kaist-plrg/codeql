import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

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

  Location getLocation() {
    result.asJavaLocation() = this.asJavaDataFlowCallable().getLocation()
    or
    result.asCppLocation() = this.asCppDataFlowCallable().getLocation()
  }

  predicate isJniFunction() { //modified
    this.asCppDataFlowCallable().toString().matches("Java_%")
  }
}

/* modified */
class DataFlowCall extends DataFlowExpr {
  JAVA::DataFlowCall asJavaDataFlowCall() { result = this.asJavaDataFlowExpr().(JAVA::DataFlowCall) }
  CPP::DataFlowCall asCppDataFlowCall() { result = this.asCppDataFlowExpr().(CPP::DataFlowCall) }
  
  DataFlowCall() {
    this.asJavaDataFlowExpr() instanceof JAVA::DataFlowCall
    or
    this.asCppDataFlowExpr() instanceof CPP::DataFlowCall
  }

  DataFlowCallable getEnclosingCallable() {
    result.asJavaDataFlowCallable() = this.asJavaDataFlowCall().getEnclosingCallable()
    or
    result.asCppDataFlowCallable() = this.asCppDataFlowCall().getEnclosingCallable()
  }

  Node getNode() {
    result.asJavaNode() = this.asJavaDataFlowCall().getNode()
    or
    result.asCppNode() = this.asCppDataFlowCall().getNode()
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
