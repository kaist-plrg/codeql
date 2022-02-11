# Remove c common type
qll="cpp/semmle/code/cpp/commons/CommonType.qll"
echo $qll
sed '117,331 s/^\/*/\/\//' $qll > __tmp__
mv __tmp__ $qll

# Tree shake library
cp small-cpp.qll cpp/cpp.qll
cp small-java.qll java/java.qll

# Remove Metric
for qll in `grep -l Metric -r java --exclude-dir=metrics`; do
  echo $qll
  sed '/etric/s/^\/*/\/\//' $qll > __tmp__
  mv __tmp__ $qll
done

# Remove Security / UnitTest
qll="java/semmle/code/java/dataflow/internal/TaintTrackingUtil.qll"
echo $qll
sed '/Security/s/^\/*/\/\//' $qll > __tmp__
mv __tmp__ $qll
