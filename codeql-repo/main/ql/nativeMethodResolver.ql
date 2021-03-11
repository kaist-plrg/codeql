import java
import cpp

from JAVA::Method m, CPP::Function f
where
  m.isNative()
and
  f.toString().matches("Java_%_" + m.toString())
select "Native method", m, "resolves to", f
