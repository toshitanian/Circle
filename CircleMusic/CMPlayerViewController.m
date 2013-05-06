//
//  CMPlayerViewController.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/6/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMPlayerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CMPlayerViewController ()

@end

@implementation CMPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //[self updatePlayingMusicInfo:nil];
    if(self.needReload){
        [self.player setQueueWithQuery:self.query];
        self.needReload=NO;
        [self.player play];
        _out_of_queue=NO;
        self.isPlaying=YES;
        _player.volume=0;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.player = [MPMusicPlayerController iPodMusicPlayer];
    
    self.player = [MPMusicPlayerController applicationMusicPlayer];
    
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(updatePlayingMusicInfo:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object:self.player];
    [self.player beginGeneratingPlaybackNotifications];
    
    
    _btn_play = [self getControllButton];
    _btn_play.center=CGPointMake(_controller.center.x,_controller.frame.size.height/2);
    [_btn_play addTarget:self
                  action:@selector(play_pushed:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn_next = [self getControllButton];
    _btn_next.center=CGPointMake(_controller.center.x+_btn_next.frame.size.width*3/2,_controller.frame.size.height/2);
    //何故かうまくいかない
    [_btn_next setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    //[_btn_next setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateHighlighted];
    
    [_btn_next addTarget:self
                  action:@selector(next_pushed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btn_previous = [self getControllButton];
    _btn_previous.center=CGPointMake(_controller.center.x-_btn_previous.frame.size.width*3/2,_controller.frame.size.height/2);
    //何故かうまくいかない
    [_btn_previous setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
    [_btn_previous setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateHighlighted];
    [_btn_previous addTarget:self
                      action:@selector(previous_pushed:) forControlEvents:UIControlEventTouchUpInside];
    
    ///ボタンaddsubview
    //[_controller addSubview:_btn_play];
    //[_controller addSubview:_btn_next];
    //[_controller addSubview:_btn_previous];
    ///ここまで
    
    [_slider addTarget:self action:@selector(slide:) forControlEvents:UIControlEventValueChanged];
    
    
    
    _artwork.layer.cornerRadius = _artwork.frame.size.width/2;
    _artwork.layer.borderWidth = 5.0f;
    _artwork.layer.borderColor = [UIColor grayColor].CGColor;
    _artwork.backgroundColor = [UIColor underPageBackgroundColor];
    _artwork.backgroundColor = [UIColor whiteColor];
    _artwork.clipsToBounds=YES;
    
    _shadow.frame=_artwork.frame;
    _shadow.layer.cornerRadius = _shadow.frame.size.width/2;
    _shadow.layer.borderWidth = 0.0f;
    _artwork.clipsToBounds=YES;
    _shadow.hidden=YES;
    UIImageView *playiv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play.png"]];
    playiv.frame=CGRectMake(0,0,_shadow.frame.size.width,_shadow.frame.size.height);
    playiv.layer.cornerRadius=_shadow.layer.cornerRadius;
    playiv.clipsToBounds=YES;
    playiv.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    [_shadow addSubview:playiv];
    
    _toast_next.frame=CGRectMake(self.view.frame.size.width-_toast_previous.frame.size.width,_artwork.frame.origin.y-_toast_next.frame.size.height,_toast_next.frame.size.width,_toast_next.frame.size.height);
    _toast_next.layer.cornerRadius = _toast_next.frame.size.width/2;
    _toast_next.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
    UIImageView *niv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next.png"]];
    niv.frame=CGRectMake(0,0,_toast_next.frame.size.width,_toast_next.frame.size.height);
    niv.layer.cornerRadius=_toast_next.layer.cornerRadius;
    niv.clipsToBounds=YES;
    niv.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    [_toast_next addSubview:niv];
    
    _toast_previous.frame=CGRectMake(0,_artwork.frame.origin.y-_toast_previous.frame.size.height,_toast_previous.frame.size.width,_toast_previous.frame.size.height);
    _toast_previous.layer.cornerRadius = _toast_previous.frame.size.width/2;
    _toast_previous.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
    UIImageView *piv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"previous.png"]];
    piv.frame=CGRectMake(0,0,_toast_previous.frame.size.width,_toast_previous.frame.size.height);
    piv.layer.cornerRadius=_toast_previous.layer.cornerRadius;
    piv.clipsToBounds=YES;
    piv.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    [_toast_previous addSubview:piv];
    
    
    _tm =
    [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(clock:) userInfo:nil repeats:YES];
    [_tm fire];
    [_song_progress addTarget:self action:@selector(seek:) forControlEvents:UIControlEventValueChanged];
    
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panRecognizer];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapRecognizer];
    /*
     UISwipeGestureRecognizer* swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
     [self.view addGestureRecognizer:swipeRecognizer];
     */
    
}

-(void)clock:(id)something
{
    if(_player.playbackState!=MPMusicPlaybackStateSeekingForward
       && _player.playbackState!=MPMusicPlaybackStateSeekingBackward
       && _player.playbackState!=MPMusicPlaybackStatePaused
       && _player.playbackState!=MPMusicPlaybackStateStopped)
    {
        // NSLog(@"%f",_player.currentPlaybackTime);
        _song_progress.value=_player.currentPlaybackTime;
        _current_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",(int)_player.currentPlaybackTime/60,(int)_player.currentPlaybackTime%60];
        
    }
    
}

-(UIButton *) getControllButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 76, 76);
    //btn.backgroundColor=[UIColor whiteColor];
    btn.layer.cornerRadius = btn.frame.size.width/2;
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    return btn;
    
}

#pragma mark - controller
-(void)play_pushed:(UIButton *)btn{
    _out_of_queue=NO;
    if(_isPlaying){
        _isPlaying=NO;
        [_player pause];
        _artwork.alpha=0.5f;
        _shadow.hidden=NO;
    }else{
        _isPlaying=YES;
        [_player play];
        _artwork.alpha=1.0f;
        _shadow.hidden=YES;
    }
}

-(void)next_pushed:(UIButton *)btn{
    if(_out_of_queue){
        
        [_player play];
        [self showToast:_toast_next];
        _out_of_queue=NO;
        return;
    }
    
    if(self.player.indexOfNowPlayingItem+1<[[self.query items] count]){
        [_player skipToNextItem];
        [self showToast:_toast_next];
        _out_of_queue=NO;
    }
}

-(void)previous_pushed:(UIButton *)btn{
    if(self.player.indexOfNowPlayingItem>0  && self.player.indexOfNowPlayingItem<10000 ){
        [_player skipToPreviousItem];
        [self showToast:_toast_previous];
    }else{
        [_player stop];
        _out_of_queue=YES;
    }
    
    
}

-(void)slide:(UISlider*)slider{
    _player.volume=slider.value;
}
#pragma mark - player
-(void)updatePlayingMusicInfo:(id *)something
{
    int index= !_out_of_queue ? self.player.indexOfNowPlayingItem+1:0;
    if(!_out_of_queue){
        index=self.player.indexOfNowPlayingItem+1>[[self.query items] count] ? [[self.query items] count]:self.player.indexOfNowPlayingItem+1;
    }
    _queue_label.text=[[NSString alloc] initWithFormat:@"%d/%d",index,[[self.query items] count]];
    //!!TODO index
    _current_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",0,0];
    float full_time=[(NSNumber *)[[_player nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
    _full_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",(int)full_time/60,(int)full_time%60];
    _song_progress.maximumValue=full_time;
    _info_artist.text=  [[_player nowPlayingItem] valueForProperty:MPMediaItemPropertyArtist];
    _info_title.text=  [[_player nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle];
    _info_album.text=  [[_player nowPlayingItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
    MPMediaItemArtwork *artwork= [[_player nowPlayingItem]valueForProperty:  MPMediaItemPropertyArtwork];
    
    UIImage *artworkImage =[artwork imageWithSize: _artwork.bounds.size];
    if(artworkImage!=nil){
        _artwork.image=artworkImage;
    }else{
        _artwork.image=[UIImage imageNamed:@"no_artwork.png"];
    }
}

-(void)MPMusicPlayerControllerVolumeDidChangeNotification:(id *)something
{
    // _slider.value=_player.volume;
}

-(void)seek:(UISlider*)slider{
    _player.currentPlaybackTime=_song_progress.value;
    _current_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",(int)_player.currentPlaybackTime/60,(int)_player.currentPlaybackTime%60];
    
}

#pragma  mark - toast
- (void) showToast:(UIView*)view {
    // アニメーションでラベルを表示させる
    void (^animations)(void) = ^{
        view.alpha = 1.0;
    };
    void (^completionAnimation)(BOOL) = ^(BOOL finished) {
        // 2秒後に表示させたラベルをアニメーションさせながら消す
        [self performSelector:@selector(hideToast:) withObject:view afterDelay:0.5];
    };
    [UIView animateWithDuration:0.0 animations:animations completion:completionAnimation];
}

-(void)hideToast:(UIView *)view
{
    void (^animations)(void) = ^{
        view.alpha = 0.0;
    };
    
    [UIView animateWithDuration:1.5 animations:animations completion:nil];
    
}

#pragma mark - gesture
//http://labs.techfirm.co.jp/ipad/cho/466
- (void)handlePanGesture:(UIGestureRecognizer *)sender {
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
    CGPoint point = [pan translationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    //  NSLog(@"pan. translation: %@, velocity: %@", NSStringFromCGPoint(point), NSStringFromCGPoint(velocity));
    float angle=atan(point.y/point.x)/2/M_PI*360;
    //NSLog(@"%lf",atan(point.y/point.x)/2/M_PI*360);
    if (sender.state == UIGestureRecognizerStateEnded){
        if(abs(angle)<40){
            if(velocity.x>200) [self previous_pushed:nil];
            if(velocity.x<-200) [self next_pushed:nil];
        }
    }
    
    if(abs(angle)>50){
        //!!TODO positionで決めたほうがいいかも
        NSLog(@"%lf",velocity.y/100000.0);
        float v_up=MAX(-0.2, velocity.y/100000.0);
        _player.volume-=v_up;
    }
}

- (void)handleTapGesture:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
        CGPoint point=[tap locationInView:_artwork];
        // NSLog(@"Tap:%lf/%lf",[tap locationInView:_artwork].x,[tap locationInView:_artwork].y);
        NSLog(@"%lf|%lf",sqrt(pow(point.x -_artwork.frame.size.width/2,2)+pow(point.y-_artwork.frame.size.height/2,2)),_artwork.frame.size.width/2);
        if(sqrt(pow(point.x -_artwork.frame.size.width/2,2)+pow(point.y-_artwork.frame.size.height/2,2))
           <_artwork.frame.size.width/2){
            [self play_pushed:nil];
        }
    }
}
/*
 - (void)handleSwipeGesture:(UIGestureRecognizer *)sender {
 if (sender.state == UIGestureRecognizerStateEnded)
 {
 UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer*)sender;
 NSLog(@"%u",swipe.direction);
 }
 }
 
 */
#pragma  mark - something

-(IBAction)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
