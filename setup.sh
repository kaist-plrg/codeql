set -e

overwrite="$1"

echo "1. Installing npm packages..."
if [ -n "$overwrite" ] || [ ! -d "node_modules" ]; then
  npm install
else
  echo "   skip"
fi

echo "2. Downloading cli binary..."
if [ ! -f "codeql.zip" ]; then
  url="https://github.com/github/codeql-cli-binaries/releases/download/v2.8.0/codeql.zip"
  wget -O codeql.zip $url
else
  echo "   skip"
fi

echo "3. Unzipping cli binary..."
if [ -n "$overwrite" ] || [ ! -d "cli" ]; then
  unzip -q codeql.zip
  rm -rf cli
  mv codeql cli

  cp -r resource/jni cli/jni
  cp -r resource/cpython cli/cpython
else
  echo "   skip"
fi

echo "4. Rewriting library and dbschemes..."
if [ -n "$overwrite" ] || [ ! -d "lib-jni/cpp" ]; then
  node rewrite-lib.js
  node rewrite-dbscheme.js
  ( cd lib-jni ; ./patch.sh )
else
  echo "   skip"
fi

echo "5. Lifting dataflow modules..."
if [ -n "$overwrite" ] || [ ! -f "lib-jni/dataflow/DataFlowMerged.qll" ]; then
  ( cd lib-jni ; ./autofill.sh )
  ( cd lib-cpython ; ./autofill.sh )
else
  echo "   skip"
fi
