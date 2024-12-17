#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "MacUtils.h"


using namespace mac_utils;

AutoGCRoot* macUtilsEventHandle = 0;

static value mac_utils_set_event_handle(value onEvent)
{
	#if defined(HX_MACOS)
	macUtilsEventHandle = new AutoGCRoot(onEvent);
	#endif
	return alloc_null();
}
DEFINE_PRIM(mac_utils_set_event_handle, 1);

static value mac_utils_save_file_with_type(value data, value type) {
	saveFileWithType(val_string(data), val_string(type));
	return alloc_null();
}
DEFINE_PRIM (mac_utils_save_file_with_type, 2);

static value mac_utils_transfer_data_from_documents_to_app_container(value prompt, value message, value dataFolderName, value checkFolders, value checkFiles) {
	return alloc_bool(transferDataFromDocumentsToAppContainer(val_string(prompt), val_string(message), val_string(dataFolderName), val_string(checkFolders), val_string(checkFiles)));
}
DEFINE_PRIM (mac_utils_transfer_data_from_documents_to_app_container, 5);

extern "C" void mac_utils_main () {

	val_int(0); // Fix Neko init

}
DEFINE_ENTRY_POINT (mac_utils_main);



extern "C" int mac_utils_register_prims () { return 0; }

extern "C" void sendMacUtilsEvent(const char* type, const char* data)
{
    value o = alloc_empty_object();
    alloc_field(o,val_id("type"),alloc_string(type));
    alloc_field(o,val_id("data"),alloc_string(data));
    val_call1(macUtilsEventHandle->get(), o);
}