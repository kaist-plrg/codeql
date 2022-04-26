from module import send

def SOURCE():
    return 42
def NOSOURCE():
    return 43

arr = [NOSOURCE()] * 10
arr[1] = SOURCE()
send(arr)
