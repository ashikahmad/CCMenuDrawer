//
//  CCShapeRoundedRect.m
//  CCShapeTest
//
//  Created by Ashik Ahmad on 8/25/12.
//  Copyright 2012 WNeeds. All rights reserved.
//

#import "CCShapeRoundedRect.h"

#define kappa 0.552228474

static int cornerSegments = 16;

@interface CCShapeRoundedRect (private)

-(void) setCalculatedPoints;

@end

@implementation CCShapeRoundedRect

+(id)rectWithSize:(CGSize)size radius:(float)r {
    return [[[self alloc] initWithSize:size radius:r] autorelease];
}

-(id)initWithSize:(CGSize)size radius:(float)r {
    if ((self = [super init])) {
        rectSize = size;
        radius = r;
        
        [self setCalculatedPoints];
    }
    return self;
}

-(int)noOfPoints {
    return 4*cornerSegments+1;
}

void appendCubicBezier3(int startPoint, CGPoint* vertices, CGPoint origin, CGPoint control1, CGPoint control2, CGPoint destination, NSUInteger segments)
{
    float t = 0;
    for(NSUInteger i = 0; i < segments; i++)
    {
        GLfloat x = powf(1 - t, 3) * origin.x + 3.0f * powf(1 - t, 2) * t * control1.x + 3.0f * (1 - t) * t * t * control2.x + t * t * t * destination.x;
        GLfloat y = powf(1 - t, 3) * origin.y + 3.0f * powf(1 - t, 2) * t * control1.y + 3.0f * (1 - t) * t * t * control2.y + t * t * t * destination.y;
        vertices[startPoint+i] = CGPointMake(x,// * CC_CONTENT_SCALE_FACTOR(),
                                             y);// * CC_CONTENT_SCALE_FACTOR() );
        t += 1.0f / segments;
    }
}

-(void) setCalculatedPoints {
    CGPoint vertices[16];
    vertices[0] = ccp(0,-radius);
    vertices[1] = ccp(0,-radius*(1-kappa));
    vertices[2] = ccp(radius*(1-kappa),0);
    vertices[3] = ccp(radius,0);
    
    vertices[4] = ccp(rectSize.width-radius,0);
    vertices[5] = ccp(rectSize.width-radius*(1-kappa),0);
    vertices[6] = ccp(rectSize.width,-radius*(1-kappa));
    vertices[7] = ccp(rectSize.width,-radius);
    
    vertices[8] = ccp(rectSize.width,-rectSize.height + radius);
    vertices[9] = ccp(rectSize.width,-rectSize.height + radius*(1-kappa));
    vertices[10] = ccp(rectSize.width-radius*(1-kappa),-rectSize.height);
    vertices[11] = ccp(rectSize.width-radius,-rectSize.height);
    
    vertices[12] = ccp(radius,-rectSize.height);
    vertices[13] = ccp(radius*(1-kappa),-rectSize.height);                   
    vertices[14] = ccp(0,-rectSize.height+radius*(1-kappa));                   
    vertices[15] = ccp(0,-rectSize.height+radius);    
    
    CGPoint polyVertices[self.noOfPoints];
    
    appendCubicBezier3(0*cornerSegments,polyVertices,vertices[0], vertices[1], vertices[2], vertices[3], cornerSegments);
    appendCubicBezier3(1*cornerSegments,polyVertices,vertices[4], vertices[5], vertices[6], vertices[7], cornerSegments);
    appendCubicBezier3(2*cornerSegments,polyVertices,vertices[8], vertices[9], vertices[10], vertices[11], cornerSegments);
    appendCubicBezier3(3*cornerSegments,polyVertices,vertices[12], vertices[13], vertices[14], vertices[15], cornerSegments);
    // close with first point
    polyVertices[4*cornerSegments] = vertices[0];
    
    for (int i=0; i<self.noOfPoints; i++) {
        self.points[i] = polyVertices[i];
    }
}

@end
