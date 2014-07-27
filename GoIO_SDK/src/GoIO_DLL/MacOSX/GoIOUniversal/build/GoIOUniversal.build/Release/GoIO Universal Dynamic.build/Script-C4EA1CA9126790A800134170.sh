#!/bin/sh
#
# Copy the library to redist folder
#

if [ $CONFIGURATION == "Release" ]
then
	echo "*** This is a release build. I am going to copy the resulting executable to the redist folder if present."
	SRC_PATH="$TARGET_BUILD_DIR/$EXECUTABLE_PATH"

	if [ -f "$SRC_PATH" ]; then
		echo "I have found the built library. I will replace the redist version with it."
		DEST_DIR_PATH="$PROJECT_DIR/../../../../redist/GoIO_DLL/MacOSX"
		DEST_FILE_PATH="$DEST_DIR_PATH/$EXECUTABLE_PATH"
		if [ -f "$DEST_FILE_PATH" ]; then
			echo "Deleting exiting copy of library in redist folder"
			rm -f $DEST_FILE_PATH
		fi
		echo "Copying the library to redist now."
		cp -f "$SRC_PATH" "$DEST_DIR_PATH"
	fi
fi


