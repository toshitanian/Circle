//
//  CMPlayerViewController.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/6/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


//http://secondflush2.blog.fc2.com/blog-entry-906.html#currentPlaybackTime
//http://secondflush2.blog.fc2.com/blog-entry-911.html
//http://secondflush2.blog.fc2.com/blog-entry-907.html
//http://netdiever.com/archives/11640

@interface CMPlayerViewController : UIViewController
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
}

-(IBAction)dismiss:(id)sender;
@property MPMusicPlayerController *player;
@property (atomic,assign) bool isPlaying;
@property (nonatomic,retain) MPMediaQuery *query;
@end
