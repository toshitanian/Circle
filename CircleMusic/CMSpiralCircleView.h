//
//  CMSpiralCircleView.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/6/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@class CMSpiralCircleView;

@protocol CMSpiralCircleViewDelegate
- (void) CircleDidTouched:(CMSpiralCircleView *)view;
- (void) CircleDidLongTouched:(CMSpiralCircleView *)view;
- (void) CircleDidTouchedOutOfView:(CMSpiralCircleView *)view WithTouch:(UITouch *)touch;
- (void) CircleDidCanceledTouching:(CMSpiralCircleView *)view;
- (void) CircleDidStartTouching:(CMSpiralCircleView *)view WithTouch:(UITouch *)touch;
@end

@interface CMSpiralCircleView : UIImageView
{
    bool touching;
    UIView *shadow;
    NSTimer *_tm;
    int _count;
    CGPoint _start_point;
    
}
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *artist_name;
@property(nonatomic,retain) NSString *album_name;
@property(nonatomic,retain) NSString *playlist_name;
@property(nonatomic,retain) MPMediaItemArtwork *artwork;

@property (nonatomic,retain) id<CMSpiralCircleViewDelegate> delegate;
@property (atomic,assign) CGPoint original_center;

-(void)setImage;
-(void)gotPlayed:(CGPoint)target;
@end

