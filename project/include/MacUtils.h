#ifndef MAC_UTILS_H
#define MAC_UTILS_H


namespace mac_utils {

	extern "C" {
		void saveFileWithType(const char *data, const char *type);
		bool transferDataFromDocumentsToAppContainer(const char *prompt, const char *message, const char *dataFolderName, const char *checkFolders, const char *checkFiles);
	}

}


#endif