//
//  CMAlbumViewController.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/6/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMAlbumViewController : UIViewController
{
    IBOutlet UIView *_slider;
    IBOutlet UIView *_spiral;
    
    CGPoint _center;
    float _radius;
    NSMutableArray *_circles;
    float _angle;
    int _item_num;
    
    int _current_target;
    
    IBOutlet UILabel *_label_main;
    IBOutlet UILabel *_label_sub_upper;
    IBOutlet UILabel *_label_sub_lower;
}

-(void)updateCircle:(float)angle;
-(IBAction)pop:(id)sender;
-(IBAction)showPlayer:(id)sender;

@end
