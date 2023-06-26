#!/bin/sh
#
# Created by TienAnh on 26/06/2023.
#
chmod +x ./auto_export.sh

generate_exporter_file() {
  src="./lib/src"

  echo "//Generated file. Do not modify." >"$src/widgets/index.dart"
  echo "//Generated file. Do not modify." >"$src/constants/index.dart"
  echo "//Generated file. Do not modify." >"$src/utils/index.dart"

  find "$src/widgets" -type f -name "*.dart" | while read -r file; do
    if [[ $(basename "$file") != "index.dart" ]]; then
      relative_path=${file#"$src/widgets/"}
      echo "export '$relative_path';" >>"$src/widgets/index.dart"
    fi
  done

  find "$src/constants" -type f -name "*.dart" | while read -r file; do
    if [[ $(basename "$file") != "index.dart" ]]; then
      relative_path=${file#"$src/constants/"}
      echo "export '$relative_path';" >>"$src/constants/index.dart"
    fi
  done

  find "$src/utils" -type f -name "*.dart" | while read -r file; do
    if [[ $(basename "$file") != "index.dart" ]]; then
      relative_path=${file#"$src/utils/"}
      echo "export '$relative_path';" >>"$src/utils/index.dart"
    fi
  done
}

generate_exporter_file
