#!/usr/bin/env bash
set -eou pipefail

INSTALL_PATH="$HOME/.apt-aside"

BIN_NAME="$(basename "$0")"
BIN_PATH="$INSTALL_PATH/debian/usr/bin/$BIN_NAME"

DYNAMIC_LINKER="$INSTALL_PATH/debian/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2"
LIBRARY_PATH="$INSTALL_PATH/debian/lib/x86_64-linux-gnu/:$INSTALL_PATH/debian/usr/lib/x86_64-linux-gnu"

# Hack so that packages written in Python can find their dependencies 
export PYTHONPLATLIBDIR="$INSTALL_PATH/debian/usr/lib"
export PYTHONPATH="$INSTALL_PATH"

is_elf_binary () {
	local first_bytes
	local magic_number
	first_bytes="$(head -c 4 "$BIN_PATH")"
	magic_number=$'\x7FELF'
	if [[ "$first_bytes" == "$magic_number" ]]; then
		return 0
	fi
	return 1
}

has_shebang () {
	local first_bytes
	first_bytes="$(head -c 2 "$BIN_PATH")"
	if [[ "$first_bytes" == "#!" ]]; then
		return 0
	fi
	return 1
}

run_shebang () {
	local shebang
	shebang="$(head -n 1 "$BIN_PATH" | cut -b 3-)"
	local interpreter
	local args
	read -r interpreter args <<< "$shebang"
	local path_var
	local new_interpreter_path
	local interp_name
	path_var="$INSTALL_PATH/debian/bin:$INSTALL_PATH/debian/usr/bin" 
	new_interpreter_path=$(realpath -ms "$INSTALL_PATH/debian/$interpreter")
	interp_name=$(basename "$new_interpreter_path")

	# it's technically incorrect to assume that the interpreter is an ELF binary, but we do for simplicity
	if (( args )); then
		PATH="$path_var" "$DYNAMIC_LINKER" --argv0 "$interp_name" --library-path "$LIBRARY_PATH" "$new_interpreter_path" "$args" "$BIN_PATH"
	else
		PATH="$path_var" "$DYNAMIC_LINKER" --argv0 "$interp_name" --library-path "$LIBRARY_PATH" "$new_interpreter_path" "$BIN_PATH"
	fi
}

run_elf () {
	"$DYNAMIC_LINKER" --argv0 "$BIN_NAME" --library-path "$LIBRARY_PATH" "$BIN_PATH" "$@"
}

if is_elf_binary; then
	run_elf "$@"
elif has_shebang; then
	run_shebang
else
	echo "Error: Unknown binary type"
fi
