from module import send

def SOURCE():
    return 42

def NOSOURCE():
    return 43

class ComplexData:
    def getData(self):
        return self.data
    def setData(self, data):
        self.data = data
    def getOther(self):
        return self.other
    def setOther(self, other):
        self.other = other

data = ComplexData()

data.setData(SOURCE());
data.setOther(NOSOURCE());

send(data)
