from module import sourceClean

def NOSOURCE():
    return 43
def SINK(n):
    print(n)

class Data:
    def getValue(self):
        return self.value
    def setValue(self, value):
        self.value = value

data = Data()

data.setValue(NOSOURCE());
sourceClean(data)
SINK(data.getValue())
