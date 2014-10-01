//
//  CardView.h
//  Memory_NoIB
//
//  Created by Mathieu White on 2014-09-15.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardDeck.h"

@class CardView;

@protocol CardViewDelegate <NSObject>

- (void) selectedCardsDoMatch: (NSMutableArray *) selectedCards;
- (void) selectedCardsDoNotMatch: (NSMutableArray *) selectedCards;
- (void) cardHasBeenFlippedFaceUp: (CardView *) card;
- (void) cardHasBeenFlippedFaceDown: (CardView *) card;

@end

@interface CardView : UIView

@property (nonatomic, weak) id <CardViewDelegate> delegate;

@property (nonatomic, strong) Card *card;

@property (nonatomic) BOOL isCardFaceUp;
@property (nonatomic) BOOL isCardMatched;

- (instancetype) initWithFrame: (CGRect) frame cardValue: (NSString *) cardValue;
- (void) flipCardFromLeft;
- (void) flipCardFromRight;
- (void) doCardMatchedAnimation;
- (void) doCardNotMatchedAnimation;
- (void) setSelectedCardAsMatched;

@end