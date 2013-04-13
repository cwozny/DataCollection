//  ViewController.m
//  Data Collection
//
//  Created by Chris Wozny on 10/22/11.
//  Copyright (c) 2013 Chris Wozny. All rights reserved.

#import "ViewController.h"
#import "InfoViewController.h"

@implementation ViewController

@synthesize mgr;
@synthesize x_accel, y_accel, z_accel, x_accel_label, y_accel_label, z_accel_label;
@synthesize x_gyro, y_gyro, z_gyro, x_gyro_label, y_gyro_label, z_gyro_label;
@synthesize x_mag, y_mag, z_mag, x_mag_label, y_mag_label, z_mag_label;
@synthesize recording;
@synthesize pitch,roll,yaw,pitchLabel,rollLabel,yawLabel;
@synthesize freq;
@synthesize info;
@synthesize accelerometerLabel, gyroscopeLabel, magnetometerLabel,recordingLabel;
@synthesize navTitle;
#ifdef FREE_VERSION
@synthesize bannerView,rateButton;

int iterations = 0;
#else
@synthesize locMan;
@synthesize back;
@synthesize latitude,latitudeLabel, longitude, longitudeLabel, altitude, altitudeLabel;
#endif
NSMutableString *data;
NSString *dateString;
NSString *fileName;
int filesWritten = 0;
double startup = 0;

-(void)writeData:(NSString*)type time:(double)timestamp firstValue:(double)val1 secondValue:(double)val2 thirdValue:(double)val3
{
    [data appendString:[NSString stringWithFormat:@"%@ %f %f %f %f\n", type, timestamp, val1, val2, val3]];
}

-(void)gyroUpdate:(double)p q:(double)q r:(double)r
{
    // Sets the labels to the respective values of the axes gyro rates.
    x_gyro_label.text = [NSString stringWithFormat:@"%1.2f", p];
    y_gyro_label.text = [NSString stringWithFormat:@"%1.2f", q];
    z_gyro_label.text = [NSString stringWithFormat:@"%1.2f", r];
    
    // Sets the value of the progress bar to the absolute value of the gyro rates for each respective axis.
    self.x_gyro.progress = ABS(p)/M_PI;
    self.y_gyro.progress = ABS(q)/M_PI;
    self.z_gyro.progress = ABS(r)/M_PI;
    
    if(p < 0)
        self.x_gyro.progressTintColor = [UIColor redColor];
    else
        self.x_gyro.progressTintColor = [UIColor blueColor];
    
    if(q < 0)
        self.y_gyro.progressTintColor = [UIColor redColor];
    else
        self.y_gyro.progressTintColor = [UIColor blueColor];
    
    if(r < 0)
        self.z_gyro.progressTintColor = [UIColor redColor];
    else
        self.z_gyro.progressTintColor = [UIColor blueColor];
    
    // If record data is on then write the gyro data to the NSArray.
    if(recording.on)
    {
        [self writeData:@"GYRO" time:(CFAbsoluteTimeGetCurrent()-startup) firstValue:p secondValue:q thirdValue:r];
    }
}

-(void)accelUpdate:(double)x y:(double)y z:(double)z
{
    // Sets the labels to the respective values of the axes acceleration.
    x_accel_label.text = [NSString stringWithFormat:@"%1.2f", x];
    y_accel_label.text = [NSString stringWithFormat:@"%1.2f", y];
    z_accel_label.text = [NSString stringWithFormat:@"%1.2f", z];
    
    // Sets the value of the progress bar to the absolute value of the acceleration for each respective axis.
    self.x_accel.progress = ABS(x);
    self.y_accel.progress = ABS(y);
    self.z_accel.progress = ABS(z);
    
    if(x < 0)
        self.x_accel.progressTintColor = [UIColor redColor];
    else
        self.x_accel.progressTintColor = [UIColor blueColor];
    
    if(y < 0)
        self.y_accel.progressTintColor = [UIColor redColor];
    else
        self.y_accel.progressTintColor = [UIColor blueColor];
    
    if(z < 0)
        self.z_accel.progressTintColor = [UIColor redColor];
    else
        self.z_accel.progressTintColor = [UIColor blueColor];
    
    // If record data is on then write the accelerometer data to the NSArray.
    if(recording.on)
    {
        [self writeData:@"ACCEL" time:(CFAbsoluteTimeGetCurrent()-startup) firstValue:x secondValue:y thirdValue:z];
    }
}

-(void)magnetoUpdate:(double)x y:(double)y z:(double)z
{    
    // Sets the labels to the respective values of the axes gyro rates.
    x_mag_label.text = [NSString stringWithFormat:@"%1.2f", x];
    y_mag_label.text = [NSString stringWithFormat:@"%1.2f", y];
    z_mag_label.text = [NSString stringWithFormat:@"%1.2f", z];
    
    // Sets the value of the progress bar to the absolute value of the gyro rates for each respective axis.
    self.x_mag.progress = ABS(x)/300;
    self.y_mag.progress = ABS(y)/300;
    self.z_mag.progress = ABS(z)/300;
    
    if(x < 0)
        self.x_mag.progressTintColor = [UIColor redColor];
    else
        self.x_mag.progressTintColor = [UIColor blueColor];
    
    if(y < 0)
        self.y_mag.progressTintColor = [UIColor redColor];
    else
        self.y_mag.progressTintColor = [UIColor blueColor];
    
    if(z < 0)
        self.z_mag.progressTintColor = [UIColor redColor];
    else
        self.z_mag.progressTintColor = [UIColor blueColor];
    
    // If record data is on then write the magnetometer data to the NSArray.
    if(recording.on)
    {
        [self writeData:@"MAGNETO" time:(CFAbsoluteTimeGetCurrent()-startup) firstValue:x secondValue:y thirdValue:z];
    }
}

-(void)attitudeUpdate:(double)p rollValue:(double)r yawValue:(double)y
{
    pitch.text = [NSString stringWithFormat:@"%1.0f°", p];
    roll.text = [NSString stringWithFormat:@"%1.0f°", r];
    yaw.text = [NSString stringWithFormat:@"%1.0f°", y];
    
    if(recording.on)
    {
        [self writeData:@"ATTITUDE" time:(CFAbsoluteTimeGetCurrent()-startup) firstValue:p secondValue:r thirdValue:y];
    }
}

#ifndef FREE_VERSION
-(void)gpsUpdate:(double)lat longitude:(double)lon altitude:(double)alt
{
    // Set the latitude, longitude, and altitude everytime the locationManager updates to a new location.
	latitude.text = [NSString stringWithFormat:@"%1.3f", lat];
    longitude.text = [NSString stringWithFormat:@"%1.3f", lon];
    altitude.text = [NSString stringWithFormat:@"%1.2f m", alt];
    
    if(recording.on)
    {
        [self writeData:@"GPS" time:(CFAbsoluteTimeGetCurrent()-startup) firstValue:lat secondValue:lon thirdValue:alt];
    }
}

// Called when the GPS has detected a movement.
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)new fromLocation:(CLLocation *)old
{
    [self gpsUpdate:new.coordinate.latitude longitude:new.coordinate.longitude altitude:new.altitude];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	// Check the error code if the LocationManager failed.
	if(error.code == kCLErrorLocationUnknown)
		NSLog(@"Currently unable to retrieve location.");
	else if(error.code == kCLErrorNetwork)
		NSLog(@"Network used to retrieve location is unavailable.");
	else if(error.code == kCLErrorDenied)
	{
		// If the user denied access for the program to use GPS, then stop attempting to update the location.
		NSLog(@"Currently unable to retrieve location.");
		[locMan stopUpdatingLocation];
		locMan = nil;
	}
    
    latitude.text = [NSString stringWithFormat:NSLocalizedString(@"Unavailable", nil)];
    longitude.text = [NSString stringWithFormat:NSLocalizedString(@"Unavailable", nil)];
    altitude.text = [NSString stringWithFormat:NSLocalizedString(@"Unavailable", nil)];
}
#endif

- (void)updateCounter:(NSTimer*)timer
{
#ifdef FREE_VERSION
    if(iterations >= 10*freq && recording.on)
    {
        recording.on = false;
        [self isRecording:self];
        iterations = 0;
    }
    else if(recording.on)
        iterations++;
#endif
    
    if([mgr isDeviceMotionAvailable] && [mgr isDeviceMotionActive])
    {
        [self attitudeUpdate:mgr.deviceMotion.attitude.pitch*180/M_PI rollValue:mgr.deviceMotion.attitude.roll*180/M_PI yawValue:mgr.deviceMotion.attitude.yaw*180/M_PI];
    }
    else
    {
        pitch.text = [NSString stringWithFormat:@"%@", @"N/A"];
        roll.text = [NSString stringWithFormat:@"%@", @"N/A"];
        yaw.text =[NSString stringWithFormat:@"%@", @"N/A"];
    }
    
    if([mgr isAccelerometerAvailable])
    {        
        [self accelUpdate:mgr.accelerometerData.acceleration.x y:mgr.accelerometerData.acceleration.y z:mgr.accelerometerData.acceleration.z];
    }
    else
    {
        x_accel_label.text = y_accel_label.text = z_accel_label.text = [NSString stringWithFormat:NSLocalizedString(@"Unavailable", nil)];
        self.x_accel.progress = self.y_accel.progress = self.z_accel.progress = 0;
    }
    
    if([mgr isGyroAvailable])
    {
        [self gyroUpdate:mgr.gyroData.rotationRate.x q:mgr.gyroData.rotationRate.y r:mgr.gyroData.rotationRate.z];
    }
    else
    {
        x_gyro_label.text = y_gyro_label.text = z_gyro_label.text = [NSString stringWithFormat:NSLocalizedString(@"Unavailable", nil)];
        self.x_gyro.progress = self.y_gyro.progress = self.z_gyro.progress = 0;
    }
    
    if([mgr isMagnetometerAvailable])
    {
        [self magnetoUpdate:mgr.magnetometerData.magneticField.x y:mgr.magnetometerData.magneticField.y z:mgr.magnetometerData.magneticField.z];
    }
    else
    {
        x_mag_label.text = y_mag_label.text = z_mag_label.text = [NSString stringWithFormat:NSLocalizedString(@"Unavailable", nil)];
        self.x_mag.progress = self.y_mag.progress = self.z_mag.progress = 0;
    }
}

-(IBAction)emailResults
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Results", nil)]
                                                    message:[NSString stringWithFormat:NSLocalizedString(@"Email", nil)]
                                                    delegate:self
                                                    cancelButtonTitle:[NSString stringWithFormat:NSLocalizedString(@"Yes", nil)]
                                                    otherButtonTitles:[NSString stringWithFormat:NSLocalizedString(@"No", nil)],
                                                    nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        MFMailComposeViewController *mailComposer; 
        mailComposer  = [[MFMailComposeViewController alloc] init];
        [mailComposer setMailComposeDelegate:self];
        [mailComposer setModalPresentationStyle:UIModalPresentationFormSheet];
#ifdef FREE_VERSION
        [mailComposer setSubject:[NSString stringWithFormat:NSLocalizedString(@"SubjectFree", nil)]];
        [mailComposer setMessageBody:[NSString stringWithFormat:NSLocalizedString(@"MessageBodyFree", nil)] isHTML:YES];
#else
        [mailComposer setSubject:[NSString stringWithFormat:NSLocalizedString(@"SubjectPaid", nil)]];
        [mailComposer setMessageBody:[NSString stringWithFormat:NSLocalizedString(@"MessageBodyPaid", nil)] isHTML:YES];
#endif
        NSData *attachmentData = [NSData dataWithContentsOfFile:fileName];
        [mailComposer addAttachmentData:attachmentData mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"DataCollection_%@.txt",dateString]];
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{ 
    [self dismissViewControllerAnimated:true completion:nil];
    
    return;
}

-(IBAction)isRecording:(id)sender
{
	// If record data is on then create file with a timestamp as the name.
	if(recording.on)
	{
		// Allocate memory for data string.
		data = [[NSMutableString alloc] init];
        data = [NSMutableString stringWithString:@""];
        [data appendString:[NSMutableString stringWithFormat:@"(Preferred) sampling frequency set to %d Hz.\nYour device may not support this sampling frequency, so always check your timestamps!\n",freq]];
#ifdef FREE_VERSION
        rateButton.enabled = false;
#else
        back.enabled = false;
#endif
        info.enabled = false;
	}
	// If record data is off and data has been written to the NSArray, dump it to a file.
	else if(!recording.on)
	{
#ifdef FREE_VERSION
        rateButton.enabled = true;
#else
        back.enabled = true;
#endif
        info.enabled = true;
		// Get an array of all the directories in the app's bundle
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        // Store the location of the documents directory into the corresponding string (documents directory will be the object at index 0)
		NSString *documentsDirectory = [paths objectAtIndex:0];
        // Create NSDate object to get the current date and time.
		NSDate *today = [NSDate date];
		// dateFormat restructures the date into a readable format.
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		// Sets the format to MM-dd-yyyy_HH:mm:ss
		[dateFormat setDateFormat:@"yyyy-MM-dd_HHmmss"];
		// Saves the current formatted date into dateString
		dateString = [dateFormat stringFromDate:today];
		// Sets the filename to the full path and filename appended.
        fileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"DataCollection_%@.txt",dateString]];
        // Try getting a handle to the file.
		NSFileHandle* outputFile = [NSFileHandle fileHandleForWritingAtPath:fileName];
        
		if(!outputFile)
		{
			// If the file doesn't exist then create it.
			[[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
			// Now get a handle to the newly created file.
			outputFile = [NSFileHandle fileHandleForWritingAtPath:fileName];
		}
		
        // Close the file if it's opened or just make sure it's closed.
		[outputFile closeFile];
        // Write the data to the file atomically.
        [data writeToFile:fileName atomically:YES encoding:NSASCIIStringEncoding error:NULL];
        
        [self emailResults];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	recording.on = false;

#ifdef FREE_VERSION
    freq = 10;
    rateButton.title = [NSString stringWithFormat:NSLocalizedString(@"RateUsButton", nil)];
#else
    // Initialize the location manager and set the delegate to us.
	locMan = [[CLLocationManager alloc] init];
    locMan.delegate = self;
	// Set the distance filter so that it will update the location manager whenever we move.
	locMan.distanceFilter = kCLDistanceFilterNone;
	// Set the desired accuracy to the best possible accuracy.
	locMan.desiredAccuracy = kCLLocationAccuracyBest;
	// Start updating the GPS location.
	[locMan startUpdatingLocation];
    back.title = [NSString stringWithFormat:NSLocalizedString(@"BackButton", nil)];
    latitudeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Latitude", nil)];
    longitudeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Longitude", nil)];
    altitudeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Altitude", nil)];
#endif
    navTitle.title = [NSString stringWithFormat:NSLocalizedString(@"SensorTitle", nil)];
    accelerometerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"AccelerometerLabel", nil)];
    gyroscopeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"GyroscopeLabel", nil)];
    magnetometerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"MagnetometerLabel", nil)];
    recordingLabel.text = [NSString stringWithFormat:NSLocalizedString(@"RecordingLabel", nil)];
    pitchLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pitch", nil)];
    rollLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Roll", nil)];
    yawLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Yaw", nil)];
    mgr = [[CMMotionManager alloc] init];
    
    [mgr startAccelerometerUpdates];
    [mgr startGyroUpdates];
    [mgr startMagnetometerUpdates];
    [mgr startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
    
	[NSTimer scheduledTimerWithTimeInterval:1.0/freq
                                     target:self
                                   selector:@selector(updateCounter:)
                                   userInfo:nil
                                    repeats:YES];
#ifdef FREE_VERSION
    bannerView = [[ADBannerView alloc] init];
#endif
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    startup = CFAbsoluteTimeGetCurrent();
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    recording.on = false;
    
    [mgr stopGyroUpdates];
    [mgr stopAccelerometerUpdates];
    [mgr stopMagnetometerUpdates];
    [mgr stopDeviceMotionUpdates];
#ifndef FREE_VERSION
    [locMan stopUpdatingLocation];
#endif
}

#ifdef FREE_VERSION
-(IBAction)userClickedRateUs:(id)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=485523535"]];
}

#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	bannerView.hidden = NO;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	bannerView.hidden = YES;
}
#else
-(IBAction)goBack
{
    if(!recording.on)
        [self dismissViewControllerAnimated:true completion:nil];
}

-(void)setFrequency:(int)frequency
{
    freq = frequency;
    
    if(freq < 1)
        freq = 1;
}
#endif
@end
