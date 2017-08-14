//  InfoViewController.h
//  Data Collection
//
//  Created by Chris Wozny on 11/8/11.
//  Copyright (c) 2013 Chris Wozny. All rights reserved.

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
{
    UILabel *infoText;
    UINavigationItem *navTitle;
    UIBarButtonItem *backButton;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UINavigationItem *navTitle;
@property (nonatomic, retain) IBOutlet UILabel *infoText;

-(IBAction)goBack;

@end
