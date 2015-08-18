#import "PWMainWindowController.h"
#import "PWNavButtonsPairView.h"
#import "PWBrain.h"
#import "PWActionNotifications.h"

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

#pragma mark IBActions
- ( IBAction ) searchWikipediaAction: ( id )_Sender
    {
    NSString* searchValue = [ ( NSSearchField* )_Sender stringValue ];
    [ [ PWBrain wiseBrain ] searchAllPagesThatHaveValue: searchValue
                                           inNamespaces: nil
                                                   what: WikiEngineSearchWhatPageText
                                                  limit: 10
                                                success:
        ^( NSArray* _MatchedPages )
            {
            if ( _MatchedPages )
                [ [ NSNotificationCenter defaultCenter ] postNotificationName: PureWikiDidSearchPagesNotif
                                                                       object: self
                                                                     userInfo: @{ kPages : _MatchedPages } ];
            } failure:
                ^( NSError* _Error )
                    {
                    NSLog( @"%@", _Error );
                    } ];
    }

@end // PWMainWindowController