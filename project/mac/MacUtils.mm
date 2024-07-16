#import <Cocoa/Cocoa.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#include <MacUtils.h>

namespace mac_utils {
	
	extern "C" void sendMacUtilsEvent (const char* event, const char* data);
	static const char* SELECT_FOLDER_SUCCESS = "select_folder_success";
	static const char* SELECT_FOLDER_ERROR = "select_folder_error";

	// data is base64 representation of jpg or pdf file
	// type can be "jpg" or "pdf"
	void saveFileWithType(const char *data, const char *type) {
		NSSavePanel* savePanel = [NSSavePanel savePanel];
		//savePanel.level = NSModalPanelWindowLevel;
		savePanel.prompt = @"Save";
		savePanel.message = @"Please select save path";

		NSArray<UTType *> *allowedContentTypes;

		if (strcmp(type,"jpg") == 0) {
			[savePanel setNameFieldStringValue:@"Untitled.jpg"];
			allowedContentTypes = @[UTTypeJPEG];
		} else
		if (strcmp(type,"pdf") == 0) {
			[savePanel setNameFieldStringValue:@"Untitled.pdf"];
			allowedContentTypes = @[UTTypePDF];
		}

		[savePanel setAllowedContentTypes:allowedContentTypes];
		[savePanel setCanCreateDirectories:YES];
		[savePanel setExtensionHidden:NO];
		
		NSInteger result = [savePanel runModal];
		//NSLog(@"Result: %ld", result);

		if (result == NSModalResponseOK) {
			NSData *dataToSave = [[NSData alloc] initWithBase64EncodedString:[NSString stringWithUTF8String:data] options:kNilOptions];
			[dataToSave writeToFile: [[savePanel URL] path] atomically: YES];

			sendMacUtilsEvent(SELECT_FOLDER_SUCCESS, "success");
		} else {
			sendMacUtilsEvent(SELECT_FOLDER_ERROR, "error");
		}
	}
}