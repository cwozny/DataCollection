//
//  ConfigViewController.h
//  DataCollection
//
//  Created by Chris Wozny on 2/28/12.
//  Copyright (c) 2013 Chris Wozny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigViewController : UIViewController
{
    UISlider *sliderRate;
    UITextField *textRate;
}

@property (nonatomic, retain) IBOutlet UISlider *sliderRate;
@property (nonatomic, retain) IBOutlet UITextField *textRate;

-(IBAction)sliderChanged:(id)sender;
-(IBAction)textChanged:(id)sender;
-(IBAction)userClickedRateUs:(id)sender;

@end
