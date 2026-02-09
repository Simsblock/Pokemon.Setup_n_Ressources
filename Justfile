# Variables
JRE := "https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz"
GITHUB_RELEASE_PDSMS_ASTRA := "https://github.com/AdAstra-LD/Pokemon-DS-Map-Studio/releases/download/v2.2.1/Pokemon.DS.Map.Studio-2.2.1.zip"
GITHUB_RELEASE_DSPRE := "https://github.com/AdAstra-LD/DS-Pokemon-Rom-Editor/releases/download/v1.11/DSPRE.Reloaded.1.11.zip"

DOWNLOAD_JRE_NAME := "openjdk-21.0.2_linux-x64_bin.tar.gz"
JRE_NAME := "jdk-21.0.2"
DOWNLOAD_NAME_PDSMS_ASTRA := "Pokemon.DS.Map.Studio-2.2.1.zip"
DOWNLOAD_NAME_DSPRE := "DSPRE.Reloaded.1.11.zip"

JRE_INSTALL_PATH := "/usr/lib/jvm"
WINDOWS_EXECUTE_PKDSMSS := "start ./Pokemon_DS_Map_Studio/bin/Pokemon DS Map Studio 2.2.exe"

# JRE

[group('jre')]
[linux]
_download-java-jre:
    echo "Downloading Java JRE..."
    curl -L -o {{ DOWNLOAD_JRE_NAME }} {{ JRE }}

[group('jre')]
[linux]
_extract-jre:
    echo "Extracting Java JRE..."
    tar -xzvf {{ DOWNLOAD_JRE_NAME }}

[group('jre')]
[linux]
_move-jre:
    echo "Moving JRE to {{ JRE_INSTALL_PATH }}..."
    sudo mv {{ JRE_NAME }} {{ JRE_INSTALL_PATH }}
# If you want to add it to alternatives, additionally run:
# sudo alternatives --install /usr/bin/java java {{ JRE_INSTALL_PATH }}/{{ JRE_NAME }}/bin/java PRIORITY-NR

# Pokemon DS Map Studio | AD ASTRA Fork

[group('pkdsmss')]
_download-pkdsmss:
    echo "Downloading GitHub release..."
    curl -L -o {{ DOWNLOAD_NAME_PDSMS_ASTRA }} {{ GITHUB_RELEASE_PDSMS_ASTRA }}

[group('pkdsmss')]
_extract-pkdsmss:
    echo "Extracting Pokemon DS Map Studio..."
    unzip {{ DOWNLOAD_NAME_PDSMS_ASTRA }} -d ./Pokemon_DS_Map_Studio

# DS-Pokemon-Rom-Editor

[group('dspre')]
_download-dspre:
    echo "Downloading GitHub release..."
    curl -L -o {{ DOWNLOAD_NAME_DSPRE }} {{ GITHUB_RELEASE_DSPRE }}

[group('dspre')]
_extract-dspre:
    echo "Extracting Pokemon DS Map Studio..."
    unzip {{ DOWNLOAD_NAME_DSPRE }} -d ./Pokemon_DS_Rom_Editor

# RUN

[group('run')]
[linux]
run-map-studio:
    echo "Running Pokemon DS Map Studio on Linux..."
    cd ./Pokemon_DS_Map_Studio/Pokemon\ DS\ Map\ Studio-2.2/lib/ && {{ JRE_INSTALL_PATH }}/{{ JRE_NAME }}/bin/java -jar "Pokemon DS Map Studio-2.2.jar"

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

# SETUP

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
    rm -f {{ DOWNLOAD_NAME_PDSMS_ASTRA }}
    rm -f {{ DOWNLOAD_NAME_DSPRE }}
    rm -f {{ DOWNLOAD_JRE_NAME }}

[group('setup')]
_reset: clean
    echo "Resetting before start..."
    -rm -r ./Pokemon_DS_Map_Studio
    -rm -r ./Pokemon_DS_Rom_Editor

# GIT CLONE

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