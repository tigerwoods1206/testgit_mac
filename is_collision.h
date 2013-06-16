//
//  is_collision.h
//  pinch_touch
//
//  Created by オオタ イサオ on 2013/03/10.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Layer.h"


@interface is_collision : CAShapeLayer 
{
    
}

- (id) initWithcollLayer:(id)layer;
- (id) is_intersect_layer:(CALayer *)layer1 layer2:(CALayer *)layer2;
@end
