import cpp
import java

bindingset[str]
predicate isHelloJNI(string str) {
  str.matches("%HelloJNI%")
}

from CPP::Expr e1, JAVA::Expr e2, string s
where
  isHelloJNI(e1.getFile().toString()) and s = e1.toString()
or
  isHelloJNI(e2.getFile().toString()) and s = e2.toString()
select s
