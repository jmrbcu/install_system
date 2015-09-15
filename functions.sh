#!/bin/bash

# Mounts a disk image.
# Parameters:
# $1 = The image path.
mount_image() {
  printf "Mounting image...\n"
  hdiutil attach "$1" -noidmereveal
}
export -f mount_image

# Unmounts a disk image.
# Parameters:
# $1 = The mount path.
unmount_image() {
  printf "Unmounting image...\n"
  hdiutil detach -force "$1"
}
export -f unmount_image

# Downloads an installer to local disk.
# Parameters:
# $1 = The URL.
# $2 = The file name.
download_installer() {
  printf "Downloading $1...\n"
  clean_work_path
  mkdir $WORK_PATH
  curl --location --retry 3 --retry-delay 5 "$1" >> "$WORK_PATH/$2"
}
export -f download_installer

# Downloads an installer to the $HOME/Downloads folder for manual use.
# Parameters:
# $1 = The URL.
# $2 = The file name.
download_only() {
  if [[ -e "$HOME/Downloads/$2" ]]; then
    printf "Downloaded: $2.\n"
  else
    printf "Downloading $1...\n"
    download_installer "$1" "$2"
    mv "$WORK_PATH/$2" "$HOME/Downloads"
  fi
}
export -f download_only

# Installs an application.
# Parameters:
# $1 = The application source path.
# $2 = The application name.
install_app() {
  local install_root=$(get_install_root "$2")
  local file_extension=$(get_file_extension "$2")

  printf "Installing: $install_root/$2...\n"

  case $file_extension in
    'app')
      cp -a "$1/$2" "$install_root";;
    'prefPane')
      sudo cp -pR "$1/$2" "$install_root";;
    'qlgenerator')
      sudo cp -pR "$1/$2" "$install_root" && qlmanage -r;;
    *)
      printf "ERROR: Unknown file extension: $file_extension.\n"
  esac
}
export -f install_app

# Installs a package.
# Parameters:
# $1 = The package source path.
# $2 = The application name.
install_pkg() {
  local install_root=$(get_install_root "$2")

  printf "Installing: $install_root/$2...\n"
  local package=$(sudo find "$1" -type f -name "*.pkg" -o -name "*.mpkg")
  sudo installer -pkg "$package" -target /
}
export -f install_pkg

# Installs an application via a DMG file.
# Parameters:
# $1 = The URL.
# $2 = The mount path.
# $3 = The application name.
install_dmg_app() {
  local url="$1"
  local mount_point="/Volumes/$2"
  local app_name="$3"
  local install_path=$(get_install_path "$app_name")
  local download_file="download.dmg"

  if [[ ! -e "$install_path" ]]; then
    download_installer "$url" "$download_file"
    mount_image "$WORK_PATH/$download_file"
    install_app "$mount_point" "$app_name"
    unmount_image "$mount_point"
    verify_application "$app_name"
  fi
}
export -f install_dmg_app

# Installs a package via a DMG file.
# Parameters:
# $1 = The URL.
# $2 = The mount path.
# $3 = The application name.
install_dmg_pkg() {
  local url="$1"
  local mount_point="/Volumes/$2"
  local app_name="$3"
  local install_path=$(get_install_path "$app_name")
  local download_file="download.dmg"

  if [[ ! -e "$install_path" ]]; then
    download_installer "$url" "$download_file"
    mount_image "$WORK_PATH/$download_file"
    install_pkg "$mount_point" "$app_name"
    unmount_image "$mount_point"
    printf "Installed: $app_name.\n"
    verify_application "$app_name"
  fi
}
export -f install_dmg_pkg

# Installs an application via a zip file.
# Parameters:
# $1 = The URL.
# $2 = The application name.
install_zip_app() {
  local url="$1"
  local app_name="$2"
  local install_path=$(get_install_path "$app_name")
  local download_file="download.zip"

  if [[ ! -e "$install_path" ]]; then
    download_installer "$url" "$download_file"

    (
      printf "Preparing...\n"
      cd "$WORK_PATH"
      unzip -q "$download_file"
    )

    install_app "$WORK_PATH" "$app_name"
    printf "Installed: $app_name.\n"
    verify_application "$app_name"
  fi
}
export -f install_zip_app

# Installs an application via a tar file.
# Parameters:
# $1 = The URL.
# $2 = The application name.
# $3 = The decompress options.
install_tar_app() {
  local url="$1"
  local app_name="$2"
  local options="$3"
  local install_path=$(get_install_path "$app_name")
  local download_file="download.tar"

  if [[ ! -e "$install_path" ]]; then
    download_installer "$url" "$download_file"

    (
      printf "Preparing...\n"
      cd "$WORK_PATH"
      tar "$options" "$download_file"
    )

    install_app "$WORK_PATH" "$app_name"
    printf "Installed: $app_name.\n"
    verify_application "$app_name"
  fi
}
export -f install_tar_app

# Installs a package via a zip file.
# Parameters:
# $1 = The URL.
# $2 = The application name.
install_zip_pkg() {
  local url="$1"
  local app_name="$2"
  local install_path=$(get_install_path "$app_name")
  local download_file="download.zip"

  if [[ ! -e "$install_path" ]]; then
    download_installer "$url" "$download_file"

    (
      printf "Preparing...\n"
      cd "$WORK_PATH"
      unzip -q "$download_file"
    )

    install_pkg "$WORK_PATH" "$app_name"
    printf "Installed: $app_name.\n"
    verify_application "$app_name"
  fi
}
export -f install_zip_pkg

# Installs application code from a Git repository.
# Parameters:
# $1 = Repository URL.
# $2 = Install path.
# $3 = Git clone options (if any).
install_git_app() {
  local repository_url="$1"
  local app_name=$(get_file_name "$2")
  local install_path="$2"
  local options="--quiet"

  if [[ -n "$3" ]]; then
    local options="$options $3"
  fi

  if [[ ! -e "$install_path" ]]; then
    printf "Installing: $install_path/$app_name...\n"
    git clone $options "$repository_url" "$install_path"
    printf "Installed: $app_name.\n"
    verify_path "$install_path"
  fi
}
export -f install_git_app

# Installs settings from a Git repository.
# Parameters:
# $1 = The repository URL.
# $2 = The repository version.
# $3 = The project directory.
# $4 = The script to run (including any arguments).
install_git_project() {
  local repo_url="$1"
  local repo_version="$2"
  local project_dir="$3"
  local script="$4"

  git clone "$repo_url"
  (
    cd "$project_dir"
    git checkout "$repo_version"
    eval "$script"
  )
  rm -rf "$project_dir"
}
export -f install_git_project

# Installs a single file.
# Parameters:
# $1 = The URL.
# $2 = The install path.
install_file() {
  local file_url=$(dirname "$1")
  local file_name=$(get_file_name "$1")
  local install_path="$2"

  if [[ ! -e "$install_path" ]]; then
    printf "Installing: $install_path/$file_name...\n"
    download_installer "$file_url" "$file_name"
    mkdir -p $(dirname "$install_path")
    mv "$WORK_PATH/$file_name" "$install_path"
    printf "Installed: $file_name.\n"
    verify_path "$install_path"
  fi
}
export -f install_file

# Verifies Homebrew software exists.
# Parameters:
# $1 = The file name.
verify_homebrew() {
  local application="$1"
  local applications="$2"

  if [[ "${applications[*]}" != *"$application"* ]]; then
    printf " - Missing: $application\n"
  fi
}
export -f verify_homebrew

# Checks for missing Homebrew software.
verify_homebrews() {
  printf "Checking Homebrew software...\n"

  local applications="$(brew list)"

  while read line; do
    # Skip blank or comment lines.
    if [[ "$line" == "brew install"* ]]; then
      local application=$(printf "$line" | awk '{print $3}')

      # Caveat: "hg" is known as "mercurial" to the system.
      if [[ "$application" == "hg" ]]; then
        application="mercurial"
      fi

      verify_homebrew "$application" "${applications[*]}"
    fi
  done < "$PWD/scripts/homebrew.sh"

  printf "Homebrew check complete.\n"
}
export -f verify_homebrews

# Verifies application exists.
# Parameters:
# $1 = The file name.
verify_application() {
  local file_name="$1"

  # Display the missing install if not found.
  local install_path=$(get_install_path "$file_name")

  if [[ ! -e "$install_path" ]]; then
    printf " - Missing: $file_name\n"
  fi
}
export -f verify_application

# Checks for missing applications suffixed by "APP_NAME" as defined in settings.sh.
verify_applications() {
  printf "\nChecking application software...\n"

  # Only use environment keys that end with "APP_NAME".
  local file_names=$(set | awk -F "=" '{print $1}' | grep ".*APP_NAME")

  # For each application name, check to see if the application is installed. Otherwise, skip.
  for name in $file_names; do
    # Pass the key value to verfication.
    verify_application "${!name}"
  done

  printf "Application software check complete.\n"
}
export -f verify_applications

# Verifies path exists.
# Parameters:
# $1 = The path.
verify_path() {
  local path="$1"

  # Display the missing path if not found.
  if [[ ! -e "$path" ]]; then
    printf " - Missing: $path\n"
  fi
}
export -f verify_path

# Checks for missing extensions suffixed by "EXTENSION_PATH" as defined in settings.sh.
verify_extensions() {
  printf "\nChecking application extensions...\n"

  # Only use environment keys that end with "EXTENSION_PATH".
  local extensions=$(set | awk -F "=" '{print $1}' | grep ".*EXTENSION_PATH")

  # For each extension, check to see if the extension is installed. Otherwise, skip.
  for extension in $extensions; do
    # Evaluate/extract the key (extension) value and pass it on for verfication.
    verify_path "${!extension}"
  done

  printf "Application extension check complete.\n"
}
export -f verify_extensions

# Answers the file name.
# Parameters:
# $1 = The file path.
get_file_name() {
  printf "${1##*/}" # Answers file or directory name.
}
export -f get_file_name

# Answers the file extension.
# Parameters:
# $1 = The file name.
get_file_extension() {
  local name=$(get_file_name "$1")
  local extension="${1##*.}" # Excludes dot.

  if [[ "$name" == "$extension" ]]; then
    printf ''
  else
    printf "$extension"
  fi
}
export -f get_file_extension

# Answers the root install path for file name.
# Parameters:
# $1 = The file name.
get_install_root() {
  local file_name="$1"
  local file_extension=$(get_file_extension "$file_name")

  # Dynamically build the install path based on file extension.
  case $file_extension in
    '')
      printf "/usr/local/bin";;
    'app')
      printf "/Applications";;
    'prefPane')
      printf "/Library/PreferencePanes";;
    'qlgenerator')
      printf "/Library/QuickLook";;
    *)
      printf "/tmp/unknown";;
  esac
}
export -f get_install_root

# Answers the full install path (including file name) for file name.
# Parameters:
# $1 = The file name.
get_install_path() {
  local file_name="$1"
  local install_path=$(get_install_root "$file_name")
  printf "$install_path/$file_name"
}
export -f get_install_path

# Cleans work path for temporary processing of installs.
clean_work_path() {
  printf "Cleaning: $WORK_PATH...\n"
  rm -rf "$WORK_PATH"
}
export -f clean_work_path