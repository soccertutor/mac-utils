#define HOME_DIR @"~"
#define DOC_DIR @"/Documents/"
#define SLASH @"/"
#define CHECK_DELIMITER @", "

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

	bool transferDataFromDocumentsToAppContainer(const char *prompt, const char *message, const char *dataFolderName, const char *checkFolders, const char *checkFiles) {
		NSString *dataFolder = [NSString stringWithUTF8String: dataFolderName];
		NSOpenPanel *panel = [[NSOpenPanel alloc] init];
		panel.prompt = [NSString stringWithUTF8String: prompt];
		panel.message = [NSString stringWithUTF8String: message];
		panel.canChooseFiles = NO;
		panel.allowsOtherFileTypes = NO;
		panel.allowsMultipleSelection = NO;
		panel.canChooseDirectories = YES;
		panel.directoryURL = [NSURL URLWithString: HOME_DIR DOC_DIR];
		NSInteger ret = [panel runModal];
		if (ret != NSModalResponseOK) return false;
		NSURL *anUrl = [[panel URLs] lastObject];
		NSString *sUrl = [anUrl absoluteString];
		NSLog(@"Selected URL: %@", sUrl);
		BOOL isAppData = [sUrl scriptingEndsWith:[[DOC_DIR stringByAppendingPathComponent:[dataFolder stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]] stringByAppendingString:SLASH]];
		BOOL isDocuments = [sUrl scriptingEndsWith:DOC_DIR];
		if (!isAppData && !isDocuments) {
			NSLog(@"These are not documents and data");
			return false;
		}

		NSFileManager *fm = [NSFileManager defaultManager];
		if (isDocuments) anUrl = [anUrl URLByAppendingPathComponent:dataFolder isDirectory:YES];
		sUrl = [[anUrl path] stringByAppendingString:SLASH];
		NSLog(@"Data URL: %@", sUrl);

		BOOL isDir;
		for (id folder in [[NSString stringWithUTF8String: checkFolders] componentsSeparatedByString:CHECK_DELIMITER]) {
			NSLog(@"Check dir %@", [sUrl stringByAppendingString:folder]);
			if (![fm fileExistsAtPath:[sUrl stringByAppendingString:folder] isDirectory:&isDir] || !isDir) {
				NSLog(@"%@ not exists or not dir", folder);
				return false;
			}
		}
		for (id file in [[NSString stringWithUTF8String: checkFiles] componentsSeparatedByString:CHECK_DELIMITER]) {
			NSLog(@"Check file %@", file);
			if (![fm fileExistsAtPath:[sUrl stringByAppendingString:file] isDirectory:&isDir] || isDir) {
				NSLog(@"%@ not exists or not file", file);
				return false;
			}
		}

		NSURL *documentsURL = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		if (anUrl == documentsURL) {
			NSLog(@"Url equals %@", anUrl);
			return false;
		}
		NSLog(@"Move files from %@ to %@", anUrl, documentsURL);

		NSError *error = Nil;
		[fm moveItemAtURL:anUrl toURL:[documentsURL URLByAppendingPathComponent:dataFolder] error:&error];
		if (error != Nil) {
			NSLog(@"Copy error: %@", error);
			return false;
		} else {
			NSLog(@"Finish copy");
			return true;
		}
	}

}