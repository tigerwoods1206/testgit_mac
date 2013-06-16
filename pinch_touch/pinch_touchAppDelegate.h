//
//  pinch_touchAppDelegate.h
//  pinch_touch
//
//  Created by オオタ イサオ on 13/02/06.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class pinch_touchViewController;
@class main_menu;

@interface pinch_touchAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, strong) IBOutlet UIWindow *window;

//@property (nonatomic, retain) IBOutlet pinch_touchViewController *viewController;

@property (nonatomic, strong) IBOutlet main_menu *viewController;

@end
