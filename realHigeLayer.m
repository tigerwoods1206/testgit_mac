//
//  realHigeLayer.m
//  pinch_touch
//
//  Created by オオタ イサオ on 2013/03/20.
//
//

#import "realHigeLayer.h"

@implementation realHigeLayer
@synthesize hairs;

- (id) initWithrealhigeLayer:(id)layer anchor:(CGPoint)_anchor origin:(CGPoint)_origin width:(CGFloat)_width height:(CGFloat)_height
{
    
    higeLayer *hair;
    CGPoint sh_anchor, sh_origin;
    int sh_width, sh_height;
    
    self = [super initWithLayer:layer];
    if(self){
        self.frame =
        CGRectMake(_origin.x, _origin.y, _width, _height);
        [self setNeedsDisplay];
    }
    
    hairs = [[NSMutableArray alloc] init];
    init_hige = [[NSMutableArray alloc] init];
    sh_width  = 30;
    sh_height = 3;
    sh_origin = CGPointMake(_origin.x, _origin.y);
    for (int i = 0; i < 5; i++) {
        sh_anchor = CGPointMake(0.2, 0.5);
        hair = [[higeLayer alloc] initWithHigeLayer:[CALayer layer]
                                             anchor:sh_anchor origin:sh_origin width:sh_width height:sh_height];
        [init_hige addObject:hair];
        hair.anchorPoint = CGPointMake(0.8, 0.5);
        sh_origin = CGPointMake(hair.frame.origin.x, hair.frame.origin.y);
        [self addSublayer:hair];
    }
    
    stop = FALSE;
    self.anchorPoint = CGPointMake(_anchor.x, _anchor.y);
    
    NSNotificationCenter *cn_lay = [NSNotificationCenter defaultCenter];
    [cn_lay addObserver:self selector:@selector(stop_motion) name:@"Stop" object:nil];
    [cn_lay addObserver:self selector:@selector(restart_motion) name:@"Restart" object:nil];
    
    return self;
    
}
- (void)stop_motion
{
    stop = TRUE;
}

- (void)restart_motion
{
    stop = FALSE;
}

- (void)drawInContext:(CGContextRef)ctx
{
    
//    CGContextSetFillColorWithColor(ctx, self.rect_color.CGColor);
//    CGContextFillRect(ctx, self.bounds);
//    // boundsは相対座標、frameは絶対座標
    
}
@end
