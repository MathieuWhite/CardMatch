//
//  PlayingCardDeck.m
//  Memory_NoIB
//
//  Created by Mathieu White on 2014-09-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
        for (NSString *suit in [PlayingCard validSuits])
        {
            for (NSString *rank in [PlayingCard validRanks])
            {
                PlayingCard *card = [[PlayingCard alloc] init];
                [card setRank: rank];
                [card setSuit: suit];
                [self addCard: card];
            }
        }
    }
    
    return self;
}

@end
