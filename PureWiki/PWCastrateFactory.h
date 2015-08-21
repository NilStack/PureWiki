//
//  PWCastrateFactory.h
//  PureWiki
//
//  Created by Tong G. on 8/22/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Foundation;
@import WebKit;

// PWCastrateFactory class
@interface PWCastrateFactory : NSObject
    {
@protected
    NSURL __strong* _cssLabURL;

    NSMutableArray __strong* _imageElements;
    NSMutableArray __strong* _styleDeclarations;
    NSMutableArray __strong* _toBeCastrated;

    DOMHTMLHeadElement __strong* _headElement;
    DOMHTMLStyleElement __strong* _styleElement;
    DOMHTMLDivElement __strong* _toctitleElement;
    DOMHTMLTableElement __strong* _metadataTableElement;         /* class="metadata plainlinks ambox ambox-content ambox-multiple_issues compact-ambox" */
    DOMHTMLTableCellElement __strong* _hlistTableDataElement;    /* class="hlist" */
    }

- ( WebArchive* ) castrateFrame: ( WebFrame* )_Frame;

@end // PWCastrateFactory class
