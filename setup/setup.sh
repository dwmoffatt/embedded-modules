#!/bin/bash

# shellcheck source=setup/setup.sh

DOWNLOADS_DIR="$HOME/Downloads/"

function InstallDeps()
{
  echo "--- Installing Dependencies ---"

  # Install dependencies
  sudo apt update
  sudo apt -y upgrade
  sudo apt install -y build-essential wget git srecord usbutils default-jdk python3-pip python3-venv

  # Create a downloads folder if it doesn't exist
  if [ ! -d "$DOWNLOADS_DIR" ]; then
    mkdir -p "$DOWNLOADS_DIR"
  fi
}

function SetupPython()
{
  echo "--- Setting up Python ---"

  # Create virtual environment if not already created
  PYTHON_VENV_FILE="py-venv/bin/activate"
  if [ -f "$PYTHON_VENV_FILE" ]; then
    echo "py-venv virtual environment already exists"
  else
    python3 -m venv py-venv
  fi

  # Activate virtual environment
  source $PYTHON_VENV_FILE

  # Install dependencies
  pip3 install --upgrade pip
  pip3 install -r requirements.txt

  # Install pre-commit if config file present
  PRE_COMMIT_FILE=".pre-commit-config.yaml"
  if [ -f "$PRE_COMMIT_FILE" ]; then
    echo "--- Installing pre-commit ---"
    pre-commit install
    pre-commit autoupdate
  else
    echo "$PRE_COMMIT_FILE not found"
  fi

}

function InstallSeggerJlink()
{
  echo "--- Installing Segger JLink ---"

  # Verify the JLink SDK is in the Downloads folder
  JLINK_SDK_FILE="JLink_Linux_V*_x86_64.tgz"
  if [ ! "$(find "$DOWNLOADS_DIR" -type f -name "$JLINK_SDK_FILE")" ]; then
    echo "$JLINK_SDK_FILE not found in $DOWNLOADS_DIR"
    return
  fi

  NEWEST_SDK_PATH=$(find "$DOWNLOADS_DIR" -type f -name "$JLINK_SDK_FILE" -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)
  NEWEST_SDK=${NEWEST_SDK_PATH/$DOWNLOADS_DIR}
  echo "$NEWEST_SDK"

  mkdir -p "$HOME/opt/SEGGER"
  if [ ! -d "$HOME/opt/SEGGER/${NEWEST_SDK/.tgz/}" ]; then
    tar -xf "$DOWNLOADS_DIR/$NEWEST_SDK" -C "$HOME/opt/SEGGER"
  fi
  chmod a-w "$HOME/opt/SEGGER/${NEWEST_SDK/.tgz/}"

  sudo ln -s "$HOME/opt/SEGGER/${NEWEST_SDK/.tgz/}/JLinkExe" /usr/bin/

  sudo cp "$HOME/opt/SEGGER/${NEWEST_SDK/.tgz/}/99-jlink.rules" /etc/udev/rules.d/99-jlink.rules

  echo "--- Verify Segger JLink ---"
  echo "$(JLinkExe)"
}

function InstallToolchain()
{
  echo "--- Installing Toolchain ---"

  #wget https://developer.arm.com/-/media/Files/downloads/gnu/12.2.mpacbti-rel1/binrel/arm-gnu-toolchain-12.2.mpacbti-rel1-x86_64-arm-none-eabi.tar.xz
  #sudo tar -xvf arm-gnu-toolchain-12.2.mpacbti-rel1-x86_64-arm-none-eabi.tar.xz -C /usr/share
  #rm -rf arm-gnu-toolchain-12.2.mpacbti-rel1-x86_64-arm-none-eabi.tar.xz

  #sudo ln -s /usr/share/arm-gnu-toolchain-12.2.mpacbti-rel1-x86_64-arm-none-eabi/bin/* /usr/bin/

  #sudo apt install -y libncurses5 libncursesw5

  #sudo add-apt-repository ppa:deadsnakes/ppa -y
  #sudo apt update
  #sudo apt install -y python3.8

  echo "--- Verify Toolchain ---"
  echo "$(arm-none-eabi-gdb --version)"

}

if [ $# -ne 1 ]; then
  echo "1 argument required of either [all|deps|python|segger|toolchain|]"
  exit 1
fi


if [[ ("$1" != "all" && "$1" != "deps" && "$1" != "python" && "$1" != "segger" && "$1" != "toolchain") ]]; then
  echo "1 argument required of either [all|deps|python|segger|toolchain]"
  exit 1
fi

case $1 in
"all")
InstallDeps
SetupPython
InstallSeggerJlink
InstallToolchain
;;
"deps")
InstallDeps ;;
"python")
SetupPython ;;
"segger")
InstallSeggerJlink ;;
"toolchain")
InstallToolchain ;;
esac
