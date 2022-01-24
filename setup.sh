set -e

echo "installing npm packages..."
npm install

echo "unzipping cli binary..."
unzip -q codeql.zip
rm -rf cli
mv codeql cli

echo "copying codeql-extractor.yml..."
cp -r resource/jni cli/jni
cp -r resource/cpython cli/cpython
