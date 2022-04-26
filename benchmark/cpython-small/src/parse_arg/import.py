from module import f1, f2, f3

def SOURCE():
    return 42

def NOSOURCE():
    return 43

arg1 = NOSOURCE()
arg2 = SOURCE()

f1(arg1, arg2)
f2(arg1, arg2)
f3(arg1, arg2)
