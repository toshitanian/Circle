//
//  CMIndexCircleView.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/15/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMIndexCircleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CMIndexCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.65f];
        self.clipsToBounds=YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
