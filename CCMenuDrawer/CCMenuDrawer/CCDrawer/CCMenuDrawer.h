//
//  WUDrawer.h
//  SpellMaster
//
//  Created by MacBook on 4/10/12.
//  Copyright (c) 2012 WNeeds. All rights reserved.
//
#import "cocos2d.h"

typedef enum {
    DRAWER_OPEN_LEFT_TO_RIGHT,
    DRAWER_OPEN_RIGHT_TO_LEFT,
    DRAWER_OPEN_TOP_TO_BOTTOM,
    DRAWER_OPEN_BOTTOM_TO_TOP
} DRAWER_OPENING;

typedef enum {
    STATE_OPENING,
    STATE_CLOSING,
    STATE_IDLE
} DRAWER_STATE;

@class CCMenuDrawerGroup;
@protocol CCMenuDrawerDelegate;

@interface CCMenuDrawer : CCNode {
    NSObject<CCMenuDrawerDelegate> *delegate_;
    CCMenuDrawerGroup *parentGroup_;
    
    CCProgressTimer *itemBg;
    
    CCSprite *icon;
    CCMenu *items;
    
    DRAWER_OPENING type;
    DRAWER_STATE state_;
    
    BOOL isOpen_;
    
    CGSize bgOffset;
    CGRect itemsBound;
}

@property (nonatomic, readonly) BOOL isOpen;
@property (nonatomic, readonly) DRAWER_STATE state;
@property (nonatomic, retain) NSObject<CCMenuDrawerDelegate> *delegate;
@property (nonatomic, readonly) CCMenuDrawerGroup *group;

+(id) drawerWithIcon:(CCSprite *) mainIcon
           itemsMenu:(CCMenu *) itemsMenu
     itemStrokeColor:(ccColor4B) itemStrokeColor
         itemBgColor:(ccColor4B) itemBgColor
  itemBgExpandedSize:(CGSize) bgSizePlus
             padding:(float) padding
             opening:(DRAWER_OPENING) openingType;

-(id) initWithIcon:(CCSprite *) mainIcon
         itemsMenu:(CCMenu *) itemsMenu
   itemStrokeColor:(ccColor4B) itemStrokeColor
       itemBgColor:(ccColor4B) itemBgColor
itemBgExpandedSize:(CGSize) bgSizePlus
           padding:(float) padding
           opening:(DRAWER_OPENING) openingType;

-(void) closeDrawer;
-(void) openDrawer;

@end

@interface CCMenuDrawerGroup : NSObject {
    NSMutableArray *drawers;
}
+(id) group;
-(void) addDrawer:(CCMenuDrawer *) drawer;
-(void) removeDrawer:(CCMenuDrawer *) drawer; 
@end

@protocol CCMenuDrawerDelegate <NSObject>
@required
-(void) drawer:(CCMenuDrawer *) drawer isOpening:(BOOL) state;
@end