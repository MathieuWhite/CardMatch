//
//  Deck.m
//  Memory_NoIB
//
//  Created by Mathieu White on 2014-09-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@property (nonatomic, strong) NSMutableArray *cards;

@end

@implementation Deck

// Returns the deck of cards
- (NSMutableArray *) cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

// Adds a new card to the deck
- (void) addCard:(Card *)card
{
    [self addCard: card toTop: NO];
}

// Adds a new card to the top of the deck
- (void) addCard: (Card *) card toTop: (BOOL) toTop
{
    if (toTop) [self.cards insertObject: card atIndex: 0];
    else [self.cards addObject: card];
}

// Returns a random card from the deck
- (Card *) drawRandomCard
{
    Card *randomCard = nil;
    
    if ([self.cards count])
    {
        NSUInteger index = arc4random() % [self.cards count];
        randomCard = [self.cards objectAtIndex: index];
        [self.cards removeObjectAtIndex: index];
    }
    
    return randomCard;
}

@end
