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

#define  ITEM_SIZE 130
#define VIEW_NUM 20
#define CIRCLES_IN_PI 6

@interface CMAlbumViewController ()

@end

@implementation CMAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _slider.frame=CGRectMake(0,_spiral.frame.size.height-ITEM_SIZE,self.view.frame.size.width,ITEM_SIZE);
    _angle=0;
    _current_target=1;
    _center=_spiral.center;
    _radius=_spiral.frame.size.height/2-ITEM_SIZE/2;
    _circles=[NSMutableArray array];
    _item_num=1000;
    for (int i=0; i<_item_num; i++) {
        float ratio=(1-(float)i/VIEW_NUM)*1.0;
        // NSLog(@"%lf",ratio);
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,0, ITEM_SIZE*ratio, ITEM_SIZE*ratio)];
        view.center=CGPointMake(_center.x+_radius*(float)sin(M_PI/CIRCLES_IN_PI*i)*ratio, _center.y+_radius*(float)cos(M_PI/CIRCLES_IN_PI*i)*ratio);
        view.backgroundColor=[UIColor redColor];
        [self makeViewCircle:view];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        label.backgroundColor=[UIColor clearColor];
        label.text=[NSString stringWithFormat:@"Index;%d",i];
        label.center=CGPointMake(view.frame.size.width/2,view.frame.size.height/2);
        [view addSubview:label];
        if(i<VIEW_NUM){
            [_spiral addSubview:view];
            [_spiral sendSubviewToBack:view];
        }
        [_circles addObject:view];
        NSLog(@"%d",i);
        
    }

    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [_slider addGestureRecognizer:panRecognizer];
    
    [self.view bringSubviewToFront:_slider];
    _slider.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
}

-(void)updateCircle:(float)angle
{
    if(_item_num==0) return;

    if(_angle==0 && angle>0){
        NSLog(@"invalid");
        return;
    }
    _angle=MAX( MIN(0, _angle+angle),-1*M_PI/CIRCLES_IN_PI*(_item_num - 1));
    
    //NSLog(@"%lf",_angle/M_PI*180);
    int target=(int)(-1*_angle/M_PI*180/30)+1;
    int target_changed=_current_target-target;
    if(target_changed<0){
        _current_target=target;
        _label_main.text=[NSString stringWithFormat:@"%d",target];
        NSLog(@"changed:%d",_current_target);
        if(_current_target>2){
            [[_circles objectAtIndex:_current_target-3] removeFromSuperview];
     
        }
        if(_current_target<_item_num-VIEW_NUM+2){
 
            UIView * view=[_circles objectAtIndex:_current_target+VIEW_NUM-2];
            [_spiral addSubview:view];
            [_spiral sendSubviewToBack:view];
        }
    }else if(target_changed>0){
      _label_main.text=[NSString stringWithFormat:@"%d",target];
         _current_target=target;
        if(_current_target>1){
            UIView *view=[_circles objectAtIndex:_current_target-2];
            [_spiral addSubview:view];
            [_spiral bringSubviewToFront:view];
            
        }
        if(_current_target<_item_num-VIEW_NUM+1){
            [[_circles objectAtIndex:_current_target+VIEW_NUM-1] removeFromSuperview];
        }
    
    }
    
    //NSLog(@"%d,%lf",target ,_angle/M_PI*180);
    for (int j=0; j<MIN(VIEW_NUM,_item_num-_current_target+1); j++) {
        int i=j+_current_target-1;
        float ratio=(1-(float)(i+_angle/M_PI*180/30)/10)*0.50+0.50;
   
        UIView *view=[_circles objectAtIndex:i];
        view.frame=CGRectMake(view.frame.origin.x,view.frame.origin.y ,MIN(ITEM_SIZE*ratio,ITEM_SIZE), MIN(ITEM_SIZE*ratio,ITEM_SIZE));
        float x=_center.x+_radius*(float)sin(M_PI/CIRCLES_IN_PI*i+_angle)*ratio;
        float y =_center.y+_radius*(float)cos(M_PI/CIRCLES_IN_PI*i+_angle)*ratio;
        if(target>i){
            y=_center.y+_radius;
            x=MAX(0,_center.x+(_radius/(M_PI/CIRCLES_IN_PI))*(_angle+M_PI/CIRCLES_IN_PI*i));
           // if(i==1) NSLog(@"%lf",_radius/(M_PI/CIRCLES_IN_PI)*(_angle+M_PI/CIRCLES_IN_PI*i)*0.1);
        }

        view.center=CGPointMake(x, y);
        view.layer.cornerRadius = view.frame.size.width/2;
    }
    
}

-(void) makeViewCircle:(UIView *)view{
    
    view.layer.cornerRadius = view.frame.size.width/2;
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [UIColor grayColor].CGColor;
    
    
}
#pragma mark - gesture
//http://labs.techfirm.co.jp/ipad/cho/466
- (void)handlePanGesture:(UIGestureRecognizer *)sender {
    if (YES || sender.state == UIGestureRecognizerStateEnded)
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
        CGPoint point = [pan translationInView:self.view];
        CGPoint velocity = [pan velocityInView:self.view];
        //  NSLog(@"pan. translation: %@, velocity: %@", NSStringFromCGPoint(point), NSStringFromCGPoint(velocity));
        float angle=atan(point.y/point.x)/2/M_PI*360;
        //NSLog(@"%lf",atan(point.y/point.x)/2/M_PI*360);
        if(abs(angle)<40){
            if(velocity.x>0) [self updateCircle:velocity.x*0.0001];
            if(velocity.x<0) [self updateCircle:velocity.x*0.0001];
        }
    }
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
    [self presentModalViewController:ad.playerViewController animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
