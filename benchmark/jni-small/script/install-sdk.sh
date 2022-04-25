cmd="cmdline-tools/bin/sdkmanager --sdk_root=sdk \
     \"platforms;android-26\" \
     \"platforms;android-28\" \
     \"build-tools;28.0.3\" \
     \"cmake;3.6.4111459\" \
     \"ndk;21.4.7075529\""

echo $cmd
eval $cmd
