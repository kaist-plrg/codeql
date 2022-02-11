set -e

overwrite="$1"

echo "installing npm packages..."
if [ -n "$overwrite" ] || [ ! -d "node_modules" ]; then
  npm install
fi

echo "downloading cli binary..."
if [ -n "$overwrite" ] || [ ! -f "codeql.zip" ]; then
  wget -O codeql.zip "https://github.com/github/codeql-cli-binaries/releases/download/v2.8.0/codeql.zip"
fi

echo "unzipping cli binary..."
if [ -n "$overwrite" ] || [ ! -d "cli" ]; then
  unzip -q codeql.zip
  rm -rf cli
  mv codeql cli
fi

echo "copying codeql-extractor.yml..."
cp -r resource/jni cli/jni
cp -r resource/cpython cli/cpython

echo "Rewriting library and dbschemes..."
node rewrite-lib.js
node rewrite-dbscheme.js
