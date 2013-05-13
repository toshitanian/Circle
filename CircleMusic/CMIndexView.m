//
//  CMIndexView.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/8/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMIndexView.h"
#import <QuartzCore/QuartzCore.h>
#import "CMAlbumViewController.h"
#define DIV 12.0f

@implementation CMIndexView

- (id)initWithFrame:(CGRect)frame WithIndexes:(NSArray*)indexChars
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
        
        _radius=self.frame.size.width/2;
        _angle=0.0f;
        _index_strings=[NSMutableArray array];
        for (int i=0; i<[indexChars count]; i++) {
            NSString *c =[[indexChars objectAtIndex:i] objectForKey:@"char"];
            [_index_strings addObject:c];
        }
        
        
        // _index_strings=[NSArray arrayWithObjects:@"A",@"B",@"A",@"B",@"A",@"B",@"A",@"B",@"A",@"B",nil ];
        int num=[_index_strings count];
        
        _index_views=[NSMutableArray array];
        
        _center=CGPointMake(self.frame.size.width*0.75, self.frame.size.height/2);
        
        for (int i=0; i<num; i++) {
            
            UIImageView *index_circle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/4, self.frame.size.width/4)];
            index_circle.layer.cornerRadius = index_circle.frame.size.width/2;
            index_circle.layer.borderWidth = 1.0f;
            index_circle.layer.borderColor = [UIColor grayColor].CGColor;
            index_circle.backgroundColor=[UIColor whiteColor];
            index_circle.userInteractionEnabled = YES;
            
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, index_circle.frame.size.width, index_circle.frame.size.height)];
            label.backgroundColor=[UIColor clearColor];
            label.textAlignment=  NSTextAlignmentCenter;
            label.text=[_index_strings objectAtIndex:i];
            [index_circle addSubview:label];
            
            
            if(i<4){
                index_circle.center=CGPointMake(_center.x+_radius*cos(i*2*M_PI/DIV-M_PI),_center.y+_radius*sin(i*2*M_PI/DIV -M_PI));
                NSLog(@"angle:%lf",_center.y+ _radius*sin(i*2*M_PI/DIV -M_PI));
            }
            
            
            CMPanGestureRecognizer* panRecognizer = [[CMPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:) ];
            panRecognizer.tag=i;
            [index_circle addGestureRecognizer:panRecognizer];
            
            CMTapGestureRecognizer* tapRecognizer = [[CMTapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:) ];
            tapRecognizer.tag=i;
            [index_circle addGestureRecognizer:tapRecognizer];
            //  [selfbringSubviewToFront:_slider3];
            [_index_views addObject:index_circle];
            [self addSubview:index_circle];
            
        }
        
        self.clipsToBounds=YES;
        
        //[self becomeFirstResponder];
        _pointPanBegan.x=-999;
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    
    
    if(_pointPanBegan.x==-999){
        _pointPanBegan= [[touches anyObject] locationInView:self];
        NSLog(@"%lf;%lf",_pointPanBegan.x,_pointPanBegan.y);
    }
}

-(void)touchesEnded: (NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesENd");
    _pointPanBegan.x=-999;
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancel");
    //_pointPanBegan.x=-999;
}

#pragma mark - moving gesture
-(void)updateCircle:(float)angle
{
    
    _angle+=angle;
    NSLog(@"%lf",_angle);
    int num=[_index_strings count];
    for (int i=0; i<num;i++) {
        UIImageView *index_circle=[_index_views objectAtIndex:i];
        if(i<4)
        index_circle.center=CGPointMake(_center.x+_radius*cos(i*2*M_PI/DIV+_angle-M_PI),_center.y+ _radius*sin(i*2*M_PI/DIV+_angle+M_PI));
      
        
        // float x=_center.x+_radius*(float)sin(M_PI/CIRCLES_IN_PI*i+_angle)*ratio;
        // float y =_center.y+_radius*(float)cos(M_PI/CIRCLES_IN_PI*i+_angle)*ratio;
    }
    
    [self setNeedsDisplay];
}


#pragma mark - gesture
//http://labs.techfirm.co.jp/ipad/cho/466


- (void)handleTapGesture:(CMTapGestureRecognizer *)tap {
    NSLog(@"%d",tap.tag);
}

- (void)handlePanGesture:(CMPanGestureRecognizer *)pan {
    // NSLog(@"%d:%lf",pan.tag,_pointPanBegan.x);
    
    CGPoint point = [pan translationInView:self];
    CGPoint velocity = [pan velocityInView:self];
    
    if(pan.state==UIGestureRecognizerStateEnded){
        _pointPanBegan.x=-999;
    }
    
    if(_pointPanBegan.x==-999) return;
    
    
    CGPoint current_point=CGPointMake(_pointPanBegan.x+point.x, _pointPanBegan.y+point.y);
    
    
    if(CGRectContainsPoint(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/3), current_point)){
        //上半分
        if(velocity.x>0){
            [self updateCircle:sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2))];
        }else{
            [self updateCircle:-1*sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2))];
        }
    }else if(CGRectContainsPoint(CGRectMake(0, self.frame.size.height*2/3, self.frame.size.width, self.frame.size.height/3), current_point)){
        //  下半分
        if(velocity.x>0){
            [self updateCircle:-1*sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2))];
        }else{
            [self updateCircle:sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2))];
        }
        
    }else{
        [self updateCircle:-1*velocity.y*0.0001];
    }
    
    
    
    
}

#pragma mark - get index

+(NSString *)getIndexCharacter:(NSString *)str
{
    //NSString *str_the=[str substringToIndex:3];
    NSMutableString *c;
    NSRange match = [str rangeOfString:@"[tTｔT][hHｈH][eEeE][ 　]+" options:NSRegularExpressionSearch];
    if (match.location != NSNotFound && match.location==0) {
        c=[NSMutableString stringWithString: [[str substringFromIndex:match.length] substringToIndex:1]];
        
    } else {
        c=[NSMutableString stringWithString: [str substringToIndex:1]];
        
    }
    
    match = [c rangeOfString:@"[ぁ-んァ-ンa-zA-Z]" options:NSRegularExpressionSearch];
    if(match.location==NSNotFound){
        NSLog(@"#for %@",c);
        return @"#";
    }
    match = [c rangeOfString:@"[ぁ-ん]" options:NSRegularExpressionSearch];
    if(match.location!=NSNotFound){
        //[c stringTransformWithTransform:kCFStringTransformHiraganaKatakana reverse:false];
        
        CFStringTransform((__bridge CFMutableStringRef)c, NULL, kCFStringTransformHiraganaKatakana, false);
        
    }
    
    return c;
    
    
}


+(NSArray *)getIndexes:(NSArray*)collections WithType:(int)type
{
    
    
    //[type] 0: artist 1: song 2:album
    NSMutableArray *indexes=[NSMutableArray array];
    NSMutableString *current=[NSMutableString stringWithString:@""];
    for (int i=0; i<[collections count]; i++) {
        //media
        
        
        MPMediaItem *representativeItem = [[collections objectAtIndex:i] representativeItem];
        
        NSString *str;
        if(type==0){
            str=
            [representativeItem valueForProperty: MPMediaItemPropertyAlbumArtist];
        }else if(type==1){
            str= [representativeItem valueForProperty: MPMediaItemPropertyTitle];
            
        }else if(type==2){
            str =
            [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];
            
        }else if(type==3){
            str= [representativeItem valueForProperty: MPMediaPlaylistPropertyName];
            
        }
        NSString *c=[self getIndexCharacter:str];
        if([current rangeOfString:c].location==NSNotFound){
            
            [current appendString:c];
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys: c,@"char",[NSNumber numberWithInt:i],@"index",nil];
            [indexes addObject:dic];
        }
    }
    
    //    /NSLog(@"%@",indexes);
    for (int i=0; i<[indexes count];i++) {
        // NSLog(@"%@",[[indexes objectAtIndex:i] objectForKey:@"char" ]);
    }
    return indexes;
    
}

@end
