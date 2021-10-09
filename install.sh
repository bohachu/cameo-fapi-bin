#!/bin/sh
set -e
if [ "$OS" = "Windows_NT" ]; then
	target="x86_64-pc-windows-msvc"
else
	case $(uname -sm) in
	"Darwin x86_64") target="x86_64-apple-darwin" ;;
	"Darwin arm64") target="aarch64-apple-darwin" ;;
	*) target="x86_64-unknown-linux-gnu" ;;
	esac
fi

cameo_uri="https://fapi.cameo.tw/cameo-fapi-${target}.zip"

cameo_install="${CAMEO_INSTALL:-$HOME/.cameo}"
bin_dir="$cameo_install/bin"
exe="$bin_dir/cameo-fapi"

if [ ! -d "$bin_dir" ]; then
	mkdir -p "$bin_dir"
fi

curl --fail --location --progress-bar --output "$exe.zip" "$cameo_uri"
unzip -d "$bin_dir" -o "$exe.zip"
chmod +x "$exe"
rm "$exe.zip"

echo "cameo-fapi was installed successfully to $exe"
if command -v cameo-fapi >/dev/null; then
	echo "Run 'cameo-fapi --help' to get started"
else
	case $SHELL in
	/bin/zsh) shell_profile=".zshrc" ;;
	*) shell_profile=".bash_profile" ;;
	esac
	echo "Manually add the directory to your \$HOME/$shell_profile (or similar)"
	echo "  export CAMEO_INSTALL=\"$cameo_install\""
	echo "  export PATH=\"\$CAMEO_INSTALL/bin:\$PATH\""
	echo "Run '$exe --help' to get started"
fi
