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
@synthesize pitch,roll,yaw;
@synthesize freq;
@synthesize info,back;
#ifdef FREE_VERSION
@synthesize bannerView;
#endif

NSMutableString *data;
NSString *dateString;
NSString *fileName;
int filesWritten = 0;
double startup = 0;

#ifdef FREE_VERSION
int iterations = 0;

-(IBAction)userClickedRateUs:(id)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=485523535"]];
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
        float m_Pitch = mgr.deviceMotion.attitude.pitch*180/M_PI;
        float m_Roll = mgr.deviceMotion.attitude.roll*180/M_PI;
        float m_Yaw = mgr.deviceMotion.attitude.yaw*180/M_PI;
        
        pitch.text = [NSString stringWithFormat:@"%@%1.0f°", @"Pitch: ", m_Pitch];
        roll.text = [NSString stringWithFormat:@"%@%1.0f°", @"Roll: ",m_Roll];
        yaw.text = [NSString stringWithFormat:@"%@%1.0f°", @"Yaw: ",m_Yaw];
        
        if(recording.on)
            [data appendString:[NSString stringWithFormat:@"ATTITUDE %f %f %f %f\n", CFAbsoluteTimeGetCurrent()-startup, m_Pitch, m_Roll, m_Yaw]];
    }
    else if([mgr isAccelerometerAvailable])
    {
        float x = mgr.accelerometerData.acceleration.x;
        float y = mgr.accelerometerData.acceleration.y;
        float z = mgr.accelerometerData.acceleration.z;
        
        float m_Roll = atan (x / sqrt(y*y + z*z))*180/M_PI;
        float m_Pitch = -1*atan (y / sqrt(x*x + z*z))*180/M_PI;
        
        pitch.text = [NSString stringWithFormat:@"Pitch: %1.0f°", m_Pitch];
        roll.text = [NSString stringWithFormat:@"Roll: %1.0f°", m_Roll];
        yaw.text = [NSString stringWithFormat:@"%@", @"Yaw: N/A"];
        
        if(recording.on)
            [data appendString:[NSString stringWithFormat:@"ATTITUDE %f %f %f YAW_NA\n", CFAbsoluteTimeGetCurrent()-startup, m_Pitch, m_Roll]];
    }
    else
    {
        pitch.text = [NSString stringWithFormat:@"%@", @"Pitch: N/A"];
        roll.text = [NSString stringWithFormat:@"%@", @"Roll: N/A"];
        yaw.text =[NSString stringWithFormat:@"%@", @"Yaw: N/A"];
    }
    
    if([mgr isAccelerometerAvailable])
    {
        float accelX = mgr.accelerometerData.acceleration.x;
        float accelY = mgr.accelerometerData.acceleration.y;
        float accelZ = mgr.accelerometerData.acceleration.z;
        
        // Sets the labels to the respective values of the axes acceleration.
        x_accel_label.text = [NSString stringWithFormat:@"%@%1.2f g", @"X: ", accelX];
        y_accel_label.text = [NSString stringWithFormat:@"%@%1.2f g", @"Y: ", accelY];
        z_accel_label.text = [NSString stringWithFormat:@"%@%1.2f g", @"Z: ", accelZ];
        
        // Sets the value of the progress bar to the absolute value of the acceleration for each respective axis.
        self.x_accel.progress = ABS(accelX);
        self.y_accel.progress = ABS(accelY);
        self.z_accel.progress = ABS(accelZ);
        
        if(accelX < 0)
            self.x_accel.progressTintColor = [UIColor redColor];
        else
            self.x_accel.progressTintColor = [UIColor blueColor];
        
        if(accelY < 0)
            self.y_accel.progressTintColor = [UIColor redColor];
        else
            self.y_accel.progressTintColor = [UIColor blueColor];
        
        if(accelZ < 0)
            self.z_accel.progressTintColor = [UIColor redColor];
        else
            self.z_accel.progressTintColor = [UIColor blueColor];
        
        // If record data is on then write the accelerometer data to the NSArray.
        if(recording.on)
            [data appendString:[NSString stringWithFormat:@"ACCEL %f %f %f %f\n", CFAbsoluteTimeGetCurrent()-startup, accelX, accelY, accelZ]];
    }
    else
    {
        x_accel_label.text = y_accel_label.text = z_accel_label.text = [NSString stringWithFormat:@"Unavailable"];
        self.x_accel.progress = self.y_accel.progress = self.z_accel.progress = 0;
    }
    
    if([mgr isGyroAvailable])
    {
        float gyroX = mgr.gyroData.rotationRate.x;
        float gyroY = mgr.gyroData.rotationRate.y;
        float gyroZ = mgr.gyroData.rotationRate.z;
        
        // Sets the labels to the respective values of the axes gyro rates.
        x_gyro_label.text = [NSString stringWithFormat:@"%@%1.2f rad/s", @"X: ", gyroX];
        y_gyro_label.text = [NSString stringWithFormat:@"%@%1.2f rad/s", @"Y: ", gyroY];
        z_gyro_label.text = [NSString stringWithFormat:@"%@%1.2f rad/s", @"Z: ", gyroZ];
        
        // Sets the value of the progress bar to the absolute value of the gyro rates for each respective axis.
        self.x_gyro.progress = ABS(gyroX)/M_PI;
        self.y_gyro.progress = ABS(gyroY)/M_PI;
        self.z_gyro.progress = ABS(gyroZ)/M_PI;
        
        if(gyroX < 0)
            self.x_gyro.progressTintColor = [UIColor redColor];
        else
            self.x_gyro.progressTintColor = [UIColor blueColor];
        
        if(gyroY < 0)
            self.y_gyro.progressTintColor = [UIColor redColor];
        else
            self.y_gyro.progressTintColor = [UIColor blueColor];
        
        if(gyroZ < 0)
            self.z_gyro.progressTintColor = [UIColor redColor];
        else
            self.z_gyro.progressTintColor = [UIColor blueColor];
        
        // If record data is on then write the accelerometer data to the NSArray.
        if(recording.on)
            [data appendString:[NSString stringWithFormat:@"GYRO %f %f %f %f\n", CFAbsoluteTimeGetCurrent()-startup, gyroX, gyroY, gyroZ]];
    }
    else
    {
        x_gyro_label.text = y_gyro_label.text = z_gyro_label.text = [NSString stringWithFormat:@"Unavailable"];
        self.x_gyro.progress = self.y_gyro.progress = self.z_gyro.progress = 0;
    }
    
    if([mgr isMagnetometerAvailable])
    {
        float magX = mgr.magnetometerData.magneticField.x;
        float magY = mgr.magnetometerData.magneticField.y;
        float magZ = mgr.magnetometerData.magneticField.z;
        
        // Sets the labels to the respective values of the axes gyro rates.
        x_mag_label.text = [NSString stringWithFormat:@"%@%1.2f", @"X: ", magX];
        y_mag_label.text = [NSString stringWithFormat:@"%@%1.2f", @"Y: ", magY];
        z_mag_label.text = [NSString stringWithFormat:@"%@%1.2f", @"Z: ", magZ];
        
        // Sets the value of the progress bar to the absolute value of the gyro rates for each respective axis.
        self.x_mag.progress = ABS(magX)/300;
        self.y_mag.progress = ABS(magY)/300;
        self.z_mag.progress = ABS(magZ)/300;
        
        if(magX < 0)
            self.x_mag.progressTintColor = [UIColor redColor];
        else
            self.x_mag.progressTintColor = [UIColor blueColor];
        
        if(magY < 0)
            self.y_mag.progressTintColor = [UIColor redColor];
        else
            self.y_mag.progressTintColor = [UIColor blueColor];
        
        if(magZ < 0)
            self.z_mag.progressTintColor = [UIColor redColor];
        else
            self.z_mag.progressTintColor = [UIColor blueColor];
        
        // If record data is on then write the accelerometer data to the NSArray.
        if(recording.on)
            [data appendString:[NSString stringWithFormat:@"MAGNETO %f %f %f %f\n", CFAbsoluteTimeGetCurrent()-startup, magX, magY, magZ]];
    }
    else
    {
        x_mag_label.text = y_mag_label.text = z_mag_label.text = [NSString stringWithFormat:@"Unavailable"];
        self.x_mag.progress = self.y_mag.progress = self.z_mag.progress = 0;
    }
}

-(IBAction)emailResults
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Results" 
                                                    message:@"Would you like to email the collected data?" 
                                                    delegate:self
                                                    cancelButtonTitle:@"Yes"
                                                    otherButtonTitles:@"No",
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
        [mailComposer setSubject:@"Accelerometer, Gyroscope, and Magnetometer data from Data Collection App"];
        [mailComposer setMessageBody:@"I've attached the collected data from the Data Collection app. The raw values are ordered as x, y, and z for gyro, magnetometers, and accelerometers. Attitude is ordered as pitch, roll, and yaw (if available.) You can get it here at http://ece.arizona.edu/~cwozny/index.php/DataCollection/DataCollection" isHTML:NO];
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

#ifndef FREE_VERSION
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

-(IBAction)isRecording:(id)sender
{
	// If record data is on then create file with a timestamp as the name.
	if(recording.on)
	{
		// Allocate memory for data string.
		data = [[NSMutableString alloc] init];
        data = [NSMutableString stringWithFormat:@"(Preferred) sampling frequency set to %d Hz.\nYour device may not support this sampling frequency, so always check your timestamps!\n",freq];
        
        back.enabled = false;
        info.enabled = false;
	}
	// If record data is off and data has been written to the NSArray, dump it to a file.
	else if(!recording.on)
	{
        back.enabled = true;
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
#endif
    
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    recording.on = false;
    
    [mgr stopGyroUpdates];
    [mgr stopAccelerometerUpdates];
    [mgr stopMagnetometerUpdates];
    [mgr stopDeviceMotionUpdates];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
#ifdef FREE_VERSION
#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	bannerView.hidden = NO;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	bannerView.hidden = YES;
}
#endif
@end
