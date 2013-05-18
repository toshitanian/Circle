//
//  CMAlbumViewController.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/6/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMAlbumViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CMAppDelegate.h"
#import "CMSpiralCircleView.h"


#define  ITEM_SIZE 130
#define VIEW_NUM 20
#define CIRCLES_IN_PI 6
#define TIMER 0.05f



@implementation CMPanGestureRecognizer
- (id)initWithTarget:(id)target action:(SEL)action
{
    self=[super initWithTarget:target action:action];
    if(self){
        
    }
    return self;
}

@end

@implementation CMTapGestureRecognizer
- (id)initWithTarget:(id)target action:(SEL)action
{
    self=[super initWithTarget:target action:action];
    if(self){
        
    }
    return self;
}

@end



@interface CMAlbumViewController ()

@end

@implementation CMAlbumViewController

#pragma mark - view
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withType:(int)type
{
    CMAppDelegate *ad=[[UIApplication sharedApplication] delegate];
    if(ad.iOStype==2){
        nibNameOrNil=@"CMAlbumViewController_for_35inch";
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.type=type;

        
    }
    return self;
}

-(void)prepare 
{

    // Custom initialization
    _circles=[NSMutableArray array];

#pragma mark Query
    MPMediaQuery *query;
    NSArray *collections;
    if(self.type==0){
        query = [MPMediaQuery  artistsQuery];
        [query setGroupingType: MPMediaGroupingArtist];
        collections = [query collections];
    }else if(self.type==1){
        query = [MPMediaQuery  songsQuery];
        [query setGroupingType: MPMediaGroupingTitle];
        if(self.query_keyword!=nil){
            [query addFilterPredicate: [MPMediaPropertyPredicate
                                        predicateWithValue: self.query_keyword
                                        forProperty: MPMediaItemPropertyAlbumTitle]];
        }
        collections = [query collections];
    }else if(self.type==2){
        query = [MPMediaQuery  albumsQuery];
        [query setGroupingType: MPMediaGroupingAlbum];
        if(self.query_keyword!=nil){
            [query addFilterPredicate: [MPMediaPropertyPredicate
                                        predicateWithValue: self.query_keyword
                                        forProperty: MPMediaItemPropertyAlbumArtist]];
        }
        collections = [query collections];
    }else if(self.type==3){
        query = [MPMediaQuery  playlistsQuery];
        //[query setGroupingType: MPMediaGroupingPlaylist];
        collections = [query collections];
    }
    
    //TODO: index
   // NSArray *indexes=[self partitionObjects:collections collationStringSelector:@selector(albumArtist)];
//    NSLog(@"%@",indexes);
#pragma mark - make views
    
    _item_num=[collections count];
    for (int i=0; i<_item_num; i++) {
        float ratio=(1-(float)i/VIEW_NUM)*1.0;
        CMSpiralCircleView *view=[[CMSpiralCircleView alloc] initWithFrame:CGRectMake(0,0, ITEM_SIZE*ratio, ITEM_SIZE*ratio)];
        
        //media
        MPMediaItem *representativeItem = [collections[i] representativeItem];
        NSString *artistName =
        [representativeItem valueForProperty: MPMediaItemPropertyAlbumArtist];
        NSString *albumName =
        [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];
        NSString *title= [representativeItem valueForProperty: MPMediaItemPropertyTitle];
        NSString *playlist= [representativeItem valueForProperty: MPMediaPlaylistPropertyName];
        MPMediaItemArtwork *artwork= [representativeItem valueForProperty:  MPMediaItemPropertyArtwork];
        
        view.artist_name=artistName;
        view.album_name=albumName;
        view.title=title;
        view.artwork=artwork;
        
        if(self.type==3){
            view.playlist_name=playlist;
        }
        
  
        
        [view setImage];
        [_circles addObject:view];
        @try {
            if(i%20==0){
            [self.delegate CMAlbumViewControllerDidChangeProgressOfLoad:(float)i/(float)_item_num From:self];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    [self.delegate CMAlbumViewControllerDidFinishLoading:self];
}


-(void)viewWillAppear:(BOOL)animated
{
    _pointPanBegan.x=-1;
     CMAppDelegate *ad=[[UIApplication sharedApplication] delegate];
    if (ad.playerViewController.isAvailable) {
        _btn_player.hidden=NO;
    }else{
        _btn_player.hidden=YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.delegate CMAlbumViewControllerDidFinishShowing:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _angle=0;
    _current_target=0;
    _center=_spiral.center;
    _radius=_spiral.frame.size.height/2-ITEM_SIZE/2;

    _label_main.backgroundColor=[UIColor whiteColor];
    _label_sub_lower.backgroundColor=[UIColor whiteColor];
    _label_sub_upper.backgroundColor=[UIColor whiteColor];
    _spiral.backgroundColor=[UIColor whiteColor];
    _label_height=_label_main.frame.size.height+_label_sub_lower.frame.size.height+_label_sub_upper.frame.size.height;

    
    if(self.type==0){
        _label_sub_upper.hidden=YES;
        _label_main.hidden=NO;
        _label_sub_lower.hidden=YES;
    }else if(self.type==1){
        _label_sub_upper.hidden=NO;
        _label_main.hidden=NO;
        _label_sub_lower.hidden=NO;
    }else if(self.type==2){
        _label_sub_upper.hidden=NO;
        _label_main.hidden=NO;
        _label_sub_lower.hidden=YES;
    }else if(self.type==3){
        _label_sub_upper.hidden=YES;
        _label_main.hidden=NO;
        _label_sub_lower.hidden=YES;
    }
    
    for (int i=0; i<_item_num; i++) {
        
        CMSpiralCircleView *view=_circles[i];
        
        view.delegate=self;
        
        if(i==0){
            if(self.type==0){
                _label_main.text=[NSString stringWithFormat:@"%@",view.artist_name];
            }else if(self.type==1){
                _label_main.text=[NSString stringWithFormat:@"%@",view.title];
                _label_sub_upper.text=[NSString stringWithFormat:@"%@",view.artist_name];
                _label_sub_lower.text=[NSString stringWithFormat:@"%@",view.album_name];
            }else if(self.type==2){
                _label_main.text=[NSString stringWithFormat:@"%@",view.album_name ];
                _label_sub_upper.text=[NSString stringWithFormat:@"%@",view.artist_name];
            }else if(self.type==3){
                _label_main.text=[NSString stringWithFormat:@"%@",view.playlist_name ];
            }
        }
        
        
        float ratio=(1-(float)i/VIEW_NUM)*1.0;
        //view
        view.center=CGPointMake(_center.x+_radius*(float)sin(M_PI/CIRCLES_IN_PI*i)*ratio, _center.y+_radius*(float)cos(M_PI/CIRCLES_IN_PI*i)*ratio);
        if(i<VIEW_NUM){
            [_spiral addSubview:view];
            [_spiral sendSubviewToBack:view];
        }else{
            view.frame=CGRectMake(0,0,0,0);
        }
        @try {
            [self.delegate CMAlbumViewControllerDidChangeProgressOfLoad:(float)i/(float)_item_num From:self];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
    }
    
    
    [self initSlider];
    
    _shadow=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ITEM_SIZE*2.0, ITEM_SIZE*2.0)];
    _shadow.center=CGPointMake(_center.x, _center.y+_radius);
    _shadow.backgroundColor=[UIColor clearColor];
    _shadow.layer.cornerRadius = _shadow.frame.size.width/2;
    _shadow.alpha=1.0f;
    _shadow.image=[UIImage imageNamed:@"blur.png"];
    [_spiral addSubview:_shadow];
    [_spiral sendSubviewToBack:_shadow];
    
    
    _scroll_speed=0.0;
    
#pragma mark index circle view
    _index_circle_view=[[CMIndexCircleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4, self.view.frame.size.width/4)];
    _index_circle_view.center=CGPointMake(_center.x, _center.y);
    [self.view addSubview:_index_circle_view];
    _index_circle_view.isShowing=NO;
    
    
#pragma mark index_view init
    /*
    index_dic=[CMIndexView getIndexes:collections WithType:self.type];
    _index_view=[[CMIndexView alloc] initWithFrame:self.view.frame WithIndexes:index_dic];
    [_index_view setFrame:CGRectMake(self.view.frame.size.width, 0, _index_view.frame.size.width, _index_view.frame.size.height)];
    
    [self.view addSubview:_index_view];
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [_index_view addGestureRecognizer:tapRecognizer];
     */
    
#pragma mark control button
    [_btn_player makeCircle];
    _btn_player.image=[UIImage imageNamed:@"headphone.png"];
    [_btn_pop makeCircle];
    _btn_pop.image=[UIImage imageNamed:@"back.png"];
    UITapGestureRecognizer* p_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureForController:)];
    p_tapRecognizer.delegate=self;
    [_controller_view addGestureRecognizer:p_tapRecognizer];
    
    UILongPressGestureRecognizer* p_longpressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureForController:)];
    p_longpressRecognizer.delegate=self;
    [_controller_view addGestureRecognizer:p_longpressRecognizer];
    
    UIPanGestureRecognizer *p_panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureForController:)];
    p_panRecognizer.delegate=self;
    [_controller_view addGestureRecognizer:p_panRecognizer];
    
    
    _player_abs_point=absPoint_(_btn_player);
    _pop_abs_point=absPoint_(_btn_pop);
    
    
}

-(void)initSlider
{
    _slider1.frame=CGRectMake(0,_spiral.frame.size.height-ITEM_SIZE,self.view.frame.size.width,ITEM_SIZE);
    CMPanGestureRecognizer* panRecognizer = [[CMPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:) ];
    panRecognizer.tag=1;
    [_slider1 addGestureRecognizer:panRecognizer];
    [self.view bringSubviewToFront:_slider1];
    _slider1.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
    
    
    _slider2.frame=CGRectMake(_spiral.frame.size.width-ITEM_SIZE*0.8,_label_height,ITEM_SIZE*0.8,_spiral.frame.size.height-_label_height-_slider1.frame.size.height);
    CMPanGestureRecognizer* panRecognizer2 = [[CMPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:) ];
    panRecognizer2.tag=2;
    [_slider2 addGestureRecognizer:panRecognizer2];
    [self.view bringSubviewToFront:_slider2];
    _slider2.backgroundColor=[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.2f];
    
    _slider3.frame=CGRectMake(0,_label_height,_spiral.frame.size.width-_slider2.frame.size.width,ITEM_SIZE*0.7);
    CMPanGestureRecognizer* panRecognizer3 = [[CMPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:) ];
    panRecognizer3.tag=3;
    [_slider3 addGestureRecognizer:panRecognizer3];
    [self.view bringSubviewToFront:_slider3];
    _slider3.backgroundColor=[UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.2f];
    
    
    _slider4.frame=CGRectMake(0,_label_height+_slider3.frame.size.height,ITEM_SIZE,ITEM_SIZE*1.3);
    CMPanGestureRecognizer* panRecognizer4 = [[CMPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:) ];
    panRecognizer4.tag=4;
    [_slider4 addGestureRecognizer:panRecognizer4];
    [self.view bringSubviewToFront:_slider4];
    _slider4.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.2f];
    
    _slider1.hidden=YES;
    _slider2.hidden=YES;
    _slider3.hidden=YES;
    _slider4.hidden=YES;
    
    
    CMPanGestureRecognizer* panRecognizer_spiral = [[CMPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:) ];
    panRecognizer_spiral.tag=9;
    [_spiral addGestureRecognizer:panRecognizer_spiral];
    
    
}

-(void)updateCircle:(float)angle
{
    if(_item_num==0) return;
    
    if(_angle==0 && angle>0){
        // NSLog(@"invalid");
        
        return;
    }
    _angle=MAX( MIN(0, _angle+angle),-1*M_PI/CIRCLES_IN_PI*((float)_item_num-0.5));
    
    //NSLog(@"%lf",_angle/M_PI*180);
    int target=(int)(-1*_angle/M_PI*180/30);
    int target_changed=_current_target-target;
    [_spiral sendSubviewToBack:_shadow];
    
    if(target_changed!=0){
        @try {
            CMSpiralCircleView *view=_circles[target];
            if(self.type==0){
                _label_main.text=[NSString stringWithFormat:@"%@",view.artist_name];
            }else if(self.type==1){
                _label_main.text=[NSString stringWithFormat:@"%@",view.title];
                _label_sub_upper.text=[NSString stringWithFormat:@"%@",view.artist_name];
                _label_sub_lower.text=[NSString stringWithFormat:@"%@",view.album_name];
            }else if(self.type==2){
                _label_main.text=[NSString stringWithFormat:@"%@",view.album_name ];
                _label_sub_upper.text=[NSString stringWithFormat:@"%@",view.artist_name];
            }else if(self.type==3){
                _label_main.text=[NSString stringWithFormat:@"%@",view.playlist_name ];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
        
        
        _current_target=target;
        //NSLog(@"changed:%d",_current_target);
        
        
        if(target_changed<0){
            
            if(_current_target>1){
                //左に消えていく
                
                @try {
                    CMSpiralCircleView *view=_circles[_current_target-2];
                    CGPoint center=CGPointMake(-1*view.frame.size.width/2,view.center.y);
                    [view removeFromSuperview];
                    /*
                     void (^animations)(void) = ^{
                     
                     
                     [view setCenter:center];
                     };
                     void (^completionAnimation)(BOOL) = ^(BOOL finished) {
                     
                     [view removeFromSuperview];
                     };
                     
                     if(_current_target!=_item_num-1){
                     [UIView animateWithDuration:0.4
                     animations:animations
                     completion:completionAnimation];
                     }
                     */
                }
                @catch (NSException *exception) {
                    NSLog(@"LeftDisApper:%@",exception);
                }
                @finally {
                    
                }
                
                
                
            }
            if(_current_target<_item_num-VIEW_NUM+1){
                //中心から現れる
                @try {
                    CMSpiralCircleView * view=_circles[_current_target+VIEW_NUM-1];
                    NSLog(@"%@",view.album_name);
                    [_spiral addSubview:view];
                    [_spiral sendSubviewToBack:view];
                }
                @catch (NSException *exception) {
                    NSLog(@"CenterApper:%@",exception);
                }
                @finally {
                    
                }
                
            }
        }else if(target_changed>0){
            
            if(_current_target<_item_num-VIEW_NUM+1){
                //中心に消えていく
                @try {
                    [_circles[_current_target+VIEW_NUM] removeFromSuperview];
                }
                @catch (NSException *exception) {
                    NSLog(@"CenterDisApper:%@",exception);
                }
                @finally {
                    
                }
                
            }
            
            if(_current_target>-1){
                //左から現れる
                @try {
                    CMSpiralCircleView *view=_circles[_current_target];
                    [_spiral addSubview:view];
                    [_spiral bringSubviewToFront:view];
                }
                @catch (NSException *exception) {
                    NSLog(@"CenterApper:%@",exception);
                }
                @finally {
                    
                }
                
                
            }
            
        }
        
    }
    
    
    
    
    
    
    //NSLog(@"%d,%lf",target ,_angle/M_PI*180);
    for (int j=0; j<MIN(VIEW_NUM+1,_item_num-_current_target+1); j++) {
        int i=j+_current_target-1;
        float ratio=(1-(float)(i+_angle/M_PI*180/30)/10)*0.50+0.50;
        @try {
            
            
            CMSpiralCircleView *view=_circles[i];
            view.frame=CGRectMake(view.frame.origin.x,view.frame.origin.y ,MIN(ITEM_SIZE*ratio,ITEM_SIZE), MIN(ITEM_SIZE*ratio,ITEM_SIZE));
            float x=_center.x+_radius*(float)sin(M_PI/CIRCLES_IN_PI*i+_angle)*ratio;
            float y =_center.y+_radius*(float)cos(M_PI/CIRCLES_IN_PI*i+_angle)*ratio;
            if(target>i-1){
                y=_center.y+_radius;
                x=_center.x+(_radius/(M_PI/CIRCLES_IN_PI))*(_angle+M_PI/CIRCLES_IN_PI*i);
                // if(i==1) NSLog(@"%lf",_radius/(M_PI/CIRCLES_IN_PI)*(_angle+M_PI/CIRCLES_IN_PI*i)*0.1);
                _shadow.center=CGPointMake(x, y);
            }
            
            view.center=CGPointMake(x, y);
            view.layer.cornerRadius = view.frame.size.width/2;
        }
        @catch (NSException *exception) {
            NSLog(@"Error with moving view");
        }
        @finally {
            
        }
        
    }
}
#pragma mark - scrolling

-(void)clock:(id)something
{
    if(_scroll_speed>0.005 || _scroll_speed<-0.005){
        [self updateCircle:_scroll_speed*1.2];
        _scroll_speed*=0.96;
        //NSLog(@"SPEED:%lf",_scroll_speed);
        
    }else{
        _scroll_speed=0.0;
        //  NSLog(@"scroll_end");
        [_tm invalidate];
        
    }
    
}



#pragma mark - gesture
//http://labs.techfirm.co.jp/ipad/cho/466


CGPoint absPoint_(UIView* view)
{
    CGPoint ret = CGPointMake(view.frame.origin.x, view.frame.origin.y);
    if ([view superview] != nil){
        CGPoint addPoint = absPoint_([view superview]);ret = CGPointMake(ret.x + addPoint.x, ret.y + addPoint.y);
    }
    return ret;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]]){
        CGPoint point=[touch locationInView:self.view];
        if(CGRectContainsPoint(CGRectMake(_player_abs_point.x, _player_abs_point.y, _btn_player.frame.size.width, _btn_player.frame.size.height), point)){
            void (^animations)(void) = ^{
                
                float scale_value=1.2;
                
                CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
                [_btn_player setTransform:scale];
                
            };
            
            [UIView animateWithDuration:0.1 animations:animations completion:nil];
            _onPlayer=YES;
            
        }
        
        if(CGRectContainsPoint(CGRectMake(_pop_abs_point.x, _pop_abs_point.y, _btn_pop.frame.size.width, _btn_pop.frame.size.height), point)){
            void (^animations)(void) = ^{
                
                float scale_value=1.2;
                
                CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
                [_btn_pop setTransform:scale];
                
            };
            
            [UIView animateWithDuration:0.1 animations:animations completion:nil];
            _onPop=YES;
            
        }
    }
    
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    return YES;
    
}

- (void)handleTapGesture:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self hideIndex:nil];
    }
}

- (void)handleTapGestureForController:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        
        UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
        CGPoint point=[tap locationInView:self.view];
        
        [self resetControlButtons];
        
        if(CGRectContainsPoint(CGRectMake(_player_abs_point.x, _player_abs_point.y, _btn_player.frame.size.width, _btn_player.frame.size.height), point)){
            [self showPlayer:nil];
        }
        
        if(CGRectContainsPoint(CGRectMake(_pop_abs_point.x, _pop_abs_point.y, _btn_pop.frame.size.width, _btn_pop.frame.size.height), point)){
            [self pop:nil];
        }
        
        
    }else if(sender.state==UIGestureRecognizerStateCancelled ||sender.state==UIGestureRecognizerStateFailed){
        [self resetControlButtons];
    }
}

- (void)handlePanGestureForController:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        
        [self resetControlButtons];
    }else if(sender.state==UIGestureRecognizerStateCancelled ||sender.state==UIGestureRecognizerStateFailed){
        [self resetControlButtons];
    }
}

- (void)handlePanGesture:(UIGestureRecognizer *)sender {
    _touching_view=nil;
    CMPanGestureRecognizer *pan = (CMPanGestureRecognizer*)sender;
    int tag=pan.tag;
    CGPoint point = [pan translationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    
    if(tag==9 && _pointPanBegan.x!=-1){
        CGPoint current_point=CGPointMake(_pointPanBegan.x+point.x, _pointPanBegan.y+point.y);
        if(CGRectContainsPoint(_slider1.frame, current_point)) tag=1;
        if(CGRectContainsPoint(_slider2.frame, current_point)) tag=2;
        if(CGRectContainsPoint(_slider3.frame, current_point)) tag=3;
        if(CGRectContainsPoint(_slider4.frame, current_point)) tag=4;
        //NSLog(@"%d|%lf:%lf",tag,velocity.x,velocity.y);
        //NSLog(@"BEGAN¥%lf:%lf",current_point.x,current_point.y);
        
    }
    if(sender.state==UIGestureRecognizerStateEnded){
        self.pointPanBegan=CGPointMake(-1,-1);
    }
    
    if(sender.state==UIGestureRecognizerStateBegan){
        // NSLog(@"BEGAN¥%lf:%lf",point.x,velocity.x);
        
    }else{
        
        //NSLog(@"Tag:%d",tag);
        
        float angle=atan(point.y/point.x)/2/M_PI*360;
        if(tag==1){
            
            // NSLog(@"%lf",atan(point.y/point.x)/2/M_PI*360);
            //NSLog(@"%lf",point.y);
            if(YES || abs(angle)<45){
                if(velocity.x>0) [self updateCircle:sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2))];
                if(velocity.x<0) [self updateCircle:-1*sqrt(pow(velocity.x*0.0001,2)+pow(MIN(velocity.y,0)*0.0001,2))];
                
                if (sender.state == UIGestureRecognizerStateEnded){
                    _scroll_speed=velocity.x*0.0001;
                    //  NSLog(@"Tag:%d",tag);
                    _tm =
                    [NSTimer scheduledTimerWithTimeInterval:TIMER target:self selector:@selector(clock:) userInfo:nil repeats:YES];
                    
                    [_tm fire];
                }
                
                
            }/*
              else if(angle<0 && abs(velocity.x)<100 && velocity.y<-200 && point.y<-30 ){
              
              CMSpiralCircleView *view=[_circles objectAtIndex:_current_target];
              NSLog(@"%lf:%lf",view.center.x,view.center.y);
              [self CircleDidTouched:view];
              
              }*/
        }else if (tag==2){
            if(YES || abs(angle)>45){
                if(velocity.y>0) [self updateCircle:-1*sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2))];
                if(velocity.y<0) [self updateCircle:sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2))];
                
                if (sender.state == UIGestureRecognizerStateEnded){
                    _scroll_speed=-1*velocity.y*0.0001;
                    //  NSLog(@"Tag:%d",tag);
                    _tm =
                    [NSTimer scheduledTimerWithTimeInterval:TIMER target:self selector:@selector(clock:) userInfo:nil repeats:YES];
                    
                    [_tm fire];
                }
            }
        }else if (tag==3){
            if(abs(angle)<45 || YES){
                if(velocity.x>0) [self updateCircle:-1*sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2))];
                if(velocity.x<0) [self updateCircle:sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2))];
                
                if (sender.state == UIGestureRecognizerStateEnded){
                    _scroll_speed=-1*velocity.x*0.0001;
                    //  NSLog(@"Tag:%d",tag);
                    _tm =
                    [NSTimer scheduledTimerWithTimeInterval:TIMER target:self selector:@selector(clock:) userInfo:nil repeats:YES];
                    
                    [_tm fire];
                }
            }
        }else if (tag==4){
            if(abs(angle)>45 || YES){
                if(velocity.y>0) [self updateCircle:sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2))];
                if(velocity.y<0) [self updateCircle:-1*sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2))];
                if (sender.state == UIGestureRecognizerStateEnded){
                    _scroll_speed=velocity.y*0.0001;
                    //  NSLog(@"Tag:%d",tag);
                    _tm =
                    [NSTimer scheduledTimerWithTimeInterval:TIMER target:self selector:@selector(clock:) userInfo:nil repeats:YES];
                    
                    [_tm fire];
                }
            }
        }
        
    }
    
    if (sender.state == UIGestureRecognizerStateEnded || sender.state==UIGestureRecognizerStateCancelled ||sender.state==UIGestureRecognizerStateFailed){
        [self resetControlButtons];
    }
}

-(void)resetControlButtons
{
    NSLog(@"reset");
    if(_onPlayer){
        float scale_value=1.0;
        CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
        [_btn_player setTransform:scale];
    }
    if(_onPop){
        float scale_value=1.0;
        CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
        [_btn_pop setTransform:scale];
    }
    
    _onPop=NO;
    
}

-(IBAction)label_touched:(id)sender
{
    CMSpiralCircleView *view=_circles[_current_target];
    
    [self CircleDidTouched:view];
}

#pragma mark - Circle Delegate
-(void)CircleDidCanceledTouching:(CMSpiralCircleView *)view
{
    
    _touching_view=nil;
}
-(void)CircleDidTouchedOutOfView:(CMSpiralCircleView *)view WithTouch:(UITouch *)touch
{
    _touching_view=nil;
    NSLog(@"Out Of View");
}

-(void)CircleDidLongTouched:(CMSpiralCircleView *)view
{
    if(_touching_view==view){
        // NSLog(@"TouchUp Cancel");
        _touching_view=nil;
        return;
    }
    _touching_view=nil;
    
    
    if(_presenting_player) return;
    
    view.original_center=view.center;
    
    
    CMAppDelegate *ad=[[UIApplication sharedApplication] delegate];
    
    
    
    if(self.type==0){
        
        [view gotPlayed:CGPointMake(_spiral.center.x,_spiral.center.y+_radius)];
        CMAlbumViewController *vc=[[CMAlbumViewController alloc] initWithNibName:@"CMAlbumViewController" bundle:nil withType:2];
        vc.query_keyword=view.artist_name;
        [vc prepare];
        
        vc.view.alpha=0.0;
        [self.view addSubview:vc.view];
        [UIView transitionWithView:vc.view duration:0.33 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            vc.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.navigationController pushViewController:vc animated:NO];
            [vc.view removeFromSuperview];
        }];
        return;
        
    }else if(self.type==1){
        [view gotPlayed:CGPointMake(_spiral.center.x,_spiral.center.y)];
        _presenting_player=YES;
        MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
        [songQuery addFilterPredicate: [MPMediaPropertyPredicate
                                        predicateWithValue: view.title
                                        forProperty: MPMediaItemPropertyTitle]];
        
        ad.playerViewController.query=songQuery;
        ad.playerViewController.needReload=YES;
        
        
        
        [self presentViewController:ad.playerViewController animated:YES completion:  ^{_presenting_player=NO;}];
    }else if(self.type==2){
        [view gotPlayed:CGPointMake(_spiral.center.x,_spiral.center.y)];
        MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
        [songQuery addFilterPredicate: [MPMediaPropertyPredicate
                                        predicateWithValue: view.album_name
                                        forProperty: MPMediaItemPropertyAlbumTitle]];
        
        ad.playerViewController.query=songQuery;
        ad.playerViewController.needReload=YES;
        [self presentViewController:ad.playerViewController animated:YES completion:  ^{_presenting_player=NO;}];
    }else if(self.type==3){
        MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
        [songQuery addFilterPredicate: [MPMediaPropertyPredicate
                                        predicateWithValue: view.playlist_name
                                        forProperty: MPMediaPlaylistPropertyName]];
        ad.playerViewController.query=songQuery;
        ad.playerViewController.needReload=YES;
        [self presentViewController:ad.playerViewController animated:YES completion:  ^{_presenting_player=NO;}];
    }

}

-(void)CircleDidTouched:(CMSpiralCircleView *)view
{
    
    
    if(_touching_view==view){
        // NSLog(@"TouchUp Cancel");
        _touching_view=nil;
        return;
    }
    _touching_view=nil;
    
    
    if(_presenting_player) return;
    
    view.original_center=view.center;
    
    
    CMAppDelegate *ad=[[UIApplication sharedApplication] delegate];
    
    
    
    if(self.type==0){
   
        [view gotPlayed:CGPointMake(_spiral.center.x,_spiral.center.y+_radius)];
        CMAlbumViewController *vc=[[CMAlbumViewController alloc] initWithNibName:@"CMAlbumViewController" bundle:nil withType:2];
        vc.query_keyword=view.artist_name;
        [vc prepare];
   
        vc.view.alpha=0.0;
        [self.view addSubview:vc.view];
        [UIView transitionWithView:vc.view duration:0.33 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            vc.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.navigationController pushViewController:vc animated:NO];
            [vc.view removeFromSuperview];
        }];
        return;
        
    }else if(self.type==1){
        [view gotPlayed:CGPointMake(_spiral.center.x,_spiral.center.y)];
        _presenting_player=YES;
        MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
        [songQuery addFilterPredicate: [MPMediaPropertyPredicate
                                        predicateWithValue: view.title
                                        forProperty: MPMediaItemPropertyTitle]];
        
        ad.playerViewController.query=songQuery;
        ad.playerViewController.needReload=YES;
        
        
        
        [self presentViewController:ad.playerViewController animated:YES completion:  ^{_presenting_player=NO;}];
    }else if(self.type==2){
        [view gotPlayed:CGPointMake(_spiral.center.x,_spiral.center.y)];
        MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
        [songQuery addFilterPredicate: [MPMediaPropertyPredicate
                                        predicateWithValue: view.album_name
                                        forProperty: MPMediaItemPropertyAlbumTitle]];
        
        ad.playerViewController.query=songQuery;
        ad.playerViewController.needReload=YES;
        [self presentViewController:ad.playerViewController animated:YES completion:  ^{_presenting_player=NO;}];
    }else if(self.type==3){
        MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
        [songQuery addFilterPredicate: [MPMediaPropertyPredicate
                                        predicateWithValue: view.playlist_name
                                        forProperty: MPMediaPlaylistPropertyName]];
        ad.playerViewController.query=songQuery;
        ad.playerViewController.needReload=YES;
        [self presentViewController:ad.playerViewController animated:YES completion:  ^{_presenting_player=NO;}];
    }
}


-(void)CircleDidStartTouching:(CMSpiralCircleView *)view WithTouch:(UITouch *)touch
{
    
    if(_scroll_speed){
        _scroll_speed=0.0;
        
        _touching_view=view;
        
    }
    if(_pointPanBegan.x==-1.0){
        _pointPanBegan=[touch locationInView:_spiral];
        
        
    }
}

#pragma mark - index view
-(IBAction)showIndex:(id)sender
{
    
    void (^animations)(void) = ^{
        _index_view.center=CGPointMake(self.view.frame.size.width*0.75,self.view.frame.size.height/2);
        
        // _index_view.center=CGPointMake(self.view.frame.size.width*0.5,self.view.frame.size.height/2);
        
    };
    void (^completionAnimation)(BOOL) = ^(BOOL finished) {
        
    };
    [UIView animateWithDuration:0.7 animations:animations completion:completionAnimation];
    
}

-(IBAction)hideIndex:(id)sender
{
    void (^animations)(void) = ^{
        _index_view.frame=CGRectMake(self.view.frame.size.width, 0, _index_view.frame.size.width, _index_view.frame.size.height);
    };
    void (^completionAnimation)(BOOL) = ^(BOOL finished) {
        
    };
    [UIView animateWithDuration:0.5 animations:animations completion:completionAnimation];
}

- (NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector
{
//    self.collation = [UILocalizedIndexedCollation currentCollation];
  UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger sectionCount = [[collation sectionTitles] count];
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    for(int i = 0; i < sectionCount; i++)
        [unsortedSections addObject:[NSMutableArray array]];
    
    for (id object in array)
    {
        NSInteger index = [collation sectionForObject:object collationStringSelector:selector];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    for (NSMutableArray *section in unsortedSections)
        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
    
    return sections;
}


#pragma mark - something

-(IBAction)pop:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)showPlayer:(id)sender
{
    CMAppDelegate *ad=[[UIApplication sharedApplication] delegate];
    if(!(ad.playerViewController.isViewLoaded && ad.playerViewController.view.window)){
        ad.playerViewController.query=nil;
        [self presentViewController:ad.playerViewController animated:YES completion: nil];
    }
 
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
