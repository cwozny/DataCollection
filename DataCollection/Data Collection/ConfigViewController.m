//  ConfigViewController.m
//  DataCollection
//
//  Created by Chris Wozny on 2/28/12.
//  Copyright (c) 2013 Chris Wozny. All rights reserved.

#import "ConfigViewController.h"
#import "ViewController.h"

@implementation ConfigViewController

@synthesize textRate,sliderRate;

int samplingFrequency = 1;

-(IBAction)sliderChanged:(id)sender
{
    samplingFrequency = [sliderRate value];
    textRate.text = [NSString stringWithFormat:@"%d",samplingFrequency];
}

-(IBAction)textChanged:(id)sender
{
    samplingFrequency = [textRate.text intValue];
    textRate.text = [NSString stringWithFormat:@"%d",samplingFrequency];
    sliderRate.value = samplingFrequency;
    [textRate resignFirstResponder];
}

-(IBAction)userClickedRateUs:(id)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=479348835"]];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#ifndef FREE_VERSION
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"SendFrequency"])
	{
		[segue.destinationViewController setFrequency:samplingFrequency];
	}
}
#endif

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    samplingFrequency = 120;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [textRate addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
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

@end
