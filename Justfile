# Variables
JAVA_JRE_URL := "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=252897_0d06828d282343ea81775b28020a7cd3"
GITHUB_RELEASE_PKDSMSS := "https://github.com/Trifindo/Pokemon-DS-Map-Studio/releases/download/2.2/Pokemon.DS.Map.Studio-2.2.zip"
GITHUB_RELEASE_DSPRE := "https://github.com/AdAstra-LD/DS-Pokemon-Rom-Editor/releases/download/v1.11/DSPRE.Reloaded.1.11.zip"

JAVA_JRE_NAME := "jre-8u281-linux-x64.tar.gz"
DOWNLOAD_NAME_PKDSMSS := "Pokemon.DS.Map.Studio-2.2.zip"
DOWNLOAD_NAME_DSPRE := "DSPRE.Reloaded.1.11.zip"

JRE_INSTALL_PATH := "/usr/lib/jvm"
WINDOWS_EXECUTE_PKDSMSS := "start ./Pokemon_DS_Map_Studio/bin/Pokemon DS Map Studio 2.2.exe"

#JRE

[group('jre')]
[linux]
_download-java-jre:
    echo "Downloading Java JRE..."
    curl -L -o {{ JAVA_JRE_NAME }} {{ JAVA_JRE_URL }}

[group('jre')]
[linux]
_extract-jre:
    echo "Extracting Java JRE..."
    tar -xzvf {{ JAVA_JRE_NAME }}

[group('jre')]
[linux]
_move-jre:
    echo "Moving JRE to {{ JRE_INSTALL_PATH }}..."
    sudo mv jre1.8.0_* {{ JRE_INSTALL_PATH }}

# Pokemon DS Map Studio Setup
[group('pkdsmss')]
_download-pkdsmss:
    echo "Downloading GitHub release..."
    curl -L -o {{ DOWNLOAD_NAME_PKDSMSS }} {{ GITHUB_RELEASE_PKDSMSS }}

[group('pkdsmss')]
_extract-pkdsmss:
    echo "Extracting Pokemon DS Map Studio..."
    unzip {{ DOWNLOAD_NAME_PKDSMSS }} -d ./Pokemon_DS_Map_Studio

# DS-Pokemon-Rom-Editor
[group('dspre')]
_download-dspre:
    echo "Downloading GitHub release..."
    curl -L -o {{ DOWNLOAD_NAME_DSPRE }} {{ GITHUB_RELEASE_DSPRE }}

[group('dspre')]
_extract-dspre:
    echo "Extracting Pokemon DS Map Studio..."
    unzip {{ DOWNLOAD_NAME_DSPRE }} -d ./Pokemon_DS_Rom_Editor

# Execution
[group('run')]
[linux]
run-map-studio:
    echo "Running Pokemon DS Map Studio on Linux..."
    cd ./Pokemon_DS_Map_Studio/Pokemon\ DS\ Map\ Studio-2.2/lib/ && {{ JRE_INSTALL_PATH }}/jre1.8.0_*/bin/java -jar "Pokemon DS Map Studio-2.2.jar"

[group('run')]
[windows]
run-map-studio:
    echo "Running Pokemon DS Map Studio on Windows..."
    {{ WINDOWS_EXECUTE_PKDSMSS }}

[group('run')]
[linux]
run-rom-editor:
    echo "Running DS Pokemon Rom Editor"
    cd ./Pokemon_DS_Rom_Editor && wine DSPRE.exe

[group('run')]
[windows]
run-rom-editor:
    echo "Running DS Pokemon Rom Editor"
    cd ./Pokemon_DS_Rom_Editor && DSPRE.exe

# Setup
[group('setup')]
[windows]
setup: _reset _download-pkdsmss _extract-pkdsmss _download-dspre _extract-dspre 
    just clean

[group('setup')]
no-jre-setup: _reset _download-pkdsmss _extract-pkdsmss _download-dspre _extract-dspre 
    just clean

[group('setup')]
[linux]
setup: _reset _download-java-jre _extract-jre _move-jre _download-pkdsmss _extract-pkdsmss _download-dspre _extract-dspre 
    just clean

[group('setup')]
clean:
    echo "Cleanup..."
    rm -f {{ DOWNLOAD_NAME_PKDSMSS }}
    rm -f {{ DOWNLOAD_NAME_DSPRE }}
    rm -f {{ JAVA_JRE_NAME }}

[group('setup')]
_reset: clean
    echo "Resetting before start..."
    -rm -r ./Pokemon_DS_Map_Studio
    -rm -r ./Pokemon_DS_Rom_Editor

[group('clone')]
clone-dreamCrystal ssh="true":
    #!/usr/bin/env bash
    cd ./Projects
    if [ "{{ssh}}" = "true" ]; then
        git clone git@github.com:Simsblock/Pokemon.Dream_Crystal.git
    else
        git clone https://github.com/Simsblock/Pokemon.Dream_Crystal.git
    fi
    git fetch origin