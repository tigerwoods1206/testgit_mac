//
//  is_collision_face_judge.h
//  pinch_touch
//
//  Created by オオタ イサオ on 2013/05/27.
//
//

#import "Layer.h"

@interface is_collision_face_judge : NSObject
+ (BOOL)reflection:(Layer *)layer face:(Layer *)face top_layer:(CALayer *)top_layer;
@end
