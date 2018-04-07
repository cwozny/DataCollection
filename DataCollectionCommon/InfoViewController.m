//  InfoViewController.m
//  Data Collection
//
//  Created by Chris Wozny on 11/8/11.
//  Copyright (c) 2013, 2018 Chris Wozny. All rights reserved.

#import "InfoViewController.h"

@implementation InfoViewController

@synthesize infoText;
@synthesize navTitle;
@synthesize backButton;

-(IBAction)goBack
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    infoText.text = [NSString stringWithFormat:NSLocalizedString(@"InfoText", nil)];
    backButton.title = [NSString stringWithFormat:NSLocalizedString(@"BackButton", nil)];
    navTitle.title = [NSString stringWithFormat:NSLocalizedString(@"InfoTitle", nil)];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
