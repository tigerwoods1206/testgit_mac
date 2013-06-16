//
//  in_window_wall_judge.h
//  pinch_touch
//
//  Created by オオタ イサオ on 2013/05/23.
//
//

#import "Layer.h"

@interface in_window_wall_judge : NSObject
{
    
}
+ (BOOL)is_in_window:(Layer *)layer window_frame:(CGRect)window_frame top_layer:(CALayer *)top_layer;
@end
