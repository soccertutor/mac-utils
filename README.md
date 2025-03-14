[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE.md)

# mac-utils
Haxe Extension, allows to call NSSavePanel dilog.
Allows to save jpg or pdf file.
- macOS support only

# Installation

You can install mac-utils using haxelib:

	haxelib git mac-utils https://github.com/soccertutor/mac-utils

	lime rebuild mac-utils mac


To add it to a Lime or OpenFL project, add this to your project file:

	<haxelib name="mac-utils" />

# Usage

## 1. Initialize:

```haxe
import extension.macutils.MacUtils;
import extension.macutils.MacUtilsEvent;

MacUtils.initialize();
MacUtils.addEventListener(MacUtilsEvent.SELECT_FOLDER_SUCCESS, onSelected);
MacUtils.addEventListener(MacUtilsEvent.SELECT_FOLDER_ERROR, onCancelled);
```

## 2. Call native save dialog:

```haxe
final base64 = "base64string";
MacUtils.saveFileWithType(base64, "Untitled", "jpg");

private function onSelected( event:MacUtilsEvent ) {
	trace(event.data);
}

private function onCancelled( event:MacUtilsEvent ) {
	trace(event.data);
}
```

## 3. MacOS builds

Use this commands to rebuild extension for all architectures on macOS:

```bash
lime rebuild mac-utils mac -64 -clean && lime rebuild mac-utils mac -debug -64 -clean && lime rebuild mac-utils mac -arm64 -clean && lime rebuild mac-utils mac -debug -arm64 -clean
```