//
//  GameView.m
//  Memory_NoIB
//
//  Created by Mathieu White on 2014-09-17.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "GameView.h"
#import "Game.h"

@interface GameView() <CardViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *cardViews;
@property (nonatomic, weak) UILabel *scoreLabel;

@end

@implementation GameView

#pragma mark - UIView Methods

- (instancetype) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        [self gameInit];
    }
    
    return self;
}

#pragma mark - Object Methods

- (void) gameInit
{
    // Set the background image
    [self setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"felt"]]];
    
    // Init the deck of cards
    PlayingCardDeck *deck = [[PlayingCardDeck alloc] init];
    
    // Initialize the array holding the cards
    NSMutableArray *cards = [[NSMutableArray alloc] initWithCapacity: 16];
    
    // Iinitalize the array holding the card views
    NSMutableArray *cardViews = [[NSMutableArray alloc] initWithCapacity: 16];

    
    // Draw 8 random cards and add them to the array twice
    for (NSUInteger i = 0; i < 8; i++)
    {
        Card *randomCard = [deck drawRandomCard];
        [cards addObject: randomCard];
        [cards addObject: randomCard];
    }
        
    // Initialize a new game
    Game *game = [[Game alloc] initWithCardCount: [cards count]
                                            deck: deck];
    
    // Shuffle the playing cards
    [self shufflePlayingCards: cards];
    
    for (Card *card in cards)
        NSLog(@"Card: %@", [card content]);
    
    // Create the CardViews
    NSUInteger index = 0;
    for (NSUInteger col = 0; col < 4; col++)
    {
        for (NSUInteger row = 0; row < 4; row++)
        {
            CGFloat x = 10 + (row * 67) + (row * 10);
            CGFloat y = 40 + (col * 90) + (col * 20);
            
            CardView *cardView = [[CardView alloc] initWithFrame: CGRectMake(x, y, 67, 99)
                                                       cardValue: [[cards objectAtIndex: index] content]];
            [cardView setDelegate: self];
            [cardViews addObject: cardView];
            [self addSubview: cardView];
            index++;
        }
    }
    
    // Create the score label
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 300, 24)];
    [scoreLabel setText: [NSString stringWithFormat: @"Score: %2ld", (long) [game score]]];
    [scoreLabel setTextColor: [UIColor whiteColor]];
    [scoreLabel setCenter: CGPointMake(self.center.x, self.frame.size.height - 48)];
    [scoreLabel setTextAlignment: NSTextAlignmentCenter];
    
    // Add the components to the view
    [self addSubview: scoreLabel];
    
    // Set each component to a property
    [self setScoreLabel: scoreLabel];
    [self setCards: cards];
    [self setGame: game];
    [self setCardViews: cardViews];
}

// Method to shuffle the playing cards
- (void) shufflePlayingCards: (NSMutableArray *) cards
{
    for (NSUInteger i = 0; i < [cards count]; i++)
    {
        NSUInteger random = arc4random_uniform((uint32_t) [cards count]);
        [cards exchangeObjectAtIndex: random withObjectAtIndex: i];
    }
}

#pragma mark - CardViewDelegate Methods

- (void) cardHasBeenFlippedFaceUp: (CardView *) card
{    
    // Check to see if two cards have been selected
    if ([self.game.selectedCards count] > 0)
    {
        [self.game.selectedCards addObject: card];
        if ([self.game doSelectedCardsMatch: [self.game selectedCards]])
        {
            if ([card.delegate respondsToSelector:@selector(selectedCardsDoMatch:)])
                [self selectedCardsDoMatch: [[self.game selectedCards] copy]];
            [self.game.selectedCards removeAllObjects];
        }
        else
        {
            if ([card.delegate respondsToSelector:@selector(selectedCardsDoNotMatch:)])
                [self selectedCardsDoNotMatch: [[self.game selectedCards] copy]];
            [self.game.selectedCards removeAllObjects];
        }
    }
    else
    {
        [self.game.selectedCards addObject: card];
    }
}

- (void) cardHasBeenFlippedFaceDown: (CardView *) card
{
    [self.game.selectedCards removeLastObject];
}

- (void) selectedCardsDoMatch: (NSMutableArray *) selectedCards
{
    for (CardView *cardView in selectedCards)
    {
        [cardView setSelectedCardAsMatched];
    }
    
    [self updateGameScore: 10];
    
    BOOL hasWon = YES;
    
    for (CardView *cardView in [self cardViews])
    {
        if (![cardView isCardMatched])
        {
            hasWon = NO;
            break;
        }
    }
    
    if (hasWon)
        [self showUserDidWin];
}

- (void) selectedCardsDoNotMatch: (NSMutableArray *) selectedCards
{
    for (CardView *cardView in selectedCards)
    {
        [cardView doCardNotMatchedAnimation];
    }
    
    [self updateGameScore: -2];
}

- (void) updateGameScore: (NSInteger) score
{
    [self.game updateScore: score];

    [UIView transitionWithView: [self scoreLabel]
                      duration: 0.2
                       options: UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        [self.scoreLabel setText: [NSString stringWithFormat: @"Score: %2ld", (long) [self.game score]]];
                        [self.scoreLabel setTransform: CGAffineTransformMakeScale(1.1, 1.1)];
                    }
                    completion: ^(BOOL _finished){
                        [UIView transitionWithView: [self scoreLabel]
                                          duration: 0.2
                                           options: UIViewAnimationOptionCurveEaseInOut
                                        animations:^{
                                            [self.scoreLabel setTransform: CGAffineTransformMakeScale(1.0, 1.0)];
                                        }
                                        completion: NULL];
                    }];
}

- (void) showUserDidWin
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"You Won!"
                                                        message: [NSString stringWithFormat: @"Your Score: %ld", (long) [self.game score]]
                                                       delegate: self
                                              cancelButtonTitle: nil
                                              otherButtonTitles: @"New Game", nil];
    
    [alertView show];
}

#pragma mark - UIAlertViewDelegate Methods

- (void) alertView: (UIAlertView *) alertView didDismissWithButtonIndex: (NSInteger) buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName: kGameViewDidFinishNewGameNotification object: nil];
}

@end
