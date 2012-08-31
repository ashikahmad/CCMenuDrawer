//
//  HelloWorldLayer.m
//  CCMenuDrawer
//
//  Created by Ashik Ahmad on 8/31/12.
//  Copyright WNeeds 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

#define TAG_MUSIC_ITEM      601
#define TAG_SOUND_ITEM      602
#define TAG_INFO_ITEM       603

#define TAG_RATIGN_ITEM     604
#define TAG_FACEBOOK_ITEM   605
#define TAG_TWEETER_ITEM    606

#define TAG_DRAWER_SETTINGS 607
#define TAG_DRAWER_SHARE    608

#define NSNum(num) [NSNumber numberWithInt:num]

@interface HelloWorldLayer (private)

-(CCMenuItem *) menuItemNamed:(NSString *) name callback:(SEL) sel tag:(int) tag ;
-(CCMenuDrawer *) drawerWithIcon:(NSString *) icon itemNames:(NSArray *) names tags:(NSArray *) tags opening:(DRAWER_OPENING) opening;

@end

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];
	[scene addChild: layer];
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self = [super initWithColor:ccc4(180, 211, 242, 255)
                              fadingTo:ccc4(80, 140, 201, 255)
                           alongVector:ccp(0, 1)]) ) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MainMenu.plist"];
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Drawer Test" fontName:@"Arial" fontSize:60];
        title.position = ccp(winSize.width/2, winSize.height/2 + 25);
        [self addChild:title];
        
        CCMenuDrawerGroup *group = [CCMenuDrawerGroup group];
        
        NSArray *names = [NSArray arrayWithObjects:@"Music_on.png:Music_off.png", @"Sound_on.png:Sound_off.png", @"Devider.png", @"Info.png", nil];
        NSArray *tags = [NSArray arrayWithObjects:NSNum(TAG_MUSIC_ITEM ), NSNum(TAG_SOUND_ITEM), NSNum(-1), NSNum(TAG_INFO_ITEM), nil];
        
		CCMenuDrawer *setttingsDrawer = [self drawerWithIcon:@"Settings_Icon.png"
                                                   itemNames:names
                                                        tags:tags
                                                     opening:DRAWER_OPEN_LEFT_TO_RIGHT];
        setttingsDrawer.position = ccp(37, 50);
        setttingsDrawer.delegate = self;
        [self addChild:setttingsDrawer];
        [group addDrawer:setttingsDrawer];
        
        
        NSArray *names2 = [NSArray arrayWithObjects:@"Star.png", @"Devider.png", @"Facebook.png", @"Tweeter.png", nil];
        NSArray *tags2 = [NSArray arrayWithObjects:NSNum(TAG_RATIGN_ITEM), NSNum(-1), NSNum(TAG_FACEBOOK_ITEM), NSNum(TAG_TWEETER_ITEM), nil];
        
		CCMenuDrawer *shareDrawer = [self drawerWithIcon:@"Share_Icon.png"
                                               itemNames:names2
                                                    tags:tags2
                                                 opening:DRAWER_OPEN_RIGHT_TO_LEFT];
        shareDrawer.position = ccp(winSize.width - 37, 50);
        shareDrawer.delegate = self;
        [self addChild:shareDrawer];
        [group addDrawer:shareDrawer];
        
        CCMenuDrawerGroup *group2 = [CCMenuDrawerGroup group];
        
        NSArray *names3 = [NSArray arrayWithObjects:@"Music_on.png:Music_off.png", @"Sound_on.png:Sound_off.png", @"Devider-v.png", @"Info.png", nil];
        NSArray *tags3 = [NSArray arrayWithObjects:NSNum(TAG_MUSIC_ITEM ), NSNum(TAG_SOUND_ITEM), NSNum(-1), NSNum(TAG_INFO_ITEM), nil];
        
		CCMenuDrawer *setttingsDrawer2 = [self drawerWithIcon:@"Settings_Icon.png"
                                                   itemNames:names3
                                                        tags:tags3
                                                     opening:DRAWER_OPEN_TOP_TO_BOTTOM];
        setttingsDrawer2.position = ccp(37, winSize.height - 35);
        setttingsDrawer2.delegate = self;
        [self addChild:setttingsDrawer2];
        [group2 addDrawer:setttingsDrawer2];
        
        
        NSArray *names4 = [NSArray arrayWithObjects:@"Star.png", @"Devider-v.png", @"Facebook.png", @"Tweeter.png", nil];
        NSArray *tags4 = [NSArray arrayWithObjects:NSNum(TAG_RATIGN_ITEM), NSNum(-1), NSNum(TAG_FACEBOOK_ITEM), NSNum(TAG_TWEETER_ITEM), nil];
        
		CCMenuDrawer *shareDrawer2 = [self drawerWithIcon:@"Share_Icon.png"
                                               itemNames:names4
                                                    tags:tags4
                                                 opening:DRAWER_OPEN_TOP_TO_BOTTOM];
        shareDrawer2.position = ccp(winSize.width - 37, winSize.height - 35);
        shareDrawer2.delegate = self;
        [self addChild:shareDrawer2];
        [group2 addDrawer:shareDrawer2];
	}
	return self;
}

-(void)drawer:(CCMenuDrawer *)drawer isOpening:(BOOL)state {
    NSLog(@"Dawer %s", state? "opening":"closing");
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) menuCallBack:(id) sender {
    
}

/*
 This methods used down here are just little utils to keep actual 
 code cleaner. This is no rocket science or not part of the 
 drawer-utility. I think, you'll get it fine.
 */

-(CCMenuItem *)menuItemNamed:(NSString *)name callback:(SEL)sel tag:(int) tag {
    // I am taking normal and selected spriteNames at once with a separator ":"
    // So, here I check, if selected name is provided. And separating if so.
    // For me, here selected is provided only for toggleItems
    NSString *sName = nil;
    NSArray *splitted = [name componentsSeparatedByString:@":"];
    if(splitted.count > 1){
        name = [splitted objectAtIndex:0];
        sName = [splitted objectAtIndex:1];
    }
    
    CCSprite *sprNorm = [CCSprite spriteWithSpriteFrameName:name];
    
    if (sName == nil) {
        // Used same sprite for selected and used a littie dark color
        // for tap-effect. You can do it your way. I just love this
        // simple thing.
        CCSprite *sprSel = [CCSprite spriteWithSpriteFrameName:name];
        sprSel.color = ccc3(150, 150, 150);
        CCMenuItem *item = [CCMenuItemSprite itemWithNormalSprite:sprNorm selectedSprite:sprSel target:(sel)?self:nil selector:sel];
        return item;
    } else {
        CCMenuItem *item = [CCMenuItemToggle itemWithTarget:self
                                                   selector:sel
                                                      items:
                            [self menuItemNamed:name callback:nil tag:-1],
                            [self menuItemNamed:sName callback:nil tag:-1],
                            nil];
        return item;
    }
}

// Need to have same no of items in names and tags. so not checked here
-(CCMenuDrawer *)drawerWithIcon:(NSString *) icon itemNames:(NSArray *)names tags:(NSArray *)tags opening:(DRAWER_OPENING)opening {
    NSMutableArray *items = [NSMutableArray array];
    SEL cb = @selector(menuCallBack:);
    for (int i=0; i<names.count; i++) {
        NSString *name = [names objectAtIndex:i];
        NSNumber *num = [tags objectAtIndex:i];
        int itemTag = [num intValue];
        CCMenuItem *item = [self menuItemNamed:name callback:cb tag:itemTag];
        [items addObject:item];
    }
    CCMenu *menu = [CCMenu menuWithArray:items];
    CCSprite *sprIcon = [CCSprite spriteWithSpriteFrameName:icon];
    CCMenuDrawer *drawer = [CCMenuDrawer drawerWithIcon:sprIcon
                                              itemsMenu:menu
                                        itemStrokeColor:ccc4(255, 255, 255, 255)
                                            itemBgColor:ccc4(0, 0, 0, 100)
                                     itemBgExpandedSize:CGSizeMake(0, -10)
                                                padding:0
                                                opening:opening];
    return drawer;
}

@end
