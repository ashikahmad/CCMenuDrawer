//
//  WUDrawer.m
//  SpellMaster
//
//  Created by MacBook on 4/10/12.
//  Copyright (c) 2012 WNeeds. All rights reserved.
//

#import "CCShapeRoundedRect.h"
#import "CCMenuDrawer.h"
#import "CCMenu+BoundingBox.h"


@interface CCMenuDrawer (hidden)
-(void) setParentGroup:(CCMenuDrawerGroup *) dGroup;
@end

@interface CCMenuDrawerGroup (hidden)
-(void) drawerOpening:(CCMenuDrawer *) drawer;
@end

#pragma mark - CCMenuDrawer

@implementation CCMenuDrawer

@synthesize isOpen = isOpen_, state = state_, delegate = delegate_, group = parentGroup_;

#pragma mark - Initialization

+(id)drawerWithIcon:(CCSprite *)mainIcon 
          itemsMenu:(CCMenu *)itemsMenu 
    itemStrokeColor:(ccColor4B)itemStrokeColor
        itemBgColor:(ccColor4B)itemBgColor 
 itemBgExpandedSize:(CGSize) bgSizePlus
            padding:(float) padding
            opening:(DRAWER_OPENING) openingType {
    return [[[CCMenuDrawer alloc] initWithIcon:mainIcon 
                                itemsMenu:itemsMenu 
                          itemStrokeColor:itemStrokeColor 
                              itemBgColor:itemBgColor
                       itemBgExpandedSize:bgSizePlus
                                  padding:padding
                                  opening:openingType] autorelease];
}

-(void) handleIconTap {    
    if(isOpen_) [self closeDrawer];
    else [self openDrawer];
}

-(BOOL) isHorizontal {
    return (type == DRAWER_OPEN_LEFT_TO_RIGHT || type == DRAWER_OPEN_RIGHT_TO_LEFT);
}

-(id)initWithIcon:(CCSprite *) mainIcon
        itemsMenu:(CCMenu *)itemsMenu 
  itemStrokeColor:(ccColor4B)itemStrokeColor 
      itemBgColor:(ccColor4B)itemBgColor
itemBgExpandedSize:(CGSize) bgSizePlus
          padding:(float) padding
          opening:(DRAWER_OPENING) openingType {
    if ((self = [super init])) {
        icon = mainIcon;
        items = itemsMenu;
        type = openingType;
        bgOffset = bgSizePlus;
        
        parentGroup_ = nil;
        self.delegate = nil;
        
        // Items
        if(padding <= 0){
            if([self isHorizontal]) [items alignItemsHorizontally];
            else [items alignItemsVertically];
        } else {
            if([self isHorizontal]) [items alignItemsHorizontallyWithPadding:padding];
            else [items alignItemsVerticallyWithPadding:padding];
        }
                    
        
        itemsBound = [items getActualBoundingBox];
        itemsBound.size.width += bgOffset.width;
        itemsBound.size.height += bgOffset.height;
        
        NSLog(@"ItemsBound:(%f, %f, %f, %f)", itemsBound.origin.x, itemsBound.origin.y, itemsBound.size.width, itemsBound.size.height);
        
        int dx, dy;
        int spacing = 5;
        if([self isHorizontal]) {
            dx = icon.contentSize.width/2 + spacing*2;
            dy = 0;
        }
        else {
            dx = 0;
            dy = icon.contentSize.height/2 + spacing*2;
        }
        itemsBound.size = CGSizeMake(itemsBound.size.width + dx, itemsBound.size.height + dy);
        NSLog(@"ItemsBound:(%f, %f, %f, %f)", itemsBound.origin.x, itemsBound.origin.y, itemsBound.size.width, itemsBound.size.height);
        
        CCShapeRoundedRect *rect = [CCShapeRoundedRect rectWithSize:itemsBound.size
                                                             radius:5];
        rect.lineColor = ccc4FFromccc4B(itemStrokeColor);
        rect.fillColor = ccc4FFromccc4B(itemBgColor);
        rect.lineWidth = 2;
        [rect updateTexture];
        itemBg = [CCProgressTimer progressWithSprite:rect];
        itemBg.type = kCCProgressTimerTypeBar;
        switch (type) {
            case DRAWER_OPEN_LEFT_TO_RIGHT:
                itemBg.midpoint = ccp(1, 0);
                itemBg.barChangeRate = ccp(1, 0);
                itemBg.anchorPoint = ccp(1, 0.5);
                
                items.position = ccp(-itemsBound.size.width/2 + icon.contentSize.width/4, 0);
                break;
            case DRAWER_OPEN_RIGHT_TO_LEFT:
                itemBg.midpoint = ccp(0, 0);
                itemBg.barChangeRate = ccp(1, 0);
                itemBg.anchorPoint = ccp(0, 0.5);
                
                items.position = ccp(itemsBound.size.width/2 - icon.contentSize.width/4, 0);
                break;
            case DRAWER_OPEN_TOP_TO_BOTTOM:
                itemBg.midpoint = ccp(0, 0);
                itemBg.barChangeRate = ccp(0, 1);
                itemBg.anchorPoint = ccp(0.5, 0);
                
                items.position = ccp(0, itemsBound.size.height/2 - icon.contentSize.height/4);
                break;
            case DRAWER_OPEN_BOTTOM_TO_TOP:
                itemBg.midpoint = ccp(0, 1);
                itemBg.barChangeRate = ccp(0, 1);
                itemBg.anchorPoint = ccp(0.5, 1);
                
                items.position = ccp(0, -itemsBound.size.height/2 + icon.contentSize.height/4);
                break;
        }
        itemBg.percentage = 0;
        [self addChild:itemBg];
        
        [self addChild:items];
        
        for (CCMenuItem *item in items.children) {
            item.visible = NO;
        }
        
        // Main Icon        
        CCMenu *iconMenu = [CCMenu menuWithItems:[CCMenuItemSprite itemWithNormalSprite:icon selectedSprite:nil target:self selector:@selector(handleIconTap)], nil];
        iconMenu.position = ccp(0, 0);
        [self addChild:iconMenu];
        
        // SET DEAFULT STATUS
        state_ = STATE_IDLE;
        isOpen_ = NO;
    }
    return self;
}

-(void) updateMe:(ccTime) dt {
    if(state_ == STATE_OPENING) {
        itemBg.percentage += 5;
        
        switch (type) {
            case DRAWER_OPEN_LEFT_TO_RIGHT:
                items.position = ccpAdd(items.position, ccp(itemsBound.size.width/20, 0));
                itemBg.position = ccpAdd(itemBg.position, ccp(itemsBound.size.width/20, 0));
                
                for (CCMenuItem *item in items.children) {
                    if(items.position.x + item.position.x > 0)
                        item.visible = YES;
                }
                break;
            case DRAWER_OPEN_RIGHT_TO_LEFT:
                items.position = ccpAdd(items.position, ccp(-itemsBound.size.width/20, 0));
                itemBg.position = ccpAdd(itemBg.position, ccp(-itemsBound.size.width/20, 0));
                
                for (CCMenuItem *item in items.children) {
                    if(items.position.x + item.position.x < 0)
                        item.visible = YES;
                }
                break;
            case DRAWER_OPEN_TOP_TO_BOTTOM:
                items.position = ccpAdd(items.position, ccp(0, -itemsBound.size.height/20));
                itemBg.position = ccpAdd(itemBg.position, ccp(0, -itemsBound.size.height/20));
                
                for (CCMenuItem *item in items.children) {
                    if(items.position.y + item.position.y < 0)
                        item.visible = YES;
                }
                break;
            case DRAWER_OPEN_BOTTOM_TO_TOP:
                items.position = ccpAdd(items.position, ccp(0, itemsBound.size.height/20));
                itemBg.position = ccpAdd(itemBg.position, ccp(0, itemsBound.size.height/20));
                
                for (CCMenuItem *item in items.children) {
                    if(items.position.y + item.position.y > 0)
                        item.visible = YES;
                }
                break;
        }
        
        if (itemBg.percentage >= 100) {
            [self unschedule:@selector(updateMe:)];
            isOpen_ = YES;
            state_ = STATE_IDLE;
        }
    }
    else if (state_ == STATE_CLOSING){
        itemBg.percentage -= 5;
        
        switch (type) {
            case DRAWER_OPEN_LEFT_TO_RIGHT:
                items.position = ccpAdd(items.position, ccp(-itemsBound.size.width/20, 0));
                itemBg.position = ccpAdd(itemBg.position, ccp(-itemsBound.size.width/20, 0));
                
                for (CCMenuItem *item in items.children) {
                    if(items.position.x + item.position.x < 0)
                        item.visible = NO;
                }
                break;
            case DRAWER_OPEN_RIGHT_TO_LEFT:
                items.position = ccpAdd(items.position, ccp(itemsBound.size.width/20, 0));
                itemBg.position = ccpAdd(itemBg.position, ccp(itemsBound.size.width/20, 0));
                
                for (CCMenuItem *item in items.children) {
                    if(items.position.x + item.position.x > 0)
                        item.visible = NO;
                }
                break;
            case DRAWER_OPEN_TOP_TO_BOTTOM:
                items.position = ccpAdd(items.position, ccp(0, itemsBound.size.height/20));
                itemBg.position = ccpAdd(itemBg.position, ccp(0, itemsBound.size.height/20));
                
                for (CCMenuItem *item in items.children) {
                    if(items.position.y + item.position.y > 0)
                        item.visible = NO;
                }
                break;
            case DRAWER_OPEN_BOTTOM_TO_TOP:
                items.position = ccpAdd(items.position, ccp(0, -itemsBound.size.height/20));
                itemBg.position = ccpAdd(itemBg.position, ccp(0, -itemsBound.size.height/20));
                
                for (CCMenuItem *item in items.children) {
                    if(items.position.y + item.position.y < 0)
                        item.visible = NO;
                }
                break;
        }
        
//        if (percentageDraw <= 0) {
        if (itemBg.percentage <= 0) {
            [self unschedule:@selector(updateMe:)];
            isOpen_ = NO;
            state_ = STATE_IDLE;
        }
    }
}

-(void)openDrawer {
    if (!isOpen_ && state_ != STATE_OPENING) {
        DRAWER_STATE preState = state_;
        state_ = STATE_OPENING;
        
        if(preState == STATE_IDLE)
            [self schedule:@selector(updateMe:)];
        
        if(delegate_) [delegate_ drawer:self isOpening:YES];
        if(parentGroup_) [parentGroup_ drawerOpening:self];
    }
}

-(void)closeDrawer {
    if (!(state_ == STATE_CLOSING || (state_ == STATE_IDLE && !isOpen_))) {
        DRAWER_STATE preState = state_;
        state_ = STATE_CLOSING;
        isOpen_ = NO;
        
        if (preState == STATE_IDLE)
            [self schedule:@selector(updateMe:)];
        
        if(delegate_) [delegate_ drawer:self isOpening:NO];
    }
}

-(void)setParentGroup:(CCMenuDrawerGroup *)dGroup {
    if(parentGroup_) [parentGroup_ release];
    parentGroup_ = [dGroup retain];
}

-(void)dealloc {
    if(parentGroup_) [parentGroup_ release];
    [super dealloc];
}

@end

@implementation CCMenuDrawerGroup

+(id)group {
    return [[[self alloc] init] autorelease];
}

-(id)init {
    if((self = [super init])){
        drawers = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc {
    [drawers release];
    [super dealloc];
}

-(void)addDrawer:(CCMenuDrawer *)drawer {
    [drawers addObject:drawer];
    [drawer setParentGroup:self];
}

-(void)removeDrawer:(CCMenuDrawer *)drawer {
    [drawers removeObject:drawer];
    [drawer setParentGroup:nil];
}

-(void)drawerOpening:(CCMenuDrawer *)drawer {
    for (CCMenuDrawer *anyDrawer in drawers) {
        if(drawer != anyDrawer)
            [anyDrawer closeDrawer];
    }
}

@end
