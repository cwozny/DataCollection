//  ViewController.m
//  Data Collection
//
//  Created by Chris Wozny on 10/22/11.
//  Copyright (c) 2013, 2018 Chris Wozny. All rights reserved.

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
@synthesize locMan;
@synthesize back;
@synthesize latitude, latitudeLabel, longitude, longitudeLabel, altitude, altitudeLabel;
NSMutableString *data;
NSString *dateString;
NSString *fileName;
int filesWritten = 0;

bool isLocationUpdating = false;

-(void)gyroUpdate:(double)p q:(double)q r:(double)r
{
    if(recording.on == false)
    {
        // Sets the labels to the respective values of the axes gyro rates.
        x_gyro_label.text = [NSString stringWithFormat:@"%1.2f", p];
        y_gyro_label.text = [NSString stringWithFormat:@"%1.2f", q];
        z_gyro_label.text = [NSString stringWithFormat:@"%1.2f", r];
        
        // Sets the value of the progress bar to the absolute value of the gyro rates for each respective axis.
        self.x_gyro.progress = ABS(p)/M_PI;
        self.y_gyro.progress = ABS(q)/M_PI;
        self.z_gyro.progress = ABS(r)/M_PI;
        
        self.x_gyro.progressTintColor = (p < 0) ? [UIColor redColor] : [UIColor blueColor];
        self.y_gyro.progressTintColor = (q < 0) ? [UIColor redColor] : [UIColor blueColor];
        self.z_gyro.progressTintColor = (r < 0) ? [UIColor redColor] : [UIColor blueColor];
    }
}

-(void)accelUpdate:(double)x y:(double)y z:(double)z
{
    if(recording.on == false)
    {
        // Sets the labels to the respective values of the axes acceleration.
        x_accel_label.text = [NSString stringWithFormat:@"%1.2f", x];
        y_accel_label.text = [NSString stringWithFormat:@"%1.2f", y];
        z_accel_label.text = [NSString stringWithFormat:@"%1.2f", z];
        
        // Sets the value of the progress bar to the absolute value of the acceleration for each respective axis.
        self.x_accel.progress = ABS(x);
        self.y_accel.progress = ABS(y);
        self.z_accel.progress = ABS(z);
        
        self.x_accel.progressTintColor = (x < 0) ? [UIColor redColor] : [UIColor blueColor];
        self.y_accel.progressTintColor = (y < 0) ? [UIColor redColor] : [UIColor blueColor];
        self.z_accel.progressTintColor = (z < 0) ? [UIColor redColor] : [UIColor blueColor];
    }
}

-(void)magnetoUpdate:(double)x y:(double)y z:(double)z
{
    if(recording.on == false)
    {
        // Sets the labels to the respective values of the axes gyro rates.
        x_mag_label.text = [NSString stringWithFormat:@"%1.2f", x];
        y_mag_label.text = [NSString stringWithFormat:@"%1.2f", y];
        z_mag_label.text = [NSString stringWithFormat:@"%1.2f", z];
        
        // Sets the value of the progress bar to the absolute value of the gyro rates for each respective axis.
        self.x_mag.progress = ABS(x)/300;
        self.y_mag.progress = ABS(y)/300;
        self.z_mag.progress = ABS(z)/300;
        
        self.x_mag.progressTintColor = (x < 0) ? [UIColor redColor] : [UIColor blueColor];
        self.y_mag.progressTintColor = (y < 0) ? [UIColor redColor] : [UIColor blueColor];
        self.z_mag.progressTintColor = (z < 0) ? [UIColor redColor] : [UIColor blueColor];
    }
}

-(void)attitudeUpdate:(double)p rollValue:(double)r yawValue:(double)y
{
    if(recording.on == false)
    {
        pitch.text = [NSString stringWithFormat:@"%1.2f°", p];
        roll.text = [NSString stringWithFormat:@"%1.2f°", r];
        yaw.text = [NSString stringWithFormat:@"%1.2f°", y];
    }
}

-(void)gpsUpdate:(double)lat longitude:(double)lon altitude:(double)alt
{
    if(recording.on == false)
    {
        // Set the latitude, longitude, and altitude everytime the locationManager updates to a new location.
        latitude.text = [NSString stringWithFormat:@"%1.5f", lat];
        longitude.text = [NSString stringWithFormat:@"%1.5f", lon];
        altitude.text = [NSString stringWithFormat:@"%1.2f m", alt];
    }
}

// Called when the GPS has detected a movement.
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    isLocationUpdating = true;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	// Check the error code if the LocationManager failed.
	if(error.code == kCLErrorLocationUnknown)
    {
		NSLog(@"Currently unable to retrieve location.");
    }
	else if(error.code == kCLErrorNetwork)
    {
		NSLog(@"Network used to retrieve location is unavailable.");
    }
	else if(error.code == kCLErrorDenied)
	{
		// If the user denied access for the program to use GPS, then stop attempting to update the location.
		NSLog(@"Currently unable to retrieve location.");
		[locMan stopUpdatingLocation];
		locMan = nil;
	}
    
    isLocationUpdating = false;
}

- (void)updateCounter:(NSTimer*)timer
{
    double attitude[3] = {NAN, NAN, NAN};
    double accel[3] = {NAN, NAN, NAN};
    double rotation[3] = {NAN, NAN, NAN};
    double magnetic[3] = {NAN, NAN, NAN};
    double lla[3] = {NAN, NAN, NAN};
    
    if([mgr isDeviceMotionAvailable] && [mgr isDeviceMotionActive])
    {
        attitude[0] = mgr.deviceMotion.attitude.pitch*180.0/M_PI;
        attitude[1] = mgr.deviceMotion.attitude.roll*180.0/M_PI;
        attitude[2] = mgr.deviceMotion.attitude.yaw*180.0/M_PI;
        
        [self attitudeUpdate:attitude[0] rollValue:attitude[1] yawValue:attitude[2]];
    }
    else
    {
        pitch.text = [NSString stringWithFormat:@"%@", @"N/A"];
        roll.text = [NSString stringWithFormat:@"%@", @"N/A"];
        yaw.text = [NSString stringWithFormat:@"%@", @"N/A"];
    }
    
    if([mgr isAccelerometerAvailable])
    {
        accel[0] = mgr.accelerometerData.acceleration.x*-1;
        accel[1] = mgr.accelerometerData.acceleration.y*-1;
        accel[2] = mgr.accelerometerData.acceleration.z*-1;
        
        [self accelUpdate:accel[0] y:accel[1] z:accel[2]];
    }
    else
    {
        x_accel_label.text = y_accel_label.text = z_accel_label.text = [NSString stringWithFormat:NSLocalizedString(@"Unavailable", nil)];
        self.x_accel.progress = self.y_accel.progress = self.z_accel.progress = 0;
    }
    
    if([mgr isGyroAvailable])
    {
        rotation[0] = mgr.gyroData.rotationRate.x;
        rotation[1] = mgr.gyroData.rotationRate.y;
        rotation[2] = mgr.gyroData.rotationRate.z;
        
        [self gyroUpdate:rotation[0] q:rotation[1] r:rotation[2]];
    }
    else
    {
        x_gyro_label.text = y_gyro_label.text = z_gyro_label.text = [NSString stringWithFormat:NSLocalizedString(@"Unavailable", nil)];
        self.x_gyro.progress = self.y_gyro.progress = self.z_gyro.progress = 0;
    }
    
    if([mgr isMagnetometerAvailable])
    {
        magnetic[0] = mgr.magnetometerData.magneticField.x;
        magnetic[1] = mgr.magnetometerData.magneticField.y;
        magnetic[2] = mgr.magnetometerData.magneticField.z;
        
        [self magnetoUpdate:magnetic[0] y:magnetic[1] z:magnetic[2]];
    }
    else
    {
        x_mag_label.text = y_mag_label.text = z_mag_label.text = [NSString stringWithFormat:NSLocalizedString(@"Unavailable", nil)];
        self.x_mag.progress = self.y_mag.progress = self.z_mag.progress = 0;
    }
    
    if(isLocationUpdating)
    {
        lla[0] = locMan.location.coordinate.latitude;
        lla[1] = locMan.location.coordinate.longitude;
        lla[2] = locMan.location.altitude;
        
        [self gpsUpdate:lla[0] longitude:lla[1] altitude:lla[2]];
    }
    else
    {
        latitude.text = longitude.text = altitude.text = [NSString stringWithFormat:NSLocalizedString(@"Unavailable", nil)];
    }
    
    // Append time
    [data appendString:[NSString stringWithFormat:@"%f,", CFAbsoluteTimeGetCurrent()]];
    // Append attitude
    [data appendString:[NSString stringWithFormat:@"%f,%f,%f,", attitude[0], attitude[1], attitude[2]]];
    // Append acceleration
    [data appendString:[NSString stringWithFormat:@"%f,%f,%f,", accel[0], accel[1], accel[2]]];
    // Append rotation
    [data appendString:[NSString stringWithFormat:@"%f,%f,%f,", rotation[0], rotation[1], rotation[2]]];
    // Append magnetic
    [data appendString:[NSString stringWithFormat:@"%f,%f,%f,", magnetic[0], magnetic[1], magnetic[2]]];
    // Append GPS
    [data appendString:[NSString stringWithFormat:@"%f,%f,%f", lla[0], lla[1], lla[2]]];
    // Append newline
    [data appendString:@"\n"];
}

-(IBAction)emailResults
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Results", nil)]
                                 message:[NSString stringWithFormat:NSLocalizedString(@"Email", nil)]
                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Yes", nil)]
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    if ([MFMailComposeViewController canSendMail])
                                    {
                                        MFMailComposeViewController *mailComposer;
                                        mailComposer  = [[MFMailComposeViewController alloc] init];
                                        [mailComposer setMailComposeDelegate:self];
                                        [mailComposer setModalPresentationStyle:UIModalPresentationFormSheet];
                                        [mailComposer setSubject:[NSString stringWithFormat:NSLocalizedString(@"Subject", nil)]];
                                        [mailComposer setMessageBody:[NSString stringWithFormat:NSLocalizedString(@"MessageBody", nil)] isHTML:YES];
                                        NSData *attachmentData = [NSData dataWithContentsOfFile:fileName];
                                        [mailComposer addAttachmentData:attachmentData mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"DataCollection_%@.csv",dateString]];
                                        [self presentViewController:mailComposer animated:YES completion:nil];
                                    }
                                    else
                                    {
                                        NSLog(@"Attempted to send email, but canSendMail returned false");
                                    }
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:[NSString stringWithFormat:NSLocalizedString(@"No", nil)]
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   // Do nothing if they say no
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
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
        [data appendString:@"Time (sec),"];
        [data appendString:@"Pitch (deg),Roll (deg),Yaw(deg),"];
        [data appendString:@"X-Acceleration (g),Y-Acceleration (g),Z-Acceleration (g),"];
        [data appendString:@"Pitch Rate (deg/sec),Roll Rate (deg/sec),Yaw Rate (deg/sec),"];
        [data appendString:@"Magnetic Field in X direction (uT),Magnetic Field in Y direction (uT),Magnetic Field in Z Direction (uT),"];
        [data appendString:@"Latitude (deg),Longitude (deg),Altitude (m)"];
        [data appendString:@"\n"];
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
        fileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"DataCollection_%@.csv",dateString]];
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
    recording.on = false;
    
    [mgr stopGyroUpdates];
    [mgr stopAccelerometerUpdates];
    [mgr stopMagnetometerUpdates];
    [mgr stopDeviceMotionUpdates];
    [locMan stopUpdatingLocation];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	recording.on = false;
    
    // Request user access for location services
    [locMan requestWhenInUseAuthorization];
    
    if([CLLocationManager locationServicesEnabled])
    {
        // Initialize the location manager and set the delegate to us.
        locMan = [[CLLocationManager alloc] init];
        locMan.delegate = self;
        // Set the distance filter so that it will update the location manager whenever we move.
        locMan.distanceFilter = kCLDistanceFilterNone;
        // Set the desired accuracy to the best possible accuracy.
        locMan.desiredAccuracy = kCLLocationAccuracyBest;
       
        back.title = [NSString stringWithFormat:NSLocalizedString(@"BackButton", nil)];
        latitudeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Latitude", nil)];
        longitudeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Longitude", nil)];
        altitudeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Altitude", nil)];
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
        [mgr startDeviceMotionUpdates];
        [locMan startUpdatingLocation];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0/freq
                                         target:self
                                       selector:@selector(updateCounter:)
                                       userInfo:nil
                                        repeats:YES];
    }
    else
    {
        NSLog(@"Location services are disabled");
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(IBAction)goBack
{
    if(!recording.on)
        [self dismissViewControllerAnimated:true completion:nil];
}

-(void)setSamplingRate:(float)frequency
{
    freq = frequency;
}
@end
