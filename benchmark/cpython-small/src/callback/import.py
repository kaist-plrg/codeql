from module import f

def SOURCE():
    return 42

def NOSOURCE():
    return 43

def return_second(p1, p2):
    return p2

arg1 = NOSOURCE()
arg2 = SOURCE()

f(return_second, arg1, arg2)
