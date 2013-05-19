//
//  CMSpiralCircleView.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/6/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMSpiralCircleView.h"
#import <QuartzCore/QuartzCore.h>
#import "CMAlbumViewController.h"

#define TIMER 0.1f


@implementation CMSpiralCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.backgroundColor=[UIColor whiteColor];
        self.clipsToBounds=YES;
        self.userInteractionEnabled = YES;
    
    }
    return self;
}


-(void)setImage
{
    UIImage *artworkImage =[self.artwork imageWithSize: self.bounds.size];
    if(artworkImage!=nil){
        //view.iv.image=artworkImage;
        self.image=artworkImage;
    }else{
 
        self.image=[UIImage imageNamed:@"no_artwork.png"];
    }

}

-(void)clock:(id)something
{
    _count++;
    if(fabs(_start_point.x-self.frame.origin.x)>5 || fabs(_start_point.y-self.frame.origin.y)>5){
        [_tm invalidate];
        touching=NO;
    }
    
    if(_count>6){
        [self.delegate CircleDidLongTouched:self];
        [_tm invalidate];
        touching=NO;
    }
    NSLog(@"%d",_count);
}


#pragma mark - touch
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    touching=YES;
   // NSLog(@"BEGIN:%@",self.album_name);

    [self.delegate CircleDidStartTouching:self WithTouch:[touches anyObject] ];
    _tm =
    [NSTimer scheduledTimerWithTimeInterval:TIMER target:self selector:@selector(clock:) userInfo:nil repeats:YES];
    _count=0;
    _start_point=self.frame.origin;
    [_tm fire];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _count=0;
    [_tm invalidate];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
 
    if(touching){
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[self superview]];
        if(location.x> self.frame.origin.x&& location.x<self.frame.origin.x+self.frame.size.width && location.y>self.frame.origin.y&&location.y<self.frame.origin.y+ self.frame.size.height)
        {
            
           // NSLog(@"END:%@",self.album_name);
            //[self showToast:self];
           // self.original_center=self.center;
    
                [self.delegate CircleDidTouched:self];
       
        }
        _count=0;
        [_tm invalidate];
        touching=NO;
    }else{
        _count=0;
        [_tm invalidate];
        [self.delegate CircleDidTouchedOutOfView:self WithTouch:[touches anyObject]];
    }
    
}

- (void)touchesCanceled:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.delegate CircleDidCanceledTouching:self];
    touching=NO;
    _count=0;
    [_tm invalidate];
}

#pragma mark - animation
-(void)gotPlayed:(CGPoint)target
{
    [self showToast:self To:target];
}
#pragma  mark - toast
- (void) showToast:(UIView*)view To:(CGPoint)target{

    void (^animations)(void) = ^{
        view.alpha = 0.7;
        
        float scale_value=280.0/view.frame.size.width;
        
        CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
        [view setTransform:scale];
     
        [view setCenter:target];
    };
    void (^completionAnimation)(BOOL) = ^(BOOL finished) {
        [self performSelector:@selector(hideToast:) withObject:view afterDelay:0];
    };
    [UIView animateWithDuration:0.3 animations:animations completion:completionAnimation];
}

-(void)hideToast:(UIView *)view
{
    void (^animations)(void) = ^{
        view.alpha = 1.0;
        CGAffineTransform scale = CGAffineTransformMakeScale(1.0, 1.0);
        [view setTransform:scale];
        [view setCenter:self.original_center];
     
    };
    
    [UIView animateWithDuration:0.3 animations:animations completion:nil];
    
}

@end
