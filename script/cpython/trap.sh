root=${1:-"src"}

st=`date +%s`

echo '[Creating database for python]'
rm -rf db-python
echo '[init]'
codeql database init -l=python --source-root=$root db-python
echo '[trace-command]'
mv $root/setup.py $root/setup.py.bak
codeql database trace-command --working-dir=$root db-python --index-traceless-dbs -j 0
mv $root/setup.py.bak $root/setup.py

fn=`date +%s`
took=$((fn - st))
echo "Took $took s for python"

st=`date +%s`

echo '[Creating database for cpp]'
rm -rf db-cpp
echo '[init]'
codeql database init -l=cpp --source-root=$root db-cpp
echo '[trace-command]'
(cd $root; make clean)
codeql database trace-command --working-dir=$root db-cpp make -j 0

fn=`date +%s`
took=$((fn - st))
echo "Took $took s for cpp"
