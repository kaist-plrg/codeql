st=${1:-0}
fn=${2:-2}

if [ $st -le 0 ] && [ 0 -le $fn ]; then
  rm -f dataflow/DataFlowMerged.qll
  node autofill.js > dataflow/DataFlowMerged.qll
fi

if [ $st -le 1 ] && [ 1 -le $fn ]; then
  node autofill.js 1 > __tmp__
  mv __tmp__ dataflow/DataFlowMerged.qll
fi

if [ $st -le 2 ] && [ 2 -le $fn ]; then
  node autofill.js 2 > __tmp__
  mv __tmp__ dataflow/DataFlowMerged.qll
fi

codeql query compile ql/main.ql
