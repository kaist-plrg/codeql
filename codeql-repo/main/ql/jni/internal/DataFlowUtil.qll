import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

predicate simpleLocalFlowStep(Node node1, Node node2) {
  JAVA::simpleLocalFlowStep(node1.asJavaNode(), node2.asJavaNode())
  or
  CPP::simpleLocalFlowStep(node1.asCppNode(), node2.asCppNode())
  or
  jniStringStep(node1, node2)
  or
  jniNewGlobalRefStep(node1, node2)
}

predicate localFlowStep(Node node1, Node node2) {
  JAVA::localFlowStep(node1.asJavaNode(), node2.asJavaNode())
  or
  CPP::localFlowStep(node1.asCppNode(), node2.asCppNode())
  or
  simpleLocalFlowStep(node1, node2)
}

predicate localFlow(Node node1, Node node2) = fastTC(localFlowStep/2)(node1, node2)
predicate simpleLocalFlow(Node node1, Node node2) = fastTC(simpleLocalFlowStep/2)(node1, node2)

pragma[inline]
predicate callEdge(DataFlowCall call, DataFlowCallable callable) {
  callable = viableCallable(call)
}
