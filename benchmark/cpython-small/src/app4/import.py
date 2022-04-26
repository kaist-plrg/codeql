from module import f

def SOURCE():
    return 42
def SINK(n):
    print(n)

arg = SOURCE()
ret = f(arg)
SINK(ret)
