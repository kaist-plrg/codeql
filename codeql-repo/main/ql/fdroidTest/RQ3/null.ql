import jni.DataFlow::DataFlow
import java
import cpp

class IsNull extends CPP::BarrierGuard {
  int type;

  IsNull() {
    type=0 and exists(CPP::NULL null |
      this.(CPP::ComparisonOperation).getAChild() = null
    )
    or
    type=1 and exists(CPP::IfStmt ifstmt |
      this = ifstmt.getCondition()
      or
      this = ifstmt.getCondition().(CPP::LogicalAndExpr).getAnOperand()
    )
    or
    type=2 and this instanceof CPP::NotExpr
  }

  override predicate checks(CPP::Expr e, boolean branch) {
    type=0 and e = this.(CPP::ComparisonOperation).getAChild() and branch = [true, false]
    or
    type=1 and e = this and branch = true
    or
    type=2 and e = this.(CPP::NotExpr).getOperand() and branch = false
  }
}

class IsJavaNull extends JAVA::BarrierGuard {
  IsJavaNull() {
    exists(JAVA::NullLiteral null |
      this.(JAVA::EqualityTest).getAChildExpr() = null
    )
  }

  override predicate checks(JAVA::Expr e, boolean branch) {
    branch = [true, false]
    and e = this.(JAVA::EqualityTest).getAChildExpr()
  }
}

class NullConfig extends Configuration {
  NullConfig() { this = "NullConfig" }

  override predicate isSource(Node n) {
    n.asJavaNode().asExpr() instanceof JAVA::NullLiteral
  }

  override predicate isSink(Node n) {
    exists(JniCallNode call |
      n.(ArgumentNode).argumentOf(call.getCall(), _)
      and
      not call.getName().matches("%Delete%")
    )
  }

  override predicate isBarrierGuard(BarrierGuard g) {
    g.asCppBarrierGuard() instanceof IsNull
    or
    g.asJavaBarrierGuard() instanceof IsJavaNull
  }
}

from NullConfig cfg, Node a, Node b
where cfg.hasFlow(a, b)
select a,a.asJavaNode().getLocation().getFile().getAbsolutePath(), b,b.getLocation()
