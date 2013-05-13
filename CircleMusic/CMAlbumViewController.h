//
//  CMAlbumViewController.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/6/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CMSpiralCircleView.h"
#import "CMIndexView.h"

@interface CMPanGestureRecognizer : UIPanGestureRecognizer
@property (atomic,assign) int tag;
@end

@interface CMTapGestureRecognizer : UITapGestureRecognizer
@property (atomic,assign) int tag;
@end


@class CMAlbumViewController;
@protocol CMAlbumViewControllerDelegate <NSObject>

-(void)CMAlbumViewControllerDidChangeProgressOfLoad:(float)progress From:(CMAlbumViewController *)vc;

@end

@interface CMAlbumViewController : UIViewController<CMSpiralCircleViewDelegate>
{
    
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
    NSMutableArray *_items;
    
    bool _presenting_player;
  
    
    UIImageView *_shadow;
    
    float _label_height;
    
    IBOutlet UIView *_slider1;
    IBOutlet UIView *_slider2;
    IBOutlet UIView *_slider3;
    IBOutlet UIView *_slider4;
    
    float _scroll_speed;
    NSTimer *_tm;
    
    UIView *_touching_view;
    
    CMIndexView *_index_view;
    
    NSArray *index_dic;
}
//[type] 0: artist 1: song 2:album
@property(atomic,assign) int type;
@property(atomic,assign) CGPoint pointPanBegan;
@property(nonatomic,retain) NSString *query_keyword;
@property (nonatomic,retain) id<CMAlbumViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withType:(int)type;

-(void)updateCircle:(float)angle;
-(IBAction)pop:(id)sender;
-(IBAction)showPlayer:(id)sender;
-(IBAction)label_touched:(id)sender;
-(IBAction)showIndex:(id)sender;
-(IBAction)hideIndex:(id)sender;

@end
