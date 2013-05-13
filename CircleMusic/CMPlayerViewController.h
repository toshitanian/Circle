//
//  CMPlayerViewController.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/6/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#include <AVFoundation/AVFoundation.h>

@interface CMMusicItem : NSObject

@property (nonatomic,retain) NSString *artist;
@property (nonatomic,retain) NSString *album;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) UIImage *artwork;
@property (atomic,assign) float fulltime;

@end


//http://secondflush2.blog.fc2.com/blog-entry-906.html#currentPlaybackTime
//http://secondflush2.blog.fc2.com/blog-entry-911.html MPMediaItem
//http://secondflush2.blog.fc2.com/blog-entry-907.html  MPMediaQuery
//http://netdiever.com/archives/11640
//http://secondflush2.blog.fc2.com/blog-entry-909.html Playlist

//http://ioohta.exblog.jp/tags/iPhone%E3%82%A2%E3%83%97%E3%83%AA/ play with AVPlayer
//https://developer.apple.com/jp/devcenter/ios/library/documentation/iPodLibraryAccess_Guide.pdf ドキュメント
//https://developer.apple.com/jp/devcenter/ios/library/documentation/EventHandlingiPhoneOS.pdf

//http://www.slideshare.net/funami/inside-of-attacca
//http://mtl.recruit.co.jp/blog/2012/07/iphone_dev_jpup.html
//http://www47.atwiki.jp/socup/m/pages/211.html?guid=on#id_e9391754

//UIimage http://iphone.moo.jp/app/?p=707

@interface CMPlayerViewController : UIViewController<AVAudioSessionDelegate>
{

    IBOutlet UIView *_controller;
    UIButton *_btn_play;
    UIButton *_btn_next;
    UIButton *_btn_previous;
    
    IBOutlet UISlider *_slider;
    IBOutlet UILabel *_info_artist;
    IBOutlet UILabel *_info_title;
    IBOutlet UILabel *_info_album;
    IBOutlet UIImageView *_artwork;
    IBOutlet UIView *_shadow;
    IBOutlet UIView *_toast_next;
    IBOutlet UIView *_toast_previous;
    IBOutlet UISlider *_song_progress;
    
    IBOutlet UILabel *_current_time;
    IBOutlet UILabel *_full_time;
    IBOutlet UILabel *_queue_label;
    
    NSTimer *_tm;
    bool _out_of_queue;
    
    AVQueuePlayer *_player2;
 
    NSMutableArray *_items;
    NSMutableArray *_urls;

    AVAudioSession *_audioSession;
    
    bool _isSkipping;
}

-(IBAction)dismiss:(id)sender;
@property MPMusicPlayerController *player;
@property (atomic,assign) bool isPlaying;
@property (atomic,assign) int currentIndex;
@property (atomic,assign) bool needReload;
@property (nonatomic,retain) MPMediaQuery *query;
@end
