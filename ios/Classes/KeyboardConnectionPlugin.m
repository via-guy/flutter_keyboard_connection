#import "KeyboardConnectionPlugin.h"
#if __has_include(<keyboard_connection/keyboard_connection-Swift.h>)
#import <keyboard_connection/keyboard_connection-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "keyboard_connection-Swift.h"
#endif

@implementation KeyboardConnectionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKeyboardConnectionPlugin registerWithRegistrar:registrar];
}
@end
