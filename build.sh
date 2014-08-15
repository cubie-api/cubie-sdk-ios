#!/bin/bash
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DERIVED_DATA_PATH=$BASE_DIR/derivedDataPath
BUILD_DIR=$DERIVED_DATA_PATH/Build
FRAMEWORK_BUILD_DIR=$BASE_DIR/Frameworks

function build {
   xcodebuild -workspace 'sdk.xcworkspace' -scheme $1 \
      -configuration $2 -sdk $3 -derivedDataPath $DERIVED_DATA_PATH clean build \
      ONLY_ACTIVE_ARCH=NO
}

function build_simulator {
   build $1 Debug iphonesimulator
}

function build_iphoneos {
   build $1 Release iphoneos
}

function framework_skeleton {
   echo "framework_skeleton: $1"
   FRAMEWORK_VERSION=A
   FRAMEWORK_DIR=$FRAMEWORK_BUILD_DIR/$1.framework
   rm -rf $FRAMEWORK_DIR
   mkdir -p $FRAMEWORK_DIR
   mkdir -p $FRAMEWORK_DIR/Versions
   mkdir -p $FRAMEWORK_DIR/Versions/$FRAMEWORK_VERSION
   mkdir -p $FRAMEWORK_DIR/Versions/$FRAMEWORK_VERSION/Resources
   mkdir -p $FRAMEWORK_DIR/Versions/$FRAMEWORK_VERSION/Headers
   cd $FRAMEWORK_DIR
   ln -s $FRAMEWORK_VERSION Versions/Current
   ln -s Versions/Current/Headers Headers
   ln -s Versions/Current/Resources Resources
   ln -s Versions/Current/$1 $1
}

function merge_library {
   echo "merge_library: $1"
   FRAMEWORK_DIR=$FRAMEWORK_BUILD_DIR/$1.framework
   cd $BUILD_DIR
   lipo -create "Products/Debug-iphonesimulator/$2.a" "Products/Release-iphoneos/$2.a" -o "$FRAMEWORK_DIR/Versions/Current/$1"
}

function copy_sdk_headers {
   echo "copy_sdk_headers: $1"
   FRAMEWORK_DIR=$FRAMEWORK_BUILD_DIR/$1.framework
   cd $BASE_DIR/sdk
   cp service/*.h $FRAMEWORK_DIR/Headers/
   cp error/*.h $FRAMEWORK_DIR/Headers/
   cp *.h $FRAMEWORK_DIR/Headers/
}

function copy_pod_headers {
   echo "copy_pod_headers: $1"
   FRAMEWORK_DIR=$FRAMEWORK_BUILD_DIR/$1.framework
   cd $BASE_DIR/Pods/Headers
   cp $1/*.h $FRAMEWORK_DIR/Headers/
}

function framework_sdk {
   framework_skeleton $1
   merge_library $1 libsdk
   copy_sdk_headers $1
}

function framework_pod {
   framework_skeleton $1
   merge_library $1 libPods-$1
   copy_pod_headers $1 
}

rm -rf $DERIVED_DATA_PATH $FRAMEWORK_BUILD_DIR

pod install
python fix_pod_install.py

build_simulator 'Pods'
build_simulator 'sdk'
build_iphoneos 'Pods'
build_iphoneos 'sdk'

framework_sdk CubieSDK
framework_pod AFNetworking
framework_pod CocoaLumberjack
framework_pod JSONKit-NoWarning

python $BASE_DIR/fix_imports.py $FRAMEWORK_BUILD_DIR/CubieSDK.framework/Versions/A/Headers \
   AFNetworking CocoaLumberjack JSONKit-NoWarning
