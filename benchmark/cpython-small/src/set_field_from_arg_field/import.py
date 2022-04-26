from module import setField

def SOURCE():
    return 42
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
otherWrapper = Wrapper()
data = Data()
data.setValue(SOURCE())
otherWrapper.setData(data)
dataRet = setField(wrapper, otherWrapper)

SINK(wrapper.getData().getValue())
SINK(dataRet.getValue())
