

#import <UIKit/UIKit.h>

@interface CMCircleLayout : UICollectionViewLayout
+(int)getItemSize;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;

@end
