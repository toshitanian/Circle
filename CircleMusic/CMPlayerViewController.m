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
#import "CMAppDelegate.h"
#import "CMCrashReporter.h"

#define ALPHA 0.5f

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
    CMAppDelegate *ad=[[UIApplication sharedApplication] delegate];
    if(ad.iOStype==2){
        nibNameOrNil=@"CMPlayerViewController_for_35inch";
    }
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
    _should_resume=NO;
    if(self.needReload){
        
        _urls=nil;
        _shuffle_hash=nil;
        _shuffled_urls=nil;
        _player2=nil;
        
        [_player2 removeObserver:self forKeyPath:@"status"];
        [_player2 removeObserver:self forKeyPath:@"currentItem"];
        [_player2 removeObserver:self forKeyPath:@"rate"];
        
        
        _song_progress.value=0;
        self.needReload=NO;
        // [self.player play];
        
        self.isPlaying=YES;
        self.isAvailable=YES;
        _repeat_type=0;
        _repeat.image=_repeat_normal;
        _repeat.alpha=ALPHA;
        
        _shuffle.alpha=ALPHA;
        //   _player.volume=0;
        _shadow.hidden=YES;
        _artwork.alpha=1.0f;
        _urls=[NSMutableArray array];
        _shuffle_hash=[NSMutableArray array];
        
        _isShuffling=NO;
        collections=nil;
        collections=[self.query collections];
        self.currentIndex=0;
        _item_count=[collections count];
        for (int i = 0 ; i <[collections count];  i++){
            
            
            MPMediaItem *representativeItem = [collections[i] representativeItem];
            NSURL *url = [representativeItem valueForProperty:MPMediaItemPropertyAssetURL];
            if(url!=nil){
                [_urls addObject:url];
                //AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
                // [_playerItems addObject:playerItem];
            }
            url=nil;
            representativeItem=nil;
            //NSLog(@"ss");
        }
        //_player2 = [AVQueuePlayer queuePlayerWithItems:_playerItems];
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"player_intro"]){
            _intro=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,MAX(self.view.frame.size.width*1093/640,self.view.frame.size.height))];
            _intro.image=[UIImage imageNamed:@"intro_tap"];
            [self.view addSubview:_intro];
            _intro_type=1;
            
            UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureForIntro:)];
            _intro.userInteractionEnabled=YES;
            [_intro addGestureRecognizer:tapRecognizer];
            
        }else{
            
            if(self.index_for_play==-1){
                [self playAtIndex:0];
                
            }else{
                //[self playAtIndex:self.index_for_play];
            }
        }
        
        
        
        
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.player = [MPMusicPlayerController iPodMusicPlayer];
    
    self.player = [MPMusicPlayerController applicationMusicPlayer];
    
    _no_artwork=[UIImage imageNamed:@"no_artwork.png"];
    _repeat_normal=[UIImage imageNamed:@"repeat.png"];
    _repeat_once=[UIImage imageNamed:@"repeat_once.png"];
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
    
    _toast_next.frame=CGRectMake(_toast_next.frame.origin.x,_toast_next.frame.origin.y,_toast_next.frame.size.width,_toast_next.frame.size.width);
    _toast_next.layer.cornerRadius = _toast_next.frame.size.width/2;
    _toast_next.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.65f];
    UIImageView *niv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next.png"]];
    niv.frame=CGRectMake(0,0,_toast_next.frame.size.width,_toast_next.frame.size.width);
    niv.layer.cornerRadius=_toast_next.layer.cornerRadius;
    niv.clipsToBounds=YES;
    niv.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    [_toast_next addSubview:niv];
    
    _toast_previous.frame=CGRectMake(0,_toast_previous.frame.origin.y,_toast_previous.frame.size.width,_toast_previous.frame.size.width);
    _toast_previous.layer.cornerRadius = _toast_previous.frame.size.width/2;
    _toast_previous.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.65f];
    UIImageView *piv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"previous.png"]];
    piv.frame=CGRectMake(0,0,_toast_previous.frame.size.width,_toast_previous.frame.size.width);
    piv.layer.cornerRadius=_toast_previous.layer.cornerRadius;
    piv.clipsToBounds=YES;
    piv.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    [_toast_previous addSubview:piv];
    
    
    _tm =
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(clock:) userInfo:nil repeats:YES];
    
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
    _pull.image=[UIImage imageNamed:@"back.png"];
    _pull_abs_point=absPoint(_pull);
    
    [_repeat makeCircle];
    _repeat.image=_repeat_normal;
    _repeat_abs_point=absPoint(_repeat);
    _repeat.alpha=ALPHA;
    
    [_shuffle makeCircle];
    _shuffle.image=[UIImage imageNamed:@"shuffle.png"];
    _shuffle_abs_point=absPoint(_shuffle);
    _shuffle.alpha=ALPHA;
    
    
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
    
    
    if (context == &PlayerStatusContext) {
        
        AVPlayer *thePlayer = (AVPlayer *)object;
        if ([thePlayer status] == AVPlayerStatusFailed) {
            NSLog(@"1122");
            NSError *error = [thePlayer error];
            NSLog(@"Error:%@",error);
            // Respond to error: for example, display an alert sheet.
            //self.isPlaying = NO;
            return;
            
        }else if ([thePlayer status] == AVPlayerStatusReadyToPlay){
            // if status OK start play
            NSLog(@"1122");
            [_player2 play];
            _cant_playatindex=NO;
            [self updatePlayingMusicInfo:nil];
            
        }else{
            NSLog(@"1133");
            //NSLog(@"AVPlayerStatusNone:%@",object);
        }
        
    }else if (context == &CurrentItemChangedContext){
        NSLog(@"2222");
        AVPlayerItem *currentItem = [_player2 currentItem];
        AVURLAsset *asset = (AVURLAsset *)currentItem.asset;
        //  NSLog(@"currentItem%@.asset:%@",currentItem,currentItem.asset);
        
        if (currentItem != nil){
            if(!_isShuffling){
                self.currentIndex = [_urls indexOfObject:asset.URL];
                
            }else{
                self.currentIndex = [_shuffled_urls indexOfObject:asset.URL];
            }
            [self updatePlayingMusicInfo:nil];
        }else{
            
            [self finishOrRepeat];
        }
        
    }else if (context == &PlayerRateContext){
        [self updatePlayingMusicInfo:nil];
    }
    
    return;
    
}




-(void)clock:(id)something
{
    
    @try {
        
        
        if(self.isPlaying){
            AVPlayerItem *item=[_player2 currentItem];
            int current_time=CMTimeGetSeconds(item.currentTime);
            _song_progress.value=current_time;
            _current_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",current_time/60,current_time%60];
        }/*else{
          NSLog(@"clock not playing");
          }*/
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"clock error");
    }
    @finally {
        
    }
    
}

-(void)refuse_clock:(id)something
{
    if(_refuse_count>8){
        [_refuse invalidate];
        _is_refuse=NO;
    }else{
        _refuse_count++;
    }
}

-(void)start_refuse{
    _is_refuse=YES;
    _refuse_count=0;
    _refuse =
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(refuse_clock:) userInfo:nil repeats:YES];
    [_refuse fire];
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
    NSLog(@"%s",__func__);
    
    if (self.isPlaying){
        [_player2 pause];
        self.isPlaying = NO;
    }
    _player2 = nil;
}

-(int)get_next_index
{
    if (self.currentIndex+1>_item_count-1) {
        return -1;
    }
    return self.currentIndex+1;
}

-(void)finishOrRepeat
{
    NSLog(@"%s",__func__);
    if(_repeat_type==2){
        self.currentIndex=0;
        [self playAtIndex:0];
        //s   [self updatePlayingMusicInfo:nil];
    }else if(_repeat_type==1){
        self.currentIndex=0;
        [self playAtIndex:0];
        _repeat_type=0;
        _repeat.image=[UIImage imageNamed:@"repeat.png"];
        _repeat.alpha=ALPHA;
        // [self updatePlayingMusicInfo:nil];
    }else{
        
        [self stop];
        self.isAvailable=NO;
        [self dismiss:nil];
    }
    
}


-(void)finish
{
    NSLog(@"%s",__func__);
    [self stop];
    _player2=nil;
    self.isAvailable=NO;
    [self dismiss:nil];
    
}

-(int)get_previous_index
{
    if(self.currentIndex-1<0) return -1;
    
    return self.currentIndex-1;
}


- (void)playAtIndex:(NSInteger)index
{
    _cant_playatindex=YES;
    self.currentIndex = index;
    __weak CMPlayerViewController* wself = self;
    dispatch_queue_t q_global;
    q_global = dispatch_get_global_queue(0, 0);
    //dispatch_async(q_global, ^{
    
   [_player2 pause];
    
    
    NSMutableArray* _playerItems = [NSMutableArray array];
    // palyerItems に　AVPlayerItemを追加
    for (int i = index ; i < MIN(_item_count,wself.currentIndex+30) ; i++){
        NSURL *url;
        @try {
            if(!_isShuffling){
                url= _urls[i];
            }else{
                url=_shuffled_urls[i];
            }
            if (url != nil){
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
                [_playerItems addObject:playerItem];
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
        
    }
    
    // AVQueuePlayerのインスタンスつくる
    _player2=nil;
    _player2 = [AVQueuePlayer queuePlayerWithItems:_playerItems];
    
    
    [_player2 addObserver:wself forKeyPath:@"status" options:0 context:&PlayerStatusContext];
    [_player2 addObserver:wself forKeyPath:@"currentItem" options:0 context:&CurrentItemChangedContext];
    [_player2 addObserver:wself forKeyPath:@"rate" options:0 context:&PlayerRateContext];
    
    if(self.isPlaying){
        
        [_player2 play];
    }else{
        [_player2 pause];
    }
    
    //  [self updatePlayingMusicInfo:nil];
    
    
    
    //});
}
-(void)next_pushed:(UIButton *)btn{
    
    if(_is_refuse) return;
    [self start_refuse];
    
    if(_cant_playatindex) return;
    _song_progress.value=0.0f;
    if ([self get_next_index]!=-1) {
        self.currentIndex=[self get_next_index];
        if (self.isPlaying) {
            if(!_needShuffleReload){
                
                [_player2 advanceToNextItem];
            }else{
                _needShuffleReload=NO;
                [self playAtIndex:self.currentIndex];
                //  [self updatePlayingMusicInfo:nil];
            }
            NSLog(@"nextPlayWithPlaying:%d",self.currentIndex);
        }else{
            
            if(!_needShuffleReload){
                
                [_player2 advanceToNextItem];
            }else{
                _needShuffleReload=NO;
                [self playAtIndex:self.currentIndex];
                //   [self updatePlayingMusicInfo:nil];
            }
            NSLog(@"nextPlayNotPlaying:%d",self.currentIndex);
        }
        
        [self showToast:_toast_next];
    }else{
        
        [self finishOrRepeat];
        
        
        
    }
    
    
    
    
}



-(void)previous_pushed:(UIButton *)btn{
    if(_is_refuse) return;
    [self start_refuse];
    
    if(_cant_playatindex) return;
    
    AVPlayerItem *item=[_player2 currentItem];
    int current_time=CMTimeGetSeconds(item.currentTime);
    
    if(current_time>10){
        [self backToStart];
    }else{
        _song_progress.value=0.0f;
        
        if([self get_previous_index]==-1){
            self.currentIndex=0;
            [self finish];
        }else{
            self.currentIndex=[self get_previous_index];
            [self playAtIndex:self.currentIndex];
            [self showToast:_toast_previous];
        }
        
        
        
    }
    // [self updatePlayingMusicInfo:nil];
    
    
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

#pragma mark Interruption event handling
- (void)beginInterruption
{
    if(_isPlaying){
        _isPlaying=NO;
        // [_player pause];
        [_player2 pause];
        _artwork.alpha=0.5f;
        _shadow.hidden=NO;
        _should_resume=YES;
    }
}

- (void)endInterruptionWithFlags:(NSUInteger)flags
{
    //NSLog(@"endInterruptionWithFlags:%d %d %d",self.playingMusic,_shouldResume,flags);
    if (flags == AVAudioSessionInterruptionFlags_ShouldResume){
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        if(_should_resume){
            _isPlaying=YES;
            //  [_player play];
            [_player2 play];
            _artwork.alpha=1.0f;
            _shadow.hidden=YES;
            _should_resume=NO;
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
//ID3取得
//http://log.shipweb.jp/?mode=datview&board_name=mac&thread_key=1335398820&thread_id=494251
//artwork取得
//http://stackoverflow.com/questions/6607401/get-album-artwork-from-id3-tag-convert-function-from-java-to-objective-c
-(void)updatePlayingMusicInfo:(id *)something
{
    
    
    float fulltime;
    MPMediaItem *representativeItem;
    if(!_isShuffling){
        representativeItem = [collections[self.currentIndex] representativeItem];
    }else{
        NSNumber *num = _shuffle_hash[self.currentIndex];
        representativeItem = [collections[[num intValue]] representativeItem];
    }
    current_artist=  [representativeItem valueForProperty:MPMediaItemPropertyArtist];
    current_title=  [representativeItem valueForProperty:MPMediaItemPropertyTitle];
    current_album=  [representativeItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    fulltime=[(NSNumber *)[representativeItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
    MPMediaItemArtwork *artwork= [representativeItem valueForProperty: MPMediaItemPropertyArtwork];
    
    current_artwork_img=nil;
    current_artwork_img=[artwork imageWithSize: _artwork.bounds.size];
    if(current_artwork_img==nil){
        current_artwork_img=_no_artwork;
    }
    
    
    _queue_label.text=[[NSString alloc] initWithFormat:@"%d/%d",self.currentIndex+1,_item_count];
    [_queue_label setNeedsDisplay];
    //!!TODO index
    _current_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",0,0];
    [_current_time setNeedsDisplay];
    
    _full_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",(int)fulltime/60,(int)fulltime%60];
    [_full_time setNeedsDisplay];
    _song_progress.maximumValue=fulltime;
    _info_artist.text=  current_artist;
    [_info_artist setNeedsDisplay];
    _info_title.text=  current_title;
    [_info_title setNeedsDisplay];
    _info_album.text=  current_album;
    [_info_album setNeedsDisplay];
    _artwork.image=nil;
    _artwork.image=current_artwork_img;
    [_artwork setNeedsDisplay];
    
    
    
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        songInfo[MPMediaItemPropertyTitle] = current_title;
        songInfo[MPMediaItemPropertyArtist] = current_artist;
        songInfo[MPMediaItemPropertyAlbumTitle] = current_album;
        
        // UIImage *img=[self roundCornersOfImage:[UIImage imageWithCGImage:item.artwork.CGImage]];
        
        
        
        if (current_artwork_img){
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:current_artwork_img];
            
            songInfo[MPMediaItemPropertyArtwork] = artwork;
        }else{
            songInfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"no_artwork_with_circle.png"]];
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
    
    
    AVPlayerItem *item=[_player2 currentItem];
    [item seekToTime:CMTimeMake(slider.value, 1)];
    
    if(!self.isPlaying){
        int current_time=CMTimeGetSeconds(item.currentTime);
        _song_progress.value=current_time;
        _current_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",current_time/60,current_time%60];
    }
}

-(void)backToStart{
    // _player.currentPlaybackTime=_song_progress.value;
    // _current_time.text=[[NSString alloc] initWithFormat:@"%2d:%02d",(int)_player.currentPlaybackTime/60,(int)_player.currentPlaybackTime%60];
    
    
    AVPlayerItem *item=[_player2 currentItem];
    [item seekToTime:CMTimeMake(0, 1)];
    _song_progress.value=0.0f;
    
    if(!self.isPlaying){
        int current_time=CMTimeGetSeconds(item.currentTime);
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
            NSLog(@"Pull Tocuhed");
            
            void (^animations)(void) = ^{
                
                float scale_value=1.2;
                
                CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
                [_pull setTransform:scale];
                _onPull=YES;
                
            };
            
            [UIView animateWithDuration:0.1 animations:animations completion:nil];
        }else if(CGRectContainsPoint(CGRectMake(_repeat_abs_point.x, _repeat_abs_point.y, _repeat.frame.size.width, _repeat.frame.size.height), point)){
            NSLog(@"Repeat Tocuhed");
            
            void (^animations)(void) = ^{
                
                float scale_value=1.2;
                
                CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
                [_repeat setTransform:scale];
                _onRepeat=YES;
                
            };
            
            [UIView animateWithDuration:0.1 animations:animations completion:nil];
        }else if(CGRectContainsPoint(CGRectMake(_shuffle_abs_point.x, _shuffle_abs_point.y, _shuffle.frame.size.width, _shuffle.frame.size.height), point)){
            NSLog(@"Shuffle Tocuhed");
            
            void (^animations)(void) = ^{
                
                float scale_value=1.2;
                
                CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
                [_shuffle setTransform:scale];
                _onShuffle=YES;
                
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
    
    
    if(_intro_type!=0){
        [self intro];
        return;
        
    }
    
    
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
        if(_onRepeat){
            float scale_value=1.0;
            CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
            [_repeat setTransform:scale];
        }
        if(_onShuffle){
            float scale_value=1.0;
            CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
            [_shuffle setTransform:scale];
        }
        _onTwitter=NO;
        _onPull=NO;
        _onArtwork=NO;
        _onRepeat=NO;
        _onShuffle=NO;
    }
}

-(void)intro{
    
    
    if(_intro_type==1){
        _intro.image=[UIImage imageNamed:@"intro_swipe"];
        _intro_type=2;
    }else{
        [_intro removeFromSuperview];
        
        if(self.index_for_play==-1){
            [self playAtIndex:0];
        }else{
            [self playAtIndex:self.index_for_play];
        }
        
        _intro_type=0;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"player_intro"];
    
}

- (void)handleTapGestureForIntro:(UIGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self intro];
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
        if(_onRepeat){
            float scale_value=1.0;
            CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
            [_repeat setTransform:scale];
        }
        if(_onShuffle){
            float scale_value=1.0;
            CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
            [_shuffle setTransform:scale];
        }
        _onTwitter=NO;
        _onPull=NO;
        _onArtwork=NO;
        _onRepeat=NO;
        _onShuffle=NO;
        
        if(CGRectContainsPoint(_artwork.frame, point)){
            [self play_pushed:nil];
        }
        point=[tap locationInView:_controller];
        if(CGRectContainsPoint(_twitter.frame, point)){
            NSLog(@"Twitter");
            [self tweetWithTitle:_info_title.text AndArtist:_info_artist.text];
        }else if(CGRectContainsPoint(_pull.frame, point)){
            [self dismiss:nil];
        }else if(CGRectContainsPoint(_repeat.frame, point)){
            
            if(_repeat_type==0){
                _repeat_type=1;
                _repeat.image= _repeat_once;
                _repeat.alpha=1.0f;
            }else if(_repeat_type==1){
                _repeat_type=2;
                _repeat.image= _repeat_normal;
                _repeat.alpha=1.0f;
            }else{
                _repeat_type=0;
                _repeat.image= _repeat_normal;
                _repeat.alpha=ALPHA;
            }
        }else if(CGRectContainsPoint(_shuffle.frame, point)){
            //TODO: shuffle
            if(!_isShuffling){
                _shuffle.alpha=1.0f;
                
                [self setShuffle];
            }else{
                _shuffle.alpha=ALPHA;
                
                [self removeShuffle];
            }
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
        if(_onRepeat){
            float scale_value=1.0;
            CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
            [_repeat setTransform:scale];
        }
        if(_onShuffle){
            float scale_value=1.0;
            CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
            [_shuffle setTransform:scale];
        }
        _onTwitter=NO;
        _onPull=NO;
        _onArtwork=NO;
        _onRepeat=NO;
        _onShuffle=NO;
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
    
    [tweetViewController setInitialText:[NSString stringWithFormat:@"#nowplaying %@ by %@ with Circle",title,artist]];
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


#pragma mark - shuffle

-(void)setShuffle
{
    _isShuffling=YES;
    _shuffle_hash= [self getShuffledHash:_item_count Except:self.currentIndex];
    _shuffled_urls=[NSMutableArray array];
    _needShuffleReload=YES;
    for(int i=0;i<_item_count;i++){
        @try {
            _shuffled_urls[i]=_urls[[_shuffle_hash[i] intValue]];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
        
    }
    
    
    self.currentIndex=0;
    //[self playAtIndex:self.currentIndex];
    [self updatePlayingMusicInfo:nil];
}

-(void)removeShuffle
{
    _isShuffling=NO;
    _needShuffleReload=YES;
    AVPlayerItem *currentItem = [_player2 currentItem];
    AVURLAsset *asset = (AVURLAsset *)currentItem.asset;
    //  NSLog(@"currentItem%@.asset:%@",currentItem,currentItem.asset);
    self.currentIndex = [_urls indexOfObject:asset.URL];
    
    //[self playAtIndex:self.currentIndex];
    [self updatePlayingMusicInfo:nil];
}

- (NSMutableArray *)getShuffledHash:(int)length Except:(int)index{
    
    if(length==1){
        NSMutableArray *retArray=[NSMutableArray array];
        [retArray addObject:[NSNumber numberWithInt:index]];
        return  retArray;
    }
    
    
    srand([[NSDate date] timeIntervalSinceReferenceDate]);
    int i = length;
    NSMutableArray *array=[NSMutableArray array];
    for (i=0; i<length; i++) {
        if(i!=index){
            [array addObject:[NSNumber numberWithInt:i]];
        }
    }
    i-=1;
    while(--i) {
        int j = rand() % (i+1);
        [array exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    NSMutableArray *retArray=[NSMutableArray array];
    [retArray addObject:[NSNumber numberWithInt:index]];
    [retArray addObjectsFromArray:array];
    
    return retArray;
}

#pragma  mark - something

-(IBAction)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"%s",__func__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self stop];
    [CMCrashReporter reportCrash:@"didReceiveMemoryWarning@CMPlayerViewController"];
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
    self.isAvailable=NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [self stop];
    
}
@end
