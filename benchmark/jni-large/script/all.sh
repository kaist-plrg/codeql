# Download and extract apps
script/download.sh
script/extract.sh

# Install sdk and ndk
script/intall-sdkmanager.sh
script/install-sdk.sh
script/install-ndk.sh

# Apply some patches
node script/rewrite-local-properties.js
script/gradle-version-patch.sh
script/manual-patch.sh
node script/rewrite-app-abi.js

# Preheat for gradle
script/try-gradle.sh

# Create commands for creating merged DB
script/create-cmd.sh
