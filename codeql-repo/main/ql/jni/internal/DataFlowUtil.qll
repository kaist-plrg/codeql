import DataFlowImplSpecific::Public
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Original

predicate simpleLocalFlowStep(Node node1, Node node2) {
  JAVA::simpleLocalFlowStep(node1.asJavaNode(), node2.asJavaNode())
  or
  CPP::simpleLocalFlowStep(node1.asCppNode(), node2.asCppNode())
}

predicate localFlowStep(Node node1, Node node2) {
  JAVA::localFlowStep(node1.asJavaNode(), node2.asJavaNode())
  or
  CPP::localFlowStep(node1.asCppNode(), node2.asCppNode())
}

predicate localFlow(Node node1, Node node2) = fastTC(localFlowStep/2)(node1, node2)
