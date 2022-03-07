from cmodule import f, g

def identity(x):
  return x

val0 = 42;
val1 = f(val0);
val2 = g(val1, identity);

print(val2)
