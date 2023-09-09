//  ConfigViewController.h
//  DataCollection
//
//  Created by Chris Wozny on 2/28/12.
//  Copyright (c) 2013 Chris Wozny. All rights reserved.

#import <UIKit/UIKit.h>

@interface ConfigViewController : UIViewController
{
    UITextField *textRate;
    UILabel *setRate;
    UILabel *noteText;
    UILabel *rateUsText;
    UINavigationItem *navTitle;
    UIBarButtonItem *goButton;
    UIButton *rateUsButton;
}

@property (nonatomic, retain) IBOutlet UITextField *textRate;
@property (nonatomic, retain) IBOutlet UILabel *setRate;
@property (nonatomic, retain) IBOutlet UILabel *noteText;
@property (nonatomic, retain) IBOutlet UILabel *rateUsText;
@property (nonatomic, retain) IBOutlet UINavigationItem *navTitle;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *goButton;
@property (nonatomic, retain) IBOutlet UIButton *rateUsButton;

-(IBAction)textChanged:(id)sender;
-(IBAction)userClickedRateUs:(id)sender;
-(void)dismissKeyboard;

@end
