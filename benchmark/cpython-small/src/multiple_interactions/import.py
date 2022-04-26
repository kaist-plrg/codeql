from module import propagate, leak

def SOURCE():
    return 42

class Data:
    pass

def toNative(d, v):
    d.v = v
    propagate(d, toNativeAgain)

def toNativeAgain(v):
    leak(v)

data = Data()

toNative(data, SOURCE())
