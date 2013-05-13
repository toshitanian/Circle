//
//  CMIndexView.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/8/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMIndexView : UIView
{
    CGPoint _pointPanBegan;
    NSMutableArray *_index_strings;
    NSMutableArray *_index_views;
    float _radius;
    float _angle;
    UIImageView *iv;
    CGPoint _center;
}

- (id)initWithFrame:(CGRect)frame WithIndexes:(NSArray*)indexChars;
+(NSArray *)getIndexes:(NSArray*)collections WithType:(int)type;
@end
