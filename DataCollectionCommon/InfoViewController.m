//  InfoViewController.m
//  Data Collection
//
//  Created by Chris Wozny on 11/8/11.
//  Copyright (c) 2013 Chris Wozny. All rights reserved.

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    infoText.text = [NSString stringWithFormat:NSLocalizedString(@"InfoText", nil)];
    backButton.title = [NSString stringWithFormat:NSLocalizedString(@"BackButton", nil)];
    navTitle.title = [NSString stringWithFormat:NSLocalizedString(@"InfoTitle", nil)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
