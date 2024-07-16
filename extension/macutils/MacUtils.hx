package extension.macutils;

import cpp.Lib;
import openfl.events.Event;
import openfl.events.EventDispatcher;

class MacUtils {
	
	private static var initialized:Bool = false;
	private static var dispatcher = new EventDispatcher ();

	public static function addEventListener (type:String, listener:Dynamic, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		dispatcher.addEventListener (type, listener, useCapture, priority, useWeakReference);
	}
	
	public static function removeEventListener (type:String, listener:Dynamic):Void {
		dispatcher.removeEventListener (type, listener);
	}
	
	public static function dispatchEvent (event:Event):Bool {
		return dispatcher.dispatchEvent (event);
	}
	
	public static function hasEventListener (type:String):Bool {
		return dispatcher.hasEventListener (type);
	}
	private static function notifyListeners (inEvent:Dynamic) {
		#if mac
		var type = Std.string (Reflect.field (inEvent, "type"));
		var data = Std.string (Reflect.field (inEvent, "data"));
		dispatcher.dispatchEvent(new MacUtilsEvent(type, data));
		#end
	}

	public static function initialize ():Void {
		#if mac
		if (!initialized) {
			initialized = true;
			mac_utils_set_event_handle (notifyListeners);
		}
		#end
	}
	
	public static function saveFileWithType (data:String, type:String) {
		#if mac
		return mac_utils_save_file_with_type(data, type);
		#end
	}
	
	#if mac
	private static var mac_utils_save_file_with_type = Lib.load ("mac_utils", "mac_utils_save_file_with_type", 2);
	private static var mac_utils_set_event_handle = cpp.Lib.load ("mac_utils", "mac_utils_set_event_handle", 1);
	#end
	
	
}