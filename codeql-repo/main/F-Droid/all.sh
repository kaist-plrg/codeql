# Download and extract apps
./download.sh
./extract.sh

# Install sdk and ndk
#./intall-sdkmanager.sh
./install-sdk.sh
./install-ndk.sh

# Apply some patches
node rewrite-local-properties.js
./rewrite-local-properties.sh

# Run gradle
./try-gradle.sh
