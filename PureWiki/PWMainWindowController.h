@import Cocoa;

@class PWNavButtons;

// PWMainWindowController class
@interface PWMainWindowController : NSWindowController <NSToolbarDelegate>

@property ( weak ) IBOutlet PWNavButtons* navButtons;
@property ( weak ) IBOutlet NSButton* sidebarStyleButton;

@property ( weak ) IBOutlet NSSearchField* searchWikipediaBar;

+ ( id ) mainWindowController;

@end // PWMainWindowController