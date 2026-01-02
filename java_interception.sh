#!/usr/bin/env bash
set -euo pipefail
INSTALL_DIR="$HOME/.apt-aside"

CLASS_PATH=""
OTHER_ARGS=()

NEXT_ITERATION_IS_CLASS_PATH=0

declare -i I
I=1
while [[ $I -le $# ]]; do
	ARG="${!I}"
	I+=1
	if (( NEXT_ITERATION_IS_CLASS_PATH )); then
		CLASS_PATH="$ARG"
		NEXT_ITERATION_IS_CLASS_PATH=0
		continue;
	fi
	if [[ "$ARG" == "-cp" ]]; then
		NEXT_ITERATION_IS_CLASS_PATH=1
		continue;
	fi
	OTHER_ARGS+=("$ARG")
done

if [[ "$CLASS_PATH" ]]; then
	declare class_path

	if [[ "${CLASS_PATH:0:1}" == "/" ]]; then
		class_path="$INSTALL_DIR/debian$CLASS_PATH"
	else
		class_path="$CLASS_PATH"
	fi

	# Re-splitting of the arguments is intention
	# shellcheck disable=SC2068
	"$INSTALL_DIR/debian/usr/bin/java" -cp "$class_path" ${OTHER_ARGS[@]} 
else
	"$INSTALL_DIR/debian/usr/bin/java" "$@"
fi
