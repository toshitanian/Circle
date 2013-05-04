//
//  CMSpiralCell.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/5/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMSpiralCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CMSpiralLayout.h"
@implementation CMSpiralCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = [CMSpiralLayout getItemSize]/2;
        self.contentView.layer.borderWidth = 3.0f;
        self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
        self.contentView.backgroundColor = [UIColor whiteColor];
        // CGRect rect= CGRectMake(0, 0, self.contentView.frame.size.width/sqrt(2.0), self.contentView.frame.size.height/sqrt(2.0));
        CGRect rect= CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        self.iv=[[UIImageView alloc] initWithFrame:rect];
        self.iv.center=CGPointMake(self.contentView.center.x,self.contentView.center.y);
        self.iv.image=[UIImage imageNamed:@"cell-group.png"];
        self.iv.layer.cornerRadius=self.contentView.layer.cornerRadius;
        self.iv.clipsToBounds=YES;
        [self.contentView addSubview:self.iv];
        self.label=[[UILabel alloc] initWithFrame:rect];
        //[self.contentView addSubview:self.label];
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
