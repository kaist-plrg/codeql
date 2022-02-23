private import cpp.cpp

// WARNING: these flags might be changed
// TODO: automatically find those values
predicate flagVarargs(Expr f) { f.toString() = "1" }
predicate flagFastcall(Expr f) { f.toString() = "128" }
predicate flagO(Expr f) { f.toString() = "8" }

class PyMethodDef extends ClassAggregateLiteral {
  
  PyMethodDef() { getActualType().toString() = "PyMethodDef" }
    
  Expr getFieldExprByName(string name) {
    exists(Field f |
      result = getFieldExpr(f)
      and f.toString() = name
    )
  }

  Expr getNameExpr() { result = getFieldExprByName("ml_name") }
  Expr getMethExpr() { result = getFieldExprByName("ml_meth") }
  Expr getFlagExpr() { result = getFieldExprByName("ml_flags") }
  Expr getDocExpr() { result = getFieldExprByName("ml_doc") }

  string getName() { result = getNameExpr().toString() }
  Function getMeth() { result = getMethExpr().(FunctionAccess).getTarget() }
  predicate isVarargs() { flagVarargs(getFlagExpr()) }
  predicate isFastcall() { flagFastcall(getFlagExpr()) }
  predicate isO() { flagO(getFlagExpr()) }
}
