#!/bin/bash

SHELL_DIR=$(cd "$(dirname "$0")";pwd)

OUT_DIR="$SHELL_DIR/lib/jetra/adapter/grpc"

cd "$SHELL_DIR/files/protos/"

grpc_tools_ruby_protoc --grpc_out=$OUT_DIR --ruby_out=$OUT_DIR jetra.proto