#!/bin/bash
# Generate Dart gRPC code from Laravel proto files
# Wedding Flower Decoration App - Mobile App

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PROTO_DIR="$(dirname "$PROJECT_ROOT")/Mobile-And-Backend/proto"
OUTPUT_DIR="$PROJECT_ROOT/lib/core/api/grpc_client/generated_v1"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Check if protoc is installed
if ! command -v protoc &> /dev/null; then
    echo "Error: protoc is not installed. Please install Protocol Buffers compiler."
    echo "Visit: https://grpc.io/docs/protoc-installation/"
    exit 1
fi

# Check if protoc-gen-dart is installed
if ! command -v protoc-gen-dart &> /dev/null; then
    echo "Error: protoc-gen-dart is not installed."
    echo "Install with: dart pub global activate protoc_plugin"
    exit 1
fi

# `proto/*.proto` is a retired, internally inconsistent contract set. The
# active API is the versioned wedding/user/v1 contract; generating the legacy
# files produces duplicate enum symbols and clients that cannot talk to the
# current Laravel message classes.
mapfile -t proto_files < <(find "$PROTO_DIR/wedding/user/v1" -maxdepth 1 -name '*.proto' -printf 'wedding/user/v1/%f\n' | sort)

if [ "${#proto_files[@]}" -eq 0 ]; then
    echo "Error: no wedding/user/v1 proto files found."
    exit 1
fi

protoc \
    --proto_path="$PROTO_DIR" \
    --dart_out=grpc:"$OUTPUT_DIR" \
    "${proto_files[@]}"

echo ""
echo "Dart gRPC code generated successfully!"
echo "Output directory: $OUTPUT_DIR"
ls -la "$OUTPUT_DIR"
