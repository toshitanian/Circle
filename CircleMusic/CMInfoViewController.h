//
//  CMInfoViewController.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/7/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AVFoundation/AVFoundation.h>
#import "CMPlayerButtonView.h"

@class CMInfoViewController;
@protocol CMInfoViewControllerDelegate <NSObject>
-(void)CMInfoViewControllerDidFinishShowing:(CMInfoViewController *)vc;

@end

@interface CMInfoViewController : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet CMPlayerButtonView *_btn_player;
    IBOutlet CMPlayerButtonView *_btn_pop;
    BOOL _onPlayer;
    BOOL _onPop;
    CGPoint _player_abs_point;
    CGPoint _pop_abs_point;
}


-(IBAction)pop:(id)sender;
-(IBAction)showPlayer:(id)sender;
@property (nonatomic,retain) id<CMInfoViewControllerDelegate> delegate;
@end
