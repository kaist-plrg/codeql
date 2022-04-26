from module import setField

def SINK(n):
    print(n)

class Data:
    def setValue(self, value):
        self.value = value
    def getValue(self):
        return self.value
class Wrapper:
    def setData(self, data):
        self.data = data
    def getData(self):
        return self.data

wrapper = Wrapper()
wrapper.setData(Data())
dataRet = setField(wrapper)

SINK(wrapper.getData().getValue())
SINK(dataRet.getValue())
