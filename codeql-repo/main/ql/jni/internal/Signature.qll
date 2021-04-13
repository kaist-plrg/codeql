bindingset[sig]
string handleMethodSignature(string sig) {
  exists(int st, int fn |
    "(" = sig.charAt(st) and
    ")" = sig.charAt(fn) |
    result = handleArgs(sig.substring(st + 1, fn))
  )
}

bindingset[args]
string handleArgs(string args) {
  if args = ""
  then result = ""
  else result = concat(string arg, int n | arg = args.splitAt(",", n) | handleType(arg) order by n)
}

bindingset[ty]
string handleType(string ty) {
  exists(int idx | 
    idx = min(int i | "[" = ty.charAt(i) or i = ty.length() | i) |
    result = concat(int i | "[" = ty.charAt(i) | "[") + handleAtomicType(ty.prefix(idx))
  )
}

bindingset[ty]
string handleAtomicType(string ty) {
  if ty = "boolean"
  then result = "Z"

  else if ty = "byte"
  then result = "B"

  else if ty = "char"
  then result = "C"

  else if ty = "short"
  then result = "S"

  else if ty = "int"
  then result = "I"

  else if ty = "long"
  then result = "J"

  else if ty = "float"
  then result = "F"

  else if ty = "double"
  then result = "D"

  else result = "L" + ty.replaceAll(".", "/") + ";"
}
