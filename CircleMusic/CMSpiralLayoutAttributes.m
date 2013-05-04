//
//  CMSpiralLayoutAttributes.m
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/21/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "CMSpiralLayoutAttributes.h"

@implementation CMSpiralLayoutAttributes 

- (id)init
{
    self = [super init];
    if (self) {
        _headerTextAlignment = NSTextAlignmentLeft;
        _shadowOpacity = 0.5;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    CMSpiralLayoutAttributes *newAttributes = [super copyWithZone:zone];
    newAttributes.headerTextAlignment = self.headerTextAlignment;
    newAttributes.shadowOpacity = self.shadowOpacity;
    return newAttributes;
}

/*+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath
{
    CMSpiralLayoutAttributes *attributes = [[CMSpiralLayoutAttributes alloc] init];
    attributes->_representedElementCategory = UICollectionElementCategoryCell;
    return attributes;
}

+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath*)indexPath
{
    CMSpiralLayoutAttributes *attributes = [[CMSpiralLayoutAttributes alloc] init];
    return attributes;
}

+ (instancetype)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind withIndexPath:(NSIndexPath *)indexPath
{
    CMSpiralLayoutAttributes *attributes = [[CMSpiralLayoutAttributes alloc] init];
    return attributes;
}*/

@end
