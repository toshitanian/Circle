//
//  CMPlayerViewController.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/6/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMPlayerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CMAlbumViewController.h"
#import <Social/Social.h>
static const NSString *PlayerStatusContext;
static const NSString *CurrentItemChangedContext;
static const NSString *PlayerRateContext;







@implementation CMMusicItem
@end


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


#pragma mark - views
-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //[self updatePlayingMusicInfo:nil];
    if(self.needReload){
        [self.player setQueueWithQuery:self.query];
        self.needReload=NO;
        // [self.player play];
        
        self.isPlaying=YES;
        //   _player.volume=0;
        _shadow.hidden=YES;
        _artwork.alpha=1.0f;
        _items = [NSMutableArray array];
        _urls=[NSMutableArray array];
        NSArray *collections=[self.query collections];
        NSMutableArray *_playerItems = [NSMutableArray array];
        self.currentIndex=0;
        for (int i = 0 ; i < [collections count];  i++){
            CMMusicItem *item=[[CMMusicItem alloc] init];
            MPMediaItem *representativeItem = [[collections objectAtIndex:i] representativeItem];
            NSURL *url = [representativeItem valueForProperty:MPMediaItemPropertyAssetURL];
            item.artist=  [representativeItem valueForProperty:MPMediaItemPropertyArtist];
            item.title=  [representativeItem valueForProperty:MPMediaItemPropertyTitle];
            item.album=  [representativeItem valueForProperty:MPMediaItemPropertyAlbumTitle];
            item.fulltime=[(NSNumber *)[representativeItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
            
            MPMediaItemArtwork *artwork= [representativeItem valueForProperty: MPMediaItemPropertyArtwork];
            item.artwork=[artwork imageWithSize: _artwork.bounds.size];
            [_items addObject:item];
            if(url!=nil){
                [_urls addObject:url];
            }
            //NSLog(@"%@",url);
            if (url != nil){
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
                [_playerItems addObject:playerItem];
                
            }
        }
        _player2 = [AVQueuePlayer queuePlayerWithItems:_playerItems];
        [_player2 play];
        [_player2 addObserver:self forKeyPath:@"status" options:0 context:&PlayerStatusContext];
        [_player2 addObserver:self forKeyPath:@"currentItem" options:0 context:&CurrentItemChangedContext];
        [_player2 addObserver:self forKeyPath:@"rate" options:0 context:&PlayerRateContext];
        
        [self updatePlayingMusicInfo:nil];
        
        
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.player = [MPMusicPlayerController iPodMusicPlayer];
    
    self.player = [MPMusicPlayerController applicationMusicPlayer];
    
    
    
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
    
    _toast_next.frame=CGRectMake(_toast_next.frame.origin.x,_toast_next.frame.origin.y,_toast_next.frame.size.width,_toast_next.frame.size.height);
    _toast_next.layer.cornerRadius = _toast_next.frame.size.width/2;
    _toast_next.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.65f];
    UIImageView *niv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next.png"]];
    niv.frame=CGRectMake(0,0,_toast_next.frame.size.width,_toast_next.frame.size.height);
    niv.layer.cornerRadius=_toast_next.layer.cornerRadius;
    niv.clipsToBounds=YES;
    niv.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    [_toast_next addSubview:niv];
    
    _toast_previous.frame=CGRectMake(0,_toast_previous.frame.origin.y,_toast_previous.frame.size.width,_toast_previous.frame.size.height);
    _toast_previous.layer.cornerRadius = _toast_previous.frame.size.width/2;
    _toast_previous.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.65f];
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
    
    
#pragma mark gesture
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panRecognizer.delegate=self;
    [self.view addGestureRecognizer:panRecognizer];
    
    UILongPressGestureRecognizer* longpressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    longpressRecognizer.delegate=self;
    [self.view addGestureRecognizer:longpressRecognizer];
    
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapRecognizer.delegate=self;
    [self.view addGestureRecognizer:tapRecognizer];

#pragma mark  control button
    [_twitter makeCircle];
    _twitter.image=[UIImage imageNamed:@"twitter.png"];
    _twitter_abs_point=absPoint(_twitter);
    [_pull makeCircle];
    _pull.image=[UIImage imageNamed:@"pull.png"];
    _pull_abs_point=absPoint(_pull);
    
    
#pragma mark  audio session
    _audioSession = [AVAudioSession sharedInstance];
    _audioSession.delegate=self;
    [_audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [_audioSession setActive:YES error:nil];
    
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}


#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSLog(@"observer start");
    
    if (context == &PlayerStatusContext) {
        AVPlayer *thePlayer = (AVPlayer *)object;
        if ([thePlayer status] == AVPlayerStatusFailed) {
            NSError *error = [thePlayer error];
            NSLog(@"Error:%@",error);
            // Respond to error: for example, display an alert sheet.
            //self.isPlaying = NO;
            return;
            
        }else if ([thePlayer status] == AVPlayerStatusReadyToPlay){
            // if status OK start play
            
            [_player2 play];
            
            
        }else{
            //NSLog(@"AVPlayerStatusNone:%@",object);
        }
        
    }else if (context == &CurrentItemChangedContext){
        
        AVPlayerItem *currentItem = [_player2 currentItem];
        AVURLAsset *asset = (AVURLAsset *)currentItem.asset;
        //  NSLog(@"currentItem%@.asset:%@",currentItem,currentItem.asset);
        
        if (currentItem != nil){
            self.currentIndex = [_urls indexOfObject:asset.URL];
            [self updatePlayingMusicInfo:nil];
        }else{
            [self finish];
        }
        
    }else if (context == &PlayerRateContext){
        
    }
    NSLog(@"observer end");
    return;
    
}




-(void)clock:(id)something
{
    
    @try {
        
        if(_isSkipping) return;
        if(self.isPlaying){
            AVPlayerItem *item=[_player2 currentItem];
            int current_time=CMTimeGetSeconds(item.currentTime);
            _song_progress.value=current_time;
            _current_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",current_time/60,current_time%60];
            
        }
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"clock error");
    }
    @finally {
        
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
 
    if(_isPlaying){
        _isPlaying=NO;
        // [_player pause];
        [_player2 pause];
        _artwork.alpha=0.5f;
        _shadow.hidden=NO;
    }else{
        _isPlaying=YES;
        //  [_player play];
        [_player2 play];
        _artwork.alpha=1.0f;
        _shadow.hidden=YES;
    }
}

- (void)stop
{
    if (self.isPlaying){
        [_player2 pause];
        self.isPlaying = NO;
    }
    _player2 = nil;
}

-(int)get_next_index
{
    if (self.currentIndex+1>[_items count]-1) {
        return -1;
    }
    return self.currentIndex+1;
}

-(void)finish
{
    [self stop];
    [self dismiss:nil];
    
}

-(void)next_pushed:(UIButton *)btn{
    
       _song_progress.value=0.0f;
    if ([self get_next_index]!=-1) {
        
        self.currentIndex=[self get_next_index];
        
        if (self.isPlaying) {
            [_player2 advanceToNextItem];
            NSLog(@"nextPlayWithPlaying:%d",self.currentIndex);
        }else{
            [_player2 advanceToNextItem];
            //[self updatePlayingMusicInfo:nil];
            NSLog(@"nextPlayNotPlaying:%d",self.currentIndex);
        }
        
        [self showToast:_toast_next];
    }else{
        [self finish];
        
        
    }
    
    
    
    
}

-(int)get_previous_index
{
    if(self.currentIndex-1<0) return 0;
    
    return self.currentIndex-1;
}


- (void)playAtIndex:(NSInteger)index
{
    
    self.currentIndex = index;
    
    
    dispatch_queue_t q_global;
    q_global = dispatch_get_global_queue(0, 0);
    dispatch_async(q_global, ^{
        
        //[self stop];
        
        
        NSMutableArray *_playerItems = [NSMutableArray array];
        int musicCount = [_items count];
        // palyerItems に　AVPlayerItemを追加
        for (int i = index ; i < musicCount ; i++){
            NSURL *url = [_urls objectAtIndex:i];
            if (url != nil){
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
                [_playerItems addObject:playerItem];
            }
        }
        
        // AVQueuePlayerのインスタンスつくる
        _player2 = [AVQueuePlayer queuePlayerWithItems:_playerItems];
        
        [_player2 addObserver:self forKeyPath:@"status" options:0 context:&PlayerStatusContext];
        [_player2 addObserver:self forKeyPath:@"currentItem" options:0 context:&CurrentItemChangedContext];
        [_player2 addObserver:self forKeyPath:@"rate" options:0 context:&PlayerRateContext];
        
        if(self.isPlaying){
            [_player2 play];
        }else{
            [_player2 pause];
        }
        
        
    });
}
-(void)previous_pushed:(UIButton *)btn{
    if(_isSkipping) return;
       _song_progress.value=0.0f;
    _isSkipping=YES;
    self.currentIndex=[self get_previous_index];
    
    [self playAtIndex:self.currentIndex];
    [self updatePlayingMusicInfo:nil];
    [self showToast:_toast_previous];
    
    [self updatePlayingMusicInfo:nil];
    
    
    _isSkipping=NO;
    
}



#pragma mark - Remote-control event handling
// Respond to remote control events
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self play_pushed:nil];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self previous_pushed:nil];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self next_pushed:nil];
                break;
                
            default:
                break;
        }
    }
}

- (void)inputIsAvailableChanged:(BOOL)isInputAvailable
{
    NSLog(@"%d",isInputAvailable);
    if (isInputAvailable) {
        if(_player.volume>0.5) _player.volume=0.5;
    }
}
#pragma mark - player
-(void)updatePlayingMusicInfo:(id *)something
{
    
    _queue_label.text=[[NSString alloc] initWithFormat:@"%d/%d",self.currentIndex+1,[_items count]];
    //!!TODO index
    _current_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",0,0];
    
    CMMusicItem *item=[_items objectAtIndex:self.currentIndex];
    _full_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",(int)item.fulltime/60,(int)item.fulltime%60];
    _song_progress.maximumValue=item.fulltime;
    _info_artist.text=  item.artist;
    _info_title.text=  item.title;
    _info_album.text=  item.album;
    
    if(item.artwork!=nil){
        _artwork.image=item.artwork;
    }else{
        _artwork.image=[UIImage imageNamed:@"no_artwork.png"];
    }
    
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        CMMusicItem *item = [_items objectAtIndex:self.currentIndex];
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        [songInfo setObject:item.title  forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:item.artist forKey:MPMediaItemPropertyArtist];
        [songInfo setObject:item.album  forKey:MPMediaItemPropertyAlbumTitle];
        
        // UIImage *img=[self roundCornersOfImage:[UIImage imageWithCGImage:item.artwork.CGImage]];
        
        
        
        if (item.artwork){
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:item.artwork];
            
            [songInfo setObject:artwork forKey:MPMediaItemPropertyArtwork];
        }else{
            [songInfo setObject:[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"no_artwork_with_circle.png"]] forKey:MPMediaItemPropertyArtwork];
        }
        
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        //NSLog(@"songInfo:%@",songInfo);
        
    }
    
    
}

-(void)handle_PlaybackStateChanged:(id)something
{
}

-(void)seek:(UISlider*)slider{
    // _player.currentPlaybackTime=_song_progress.value;
    // _current_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",(int)_player.currentPlaybackTime/60,(int)_player.currentPlaybackTime%60];
    
    //TODO: index
    AVPlayerItem *item=[_player2 currentItem];
    [item seekToTime:CMTimeMake(slider.value, 1)];
    
    if(!self.isPlaying){
        int current_time=CMTimeGetSeconds(item.currentTime);
        _song_progress.value=current_time;
        _current_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",current_time/60,current_time%60];
    }
    
    
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
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]]){
        CGPoint point=[touch locationInView:self.view];
        if(CGRectContainsPoint(_artwork.frame, point)){
            _onArtwork=YES;
        }else if(CGRectContainsPoint(CGRectMake(_twitter_abs_point.x, _twitter_abs_point.y, _twitter.frame.size.width, _twitter.frame.size.height), point)){
            NSLog(@"Twitter Touched");
            void (^animations)(void) = ^{
                
                float scale_value=1.2;
                
                CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
                [_twitter setTransform:scale];
                
            };
      
            [UIView animateWithDuration:0.1 animations:animations completion:nil];
            _onTwitter=YES;
            
        }else if(CGRectContainsPoint(CGRectMake(_pull_abs_point.x, _pull_abs_point.y, _pull.frame.size.width, _pull.frame.size.height), point)){
            NSLog(@"Pull TOcuhed");
            
            void (^animations)(void) = ^{
                
                float scale_value=1.2;
                
                CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
                [_pull setTransform:scale];
                _onPull=YES;
                
            };
            
            [UIView animateWithDuration:0.1 animations:animations completion:nil];
        }
    }
    
    return YES;
}

CGPoint absPoint(UIView* view)
{
    CGPoint ret = CGPointMake(view.frame.origin.x, view.frame.origin.y);
    if ([view superview] != nil){
        CGPoint addPoint = absPoint([view superview]);ret = CGPointMake(ret.x + addPoint.x, ret.y + addPoint.y);
    }
    return ret;
}

//http://labs.techfirm.co.jp/ipad/cho/466
- (void)handlePanGesture:(UIGestureRecognizer *)sender {
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
    CGPoint point = [pan translationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    //  NSLog(@"pan. translation: %@, velocity: %@", NSStringFromCGPoint(point), NSStringFromCGPoint(velocity));
    float angle=atan(point.y/point.x)/2/M_PI*360;
    //NSLog(@"%lf",atan(point.y/point.x)/2/M_PI*360);
    if (sender.state == UIGestureRecognizerStateEnded){
        if(_onArtwork){
            if(abs(angle)<40){
                
                if(velocity.x>200) [self previous_pushed:nil];
                if(velocity.x<-200) [self next_pushed:nil];
            }
        }
    }
    
    if(abs(angle)>50){
        if(_onArtwork){
            //!!TODO positionで決めたほうがいいかも
            //NSLog(@"%lf",velocity.y/100000.0);
            float v_up=MAX(-0.2, velocity.y/100000.0);
            _player.volume-=v_up;
            //_player.volume-=v_up;
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded || sender.state==UIGestureRecognizerStateCancelled ||sender.state==UIGestureRecognizerStateFailed){
        if(_onTwitter){
            float scale_value=1.0;
            CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
            [_twitter setTransform:scale];
        }
        if(_onPull){
            float scale_value=1.0;
            CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
            [_pull setTransform:scale];
        }
        _onTwitter=NO;
        _onPull=NO;
        _onArtwork=NO;
    }
}

- (void)handleTapGesture:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
        CGPoint point=[tap locationInView:self.view];

        
        
        if(_onTwitter){
            float scale_value=1.0;
            CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
            [_twitter setTransform:scale];
        }
        if(_onPull){
            float scale_value=1.0;
            CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
            [_pull setTransform:scale];
        }
        _onTwitter=NO;
        _onPull=NO;
        _onArtwork=NO;
        
        if(CGRectContainsPoint(_artwork.frame, point)){
            [self play_pushed:nil];
        }
        point=[tap locationInView:_controller];
        if(CGRectContainsPoint(_twitter.frame, point)){
            NSLog(@"Twitter");
              CMMusicItem *item=[_items objectAtIndex:self.currentIndex];
                  [self tweetWithTitle:item.title AndArtist:item.artist];
        }else if(CGRectContainsPoint(_pull.frame, point)){
            [self dismiss:nil];
        }


    }else if(sender.state==UIGestureRecognizerStateCancelled ||sender.state==UIGestureRecognizerStateFailed){
        if(_onTwitter){
            float scale_value=1.0;
            CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
            [_twitter setTransform:scale];
        }
        if(_onPull){
            float scale_value=1.0;
            CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
            [_pull setTransform:scale];
        }
        _onTwitter=NO;
        _onPull=NO;
        _onArtwork=NO;
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

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
    
}
void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
	float fw, fh;
	if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
	}
	CGContextSaveGState(context);
	CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGContextScaleCTM (context, ovalWidth, ovalHeight);
	fw = CGRectGetWidth (rect) / ovalWidth;
	fh = CGRectGetHeight (rect) / ovalHeight;
	CGContextMoveToPoint(context, fw, fh/2);
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}
- (UIImage *)roundCornersOfImage:(UIImage *)source
{
	int w = source.size.width;
	int h = source.size.height;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
	
	CGContextBeginPath(context);
	CGRect rect = CGRectMake(0, 0, w, h);
	addRoundedRectToPath(context, rect, 5, 5);
	CGContextClosePath(context);
	CGContextClip(context);
	
	CGContextDrawImage(context, CGRectMake(0, 0, w, h), source.CGImage);
	
	CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	return [UIImage imageWithCGImage:imageMasked];
}
#pragma mark - twitter
- (void)tweetWithTitle:(NSString*)title AndArtist:(NSString*)artist
{
    SLComposeViewController *tweetViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [tweetViewController setInitialText:[NSString stringWithFormat:@"#nowplaying %@ by %@ with CirclePlayer",title,artist]];
    [self presentViewController:tweetViewController animated:YES completion:nil];
    
    /*
     [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
     switch (result) {
     case TWTweetComposeViewControllerResultCancelled:
     // The cancel button was tapped.
     //NSlog(@"Tweet cancelled.");
     
     break;
     case TWTweetComposeViewControllerResultDone:
     // The tweet was sent.
     //NSlog(@"Tweet done.");
     break;
     default:
     break;
     }
     
     // Dismiss the tweet composition view controller.
     [self dismissViewControllerAnimated:YES completion:nil];
     
     }];
     [self presentViewController:tweetViewController animated:YES completion:nil];
     tweetViewController = nil;
     */
}


#pragma  mark - something

-(IBAction)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
}
@end
