//
//  main_menu.h
//  pinch_touch
//
//  Created by オオタ イサオ on 13/02/12.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pinch_touchViewController.h"
#import "Option_Table.h"

@class pinch_touchViewController;
@class Opion_Table;
@interface main_menu : UIViewController {
    pinch_touchViewController *modalViewController;
    Opion_Table *option_Table;
}
@property(nonatomic) pinch_touchViewController *modalViewController;
@property(nonatomic, strong) Opion_Table *option_Table;
-(IBAction) start_Button:(id)sender;
-(IBAction) option_Button:(id)sender;

@end
