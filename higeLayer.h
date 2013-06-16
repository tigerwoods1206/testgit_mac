//
//  higeLayer.h
//  pinch_touch
//
//  Created by オオタ イサオ on 2013/03/05.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface higeLayer : CAShapeLayer {
    int             stop;
    int             lock_flg;
    int             numlimit_pull;
    int             maxlimit_pull;
    
}

//rect property
@property(nonatomic, assign) BOOL touch_flg;
@property(nonatomic, assign) BOOL before_touching_flg;
@property(nonatomic, assign) BOOL skinout_flg;
@property(nonatomic, assign) BOOL skinin_flg;
@property(nonatomic, assign) int fallout_flg;
@property(nonatomic, assign) int pull_count;
@property(nonatomic, assign) int  tag;
@property(nonatomic, assign) int good_angle_flg;
@property(nonatomic, assign) CGPoint skinout_pos;
@property(nonatomic, assign) CGPoint init_pos;
@property(nonatomic, weak) UIColor *rect_color;

@property(nonatomic, assign) BOOL circle_flg;

- (id)initWithHigeLayer:(id)layer anchor:(CGPoint)_anchor origin:(CGPoint)_origin width:(CGFloat)_width height:(CGFloat)_height;
- (void)move_hige:(CGPoint)next_pos;
- (void)move_out_display;
- (void)stop_motion;
- (void)stop_back_motion;
- (void)stop_top_motion;
- (void)stop_left_motion;
- (void)stop_right_motion;
- (void)restart_motion;
- (void)toggle_lock_flg;

@end
