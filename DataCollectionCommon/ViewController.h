//
//  ViewController.h
//  Data Collection
//
//  Created by Chris Wozny on 10/22/11.
//  Copyright (c) 2013 Chris Wozny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#ifdef FREE_VERSION
#import <iAd/iAd.h>
#endif

@interface ViewController : UIViewController
#ifdef FREE_VERSION
<ADBannerViewDelegate, UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
#else
<UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
#endif
{
    UIProgressView  *x_accel;
    UIProgressView  *y_accel;
    UIProgressView  *z_accel;
    
    UIProgressView  *x_gyro;
    UIProgressView  *y_gyro;
    UIProgressView  *z_gyro;
    
    UIProgressView  *x_mag;
    UIProgressView  *y_mag;
    UIProgressView  *z_mag;   
    
    UILabel *x_accel_label;
    UILabel *y_accel_label;
    UILabel *z_accel_label;
    
    UILabel *x_gyro_label;
    UILabel *y_gyro_label;
    UILabel *z_gyro_label;
    
    UILabel *x_mag_label;
    UILabel *y_mag_label;
    UILabel *z_mag_label;
    
    UILabel *roll;
    UILabel *pitch;
    UILabel *yaw;
    
    CMMotionManager *mgr;
    
    UISwitch *recording;

#ifdef FREE_VERSION
    ADBannerView *bannerView;
#endif
    
    UIButton *info;
    UIBarButtonItem *back;
    UIBarButtonItem *plot;
}

@property (nonatomic, retain) CMMotionManager *mgr;
@property (nonatomic, retain) IBOutlet UIButton *info;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *back;
@property (nonatomic, retain) IBOutlet UIProgressView *x_accel;
@property (nonatomic, retain) IBOutlet UIProgressView *y_accel;
@property (nonatomic, retain) IBOutlet UIProgressView *z_accel;
@property (nonatomic, retain) IBOutlet UILabel *x_accel_label;
@property (nonatomic, retain) IBOutlet UILabel *y_accel_label;
@property (nonatomic, retain) IBOutlet UILabel *z_accel_label;
@property (nonatomic, retain) IBOutlet UILabel *x_gyro_label;
@property (nonatomic, retain) IBOutlet UILabel *y_gyro_label;
@property (nonatomic, retain) IBOutlet UILabel *z_gyro_label;
@property (nonatomic, retain) IBOutlet UIProgressView  *x_gyro;
@property (nonatomic, retain) IBOutlet UIProgressView  *y_gyro;
@property (nonatomic, retain) IBOutlet UIProgressView  *z_gyro;
@property (nonatomic, retain) IBOutlet UILabel *x_mag_label;
@property (nonatomic, retain) IBOutlet UILabel *y_mag_label;
@property (nonatomic, retain) IBOutlet UILabel *z_mag_label;
@property (nonatomic, retain) IBOutlet UIProgressView  *x_mag;
@property (nonatomic, retain) IBOutlet UIProgressView  *y_mag;
@property (nonatomic, retain) IBOutlet UIProgressView  *z_mag;
@property (nonatomic, retain) IBOutlet UISwitch *recording;
@property (nonatomic, retain) IBOutlet UILabel *roll;
@property (nonatomic, retain) IBOutlet UILabel *pitch;
@property (nonatomic, retain) IBOutlet UILabel *yaw;
@property (nonatomic) int freq;
#ifdef FREE_VERSION
@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;

-(IBAction)userClickedRateUs:(id)sender;
#endif

// Function that is called when the UISwitch recordData is toggled.
-(IBAction)isRecording:(id)sender;
-(IBAction)emailResults;
#ifndef FREE_VERSION
-(void)setFrequency:(int)frequency;
#endif

@end
