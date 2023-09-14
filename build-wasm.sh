#!/usr/bin/env bash
echo "Changing directory to hello-wasm"
cd hello-wasm

echo "Building module from crate as web target at pkg"
wasm-pack build --target web --release

echo "Clearing all files inside svelte/src/hello-wasm"
rm -rf ../src/hello-wasm/*

echo "Copying wasm-game-of-life from rust/pkg to svelte/src/wasm-game-of-life"
cp -r pkg/* ../src/hello-wasm

echo "Changing directory back to main directory"
cd ..

echo "Fix https://github.com/rustwasm/wasm-pack/issues/1039"
jq '.type = "module"' ./src/hello-wasm/package.json > ./src/hello-wasm/package.json.tmp && \
  mv ./src/hello-wasm/package.json.tmp ./src/hello-wasm/package.json

echo "Installing dependencies"
bun install

echo "Building Svelte app"
bun run build

while getopts ":p" opt; do
  case $opt in
    p)
      echo "-p was triggered!" >&2
      echo "Previewing svelte"
      bun run preview
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done