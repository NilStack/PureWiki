//
//  PWCastrateFactory.m
//  PureWiki
//
//  Created by Tong G. on 8/22/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWCastrateFactory.h"

// Private Interfaces
@interface PWCastrateFactory ()

- ( void ) _traverseNamedNodeMap: ( DOMNode* )_DOMNode;
- ( void ) _traverseDOMNodes: ( DOMNode* )_DOMNode;

@end // Private Interfaces

// PWCastrateFactory class
@implementation PWCastrateFactory

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
        self->_imageElements = [ NSMutableArray array ];
        self->_styleDeclarations = [ NSMutableArray array ];
        self->_toBeCastrated = [ NSMutableArray array ];
        }

    return self;
    }

- ( WebArchive* ) castrateHTMLDocument: ( DOMHTMLDocument* )_HTMLDocument URL: ( NSURL* )_URL oldArchive: ( WebArchive* )_OldArchive
    {
    return nil;
    }

- ( void ) _traverseNamedNodeMap: ( DOMNode* )_DOMNode
    {
    DOMNamedNodeMap* attrs = [ _DOMNode attributes ];

    for ( int _Index = 0; _Index < attrs.length; _Index++ )
        {
        DOMAttr* attr = ( DOMAttr* )[ attrs item: _Index ];

        if ( attr.style.cssText.length )
            [ self->_styleDeclarations addObject: attr.style ];

        if ( attr.childNodes.length > 0 )
            [ self _traverseNamedNodeMap: attr ];
        }
    }

- ( void ) _traverseDOMNodes: ( DOMNode* )_DOMNode
    {
    DOMNodeList* nodeList = [ _DOMNode childNodes ];

    for ( int _Index = 0; _Index < nodeList.length; _Index++ )
        {
        DOMNode* node = [ nodeList item: _Index ];

        NSString* className = [ ( DOMHTMLElement* )node className ];
        if ( [ className isEqualToString: @"mw-editsection" ]
                || [ className isEqualToString: @"toctoggle" ]
                || [ className isEqualToString: @"printfooter" ]
                || [ className isEqualToString: @"metadata plainlinks mbox-small" ]
                || [ className isEqualToString: @"mbox-small plainlinks sistersitebox" ]
                || [ className isEqualToString: @"collapseButton" ] /* FIXME */ )
            [ self->_toBeCastrated addObject: node ];

        if ( [ node respondsToSelector: @selector( idName ) ] )
            {
            NSString* idName = [ ( DOMHTMLElement* )node idName ];
            if ( [ idName isEqualToString: @"mw-navigation" ]
                    || [ idName isEqualToString: @"footer" ]
                    || [ idName isEqualToString: @"siteSub" ]
                    || [ idName isEqualToString: @"mw-head-base" ]
                    || [ idName isEqualToString: @"mw-page-base" ] )
                [ self->_toBeCastrated addObject: node ];
            }

        if ( [ node isKindOfClass: [ DOMHTMLHeadElement class ] ] )
            self->_headElement = ( DOMHTMLHeadElement* )node;

        if ( [ node isKindOfClass: [ DOMHTMLStyleElement class ] ] )
            self->_styleElement = ( DOMHTMLStyleElement* )node;

        if ( [ node isKindOfClass: [ DOMHTMLDivElement class ] ] )
            if ( [ [ ( DOMHTMLDivElement* )node idName ] isEqualToString: @"toctitle" ] )
                self->_toctitleElement = ( DOMHTMLDivElement* )node;


        // <td>
        if ( [ node isKindOfClass: [ DOMHTMLTableCellElement class ] ] )
            if ( [ [ ( DOMHTMLTableCellElement* )node className ] isEqualToString: @"hlist" ] )
                self->_hlistTableDataElement = ( DOMHTMLTableCellElement* )node;

        // <link>
        if ( [ node isKindOfClass: [ DOMHTMLLinkElement class ] ] )
            {
            DOMHTMLLinkElement* linkElement = ( DOMHTMLLinkElement* )node;

            if ( [ linkElement.parentElement isKindOfClass: [ DOMHTMLHeadElement class ] ] )
                {
                DOMNamedNodeMap* attrs = [ linkElement attributes ];
                for ( int _Index = 0; _Index < attrs.length; _Index++ )
                    {
                    NSString* attrName = [ attrs item: _Index ].nodeName;
                    NSString* attrValue = [ attrs item: _Index ].nodeValue;

                    if ( [ attrName isEqualToString: @"rel" ] && [ attrValue isEqualToString: @"stylesheet" ] )
                        {
                        NSLog( @"Deleting…" );
                        [ self->_toBeCastrated addObject: linkElement ];
                        }
                    }
                }
            }

        // <img>
        if ( [ node isKindOfClass: [ DOMHTMLImageElement class ] ] )
            [ self->_imageElements addObject: node ];

        // <table>
        if ( [ node isKindOfClass: [ DOMHTMLTableElement class ] ] )
            {
            DOMHTMLTableElement* HTMLTable = ( DOMHTMLTableElement* )node;
            DOMHTMLCollection* rowsCollection = [ HTMLTable rows ];

            for ( int _Index = 0; _Index < rowsCollection.length; _Index++ )
                {
                DOMHTMLTableRowElement* rowElement = ( DOMHTMLTableRowElement* )[ rowsCollection item: _Index ];

                DOMHTMLCollection* cells = [ rowElement cells ];
                for ( int _Index = 0; _Index < cells.length; _Index++ )
                    {
                    // TODO:
                    }
                }
            }

        if ( node.childNodes.length > 0 )
            {
            [ self _traverseDOMNodes: node ];
            [ self _traverseNamedNodeMap: node ];
            }
        }
    }

@end // PWCastrateFactory class
