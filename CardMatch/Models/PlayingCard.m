//
//  PlayingCard.m
//  Memory_NoIB
//
//  Created by Mathieu White on 2014-09-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

#pragma mark - Class Methods

// Returns the suits valid for a playing card
+ (NSArray *) validSuits
{
    return @[@"♦️", @"♥️", @"♠️", @"♣️"];
}

// Returns the valid ranks a playing card can have
+ (NSArray *) validRanks
{
    return @[@"A", @"2", @"3", @"4", @"5", @"6",
             @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

#pragma mark - Object Methods

// Returns the content (rank and suit) of the card
- (NSString *) content
{
    //NSArray *rankStrings = [PlayingCard validRanks];
    return [self.rank stringByAppendingString: self.suit];
}

// Checks if we have a pair of matching cards
- (NSInteger) match: (NSArray *) cards
{
    NSInteger score = 0;
    
    if ([cards count] == 1)
    {
        PlayingCard *card = [cards firstObject];
        if ([card isKindOfClass: [PlayingCard class]])
        {
            PlayingCard *otherCard = (PlayingCard *) card;
            if ([self.suit isEqualToString: otherCard.suit])
                score = 1;
            else if ([self.rank isEqualToString: otherCard.rank])
                score = 4;
        }
    }
    
    return score;
}

@end
