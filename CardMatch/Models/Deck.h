//
//  Deck.h
//  Memory_NoIB
//
//  Created by Mathieu White on 2014-09-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void) addCard: (Card *) card toTop: (BOOL) toTop;
- (void) addCard: (Card *) card;

- (Card *) drawRandomCard;

@end
