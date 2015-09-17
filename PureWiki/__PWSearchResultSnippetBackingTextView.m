//
//  __PWSearchResultSnippetBackingTextView.m
//  PureWiki
//
//  Created by Tong G. on 9/18/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "__PWSearchResultSnippetBackingTextView.h"

@implementation __PWSearchResultSnippetBackingTextView

//- ( void ) clickedOnLink: ( id )_Link atIndex: ( NSUInteger )_CharIndex
//    {
//    NSLog( @"%@", _Link );
//    }

- ( NSRange ) selectionRangeForProposedRange: ( NSRange )_ProposedSelRange
                                 granularity: ( NSSelectionGranularity )_Granularity
    {
    return NSMakeRange( 0, 0 );
    }

@end
