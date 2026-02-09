# Variables
JAVA_JRE_URL := "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=252897_0d06828d282343ea81775b28020a7cd3"
GITHUB_RELEASE_PK_DS_MAP_STUDIO := "https://github.com/Trifindo/Pokemon-DS-Map-Studio/releases/download/2.2/Pokemon.DS.Map.Studio-2.2.zip"
JAVA_JRE_NAME := "jre-8u281-linux-x64.tar.gz"
GITHUB_RELEASE_NAME_PK_DS_MAP_STUDIO := "Pokemon.DS.Map.Studio-2.2.zip"
JRE_INSTALL_PATH := "/usr/lib/jre"
LIB_PATH := "./Pokemon DS Map Studio-2.2/lib/"
WINDOWS_EXECUTE_COMMAND := "start ./Pokemon DS Map Studio-2.2/bin/Pokemon DS Map Studio 2.2.exe"

[group('low_setup')]
[linux]
_download-java-jre:
    echo "Downloading Java JRE..."
    curl -L -o {{ JAVA_JRE_NAME }} {{ JAVA_JRE_URL }}

[group('low_setup')]
[linux]
_extract-jre:
    echo "Extracting Java JRE..."
    tar -xzvf {{ JAVA_JRE_NAME }}

[group('low_setup')]
[linux]
_move-jre:
    echo "Moving JRE to {{ JRE_INSTALL_PATH }}..."
    sudo mv jre1.8.0_* {{ JRE_INSTALL_PATH }}

# Targets for Pokémon DS Map Studio
[group('low_setup')]
_download-pk-ds-map-studio:
    echo "Downloading GitHub release..."
    curl -L -o {{ GITHUB_RELEASE_NAME_PK_DS_MAP_STUDIO }} {{ GITHUB_RELEASE_PK_DS_MAP_STUDIO }}

[group('low_setup')]
_extract-pk-ds-map-studio:
    echo "Extracting Pokemon DS Map Studio..."
    unzip {{ GITHUB_RELEASE_NAME_PK_DS_MAP_STUDIO }} -d ./Pokemon_DS_Map_Studio

[group('low_setup')]
clean:
    echo "Cleanup..."
    rm -f {{ GITHUB_RELEASE_NAME_PK_DS_MAP_STUDIO }}
    rm -f {{ JAVA_JRE_NAME }}

[group('low_setup')]
_reset: clean
    echo "Resetting before start..."
    -rm -r ./Pokemon_DS_Map_Studio

[group('execute')]
[linux]
run-map-studio:
    echo "Running Pokemon DS Map Studio on Linux..."
    cd "{{ LIB_PATH }}" && {{ JRE_INSTALL_PATH }}/bin/java -jar "Pokemon DS Map Studio-2.2.jar"

[group('execute')]
[windows]
run-map-studio:
    echo "Running Pokemon DS Map Studio on Windows..."
    {{ WINDOWS_EXECUTE_COMMAND }}

[group('setup')]
[windows]
setup: _reset _download-pk-ds-map-studio _extract-pk-ds-map-studio
    just clean

[group('setup')]
no-jre-setup: _reset _download-pk-ds-map-studio _extract-pk-ds-map-studio
    just clean

[group('setup')]
[linux]
setup: _reset _download-java-jre _extract-jre _move-jre _download-pk-ds-map-studio _extract-pk-ds-map-studio
    just clean
