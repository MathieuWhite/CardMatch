//
//  Card.h
//  Memory_NoIB
//
//  Created by Mathieu White on 2014-09-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) NSString *content;

@property (nonatomic) BOOL isChosen;
@property (nonatomic) BOOL isMatched;

- (NSInteger) match: (NSArray *) otherCards;
- (BOOL) isEqualToCard: (Card *) card;

@end
