private import cpp.cpp

// WARNING: these flags might be changed
// TODO: automatically find those values
private predicate flagVarargs(Expr f) { f.toString() = "1" }
private predicate flagFastcall(Expr f) { f.toString() = "128" }
private predicate flagO(Expr f) { f.toString() = "8" }

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

class PyMemberDef extends ClassAggregateLiteral {
  
  PyMemberDef() { getActualType().toString() = "PyMemberDef" }
    
  Expr getFieldExprByName(string name) {
    exists(Field f |
      result = getFieldExpr(f)
      and f.toString() = name
    )
  }

  Expr getNameExpr() { result = getFieldExprByName("name") }
  Expr getTypeExpr() { result = getFieldExprByName("type") }
  Expr getOffsetExpr() { result = getFieldExprByName("offset") }

  string getName() { result = getNameExpr().toString() }
  Struct getBase() { result.toString() = getOffsetExpr().getChild(0).toString() }
  Field getField() { result = getOffsetExpr().getChild(1).(FieldAccess).getTarget() }
}

class PyTypeObject extends ClassAggregateLiteral {
  
  /* PyTypeObject */
  PyTypeObject() { getActualType().toString() = "_typeobject" }
    
  Expr getFieldExprByName(string name) {
    exists(Field f |
      result = getFieldExpr(f)
      and f.toString() = name
    )
  }

  Expr getNameExpr() { result = getFieldExprByName("tp_name") }
  Expr getNewMethExpr() { result = getFieldExprByName("tp_new") }
  Expr getInitMethExpr() { result = getFieldExprByName("tp_init") }

  string getName() { result = getNameExpr().toString().splitAt(".", 1) }
  Function getNewMeth() { result = getNewMethExpr().(FunctionAccess).getTarget() }
  Function getInitMeth() { result = getInitMethExpr().(FunctionAccess).getTarget() }
}
