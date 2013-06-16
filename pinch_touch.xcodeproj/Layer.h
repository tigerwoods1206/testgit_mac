//
//  Layer.h
//  pinch_touch
//
//  Created by オオタ イサオ on 13/02/06.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface pair : NSObject {
}

@property(nonatomic, weak) NSValue *pos1;
@property(nonatomic, weak) NSValue *pos2;

@end


@interface Layer : CAShapeLayer {
    int stop;
    int numlimit_pull;
    int maxlimit_pull;
    int stack_stop_flg;
    NSNotificationCenter *cn_lay;
}

//circle property
@property(nonatomic, assign) CGPoint center;
@property(nonatomic, assign) CGFloat radius;

//rect property
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, weak) UIColor *rect_color;
@property(nonatomic, assign) int good_angle_flg;

@property(nonatomic, assign) BOOL circle_flg;
@property(nonatomic, assign) CGPoint pre_pt;

// initialize method
- (id)initWithLayer:(id)layer center:(CGPoint)_center radius:(CGFloat)_radius;
- (id)initWithRectLayer:(id)layer anchor:(CGPoint)_anchor origin:(CGPoint)_origin width:(CGFloat)_width height:(CGFloat)_height;

// collision detection method
- (BOOL)isCircleArea:(CGPoint)point;
- (BOOL)is_intersect_layer:(CALayer *)layer1 layer2:(CALayer *)layer2;
- (BOOL) is_intersect_circlelay:(Layer *)layer1 layer2:(Layer *)layer2;

// move layer positon method
- (void)move_Layer:(CGPoint)next_pos pull:(int)pull_flg;
- (void)set_Layer_angle:(CGFloat)angle;
- (void)rotate_Layer:(CGFloat)angle;

// those method control switch value in above move mothod
// if this object catch NSNotification.
- (void)stop_motion;       //stop = 1(TRUE)  stop move in    motion (to x axis minus), for move layer opposite directiry (to x axis plus)
- (void)stop_back_motion;  //stop = 2,       stop move out   motion (to x axis plus) , for move layer opposite directiry (to x axis minus)
- (void)stop_left_motion;  //stop = 3,       stop move left  motion (to y axis minus), for move layer opposite directiry (to y axis plus)
- (void)stop_right_motion; //stop = 4,       stop move right motion (to y axis plus) , for move layer opposite directiry (to y axis minus)
- (void)restart_motion;    //stop = 0(FALSE) restart normal move.
- (void)toglle_stack_stop;

@end
