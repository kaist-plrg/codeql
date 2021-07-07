private import java.java

pragma[noinline]
string getHandledSignature(Callable m) {
  result = handleMethodSignature(m.getSignature())
}

bindingset[sig]
string handleMethodSignature(string sig) {
  exists(string temp, string args |
    temp = sig.splitAt("(", 1)
    and args = temp.prefix(temp.length()-1)
    and result = handleArgs(args)
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
  if ty.matches("%]")
  then exists(string brackets, int offset |
    brackets = ty.regexpFind("(\\[\\])+", _, offset) and
    result = concat(int i | i = [1 .. brackets.length()/2] | "[") + handleAtomicType(ty.prefix(offset))
  )
  else result = handleAtomicType(ty)
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
