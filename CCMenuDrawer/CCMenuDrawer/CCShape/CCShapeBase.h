//
//  CCShapeBase.h
//  CCShapeTest
//
//  Created by Ashik Ahmad on 8/24/12.
//  Copyright 2012 WNeeds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCShapeBase : CCSprite {
    NSMutableData *pointData;
    
    ccColor4F lineColor;
    ccColor4F fillColor;
    float lineWidth;
}

@property (readonly) int noOfPoints;
@property (readonly) CGPoint *points;

@property (nonatomic, assign) BOOL needToUpdatePoints;

@property (nonatomic, assign) ccColor4F lineColor;
@property (nonatomic, assign) ccColor4F fillColor;
@property (nonatomic, assign) float lineWidth;

-(void) updateTexture;

@end
