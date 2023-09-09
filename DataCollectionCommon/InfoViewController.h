//  InfoViewController.h
//  Data Collection
//
//  Created by Chris Wozny on 11/8/11.
//  Copyright (c) 2013 Chris Wozny. All rights reserved.

#import <UIKit/UIKit.h>

#ifdef FREE_VERSION
#import <iAd/iAd.h>
#endif

@interface InfoViewController : UIViewController
#ifdef FREE_VERSION
<ADBannerViewDelegate>
#endif
{
#ifdef FREE_VERSION
    ADBannerView *bannerView;
#endif
}

#ifdef FREE_VERSION
@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;
#endif

-(IBAction)goBack;

@end
