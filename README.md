# Used codeql version

codeql-cli version: 2.8.0 (https://github.com/github/codeql-cli-binaries/releases)

# setup
1. set environment variable:
```
export CODEQL_HOME=`pwd`
export PATH="$CODEQL_HOME/cli:$PATH"

export JAVA_HOME="path/to/java/"
```

2. run the following code:
```
./setup.sh
```

# Test with small C-Python benchmarks
This will run data-flow analysis for 20 benchmarks in benchmark/cpython-small/src

1. cd to the test directory:
```
cd benchmark/cpython-small
```

2. Create CodeQL DB:
```
./script/create-db.sh
```

3. Run CodeQL query:
```
./script/query.sh  # This will run the prepared CodeQL query, `lib-cpython/ql/bench.ql`
```

4. View the analysis results, also stored in the log directory. The result is a table of 4 column: the source of dataflow, the sink of dataflow, the location of source, and the location of sink.




TODO: Write better document
