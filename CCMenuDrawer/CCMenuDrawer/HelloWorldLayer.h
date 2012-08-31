//
//  HelloWorldLayer.h
//  CCMenuDrawer
//
//  Created by Ashik Ahmad on 8/31/12.
//  Copyright WNeeds 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCMenuDrawer.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerGradient<CCMenuDrawerDelegate> {
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
