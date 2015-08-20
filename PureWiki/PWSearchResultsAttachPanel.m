//
//  PWSearchResultsAttachPanel.m
//  PureWiki
//
//  Created by Tong G. on 8/20/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWSearchResultsAttachPanel.h"
#import "NSObject+PWSmartSearchBar.h"

// PWSearchResultsAttachPanel class
@implementation PWSearchResultsAttachPanel

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    [ self setLevel: NSFloatingWindowLevel ];

    [ self setOpaque: NO ];
    self.backgroundColor = [ NSColor clearColor ];

    NSImage* maskImage = [ self _maskImageWithCornerRadius: 5.f ];
    self.panelVEView.maskImage = maskImage;

    self.cornerMask = maskImage;
    }

#pragma mark Hack
- ( NSImage* ) _cornerMask
    {
//    NSProcessInfo* processInfo = [ NSProcessInfo processInfo ];
//    NSOperatingSystemVersion systemVersion = [ processInfo operatingSystemVersion ];

//    if ( systemVersion.minorVersion == 10 )
//        {
//        NSImage* image = [ self performSelector: @selector( _cornerMask ) asClass: [ self superclass ] ];
//        NSLog( @"%@", image );
//        return image;
//        }

//    return nil;

    return self.cornerMask;
    }

- ( NSImage* ) _maskImageWithCornerRadius: ( CGFloat )_CornerRadius
    {
    CGFloat edgeLength = 2.f * _CornerRadius + 1.f;
    NSImage* maskImage = [ NSImage imageWithSize: NSMakeSize( edgeLength, edgeLength )
                                         flipped: NO
                                  drawingHandler:
        ^BOOL( NSRect _DstRect )
            {
            NSBezierPath* bezierPath = [ NSBezierPath bezierPathWithRoundedRect: _DstRect xRadius: _CornerRadius yRadius: _CornerRadius ];
            [ [ NSColor blackColor ] set ];
            [ bezierPath fill ];

            return YES;
            } ];

    [ maskImage setCapInsets: NSEdgeInsetsMake( _CornerRadius, _CornerRadius, _CornerRadius, _CornerRadius ) ];
    return maskImage;
    }

@end // PWSearchResultsAttachPanel class