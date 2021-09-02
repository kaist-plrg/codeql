import experiment

predicate tuple(string ty, string loc, int cnt) {
  ty = "j2c" and exists(DataFlowCall c | 
    loc = c.asJavaDataFlowCall().getLocation().toString()
    and j2c_count(c, cnt)
  )
  or
  ty = "c2j" and exists(CPP::Location l | 
    loc = l.toString()
    and c2j_count(l, cnt)
  )
  or
  ty = "field" and exists(CPP::Location l | 
    loc = l.toString()
    and field_count(l, cnt)
  )
}

from
  int j2c1, int j2c2, int j2c3,
  int c2j1, int c2j2, int c2j3,
  int field1, int field2, int field3
where
  j2c1 = count(string loc |
    tuple("j2c", loc, 1)
  )
  and
  j2c2 = count(string loc, int cnt |
    tuple("j2c", loc, cnt)
    and cnt > 0
  )
  and
  j2c3 = count(string loc |
    tuple("j2c", loc, _)
  )
  and
  c2j1 = count(string loc |
    tuple("c2j", loc, 1)
  )
  and
  c2j2 = count(string loc, int cnt |
    tuple("c2j", loc, cnt)
    and cnt > 0
  )
  and
  c2j3 = count(string loc |
    tuple("c2j", loc, _)
  )
  and
  field1 = count(string loc |
    tuple("field", loc, 1)
  )
  and
  field2 = count(string loc, int cnt |
    tuple("field", loc, cnt)
    and cnt > 0
  )
  and
  field3 = count(string loc |
    tuple("field", loc, _)
  )
select
  j2c1, j2c2, j2c3, c2j1, c2j2, c2j3, field1, field2, field3
