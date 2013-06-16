//
//  Layer.m
//  pinch_touch
//
//  Created by オオタ イサオ on 13/02/06.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Layer.h"

@implementation pair
@synthesize pos1, pos2;

@end

@interface Layer ()
- (BOOL) cross_2line:(CGPoint)fromline1 fromline2:(CGPoint)fromline2 toline1:(CGPoint)toline1 toline2:(CGPoint)toline2;
- (BOOL) is_point_in_rect:(CGPoint)fromline1 toline1:(CGPoint)toline1 fromline2:(CGPoint)fromline2 toline2:(CGPoint)toline2;
- (BOOL) is_point_online:(CGPoint)point fromline:(CGPoint)fromline toline:(CGPoint)toline;
@end

@implementation Layer
@synthesize radius;
@synthesize circle_flg;
@synthesize pre_pt, center;
@synthesize rect_color;

@synthesize width, height;

- (id)initWithLayer:(id)layer center:(CGPoint)_center radius:(CGFloat)_radius;
{
    self = [super initWithLayer:layer];
    if(self){
        self.frame = 
        CGRectMake(_center.x - _radius, _center.y - _radius, 2*_radius, 2*_radius);
        [self setNeedsDisplay];
    }
    self.rect_color = [UIColor blackColor];
    self.center   = CGPointMake(_center.x, _center.y);
    self.radius = _radius;
    self.pre_pt   = CGPointMake(0, 0);
    self.circle_flg = TRUE;
    self.good_angle_flg = FALSE;
    return self;
}

- (id)initWithRectLayer:(id)layer anchor:(CGPoint)_anchor origin:(CGPoint)_origin width:(CGFloat)_width height:(CGFloat)_height{
    self = [super initWithLayer:layer];
    if(self){
        self.frame = 
        CGRectMake(_origin.x, _origin.y, _width, _height);
        [self setNeedsDisplay];
    }
    self.rect_color = [UIColor blackColor];
    self.width     = _width;
    self.height    = _height;
    self.anchorPoint = CGPointMake(_anchor.x, _anchor.y);
    self.pre_pt    = CGPointMake(0, 0);
    self.circle_flg = FALSE;
    stop = FALSE;
    stack_stop_flg = -2;
    numlimit_pull = 0;
    maxlimit_pull = 50;
    
    cn_lay = [NSNotificationCenter defaultCenter];
    [cn_lay addObserver:self selector:@selector(stop_motion) name:@"Stop" object:nil];
    [cn_lay addObserver:self selector:@selector(stop_back_motion) name:@"Stop_Back" object:nil];
    [cn_lay addObserver:self selector:@selector(stop_left_motion) name:@"Stop_Left" object:nil];
    [cn_lay addObserver:self selector:@selector(stop_right_motion) name:@"Stop_Right" object:nil];

    [cn_lay addObserver:self selector:@selector(restart_motion) name:@"Restart" object:nil];
    [cn_lay addObserver:self selector:@selector(toglle_stack_stop) name:@"Toggle_Stack_Stop" object:nil];
    
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetFillColorWithColor(ctx, self.rect_color.CGColor);
    if (self.circle_flg) {
        CGContextFillEllipseInRect(ctx, self.bounds);

    }
    else  {
        CGContextFillRect(ctx, self.bounds);
    }
    // boundsは相対座標、frameは絶対座標

}

- (BOOL)isCircleArea:(CGPoint)point
{
    CGPoint t_center;
    CGFloat t_radius;
    
    if (self.circle_flg) {
        t_center = CGPointMake(self.center.x, self.center.y);
        t_radius = self.radius;
        double dist = 
        sqrt((point.x - t_center.x)*(point.x - t_center.x) + (point.y - t_center.y)*(point.y - t_center.y));
        if (dist <= t_radius) {
            return TRUE;
        }
        else {
            return FALSE;
        }

    }
    
       // t_center = CGPointMake(self.width/10 + self.frame.origin.x, self.height/10 + self.frame.origin.y);
    CGRect twice_rect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height * 3);
    if(CGRectContainsPoint(twice_rect, point)) 
    {
        printf("rect touch\n");
        return TRUE;

    }    else return FALSE;    
        
}

- (BOOL) is_intersect_circlelay:(Layer *)layer1 layer2:(Layer *)layer2
{
    if (!layer1.circle_flg || !layer2.circle_flg) {
        return FALSE;
    }
    
    CGFloat dist_lay1_lay2 = 0;
    CGFloat x = (layer1.center.x - layer2.center.x);
    CGFloat y = (layer1.center.y - layer2.center.y);
    dist_lay1_lay2 = sqrtf(x*x + y*y);
    
    if (dist_lay1_lay2 > layer1.radius + layer2.radius) {
        return FALSE;
    }
    
    return TRUE;
}


- (BOOL)is_intersect_layer:(CALayer *)layer1 layer2:(CALayer *)layer2
{
    float angle1, angle2, top_angle;
    CGPoint point1_xlyl, point1_xhyl, point1_xlyh, point1_xhyh;
    CGPoint point2_xlyl, point2_xhyl, point2_xlyh, point2_xhyh;
    CATransform3D rotationTransform1, rotationTransform_top;
    
    rotationTransform_top = [self transform];
    if(rotationTransform_top.m11 < 0.0f) {
        top_angle = (180.0f - (asin(rotationTransform_top.m12))*180.0f/M_PI);
    }
    else {
        top_angle = asin(rotationTransform_top.m12)*180.0f/M_PI;
    }
    
    rotationTransform1 = [layer1 transform];
    if(rotationTransform1.m11 < 0.0f) {
        angle1 = (180.0f - (asin(rotationTransform1.m12))*180.0f/M_PI);
    }
    else {
        angle1 = asin(rotationTransform1.m12)*180.0f/M_PI;
    }
    
    CGFloat origin_x, origin_y, lay_width, lay_height;
    CGFloat rotate_cnter_x, rotate_cnter_y;
    CGPoint origin_lay;
    CGPoint lay_anchor = layer1.anchorPoint;
//    origin_x = layer1.frame.origin.x;
//    origin_y = layer1.frame.origin.y;
    
    self.transform = CATransform3DMakeRotation(0 * M_PI/180, 0, 0, 1);
    layer1.transform = CATransform3DMakeRotation(0 * M_PI/180, 0, 0, 1);
    origin_lay     = [self convertPoint:layer1.bounds.origin fromLayer:layer1];
    origin_lay     = [self.superlayer convertPoint:origin_lay fromLayer:self];
    origin_x = origin_lay.x;
    origin_y = origin_lay.y;
    lay_width    = layer1.frame.size.width;
    lay_height   = layer1.frame.size.height;
    
    rotate_cnter_x = (origin_x + lay_width * lay_anchor.x);
    rotate_cnter_y = (origin_y + lay_height * lay_anchor.y);
    
    CGAffineTransform xfrm1 = CGAffineTransformMakeRotation((angle1) *  M_PI/180);
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
    
    origin_x = self.frame.origin.x;
    origin_y = self.frame.origin.y;
    lay_width = self.frame.size.width;
    lay_height = self.frame.size.height;
    
    rotate_cnter_x = (origin_x + lay_width  * self.anchorPoint.x);
    rotate_cnter_y = (origin_y + lay_height * self.anchorPoint.y);
    
    xfrm1 = CGAffineTransformMakeRotation((top_angle) *  M_PI/180);
    
    point1_xlyl = CGPointApplyAffineTransform(CGPointMake(point1_xlyl.x - rotate_cnter_x,
                                                          point1_xlyl.y - rotate_cnter_y), xfrm1);
    
    point1_xlyl = CGPointMake(point1_xlyl.x + rotate_cnter_x, point1_xlyl.y + rotate_cnter_y);
    
    point1_xhyl = CGPointApplyAffineTransform(CGPointMake(point1_xhyl.x - rotate_cnter_x,
                                                          point1_xhyl.y - rotate_cnter_y), xfrm1);
    
    point1_xhyl = CGPointMake(point1_xhyl.x + rotate_cnter_x, point1_xhyl.y + rotate_cnter_y);
    
    point1_xlyh = CGPointApplyAffineTransform(CGPointMake(point1_xlyh.x - rotate_cnter_x,
                                                          point1_xlyh.y - rotate_cnter_y), xfrm1);
    
    point1_xlyh = CGPointMake(point1_xlyh.x + rotate_cnter_x, point1_xlyh.y + rotate_cnter_y);
    
    point1_xhyh = CGPointApplyAffineTransform(CGPointMake(point1_xhyh.x - rotate_cnter_x,
                                                          point1_xhyh.y - rotate_cnter_y), xfrm1);
    
    point1_xhyh = CGPointMake(point1_xhyh.x + rotate_cnter_x, point1_xhyh.y + rotate_cnter_y);
    
    
    self.transform = CATransform3DMakeRotation(top_angle * M_PI/180, 0, 0, 1);
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
//    origin_lay = [self.superlayer convertPoint:layer2.bounds.origin fromLayer:layer2];
    origin_x = layer2.frame.origin.x;
    origin_y = layer2.frame.origin.y;
//    origin_x = origin_lay.x;
//    origin_y = origin_lay.y;
    lay_width    = layer2.frame.size.width;
    lay_height   = layer2.frame.size.height;
    
    rotate_cnter_x = (origin_x + lay_width * lay_anchor.x);
    rotate_cnter_y = (origin_y + lay_height * lay_anchor.y);    
   
    CGAffineTransform xfrm2 = CGAffineTransformMakeRotation((0) * M_PI/180);
   
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
//    [line_points autorelease];
    
    line_points = [[pair alloc] init];
    line_points.pos1 = [NSValue valueWithCGPoint:point1_xhyl];
    line_points.pos2 = [NSValue valueWithCGPoint:point1_xhyh];
    [point1s addObject:line_points];
//    [line_points autorelease];
    
    line_points = [[pair alloc] init];
    line_points.pos1 = [NSValue valueWithCGPoint:point1_xhyh];
    line_points.pos2 = [NSValue valueWithCGPoint:point1_xlyh];
    [point1s addObject:line_points];
//    [line_points autorelease];
    
    line_points = [[pair alloc] init];
    line_points.pos1 = [NSValue valueWithCGPoint:point1_xlyh];
    line_points.pos2 = [NSValue valueWithCGPoint:point1_xlyl];
    [point1s addObject:line_points];
  //  [line_points autorelease];
    
    point2s = [[NSMutableArray alloc] init];
  //  [point2s autorelease];
    
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
//    [line_points autorelease];
    
    line_points = [[pair alloc] init];
    line_points.pos1 = [NSValue valueWithCGPoint:point2_xlyh];
    line_points.pos2 = [NSValue valueWithCGPoint:point2_xlyl];
    [point2s addObject:line_points];
//    [line_points autorelease];
    
    int flag;
    flag = 0;
    CGPoint fromline1, fromline2, toline1, toline2;

    for (pair *line1s in point1s) {
        for(pair *line2s in point2s) {
            fromline1 = [line1s.pos1 CGPointValue];
            toline1   = [line1s.pos2 CGPointValue];
            
            fromline2 = [line2s.pos1 CGPointValue];
            toline2   = [line2s.pos2 CGPointValue];
            
            if ([self cross_2line:fromline1 fromline2:fromline2 toline1:toline1 toline2:toline2]) {
                return TRUE;
            }
        }
    }
       
    return FALSE;
}

- (BOOL) is_point_in_rect:(CGPoint)fromline1 toline1:(CGPoint)toline1 fromline2:(CGPoint)fromline2 toline2:(CGPoint)toline2
{
    CGFloat cross_section1, cross_section2;
    CGFloat vx1, vy1, vx2, vy2, xp,yp;
    
    vx1 = fromline2.x;
    vy1 = fromline2.y;
    vx2 = toline2.x;
    vy2 = toline2.y;
    xp  = fromline1.x;
    yp  = fromline1.y;
    
    cross_section1 = (vx2-vx1)*(yp-vy1) - (xp-vx1)*(vy2-vy1);
   
    
    xp  = toline1.x;
    yp  = toline1.y;
    
    cross_section2 = (vx2-vx1)*(yp-vy1) - (xp-vx1)*(vy2-vy1);
   
    if (cross_section1 < 0 || cross_section2 < 0) {
        return TRUE;
    }
    
    return FALSE;
    
}

- (BOOL)cross_2line:(CGPoint)fromline1 fromline2:(CGPoint)fromline2 toline1:(CGPoint)toline1 toline2:(CGPoint)toline2
{
    CGPoint cross_pos;
    
    CGFloat a, b, c, d;
    CGFloat x1, x2;
    int x1_flg, x2_flg;
    
    x1_flg = x2_flg = FALSE;
    //fromline ax + b
    if(fromline1.x - toline1.x == 0 ) {
        x1 = toline1.x;
        x1_flg = TRUE;
    }
    else {
        a = (fromline1.y - toline1.y) / (fromline1.x - toline1.x);
        b = fromline1.y - a * fromline1.x;
    }
    // toline cx + d
    if (fromline2.x - toline2.x == 0) {
        x2 = fromline2.x;
        x2_flg = TRUE;
    }
    else {
        c = (fromline2.y - toline2.y) / (fromline2.x - toline2.x);
        d = fromline2.y - c * fromline2.x;
    }
    
    if (a - c == 0) return FALSE;
    if (x1_flg && x2_flg) {
        return FALSE;
    }
    else if (x1_flg) {
        cross_pos = CGPointMake(x1, x1 * c + d);
    }
    else if (x2_flg) {
        cross_pos = CGPointMake(x2, x2 * a + b);
    }
    else {
        cross_pos = CGPointMake((b-d)/(a-c), a * (b-d)/(a-c) + b);
    }
    if (
        [self is_point_online:cross_pos fromline:fromline1 toline:toline1] &&
        [self is_point_online:cross_pos fromline:fromline2 toline:toline2]
        ) {
        return TRUE;
    }
    return  FALSE;
}

- (BOOL) is_point_online:(CGPoint)point fromline:(CGPoint)fromline toline:(CGPoint)toline
{
    CGFloat minx, maxx, miny, maxy;

    minx = MIN(fromline.x, toline.x);
    maxx = MAX(fromline.x, toline.x);
    miny = MIN(fromline.y, toline.y);
    maxy = MAX(fromline.y, toline.y);
    
    if (
        ((point.x >= minx) && (point.x <= maxx)) &&
        ((point.y >= miny) && (point.y <= maxy))
        ) {
        return TRUE;
    }
    return FALSE;
    
}

- (void)move_Layer:(CGPoint)next_pos pull:(int)pull_flg
{
    
    if (self.good_angle_flg && pull_flg) {
        numlimit_pull = maxlimit_pull+4;
    }
    
    if (!stop) {
        self.position =  CGPointMake(self.position.x + next_pos.x, self.position.y + next_pos.y);
    } else if(stop == 2) {
        CGFloat dx;
        dx = 0.1;
        
        if (pull_flg) {
            numlimit_pull++;
            dx = 0.05;
           // dx = 0;
        }
        else {
            dx = 0.2;
        }
        
        self.position =  CGPointMake(self.position.x - dx, self.position.y);
        printf("stop_back_lay %d\n",numlimit_pull);
        
        stop = FALSE;
    } else if (stop == 3) { //stop_left
        
        printf("stop_left_lay%d\n",numlimit_pull);
        CGFloat dy;
        if (pull_flg) {
            numlimit_pull++;
            dy = 0.1;
            //dy = 0;
        }
        else {
            dy = 1;
        }
        self.position =  CGPointMake(self.position.x, self.position.y + dy);
        stop = FALSE;
    } else if (stop == 4) { //stop_right
        
        printf("stop_right_lay%d\n",numlimit_pull);
        CGFloat dy;
        dy = 0.1;
        
        if (pull_flg) {
            numlimit_pull++;
            dy = 0.08;
        }
        else {
            dy = 1;
        }

        self.position =  CGPointMake(self.position.x, self.position.y - dy);
        stop = FALSE;
    } else if (stop == 1){
        CGFloat dx;
        dx = 0.1;
        
        if (pull_flg) {
            numlimit_pull++;
            dx = 0.05;
        }
        else {
            dx = 0.2;
        }
        self.position =  CGPointMake(self.position.x + dx, self.position.y);
        printf("stop_top_lay%d\n",numlimit_pull);
        stop = FALSE;
    }
    else {
        self.position =  CGPointMake(self.position.x , self.position.y + 0.1);
        printf("remove hige\n");
    }
    
}

- (void)set_Layer_angle:(CGFloat)angle
{
   self.transform = CATransform3DMakeRotation(angle * M_PI/180, 0, 0, 1);
   
}

- (void)rotate_Layer:(CGFloat)angle
{
  
    CATransform3D trans;
    trans = CATransform3DRotate(self.transform, angle, 0, 0, 1);
    self.transform = trans;
    
}

- (void)stop_back_motion
{
    stop = 2;
    printf("lay_stop_back\n");
//   
//    if (numlimit_pull > maxlimit_pull) {
//        NSLog(@"numlimit_pull = %d",numlimit_pull);
//        stop = FALSE;
//        numlimit_pull = 0;
//    }
}

- (void)stop_left_motion
{
    stop = 3;
}

- (void)stop_right_motion
{
    stop = 4;
}

- (void)stop_motion
{
    stop = TRUE;
    printf("lay_stop_top\n");
}

- (void)restart_motion
{
    stop = FALSE;
}

- (void)toglle_stack_stop
{
    if (stack_stop_flg == -2) {
        stack_stop_flg = stop;
    }
    else {
        stop = stack_stop_flg;
        stack_stop_flg = -2;
    }
}


@end
