# exit when any command fails
set -e

# path to the macos artifact from google's CI run
# https://github.com/google/dawn/actions/workflows/ci.yml
# expect RELEASE_ROOT/lib and /include dirs inside
# todo: automate this? or make it a param?
RELEASE_ROOT="Dawn-ecf224df05e711fe7009fbd76840301fb82bde1a-macos-latest-Release"

OUTPUT_FILENAME="Dawn.xcframework"
OUTPUT_PATH="./${OUTPUT_FILENAME}"

MACOS_LIBRARY_PATH="${RELEASE_ROOT}/lib/libwebgpu_dawn.dylib"
MACOS_HEADER_PATH="${RELEASE_ROOT}/include"

xcodebuild -create-xcframework \
	-library ${MACOS_LIBRARY_PATH} -headers ${MACOS_HEADER_PATH}	\
	-output ${OUTPUT_PATH}
