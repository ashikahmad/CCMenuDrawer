//
//  CCMenu+BoundingBox.h
//  SpellMaster
//
//  Created by Ashik Ahmad on 4/11/12.
//  Copyright 2012 WNeeds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCMenu(BoundingBox)

-(CGRect) getActualBoundingBox;
-(CGSize) getActualContentSize;

@end
