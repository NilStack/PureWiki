/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 ______                   _  _  _ _ _     _ _                 |██
|                (_____ \                 (_)(_)(_|_) |   (_) |                |██
|                 _____) )   _  ____ _____ _  _  _ _| |  _ _| |                |██
|                |  ____/ | | |/ ___) ___ | || || | | |_/ ) |_|                |██
|                | |    | |_| | |   | ____| || || | |  _ (| |_                 |██
|                |_|    |____/|_|   |_____)\_____/|_|_| \_)_|_|                |██
|                                                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "NSColor+TKSafariSearchbar.h"

#import "__TKSearchbarBackingLayer.h"
#import "__TKPlaceholderTextLayer.h"
#import "__TKFrozenTitleTextLayer.h"

// Private Interfaces
@interface __TKSearchbarBackingLayer ()

@property ( assign, readwrite, setter = setActive: ) BOOL isActive;

- ( void ) _appDidBecomeActive: ( NSNotification* )_Notif;
- ( void ) _appDidResignActive: ( NSNotification* )_Notif;

@end // Private Interfaces

// __TKSearchbarBackingLayer class
@implementation __TKSearchbarBackingLayer

@dynamic isActive;
@dynamic isFocusing;

@dynamic placeholderString;
@dynamic frozenTitle;

#pragma mark Initializations
+ ( instancetype ) layerWithHostView: ( NSView* )_HostView
    {
    return [ [ self alloc ] initWithHostView: _HostView ];
    }

- ( instancetype ) initWithHostView: ( NSView* )_HostView
    {
    if ( self = [ super init ] )
        {
        self->_hostView = _HostView;
        self->_isActive = NO;

        [ self setBounds: _HostView.bounds ];
        [ self setPosition: CGPointMake( NSMinX( self.frame ), NSMinY( self.frame ) ) ];
        [ self setContentsScale: 2.f ];
        [ self setLayoutManager: [ CAConstraintLayoutManager layoutManager ] ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _appDidBecomeActive: )
                                                        name: NSApplicationDidBecomeActiveNotification
                                                      object: nil ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _appDidResignActive: )
                                                        name: NSApplicationDidResignActiveNotification
                                                      object: nil ];

        self->_placeholderLayer = [ __TKPlaceholderTextLayer layerWithContent: nil ];
        self->_frozenTitleTextLayer = [ __TKFrozenTitleTextLayer layerWithContent: nil ];

        [ self setPlaceholderString: @"Search Wikipedia" ];

//        [ self->_placeholderLayer addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintMidY
//                                                                             relativeTo: @"superlayer"
//                                                                              attribute: kCAConstraintMidY ] ];
//
//        [ self->_placeholderLayer addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintMidX
//                                                                             relativeTo: @"superlayer"
//                                                                              attribute: kCAConstraintMidX ] ];
        }

    return self;
    }

- ( void ) dealloc
    {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: NSApplicationDidBecomeActiveNotification object: nil ];
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: NSApplicationDidResignActiveNotification object: nil ];
    }

#pragma mark Custom Drawing
- ( void ) drawInContext: ( nonnull CGContextRef )_cgCtx
    {
    CGMutablePathRef cgPath = CGPathCreateMutable();

    CGPathAddRoundedRect( cgPath, NULL, NSInsetRect( self.bounds, 1.f, 1.f ), 4.f, 4.f );
    CGContextAddPath( _cgCtx, cgPath );

    CGContextSetFillColorWithColor( _cgCtx, [ NSColor colorWithHTMLColor: @"FCFBFC" ].CGColor );

    if ( self->_isActive )
        {
        CGColorRef cgShadowColor = [ [ NSColor blackColor ] colorWithAlphaComponent: .2f ].CGColor;

        if ( !self->_isFocusing )
            CGContextSetShadowWithColor( _cgCtx, CGSizeMake( 0.f, .3f ), .7f, cgShadowColor );
        }
    else
        {
        CGColorRef cgStrokeColor = [ [ NSColor blackColor ] colorWithAlphaComponent: .36f ].CGColor;
        CGContextSetStrokeColorWithColor( _cgCtx, cgStrokeColor );
        CGContextSetLineWidth( _cgCtx, .2f );
        CGContextStrokePath( _cgCtx );
        }

    CGContextFillPath( _cgCtx );
    CFRelease( cgPath );
    }

#pragma mark Dynamic Properties
- ( void ) setActive: ( BOOL )_YesOrNo
    {
    self->_isActive = _YesOrNo;
    [ self setNeedsDisplay ];
    }

- ( BOOL ) isActive
    {
    return self->_isActive;
    }

- ( BOOL ) isFocusing
    {
    return self->_isFocusing;
    }

- ( void ) setPlaceholderString: ( NSString* )_Placeholder
    {
    [ self->_placeholderLayer setContent: _Placeholder ];

    if ( _Placeholder.length > 0 )
        {
        [ self->_placeholderLayer addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintMidY
                                                                             relativeTo: @"superlayer"
                                                                              attribute: kCAConstraintMidY ] ];

        [ self->_placeholderLayer addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintMidX
                                                                             relativeTo: @"superlayer"
                                                                              attribute: kCAConstraintMidX ] ];
        [ self->_frozenTitleTextLayer removeFromSuperlayer ];
        [ self addSublayer: self->_placeholderLayer ];
        }
    }

- ( NSString* ) placeholderString
    {
    return self->_placeholderLayer.content;
    }

- ( void ) setFrozenTitle: ( NSString* )_FrozenTitle
    {
    [ self->_frozenTitleTextLayer setContent: _FrozenTitle ];

    if ( _FrozenTitle.length > 0 )
        {
        [ self->_frozenTitleTextLayer addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintMidY
                                                                                 relativeTo: @"superlayer"
                                                                                  attribute: kCAConstraintMidY ] ];

        [ self->_frozenTitleTextLayer addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintMidX
                                                                                 relativeTo: @"superlayer"
                                                                                  attribute: kCAConstraintMidX ] ];
        [ self->_placeholderLayer removeFromSuperlayer ];
        [ self addSublayer: self->_frozenTitleTextLayer ];
        }
    }

- ( NSString* ) frozenTitle
    {
    return self->_frozenTitleTextLayer.content;
    }

#pragma mark Private Interfaces
- ( void ) _appDidBecomeActive: ( NSNotification* )_Notif
    {
    self.isActive = YES;
    }

- ( void ) _appDidResignActive: ( NSNotification* )_Notif
    {
    self.isActive = NO;
    }

@end // __TKSearchbarBackingLayer class

/*===============================================================================┐
|                                                                                | 
|                      ++++++     =++++~     +++=     =+++                       | 
|                        +++,       +++      =+        ++                        | 
|                        =+++       ~+++     +        =+                         | 
|                         +++=       =++=   +=        +                          | 
|                          +++        +++= +=        +=                          | 
|                          =+++        ++++=        =+                           | 
|                           +++=       =+++         +                            | 
|                            +++~       +++=       +=                            | 
|                            ,+++      ~++++=     ==                             | 
|                             ++++     +  +++     +                              | 
|                              +++=   +   ~+++   +,                              | 
|                               +++  +:    =+++ ==                               | 
|                               =++++=      +++++                                | 
|                                +++=        +++                                 | 
|                                 ++          +=                                 | 
|                                                                                | 
└===============================================================================*/