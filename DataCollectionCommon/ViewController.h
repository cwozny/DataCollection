//  ViewController.h
//  Data Collection
//
//  Created by Chris Wozny on 10/22/11.
//  Copyright (c) 2013 Chris Wozny. All rights reserved.

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController : UIViewController
#ifdef FREE_VERSION
<UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
#else
<UIAlertViewDelegate,MFMailComposeViewControllerDelegate,CLLocationManagerDelegate>
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
    
    UILabel *roll,*rollLabel;
    UILabel *pitch,*pitchLabel;
    UILabel *yaw,*yawLabel;

    UILabel *accelerometerLabel,*magnetometerLabel,*gyroscopeLabel;
    
    UILabel *recordingLabel;
    
    UINavigationItem *navTitle;
    
    CMMotionManager *mgr;
    
    UISwitch *recording;

#ifdef FREE_VERSION
    UIBarButtonItem *rateButton;
#else
    CLLocationManager *locMan;
    UILabel *latitude,*latitudeLabel;
    UILabel *longitude,*longitudeLabel;
    UILabel *altitude,*altitudeLabel;
    UIBarButtonItem *back;
#endif
    UIButton *info;
}

@property (nonatomic, retain) CMMotionManager *mgr;
@property (nonatomic, retain) IBOutlet UINavigationItem *navTitle;
@property (nonatomic, retain) IBOutlet UIButton *info;
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
@property (nonatomic, retain) IBOutlet UILabel *rollLabel;
@property (nonatomic, retain) IBOutlet UILabel *pitchLabel;
@property (nonatomic, retain) IBOutlet UILabel *yawLabel;
@property (nonatomic, retain) IBOutlet UILabel *accelerometerLabel;
@property (nonatomic, retain) IBOutlet UILabel *magnetometerLabel;
@property (nonatomic, retain) IBOutlet UILabel *gyroscopeLabel;
@property (nonatomic, retain) IBOutlet UILabel *recordingLabel;
@property (nonatomic) float freq;
#ifdef FREE_VERSION
@property (nonatomic, retain) IBOutlet UIBarButtonItem *rateButton;

-(IBAction)userClickedRateUs:(id)sender;
#else
@property (nonatomic, retain) IBOutlet UIBarButtonItem *back;
@property (nonatomic, retain) CLLocationManager *locMan;
@property (nonatomic, retain) IBOutlet UILabel *latitude;
@property (nonatomic, retain) IBOutlet UILabel *longitude;
@property (nonatomic, retain) IBOutlet UILabel *altitude;
@property (nonatomic, retain) IBOutlet UILabel *latitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *longitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *altitudeLabel;
#endif

// Function that is called when the UISwitch recordData is toggled.
-(IBAction)isRecording:(id)sender;
-(IBAction)emailResults;
-(void)writeData:(NSString*)type time:(double)timestamp firstValue:(double)val1 secondValue:(double)val2 thirdValue:(double)val3;
-(void)gyroUpdate:(double)p q:(double)q r:(double)r;
-(void)accelUpdate:(double)x y:(double)y z:(double)z;
-(void)magnetoUpdate:(double)x y:(double)y z:(double)z;
-(void)attitudeUpdate:(double)p rollValue:(double)r yawValue:(double)y;
#ifndef FREE_VERSION
-(void)setSamplingRate:(float)frequency;
-(void)gpsUpdate:(double)lat longitude:(double)lon altitude:(double)alt;
#endif

@end
