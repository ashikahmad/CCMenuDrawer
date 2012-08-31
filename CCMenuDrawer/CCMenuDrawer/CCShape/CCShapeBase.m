//
//  CCShapeBase.m
//  CCShapeTest
//
//  Created by Ashik Ahmad on 8/24/12.
//  Copyright 2012 WNeeds. All rights reserved.
//

#import "CCShapeBase.h"

CGRect CGRectIncludePoint2(CGRect srcRect, CGPoint p){
    if(CGRectContainsPoint(srcRect, p))
        return srcRect;
    srcRect = CGRectUnion(srcRect, CGRectMake(p.x, p.y, 1, 1));
    return srcRect;
}

@implementation CCShapeBase

@synthesize noOfPoints, points;
@synthesize needToUpdatePoints;
@synthesize lineColor, fillColor, lineWidth;

-(id)init {
    if((self = [super initWithTexture:nil rect:CGRectZero])){
        lineWidth = 1;
        needToUpdatePoints = YES;
    }
    return self;
}

-(int)noOfPoints {
    return 0;
}

#pragma mark - Custom Getters

-(CGPoint *)points {
    if (pointData == nil) {
        pointData = [[NSMutableData alloc] initWithLength:sizeof(CGPoint)*self.noOfPoints];
    }
    return [pointData mutableBytes];
}

#pragma mark -

-(CGRect)getRequiredTextureRect {
    CGRect rect = CGRectZero;
    for (int i=0; i<self.noOfPoints; i++)
        rect = CGRectIncludePoint2(rect, self.points[i]);
    rect = CGRectInset(rect, -lineWidth*2, -lineWidth*2);
    return rect;
}

-(void)updatePointCoordinateWithPoint:(CGPoint) origin{
    for (int i=0; i<self.noOfPoints; i++)
        self.points[i] = ccpAdd(self.points[i], ccpMult(origin, -1));
}

-(void) updatePointsGlToCocosWithSize:(CGSize) size {
    float h = size.height;
    for (int i=0; i<self.noOfPoints; i++){
        CGPoint p = self.points[i];
        self.points[i] = ccp(p.x, h - p.y);
    }
}

#pragma mark - Public Methods

-(void)updateTexture {
    // 1: Create new CCRenderTexture
    CGRect texRect = [self getRequiredTextureRect];
    if(CGRectIsEmpty(texRect)) return;
    
    if (!CGPointEqualToPoint(texRect.origin, CGPointZero)) {
        [self updatePointCoordinateWithPoint:texRect.origin];
    }
    if(needToUpdatePoints){
        [self updatePointsGlToCocosWithSize:texRect.size];
        needToUpdatePoints = NO;
    }
//    CGSize texSize = [self getRequiredSize];
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:texRect.size.width 
                                                           height:texRect.size.height];
    
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:0 g:0 b:0 a:0];
    
    // 3: Draw into the texture
    ccDrawSolidPoly(self.points, self.noOfPoints, fillColor);
    
    glLineWidth(lineWidth*CC_CONTENT_SCALE_FACTOR());
    ccDrawColor4F(lineColor.r, lineColor.g, lineColor.b, lineColor.a);
    ccDrawPoly(self.points, self.noOfPoints, YES);
    
    // 4: Call CCRenderTexture:end
    [rt end];
    
    // 5: Create a new Texture from the texture
    CCSprite *sprite = [CCSprite spriteWithTexture:rt.sprite.texture];
    
    // 6. update texture
    [self setTexture:sprite.texture];
    [self setTextureRect:CGRectMake(0, 0, texRect.size.width, texRect.size.height)
                 rotated:NO
           untrimmedSize:texRect.size];
    [self.texture setAntiAliasTexParameters];
}

@end
