import Class

/* DataFlowUtil.qll */
ExprNode exprNode(DataFlowExpr e) { none() }
predicate simpleLocalFlowStep(Node n1, Node n2) { none() }

/* DataFlowPrivate.qll */
predicate clearsContent(Node n, Content c) { none() }
predicate isUnreachableInCall(Node n, DataFlowCall call) { none() }
DataFlowType getNodeType(Node n) { none() }
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { none() }
string ppReprType(DataFlowType t) { none() }
int accessPathLimit() { none() }
predicate nodeIsHidden(Node n) { none() }
predicate jumpStep(Node n1, Node n2) { none() }
predicate storeStep(Node node1, Content f, PostUpdateNode node2) { none() }
predicate readStep(Node node1, Content f, Node node2) { none() }
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { none() }

/* DataFlowDispatch.qll */
DataFlowCallable viableCallable(DataFlowCall c) { none() }
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }
predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable callable) { none() }
