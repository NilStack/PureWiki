#import "PWMainWindowController.h"
#import "PWNavButtonsPairView.h"

// Private Interfaces
@interface PWMainWindowController ()
@end // Private Interfaces

// prefixWindowController class
@implementation PWMainWindowController

#pragma mark Initializers
+ ( instancetype ) mainWindowController
    {
    return [ [ [ self class ] alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( self = [ super initWithWindowNibName: @"PWMainWindow" ] )
        {
        // TODO:
        }

    return self;
    }

#pragma mark Conforms <NSNibAwaking> protocol
- ( void ) awakeFromNib
    {
    // TODO:
    }

@end // PWMainWindowController