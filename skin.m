//
//  skin.m
//  pinch_touch
//
//  Created by オオタ イサオ on 2013/02/28.
//
//

#import "skin.h"

@implementation skin
@synthesize hairs;


- (id) initWithSkinLayer:(id)layer win_frame:(CGRect)win_frame
{
    higeLayer *hair;
    CGPoint origin;
    NSValue *point;
    CGPoint pre, cur, next;
    int width, height;
    skin_width = 80;
    hige_space = 10;
    limit_pos  = CGPointMake( hige_space, 25);
    
    self = [super initWithLayer:layer];
    if(self){
        self.frame =
        CGRectMake(0, 0, skin_width, 600);
        [self setNeedsDisplay];
    }
    
    anchor = CGPointMake(0.5, 0.5);
    local_win_frame =  CGRectMake(win_frame.origin.x, win_frame.origin.y, win_frame.size.width, win_frame.size.height);
    //win_frame.origin.x, win_frame.origin.y, win_frame.size.width, win_frame.size.height
    hairs = [[NSMutableArray alloc] init];
    hairs_path =  [[NSMutableArray alloc] init];
    hairs_first_last = [[NSMutableArray alloc] init];
    init_path = [[NSMutableArray alloc] init];
    
    CGFloat scale = [UIScreen mainScreen].scale;
     srand((unsigned)time(NULL));
    
    [self read_plist:@"namihei_face_ke" pointname:@"namihei_face" scale:scale win_size_y:win_frame.size.height];
    for (NSValue *hige in hairs_path) {
        CGFloat angle;
       
        width  = 5;
        height = 50;
        origin = [hige CGPointValue];
        origin = CGPointMake(origin.x, origin.y);
       
        angle = rand() % 20;
        angle = 20/2 - angle;
      
        hair = [[higeLayer alloc] initWithHigeLayer:[CAShapeLayer layer] anchor:anchor origin:origin width:width height:height];
        hair.transform = CATransform3DMakeRotation(angle * M_PI/180, 0, 0, 1);
        
//        CATransform3D trans = CATransform3DMakeRotation(180 * M_PI / 180, 0.0, 0.0, 1);
//        hair.transform = trans;

        hair.init_pos = CGPointMake(hair.position.x, hair.position.y);
        
        [hairs addObject:hair];
        
        pre = CGPointMake(hair.frame.origin.x - 0.5 * hige_space, hair.frame.origin.y);
        point = [NSValue valueWithCGPoint:pre];
        [init_path addObject:point];
        
        cur = CGPointMake(hair.frame.origin.x, hair.frame.origin.y);
        point = [NSValue valueWithCGPoint:cur];
        [init_path addObject:point];
        
        next = CGPointMake(hair.frame.origin.x + 0.5 * hige_space, hair.frame.origin.y);
        point = [NSValue valueWithCGPoint:next];
        [init_path addObject:point];
        
        [self addSublayer:hair];
      //  [hair release];
    }
    [self update_Skin];
    
    return self;
}

- (void) restart_Skin
{
    [self read_plist:@"namihei_hair" pointname:@"namihei" scale:2 win_size_y:local_win_frame.size.height];
    for (higeLayer *hair in self.hairs) {
        CGFloat angle;
        angle = rand() % 20;
        angle = 20/2 - angle;
        
        hair.position = CGPointMake( hair.init_pos.x, hair.init_pos.y);
        hair.transform = CATransform3DMakeRotation(angle * M_PI/180, 0, 0, 1);
        
        //hair.anchorPoint = CGPointMake(tmp_anchor.x, tmp_anchor.y);
        hair.skinout_pos = CGPointMake(0, 0);
        hair.touch_flg = FALSE;
        hair.skinout_flg = FALSE;
        hair.skinin_flg = FALSE;
        hair.fallout_flg = FALSE;
        hair.before_touching_flg = FALSE;
        hair.good_angle_flg = FALSE;
        hair.tag = 0;
    }
   [self update_Skin];

}

- (void)update_Skin
{
    NSNotification *n_stop = [NSNotification notificationWithName:@"Stop" object:self];
    NSNotification *n_stop_back = [NSNotification notificationWithName:@"Stop_Back" object:self];
    NSNotification *n_stop_left = [NSNotification notificationWithName:@"Stop_Left" object:self];
    NSNotification *n_stop_right = [NSNotification notificationWithName:@"Stop_Right" object:self];
 //   NSNotification *n_skinout_fall = [NSNotification notificationWithName:@"Skinout_fall" object:self];
    
    NSNotification *n_restart = [NSNotification notificationWithName:@"Restart" object:self];
    UIBezierPath*	bezier = [UIBezierPath bezierPath];
    CGPoint start, end;
    NSMutableArray *path;
    NSValue *point;
    CGPoint pre, cur, cur_pre, cur_post, next, init_pos;
    
    
    path = [[NSMutableArray alloc] init];
   
    int i = 0;
    int x_right;
    CGFloat limit_x, cur_x;
    for (higeLayer *cur_lay in self.sublayers) {
        if (cur_lay.tag == 1) {
         //   printf("first time hige in skin.m\n");
        }
        limit_x = 0;
        point = [init_path objectAtIndex:(i+1)];
        init_pos = [point CGPointValue];
        if (cur_lay.touch_flg && !cur_lay.skinout_flg) {
            cur_x = cur_lay.frame.origin.x;
            limit_x = fabs(cur_x - init_pos.x);
            x_right = cur_x - init_pos.x;
            
            if (cur_lay.frame.origin.y < init_pos.y - limit_pos.y ) {
                [[NSNotificationCenter defaultCenter] postNotification:n_stop_left];
            }
            else if(
                  (
                   (cur_lay.frame.origin.y >= init_pos.y - limit_pos.y)
                  && (cur_lay.frame.origin.y <= init_pos.y + limit_pos.y)
                   )
                  && (limit_x <= limit_pos.x/2)
                    ){
                [[NSNotificationCenter defaultCenter] postNotification:n_restart];
                printf("n_restart in skin\n");

            }
            else if(
                    (cur_lay.frame.origin.y > init_pos.y + limit_pos.y)
                    ) {
                [[NSNotificationCenter defaultCenter] postNotification:n_stop_right];
                cur_lay.pull_count++;
                
                printf("post_stop_back in skin\n");
            }
            
            if (limit_x > limit_pos.x/2) {
                if(x_right > 0){
                    [[NSNotificationCenter defaultCenter] postNotification:n_stop];
                     cur_lay.pull_count++;
                }
                else if(x_right < 0) {
                    [[NSNotificationCenter defaultCenter] postNotification:n_stop_back];
                     cur_lay.pull_count++;
                }
            }
           
        }
        
        if(   (
                   (init_pos.y + limit_pos.y + 1 >= cur_lay.frame.origin.y) &&
                  (limit_pos.x >= limit_x)
               )&&
              (!cur_lay.skinout_flg)
           ) {
            
            // during skin 
            
            point = [init_path objectAtIndex:i++];
            init_pos = [point CGPointValue];
            pre = CGPointMake(init_pos.x  - 0.5 * hige_space, init_pos.y);
            point = [NSValue valueWithCGPoint:pre];
            [path addObject:point];

            point = [init_path objectAtIndex:i++];
            init_pos = [point CGPointValue];
            cur = CGPointMake(cur_lay.frame.origin.x, cur_lay.frame.origin.y);// cur_lay.frame.origin.x + 15 (15 = to anchor)
            point = [NSValue valueWithCGPoint:cur];
            [path addObject:point];
            
            point = [init_path objectAtIndex:i++];
            init_pos = [point CGPointValue];
            next = CGPointMake(init_pos.x  + 0.5 * hige_space, init_pos.y);
            point = [NSValue valueWithCGPoint:next];
            [path addObject:point];
        }
        else {
            // after skinout
            
            if (!cur_lay.skinout_flg) {
                cur_lay.skinout_pos = CGPointMake( cur_lay.frame.origin.x,  cur_lay.frame.origin.y);
            }
            
            cur_lay.skinout_flg = TRUE;
            
           // [[NSNotificationCenter defaultCenter] postNotification:n_skinout_fall];
            
            init_pos = [[init_path objectAtIndex:i++] CGPointValue];
            pre = CGPointMake(init_pos.x  - 0.5 * hige_space, init_pos.y);
            
            point = [NSValue valueWithCGPoint:pre];
            [path addObject:point];
            
            init_pos = [[init_path objectAtIndex:i++] CGPointValue];
          //  cur = CGPointMake(init_pos.x , cur_lay.skinout_pos.y);
            cur = CGPointMake(cur_lay.skinout_pos.x , init_pos.y);
            point = [NSValue valueWithCGPoint:cur];
            [path addObject:point];
            
            init_pos = [[init_path objectAtIndex:i++] CGPointValue];
         //   next = CGPointMake(init_pos.x , init_pos.y + 0.5 * hige_space);
            next = CGPointMake(init_pos.x + 0.5 * hige_space , init_pos.y);
            point = [NSValue valueWithCGPoint:next];
            [path addObject:point];
           
            if (cur_lay.skinout_flg) {
                if (!cur_lay.fallout_flg) {
                    if (cur_lay.before_touching_flg && !cur_lay.touch_flg) {
                        cur_lay.fallout_flg = 1;
                      //[[NSNotificationCenter defaultCenter] postNotification:n_skinout_fall];
                        cur_lay.pull_count = 0;
                        
                    }
                    else if (cur_lay.touch_flg) {
                        cur_lay.before_touching_flg = TRUE;
                    }
                }
            }
        }
    }
    
//    [path autorelease];
    
//    start      = CGPointMake(self.frame.origin.x, self.frame.origin.y);
//    next_start = CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y);
//    pre_end    = CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.frame.size.height);
//    end        = CGPointMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height);
    
//    bezier.lineWidth = 1;
    start = [[hairs_first_last objectAtIndex:0] CGPointValue];
    end   = [[hairs_first_last objectAtIndex:1] CGPointValue];
    [bezier moveToPoint:start];
    [bezier addLineToPoint:start];
//    [bezier addLineToPoint:next_start];

    i = 0;
    int k=0;
    for (NSValue *cur_val  in path) {
        if(k == 0) {
            [bezier moveToPoint: [cur_val CGPointValue]];
        }
       
        switch (i) {
            case 0:
                pre  = [cur_val CGPointValue];
                break;
            case 1:
                cur  = [cur_val CGPointValue];
                cur_pre  = CGPointMake(cur.x - hige_space * 0.2, cur.y );
                cur_post = CGPointMake(cur.x + hige_space * 0.2, cur.y );
            case 2:
                next =  [cur_val CGPointValue];
             
                [bezier addQuadCurveToPoint:next controlPoint:cur];
                //[bezier addCurveToPoint:next controlPoint1:cur_pre controlPoint2:cur_post];
                i = 0;
                break;
            default:
                break;
        }
     
        i++;
        k++;
    }
    
//    [bezier addLineToPoint:pre_end];
    [bezier addLineToPoint:end];
    [bezier closePath];
 //   [bezier fill];
//    [bezier stroke];

    self.strokeColor = [UIColor colorWithRed:1.0 green:204.0/255 blue:102.0/255 alpha:1.0].CGColor;
    self.fillColor = [UIColor colorWithRed:1.0 green:204.0/255 blue:102.0/255 alpha:1.0].CGColor;// cantalope
    self.lineWidth = 2.0;

    self.path = bezier.CGPath;
    
   }

-(void) read_plist:(NSString *)plistname pointname:(NSString *)pointname scale:(CGFloat)scale win_size_y:(CGFloat)win_size_y
{
    NSString *points, *path;
    NSDictionary *pointdict;
    NSArray *pointarr, *polygon_item;
    NSError *err;
    //int     shape_flg = 1;// 1=polygon, 2=circle;
    
    pointarr = nil; 
    
    path = [[NSBundle mainBundle] pathForResource:plistname ofType:@"plist"];
    points = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    pointdict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *child_d = [pointdict objectForKey:@"bodies"];
    NSDictionary *child2_d = [child_d objectForKey:pointname];
    NSArray *child3_d = [child2_d objectForKey:@"fixtures"];
    for (NSObject *d in child3_d) {
        if ( [d isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)d;
            if ([dict.allKeys containsObject:@"polygons"]) {
                pointarr = [dict objectForKey:@"polygons"];
            }        
            break;
        }
    }
    
    NSString *allstring =[NSString stringWithFormat:@""];
    CGPoint tmp_point;
    NSValue *val_point;
    
    polygon_item = [pointarr objectAtIndex:0];
    CGSize sc_size = [[UIScreen mainScreen] bounds].size;
    for (NSString *str in polygon_item) {
        NSString *strpos = [str stringByTrimmingCharactersInSet:
                            [NSCharacterSet characterSetWithCharactersInString:@"{}"]];
        [allstring stringByAppendingString:strpos];
        NSArray *strarr = [strpos componentsSeparatedByCharactersInSet:
                           [NSCharacterSet characterSetWithCharactersInString:@","]];
        NSString *valx = (NSString *)[strarr objectAtIndex:0];
        NSString *valy = (NSString *)[strarr objectAtIndex:1];
      
        //tmp_point = CGPointMake([valx floatValue]/2, sc_size.height - [valy floatValue]/2);
        tmp_point = CGPointMake([valx floatValue]/win_size_y * sc_size.height,
                                sc_size.height - [valy floatValue]/win_size_y * sc_size.height );
        val_point = [NSValue valueWithCGPoint:tmp_point];
        [hairs_path insertObject:val_point atIndex:0];
    }
    [hairs_path sortUsingComparator:^NSComparisonResult(id item1, id item2) {
        CGFloat x1 = [item1 CGPointValue].x;
        CGFloat x2 = [item2 CGPointValue].x;
        NSNumber *x1_num = [NSNumber numberWithFloat:x1];
        NSNumber *x2_num = [NSNumber numberWithFloat:x2];
        return [x1_num compare:x2_num];
    }];

    [hairs_first_last addObject:[hairs_path objectAtIndex:0]];
    [hairs_first_last addObject:[hairs_path lastObject]];
    [hairs_path removeLastObject];
    [hairs_path removeObjectAtIndex:0];

}


- (void)drawInContext:(CGContextRef)ctx
{
    
//   CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
//   CGContextFillRect(ctx, self.bounds);
}

//
//+ (int)isInRetinaDisplay
//{
//    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
//    if (height== R4_DISPLAY_HEIGHT) {
//        return R4_DISPLAY;
//    } else if (height == R3_DISPLAY_HEIGHT) {
//        return R3_DISPLAY;
//    } else {
//        return NO;
//    }
//}



@end
