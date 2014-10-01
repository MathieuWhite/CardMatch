//
//  CardView.m
//  Memory_NoIB
//
//  Created by Mathieu White on 2014-09-15.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "CardView.h"

@interface CardView()

@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) NSString *cardValue;
@property (nonatomic, weak) UIImageView *cardImage;
@property (nonatomic, weak) UILabel *cardLabel;
@property (nonatomic, strong) UIColor *cardFontColor;

@end

@implementation CardView

#pragma mark - UIView Methods

- (instancetype) initWithFrame: (CGRect) frame cardValue: (NSString *) cardValue
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        [self setCardValue: cardValue];
        [self cardInit];
    }
    
    return self;
}

#pragma mark - Object Methods

- (void) cardInit
{
    // Create the gesture recognizer to handle touches on the card
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget: self action: @selector(cardTouched)];
    
    // Create a new Card
    Card *card = [[Card alloc] init];
    [card setContent: [self cardValue]];
    
    // Create the image view containing the card image
    UIImageView *cardImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"cardBack"]];
    
    // Create the label containing the card's suit and value
    UILabel *cardLabel = [[UILabel alloc] initWithFrame: [self bounds]];
    [cardLabel setTextAlignment: NSTextAlignmentCenter];
    [cardLabel setText: @""];
    
    NSRange spades = [[self cardValue] rangeOfString: @"♠️"];
    NSRange clubs = [[self cardValue] rangeOfString: @"♣️"];
    
    // Set the card's font color based on the suit
    if (spades.location != NSNotFound || clubs.location != NSNotFound)
        [cardLabel setTextColor: [UIColor blackColor]];
    else [cardLabel setTextColor: [UIColor redColor]];
        
    // Add the objets to the view
    [self addGestureRecognizer: tapGestureRecognizer];
    [self addSubview: cardImage];
    [self addSubview: cardLabel];
    
    // Set the objects to properties
    [self setTapGestureRecognizer: tapGestureRecognizer];
    [self setCard: card];
    [self setCardImage: cardImage];
    [self setCardLabel: cardLabel];
}

- (void) cardTouched
{
    if ([[self.cardLabel text] isEqualToString: @""])
    {
        [self setIsCardFaceUp: NO];
        [self flipCardFromRight];
    }
    else
    {
        [self setIsCardFaceUp: YES];
        [self flipCardFromLeft];
    }
}

- (void) setSelectedCardAsMatched
{
    [self setIsCardMatched: YES];
    [self doCardMatchedAnimation];
    [self removeGestureRecognizer: [self tapGestureRecognizer]];
}

#pragma mark - Animation Methods

- (void) flipCardFromLeft
{
    // Enable taps
    [self.tapGestureRecognizer setEnabled: YES];

    // Disable user interaction while CardViews animate
    //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [UIView transitionWithView: self
                      duration: 0.6
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations: ^{
                        UIImage *back = [UIImage imageNamed: @"cardBack"];
                        [self.cardImage setImage: back];
                        [self.cardLabel setText: @""];
                    }
                    completion: ^(BOOL _finished){
                        // Check if the delegate is set and it responds to the selector
                        if ([self.delegate respondsToSelector:@selector(cardHasBeenFlippedFaceDown:)])
                            [self.delegate cardHasBeenFlippedFaceDown: self];
                        
                        // Enable user interaction after the CardView animation
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    }];
}

- (void) flipCardFromRight
{
    // Disable taps
    [self.tapGestureRecognizer setEnabled: NO];
    
    // Disable user interaction while CardViews animate
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [UIView transitionWithView: self
                      duration: 0.6
                       options: UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^{
                        UIImage *front = [UIImage imageNamed: @"cardFront"];
                        [self.cardImage setImage: front];
                        [self.cardLabel setText: [self cardValue]];
                    }
                    completion: ^(BOOL _finished){
                        // Check if the delegate is set and it responds to the selector
                        if ([self.delegate respondsToSelector:@selector(cardHasBeenFlippedFaceUp:)])
                            [self.delegate cardHasBeenFlippedFaceUp: self];
                        
                        // Enable user interaction after the CardView animation
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    }];
}

- (void) doCardMatchedAnimation
{
    // Disable user interaction while CardViews animate
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [UIView transitionWithView: self
                      duration: 0.2
                       options: UIViewAnimationOptionCurveEaseInOut
                    animations: ^{
                        [self setTransform: CGAffineTransformMakeScale(1.05, 1.05)];
                    }
                    completion: ^(BOOL _finished){
                        [UIView transitionWithView: self
                                          duration: 0.2
                                           options: UIViewAnimationOptionCurveEaseInOut
                                        animations: ^{
                                            [self setTransform: CGAffineTransformMakeScale(1.0, 1.0)];
                                        }
                                        completion: ^(BOOL _finished){
                                            // Enable user interaction after the CardView animation
                                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                        }];
                    }];
}

- (void) doCardNotMatchedAnimation
{
    // Disable user interaction while CardViews animate
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"position.x"];
    [animation setDuration: 0.05];
    [animation setRepeatCount: 4];
    [animation setAutoreverses: YES];
    [animation setFromValue: @([self center].x - 4)];
    [animation setToValue: @([self center].x + 4)];
    [animation setDelegate: self];
    
    [self.layer addAnimation: animation forKey: @"position"];
    [self performSelector: @selector(flipCardFromLeft) withObject: nil afterDelay: 0.8];
}

#pragma mark - Delegate Methods

- (void) animationDidStop: (CAAnimation *) animation finished: (BOOL) flag
{
    [self.layer removeAnimationForKey: @"position"];
    
    NSLog(@"animation did stop");
    
    // Enable user interaction after the CardView animation
    //[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@end
