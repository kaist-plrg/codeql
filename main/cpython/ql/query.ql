module P {
  import python.python
}

module C {
  import cpp.cpp
}

from string tag, string res
where
  tag = "cpp" and exists(C::Expr c | res = c.toString())
  or
  tag = "python" and exists(P::Expr p | res = p.toString())
select tag, res

