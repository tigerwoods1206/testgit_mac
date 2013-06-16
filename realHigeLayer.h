//
//  realHigeLayer.h
//  pinch_touch
//
//  Created by オオタ イサオ on 2013/03/20.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "higeLayer.h"

@interface realHigeLayer : CAShapeLayer {
    NSMutableArray *hairs;
    NSMutableArray *init_hige;
    int             stop;
}

@property(nonatomic ,strong)  NSMutableArray *hairs;

- (id) initWithrealhigeLayer:(id)layer anchor:(CGPoint)_anchor origin:(CGPoint)_origin width:(CGFloat)_width height:(CGFloat)_height;
- (void)stop_motion;
- (void)restart_motion;

@end
