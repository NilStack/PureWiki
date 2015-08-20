//
//  PWSearchResultsAttachPanelController.m
//  PureWiki
//
//  Created by Tong G. on 8/20/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWSearchResultsAttachPanelController.h"

// Private Interfaces
@interface PWSearchResultsAttachPanelController ()

@end // Private Interfaces

// PWSearchResultsAttachPanelController class
@implementation PWSearchResultsAttachPanelController

#pragma mark Initializations
+ ( instancetype ) panelController
    {
    return [ [ [ self class ] alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( self = [ super initWithWindowNibName: @"PWSearchResultsAttachPanel" owner: self ] )
        ;

    return self;
    }

- ( void ) windowDidLoad
    {
    [ super windowDidLoad ];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

@end // PWSearchResultsAttachPanelController class