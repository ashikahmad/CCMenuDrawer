//
//  CCShapeRoundedRect.h
//  CCShapeTest
//
//  Created by Ashik Ahmad on 8/25/12.
//  Copyright 2012 WNeeds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCShapeBase.h"

@interface CCShapeRoundedRect : CCShapeBase {
    CGSize rectSize;
    float radius;
}

+(id) rectWithSize:(CGSize) size radius:(float) r;
-(id) initWithSize:(CGSize) size radius:(float) r;

@end
