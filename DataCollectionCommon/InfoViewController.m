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
#ifdef FREE_VERSION
@synthesize bannerView;
#endif

-(IBAction)goBack
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
#ifdef FREE_VERSION
    [bannerView setDelegate:self];
    bannerView = [[ADBannerView alloc] init];
#endif
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#ifdef FREE_VERSION

#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	[bannerView setHidden:NO];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[bannerView setHidden:YES];
}
#endif
@end
