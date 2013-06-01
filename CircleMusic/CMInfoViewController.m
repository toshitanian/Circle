//
//  CMInfoViewController.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/7/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CMAppDelegate.h"
#import "CMAlbumViewController.h"

@interface CMInfoViewController ()

@end

@implementation CMInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    CMAppDelegate *ad=[[UIApplication sharedApplication] delegate];
    if(ad.iOStype==2){
        nibNameOrNil=@"CMInfoViewController_for_35inch";
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.delegate CMInfoViewControllerDidFinishShowing:self];
}
-(void)viewWillAppear:(BOOL)animated
{

    CMAppDelegate *ad=[[UIApplication sharedApplication] delegate];
    if (ad.playerViewController.isAvailable) {
        _btn_player.hidden=NO;
    }else{
        _btn_player.hidden=YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hasLoaded=YES;
    
#pragma mark control button
    [_btn_player makeCircle];
    _btn_player.image=[UIImage imageNamed:@"headphone.png"];
    [_btn_pop makeCircle];
    _btn_pop.image=[UIImage imageNamed:@"back.png"];
    UITapGestureRecognizer* p_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureForController:)];
    p_tapRecognizer.delegate=self;
    [self.view addGestureRecognizer:p_tapRecognizer];
    
    UILongPressGestureRecognizer* p_longpressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureForController:)];
    p_longpressRecognizer.delegate=self;
    [self.view addGestureRecognizer:p_longpressRecognizer];
    
    UIPanGestureRecognizer *p_panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureForController:)];
    p_panRecognizer.delegate=self;
    [self.view addGestureRecognizer:p_panRecognizer];
    
    
    _player_abs_point=absPoint__(_btn_player);
    _pop_abs_point=absPoint__(_btn_pop);
    
}
#pragma mark - gestrure



CGPoint absPoint__(UIView* view)
{
    CGPoint ret = CGPointMake(view.frame.origin.x, view.frame.origin.y);
    if ([view superview] != nil){
        CGPoint addPoint = absPoint__([view superview]);ret = CGPointMake(ret.x + addPoint.x, ret.y + addPoint.y);
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


#pragma mark - something

-(IBAction)pop:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)showPlayer:(id)sender
{
    CMAppDelegate *ad=[[UIApplication sharedApplication] delegate];
    ad.playerViewController.query=nil;
    [self presentViewController:ad.playerViewController animated:YES completion: nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
