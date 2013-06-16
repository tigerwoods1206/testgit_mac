//
//  in_window_wall_judge.m
//  pinch_touch
//
//  Created by オオタ イサオ on 2013/05/23.
//
//

#import "in_window_wall_judge.h"

@interface in_window_wall_judge() {
    
}

@end

@implementation in_window_wall_judge

+ (BOOL)is_in_window:(Layer *)layer window_frame:(CGRect)window_frame top_layer:(CALayer *)top_layer
{
    CGRect child_layer_rect = CGRectMake(layer.frame.origin.x, layer.frame.origin.y, layer.frame.size.width , layer.frame.size.height);
    
    CGRect layer_rect = [layer convertRect:layer.bounds toLayer:top_layer];
    
    CGRect up_rect, down_rect, left_rect, right_rect;
    CGPoint left_down, right_down, left_up, right_up;
    
    NSNotification *n_stop;
    NSNotification *n_stop_back;
    NSNotification *n_stop_left;
    NSNotification *n_stop_right;
    NSNotification *n_restart;
    
    n_stop = [NSNotification notificationWithName:@"Stop" object:self];
    n_stop_back = [NSNotification notificationWithName:@"Stop_Back" object:self];
    n_stop_left = [NSNotification notificationWithName:@"Stop_Left" object:self];
    n_stop_right = [NSNotification notificationWithName:@"Stop_Right" object:self];
    n_restart = [NSNotification notificationWithName:@"Restart" object:self];
    
    
    left_down  = CGPointMake(window_frame.origin.x, window_frame.origin.y);
    left_up    = CGPointMake(window_frame.origin.x, window_frame.origin.y + window_frame.size.height);
    right_down = CGPointMake(window_frame.origin.x + window_frame.size.width, window_frame.origin.y);
    right_up   = CGPointMake(window_frame.origin.x + window_frame.size.width, window_frame.origin.y + window_frame.size.height);
    
    up_rect = CGRectMake(left_up.x, left_up.y,
                         window_frame.size.width, window_frame.size.height);
    down_rect = CGRectMake(left_down.x, left_down.y - window_frame.size.height,
                           window_frame.size.width, window_frame.size.height);
    left_rect = CGRectMake(left_down.x - window_frame.size.width, left_down.y,
                           window_frame.size.width, left_down.y + window_frame.size.height);
    right_rect = CGRectMake(right_down.x, right_down.y,
                            window_frame.size.width,  window_frame.size.height);
    
   
    if (CGRectIntersectsRect(layer_rect, up_rect)){
        [[NSNotificationCenter defaultCenter] postNotification:n_stop_right];
        return TRUE;
    }
    else if (CGRectIntersectsRect(layer_rect, down_rect)) {
        [[NSNotificationCenter defaultCenter] postNotification:n_stop_left];
        return TRUE;
    }
    else if (CGRectIntersectsRect(layer_rect, left_rect)) {
        [[NSNotificationCenter defaultCenter] postNotification:n_stop];
        return TRUE;
    }
    else if (CGRectIntersectsRect(layer_rect, right_rect)) {
        [[NSNotificationCenter defaultCenter] postNotification:n_stop_back];
        return TRUE;
    }
    
    [[NSNotificationCenter defaultCenter] postNotification:n_restart];
    
    return FALSE;
}
@end
