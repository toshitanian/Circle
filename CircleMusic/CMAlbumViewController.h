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
#import "CMIndexCircleView.h"
#import "CMPlayerButtonView.h"

@interface CMPanGestureRecognizer : UIPanGestureRecognizer
@property (atomic,assign) int tag;
@end

@interface CMTapGestureRecognizer : UITapGestureRecognizer
@property (atomic,assign) int tag;
@end


@class CMAlbumViewController;
@protocol CMAlbumViewControllerDelegate <NSObject>

-(void)CMAlbumViewControllerDidChangeProgressOfLoad:(float)progress From:(CMAlbumViewController *)vc;
-(void)CMAlbumViewControllerDidChangeProgressOfShow:(float)progress From:(CMAlbumViewController *)vc;
-(void)CMAlbumViewControllerDidFinishLoading:(CMAlbumViewController *)vc;
-(void)CMAlbumViewControllerDidFinishShowing:(CMAlbumViewController *)vc;

@end

@interface CMAlbumViewController : UIViewController<CMSpiralCircleViewDelegate,UIGestureRecognizerDelegate>
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
    
    CMSpiralCircleView *_touching_view;
    
    CMIndexView *_index_view;
    
    NSArray *index_dic;
    
    CMIndexCircleView *_index_circle_view;
    
    
    IBOutlet CMPlayerButtonView *_btn_player;
    IBOutlet CMPlayerButtonView *_btn_pop;
    IBOutlet UIView *_controller_view;
    CGPoint _player_abs_point;
    CGPoint _pop_abs_point;
    BOOL _onPlayer;
    BOOL _onPop;
    
    MPMediaQuery *current_query;

    UIImageView *_intro;
    BOOL _intro_type;
    
    IBOutlet UIImageView *img_type;
    
}
//[type] 0: artist 1: song 2:album
@property(atomic,assign) int type;
@property(atomic,assign) BOOL isSongFromPlaylist;
@property(atomic,assign) BOOL hasLoaded;
@property(atomic,assign) CGPoint pointPanBegan;
@property(nonatomic,retain) NSString *query_keyword;
@property (nonatomic,retain) id<CMAlbumViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withType:(int)type;
-(void)prepare;
-(void)updateCircle:(float)angle;
-(IBAction)pop:(id)sender;
-(IBAction)showPlayer:(id)sender;
-(IBAction)label_touched:(id)sender;
-(IBAction)showIndex:(id)sender;
-(IBAction)hideIndex:(id)sender;

@end
