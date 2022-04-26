from module import send
from module2 import send2

def SOURCE():
    return 42
def NOSOURCE():
    return 42

v = SOURCE()
send(v)

v2 = NOSOURCE()
send2(v2)
