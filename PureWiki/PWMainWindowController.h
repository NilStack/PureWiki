@import Cocoa;

// PWMainWindowController class
@interface PWMainWindowController : NSWindowController <NSTextViewDelegate>

+ ( id ) mainWindowController;

#pragma mark IBActions
- ( IBAction ) searchWikipediaAction: ( id )_Sender;

@end // PWMainWindowController