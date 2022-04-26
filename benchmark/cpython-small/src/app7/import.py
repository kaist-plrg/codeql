from module import Object

def SOURCE():
    return 42
def SINK(n):
    print(n)

obj = Object()
v = SOURCE()

obj.f1 = v
obj.f()
SINK(obj.f2)
