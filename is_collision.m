//
//  is_collision.m
//  pinch_touch
//
//  Created by オオタ イサオ on 2013/03/10.
//
//

#import "is_collision.h"

@interface is_collision ()
- (BOOL) cross_2line:(CGPoint)fromline1 fromline2:(CGPoint)fromline2 toline1:(CGPoint)toline1 toline2:(CGPoint)toline2;
- (BOOL) is_point_in_rect:(CGPoint)fromline1 toline1:(CGPoint)toline1 fromline2:(CGPoint)fromline2 toline2:(CGPoint)toline2;
- (BOOL) is_point_online:(CGPoint)point fromline:(CGPoint)fromline toline:(CGPoint)toline;
@end

@implementation is_collision

- (id) initWithcollLayer:(id)layer {
       self = [super initWithLayer:layer];
    if(self){
        self.frame =
        CGRectMake(0, 0, 100, 100);
        [self setNeedsDisplay];
    }
    return self;
}

- (id)is_intersect_layer:(CALayer *)layer1 layer2:(CALayer *)layer2
{
    float angle1, angle2;
    CGPoint point1_xlyl, point1_xhyl, point1_xlyh, point1_xhyh;
    CGPoint point2_xlyl, point2_xhyl, point2_xlyh, point2_xhyh;
    
    CATransform3D rotationTransform1 = [layer1 transform];
    if(rotationTransform1.m11 < 0.0f) {
        angle1 = (180.0f - (asin(rotationTransform1.m12))*180.0f/M_PI);
    }
    else {
        angle1 = asin(rotationTransform1.m12)*180.0f/M_PI;
    }
    
    layer1.transform = CATransform3DMakeRotation(0 * M_PI/180, 0, 0, 1);
    CGFloat origin_x, origin_y, lay_width, lay_height;
    CGFloat rotate_cnter_x, rotate_cnter_y;
    CGPoint lay_anchor = layer1.anchorPoint;
    origin_x = layer1.frame.origin.x;
    origin_y = layer1.frame.origin.y;
    lay_width    = layer1.frame.size.width;
    lay_height   = layer1.frame.size.height;
    
    rotate_cnter_x = (origin_x + lay_width * lay_anchor.x);
    rotate_cnter_y = (origin_y + lay_height * lay_anchor.y);
    
    CGAffineTransform xfrm1 = CGAffineTransformMakeRotation(angle1 *  M_PI/180);
    point1_xlyl = CGPointApplyAffineTransform(CGPointMake(origin_x - rotate_cnter_x,
                                                          origin_y - rotate_cnter_y), xfrm1);
    point1_xlyl = CGPointMake(point1_xlyl.x + rotate_cnter_x, point1_xlyl.y + rotate_cnter_y);
    
    point1_xhyl = CGPointApplyAffineTransform(CGPointMake(origin_x - rotate_cnter_x + lay_width,
                                                          origin_y - rotate_cnter_y), xfrm1);
    point1_xhyl = CGPointMake(point1_xhyl.x + rotate_cnter_x, point1_xhyl.y + rotate_cnter_y);
    
    point1_xlyh = CGPointApplyAffineTransform(CGPointMake(origin_x - rotate_cnter_x,
                                                          origin_y - rotate_cnter_y + lay_height), xfrm1);
    point1_xlyh = CGPointMake(point1_xlyh.x + rotate_cnter_x, point1_xlyh.y + rotate_cnter_y);
    
    point1_xhyh = CGPointApplyAffineTransform(CGPointMake(origin_x - rotate_cnter_x + lay_width,
                                                          origin_y - rotate_cnter_y + lay_height), xfrm1);
    point1_xhyh = CGPointMake(point1_xhyh.x + rotate_cnter_x, point1_xhyh.y + rotate_cnter_y);
    
    layer1.transform = CATransform3DMakeRotation(angle1 * M_PI/180, 0, 0, 1);
    
    
    
    CATransform3D rotationTransform2 = [layer2 transform];
    if(rotationTransform2.m11 < 0.0f) {
        angle2 = (180.0f - (asin(rotationTransform2.m12))*180.0f/M_PI);
    }
    else {
        angle2 = asin(rotationTransform2.m12)*180.0f/M_PI;
    }
    
    layer2.transform = CATransform3DMakeRotation(0 * M_PI/180, 0, 0, 1);
    lay_anchor = layer2.anchorPoint;
    origin_x = layer2.frame.origin.x;
    origin_y = layer2.frame.origin.y;
    lay_width    = layer2.frame.size.width;
    lay_height   = layer2.frame.size.height;
    
    rotate_cnter_x = (origin_x + lay_width * lay_anchor.x);
    rotate_cnter_y = (origin_y + lay_height * lay_anchor.y);
    
    CGAffineTransform xfrm2 = CGAffineTransformMakeRotation(angle2 * M_PI/180);
    
    point2_xlyl = CGPointApplyAffineTransform(CGPointMake(origin_x - rotate_cnter_x,
                                                          origin_y - rotate_cnter_y), xfrm2);
    point2_xlyl = CGPointMake(point2_xlyl.x + rotate_cnter_x, point2_xlyl.y + rotate_cnter_y);
    
    point2_xhyl = CGPointApplyAffineTransform(CGPointMake(origin_x - rotate_cnter_x + lay_width,
                                                          origin_y - rotate_cnter_y), xfrm2);
    point2_xhyl = CGPointMake(point2_xhyl.x + rotate_cnter_x, point2_xhyl.y + rotate_cnter_y);
    
    point2_xlyh = CGPointApplyAffineTransform(CGPointMake(origin_x - rotate_cnter_x,
                                                          origin_y - rotate_cnter_y + lay_height), xfrm2);
    point2_xlyh = CGPointMake(point2_xlyh.x + rotate_cnter_x, point2_xlyh.y + rotate_cnter_y);
    
    point2_xhyh = CGPointApplyAffineTransform(CGPointMake(origin_x - rotate_cnter_x + lay_width,
                                                          origin_y - rotate_cnter_y + lay_height), xfrm2);
    point2_xhyh = CGPointMake(point2_xhyh.x + rotate_cnter_x, point2_xhyh.y + rotate_cnter_y);
    
    
    layer2.transform = CATransform3DMakeRotation(angle2 * M_PI/180, 0, 0, 1);
    
    NSMutableArray *point1s, *point2s;
    pair *line_points;
    
    point1s = [[NSMutableArray alloc] init];
    //  [point1s autorelease];
    
    line_points = [[pair alloc] init];
    line_points.pos1 = [NSValue valueWithCGPoint:point1_xlyl];
    line_points.pos2 = [NSValue valueWithCGPoint:point1_xhyl];
    [point1s addObject:line_points];
    //  [line_points autorelease];
    
    line_points = [[pair alloc] init];
    line_points.pos1 = [NSValue valueWithCGPoint:point1_xhyl];
    line_points.pos2 = [NSValue valueWithCGPoint:point1_xhyh];
    [point1s addObject:line_points];
    //   [line_points autorelease];
    
    line_points = [[pair alloc] init];
    line_points.pos1 = [NSValue valueWithCGPoint:point1_xhyh];
    line_points.pos2 = [NSValue valueWithCGPoint:point1_xlyh];
    [point1s addObject:line_points];
    //   [line_points autorelease];
    
    line_points = [[pair alloc] init];
    line_points.pos1 = [NSValue valueWithCGPoint:point1_xlyh];
    line_points.pos2 = [NSValue valueWithCGPoint:point1_xlyl];
    [point1s addObject:line_points];
    //  [line_points autorelease];
    
    point2s = [[NSMutableArray alloc] init];
    //   [point2s autorelease];
    
    line_points = [[pair alloc] init];
    line_points.pos1 = [NSValue valueWithCGPoint:point2_xlyl];
    line_points.pos2 = [NSValue valueWithCGPoint:point2_xhyl];
    [point2s addObject:line_points];
    //   [line_points autorelease];
    
    line_points = [[pair alloc] init];
    line_points.pos1 = [NSValue valueWithCGPoint:point2_xhyl];
    line_points.pos2 = [NSValue valueWithCGPoint:point2_xhyh];
    [point2s addObject:line_points];
    //   [line_points autorelease];
    
    line_points = [[pair alloc] init];
    line_points.pos1 = [NSValue valueWithCGPoint:point2_xhyh];
    line_points.pos2 = [NSValue valueWithCGPoint:point2_xlyh];
    [point2s addObject:line_points];
    //   [line_points autorelease];
    
    line_points = [[pair alloc] init];
    line_points.pos1 = [NSValue valueWithCGPoint:point2_xlyh];
    line_points.pos2 = [NSValue valueWithCGPoint:point2_xlyl];
    [point2s addObject:line_points];
    //    [line_points autorelease];
    
    UIBezierPath*	bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:point1_xlyl];
    CGPoint fromline1, fromline2, toline1, toline2;
   
    [bezier addLineToPoint:point1_xlyl];
    [bezier addLineToPoint:point1_xlyh];
    [bezier addLineToPoint:point1_xhyh];
    [bezier addLineToPoint:point1_xhyl];
   
    int flag = 0;
    for (pair *line1s in point1s) {
        for(pair *line2s in point2s) {
            fromline1 = [line1s.pos1 CGPointValue];
            toline1   = [line1s.pos2 CGPointValue];
            
            fromline2 = [line2s.pos1 CGPointValue];
            toline2   = [line2s.pos2 CGPointValue];
            
            [bezier addLineToPoint:fromline1];
            [bezier addLineToPoint:toline1];
            if ([self is_point_in_rect:fromline1 toline1:toline1 fromline2:fromline2 toline2:toline2] ) {
                ++flag;
            }
            
        }
        
        if (flag == 4) {
            return self;
        }
        flag = 0;
    }
     

    [bezier closePath];

    self.strokeColor = [UIColor orangeColor].CGColor;
    self.fillColor = [UIColor orangeColor].CGColor;
    self.lineWidth = 4.0;
    self.path = bezier.CGPath;

    
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    
    //    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    //    CGContextFillRect(ctx, self.bounds);
}


@end
