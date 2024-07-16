package extension.macutils;

import openfl.events.Event;

class MacUtilsEvent extends Event {

	public static inline var SELECT_FOLDER_SUCCESS = "select_folder_success";
	public static inline var SELECT_FOLDER_ERROR = "select_folder_error";
	public var data:String;

	public function new (type:String, data:String) {
		super(type);
		this.data = data;
	}
}