//
//  Game.h
//  Memory_NoIB
//
//  Created by Mathieu White on 2014-09-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

static const NSInteger SCORE_BONUS = 4;
static const NSInteger SCORE_PENALTY = 2;
static const NSInteger SCORE_PER_PLAY = 1;

@interface Game : NSObject

// Designated Initializer for Game
- (instancetype) initWithCardCount: (NSUInteger) cardCount deck: (Deck *) deck;
- (void) selectCardAtIndex: (NSUInteger) index;
- (Card *) cardAtIndex: (NSUInteger) index;
- (BOOL) doSelectedCardsMatch: (NSMutableArray *) selectedCards;
- (void) updateScore: (NSInteger) score;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *selectedCards;

@end
