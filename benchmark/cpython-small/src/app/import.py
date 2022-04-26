from module import f, g, Object

def identity(x):
  return x

val0 = 42
val1 = f(val0)
val2 = g(val1, identity)

obj = Object()
obj.h(val2)
val3 = obj.field

print(val3)
