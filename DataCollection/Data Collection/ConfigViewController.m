//  ConfigViewController.m
//  DataCollection
//
//  Created by Chris Wozny on 2/28/12.
//  Copyright (c) 2013 Chris Wozny. All rights reserved.

#import "ConfigViewController.h"
#import "ViewController.h"

@implementation ConfigViewController

@synthesize textRate,sliderRate;
@synthesize noteText,rateUsText,setRate;
@synthesize goButton,rateUsButton;
@synthesize navTitle;

float samplingFrequency = 1.0f;

-(IBAction)sliderChanged:(id)sender
{
    samplingFrequency = [sliderRate value];
    textRate.text = [NSString stringWithFormat:@"%1.2f",samplingFrequency];
}

-(IBAction)textChanged:(id)sender
{
    samplingFrequency = MAX(0.01f, MIN([textRate.text floatValue], 500.0f));
    
    textRate.text = [NSString stringWithFormat:@"%1.2f",samplingFrequency];
    sliderRate.value = samplingFrequency;
}

-(IBAction)userClickedRateUs:(id)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/data-collection/id479348835"]];
}

-(void)dismissKeyboard
{
    [textRate resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [textRate resignFirstResponder];
    
	if ([segue.identifier isEqualToString:@"SendFrequency"])
	{
		[segue.destinationViewController setSamplingRate:samplingFrequency];
	}
}

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    setRate.text = [NSString stringWithFormat:NSLocalizedString(@"SetRateText", nil)];
    noteText.text = [NSString stringWithFormat:NSLocalizedString(@"NoteText", nil)];
    rateUsText.text = [NSString stringWithFormat:NSLocalizedString(@"RateUsText", nil)];
    navTitle.title = [NSString stringWithFormat:NSLocalizedString(@"ConfigTitle", nil)];
    goButton.title = [NSString stringWithFormat:NSLocalizedString(@"GoButton", nil)];
    rateUsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rateUsButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"RateUsButton", nil)] forState:UIControlStateNormal];
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
