//
//  CMInfoViewController.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/7/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AVFoundation/AVFoundation.h>

@class CMInfoViewController;
@protocol CMInfoViewControllerDelegate <NSObject>
-(void)CMInfoViewControllerDidFinishShowing:(CMInfoViewController *)vc;

@end

@interface CMInfoViewController : UIViewController<AVAudioPlayerDelegate>


-(IBAction)pop:(id)sender;
-(IBAction)showPlayer:(id)sender;
@property (nonatomic,retain) id<CMInfoViewControllerDelegate> delegate;
@end
