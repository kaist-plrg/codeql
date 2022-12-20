# patch python library
cp patched/DataFlowPrivate.qll python/semmle/python/dataflow/new/internal/DataFlowPrivate.qll
cp patched/Flow.qll python/semmle/python/Flow.qll
cp patched/Function.qll python/semmle/python/Function.qll

#patch cpp library
cp patched/DataFlowUtil.qll cpp/semmle/code/cpp/dataflow/internal/DataFlowUtil.qll
