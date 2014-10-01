//
//  PlayingCard.h
//  Memory_NoIB
//
//  Created by Mathieu White on 2014-09-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic, strong) NSString *suit;
@property (nonatomic, strong) NSString *rank;

+ (NSArray *) validSuits;
+ (NSArray *) validRanks;

- (NSString *) content;

@end
