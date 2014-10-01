//
//  ViewController.m
//  CardMatch
//
//  Created by Mathieu White on 2014-09-18.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "ViewController.h"
#import "GameView.h"

@interface ViewController ()

@property (nonatomic, weak) GameView *gameView;

- (void) userWantsNewGameNotification: (NSNotification *) notification;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize a Game
    GameView *gameView = [[GameView alloc] initWithFrame: [self.view bounds]];
    
    // Add the components to the view
    [self.view addSubview: gameView];
    
    // Set each component to a property
    [self setGameView: gameView];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userWantsNewGameNotification:)
                                                 name: kGameViewDidFinishNewGameNotification
                                               object: nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: kGameViewDidFinishNewGameNotification
                                                  object: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification Method

- (void) userWantsNewGameNotification: (NSNotification *) notification
{
    [[self gameView] removeFromSuperview];
    
    // Re create the game view
    GameView *gameView = [[GameView alloc] initWithFrame: [self.view bounds]];
    [self.view addSubview: gameView];
    [self setGameView: gameView];
}

@end