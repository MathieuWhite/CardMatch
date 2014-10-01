//
//  Game.m
//  Memory_NoIB
//
//  Created by Mathieu White on 2014-09-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "Game.h"
#import "CardView.h"

@interface Game()

@property (nonatomic, readwrite) NSInteger score;

@end

@implementation Game


// Designated Initializer for Game
- (instancetype) initWithCardCount: (NSUInteger) cardCount deck: (Deck *) deck
{
    self = [super init];
    
    if (self)
    {
        NSMutableArray *selectedCards = [[NSMutableArray alloc] initWithCapacity: 2];
        NSMutableArray *cards = [[NSMutableArray alloc] initWithCapacity: cardCount];
        for (NSUInteger i = 0; i < cardCount; i++)
        {
            Card *card = [deck drawRandomCard];
            if (card) [cards addObject: card];
            else
            {
                self = nil;
                break;
            }
        }
        [self setCards: cards];
        [self setSelectedCards: selectedCards];
        
    }
    
    return self;
}

// Returns the card at index
- (Card *) cardAtIndex: (NSUInteger) index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}


- (void) selectCardAtIndex: (NSUInteger) index
{
    Card *card = [self cardAtIndex: index];
    
    if (![card isMatched])
    {
        if ([card isChosen]) [card setIsChosen: NO];
        else
        {
            for (Card *otherCard in self.cards)
            {
                if ([otherCard isChosen] && ![otherCard isMatched])
                {
                    NSInteger score = [card match: @[otherCard]];
                    if (score)
                    {
                        [self setScore: self.score + score * SCORE_BONUS];
                        [otherCard setIsMatched: YES];
                        [card setIsMatched: YES];
                    }
                    else
                    {
                        [self setScore: self.score - SCORE_PENALTY];
                        [otherCard setIsChosen: NO];
                    }
                    // You can only choose 2 cards
                    break;
                }
            }
            
            [self setScore: self.score - SCORE_PER_PLAY];
            [card setIsChosen: YES];
        }
    }
}

- (void) updateScore: (NSInteger) score
{
    [self setScore: [self score] + score];
}

// Method to check if selected cards match
- (BOOL) doSelectedCardsMatch: (NSMutableArray *) selectedCards
{
    if ([[[selectedCards objectAtIndex: 0] card] isEqualToCard: [[selectedCards objectAtIndex: 1] card]])
        return YES;
    
    return NO;
}

@end
