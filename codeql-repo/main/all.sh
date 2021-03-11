# Define environment variable `CODE_QL_HOME`
if [[ -z "${CODE_QL_HOME}" ]]; then
  WD=`pwd -P`
  cd ../../
  CUR=`pwd -P`
  export CODE_QL_HOME=$CUR
  cd $WD
  export PATH="$CODE_QL_HOME/codeql:$PATH"
fi
echo CODE_QL_HOME=$CODE_QL_HOME
# Clean all (dbscheme, db)
./clean.sh

# Create DB Schemes
cd dbscheme
./run.sh
cd ..

# Dump a trap file for each language
./trap.sh

# Create mereged db from trap files.
./merge.sh

# Copy and rewrite the library
node rewrite-lib.js

# Run the test query.
./ql/query.sh
