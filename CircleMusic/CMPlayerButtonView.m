//
//  CMPlayerButtonView.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/15/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMPlayerButtonView.h"
#import <QuartzCore/QuartzCore.h>


@implementation CMPlayerButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
  
    }
    return self;
}



-(void)makeCircle
{

    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.backgroundColor=[UIColor whiteColor];
    self.clipsToBounds=YES;
    
 

}


@end
