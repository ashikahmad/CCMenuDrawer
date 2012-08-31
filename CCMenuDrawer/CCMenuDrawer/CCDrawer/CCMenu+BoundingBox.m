//
//  CCMenu+BoundingBox.m
//  SpellMaster
//
//  Created by Ashik Ahmad on 4/11/12.
//  Copyright 2012 WNeeds. All rights reserved.
//

#import "CCMenu+BoundingBox.h"


@implementation CCMenu(BoundingBox)

-(CGRect)getActualBoundingBox {
    CGRect rect = CGRectZero;
    CCMenuItem *item;
	CCARRAY_FOREACH(children_, item)
        rect = CGRectUnion(rect, item.boundingBox);
    return rect;
}

-(CGSize)getActualContentSize {
    return [self getActualBoundingBox].size;
}

@end
