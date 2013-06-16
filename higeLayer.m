//
//  higeLayer.m
//  pinch_touch
//
//  Created by オオタ イサオ on 2013/03/05.
//
//

#import "higeLayer.h"

@implementation higeLayer

- (id)initWithHigeLayer:(id)layer anchor:(CGPoint)_anchor origin:(CGPoint)_origin width:(CGFloat)_width height:(CGFloat)_height{
    
    self = [super initWithLayer:layer];
    if(self){
        self.frame =
        CGRectMake(_origin.x, _origin.y, _width, _height);
        [self setNeedsDisplay];
    }
    self.rect_color = [UIColor blackColor];
    self.anchorPoint = CGPointMake(_anchor.x, _anchor.y);
    self.skinout_pos = CGPointMake(0, 0);
    self.init_pos    = CGPointMake(0, 0);
    self.touch_flg = FALSE;
    self.skinout_flg = FALSE;
    self.skinin_flg = FALSE;
    self.fallout_flg = FALSE;
    self.before_touching_flg = FALSE;
    self.pull_count = 0;
    self.tag = 0;
    self.good_angle_flg = FALSE;
    
    stop = FALSE;
    lock_flg = FALSE;
    numlimit_pull = 0;
    maxlimit_pull = 50;
    
    NSNotificationCenter *cn_lay = [NSNotificationCenter defaultCenter];
    [cn_lay addObserver:self selector:@selector(stop_motion) name:@"Stop" object:nil];
    [cn_lay addObserver:self selector:@selector(stop_back_motion) name:@"Stop_Back" object:nil];
    [cn_lay addObserver:self selector:@selector(stop_left_motion) name:@"Stop_Left" object:nil];
    [cn_lay addObserver:self selector:@selector(stop_right_motion) name:@"Stop_Right" object:nil];
    [cn_lay addObserver:self selector:@selector(restart_motion) name:@"Restart" object:nil];
    [cn_lay addObserver:self selector:@selector(toggle_lock_flg) name:@"Toggle_lock" object:nil];
    
    return self;
}

- (void)move_hige:(CGPoint)next_pos
{
    
    if (self.good_angle_flg) {
        if (stop==4) {
             numlimit_pull = numlimit_pull + 4;
        }
    }
    
    if (!stop) {
        self.position =  CGPointMake(self.position.x + next_pos.x, self.position.y + next_pos.y);
    } else if(stop == 2) {
        self.position =  CGPointMake(self.position.x -0.05, self.position.y);
        stop = FALSE;
       // numlimit_pull++;
        printf("%d\n",numlimit_pull);
    } else if (stop == 3) {
        self.position =  CGPointMake(self.position.x, self.position.y + 0.1);
        stop = FALSE;
    } else if (stop == 4) {
        self.position =  CGPointMake(self.position.x, self.position.y - 0.08);
        stop = FALSE;
        numlimit_pull++;
        printf("%d\n",numlimit_pull);
    } else if (stop == 1){
        self.position =  CGPointMake(self.position.x + 0.05, self.position.y);
        stop = FALSE;
      //  numlimit_pull++;
        printf("%d\n",numlimit_pull);
    }
    else {
        self.position =  CGPointMake(self.position.x, self.position.y + 0.1);
        printf("remove hige\n");
    }
    if (numlimit_pull > maxlimit_pull) {
        NSNotification *n_restart = [NSNotification notificationWithName:@"Restart" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:n_restart];
        numlimit_pull = 0;
    }

}

- (void)move_out_display
{
    self.position = CGPointMake(self.position.x, self.position.y - 1000);
    self.fallout_flg = 2;
}

- (void)stop_motion
{
    if (lock_flg) {
        return;
    }
    stop = TRUE;
    
}

- (void)stop_back_motion
{
    if (lock_flg) {
        return;
    }
  
    stop = 2;
//    if (numlimit_pull > maxlimit_pull) {
//        NSLog(@"numlimit_pull = %d",numlimit_pull);
//        stop = FALSE;
//        numlimit_pull = 0;
//    }
   
}

- (void)stop_left_motion
{
    if (lock_flg) {
        return;
    }
    stop = 3;
//    if (numlimit_pull > maxlimit_pull) {
//        NSLog(@"numlimit_pull = %d",numlimit_pull);
//        stop = FALSE;
//        numlimit_pull = 0;
//    }
}

- (void)stop_right_motion
{
    if (lock_flg) {
        return;
    }
    stop = 4;
//    if (numlimit_pull > maxlimit_pull) {
//        NSLog(@"numlimit_pull = %d",numlimit_pull);
//        stop = FALSE;
//        numlimit_pull = 0;
//    }
}

- (void)restart_motion
{
    if (lock_flg) {
        return;
    }
    stop = FALSE;
}

- (void)toggle_lock_flg
{
    if (!lock_flg) {
        lock_flg = TRUE;
    }
    else {
        lock_flg = FALSE;
    }
}

- (void)drawInContext:(CGContextRef)ctx
{
   
    CGContextSetFillColorWithColor(ctx, self.rect_color.CGColor);
    CGContextFillRect(ctx, self.bounds);
        // boundsは相対座標、frameは絶対座標
    
}

@end
