//
//  Card.m
//  Memory_NoIB
//
//  Created by Mathieu White on 2014-09-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "Card.h"

@implementation Card

- (NSInteger) match: (NSArray *) otherCards
{
    NSInteger score = 0;
    
    for (Card *card in otherCards)
    {
        if ([card.content isEqualToString: [self content]])
            score = 1;
    }
    
    return score;
}

// Equality function for two Cards
- (BOOL) isEqualToCard: (Card *) card
{
    if ([[self content] isEqualToString: [card content]])
        return YES;
    
    return NO;
}

@end
