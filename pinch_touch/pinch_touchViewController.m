//
//  pinch_touchViewController.m
//  pinch_touch
//
//  Created by オオタ イサオ on 13/02/06.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "pinch_touchViewController.h"

@interface pinch_touchViewController() {
    
//    NSNotification *n_stop;
//    NSNotification *n_stop_back;
//    NSNotification *n_stop_left;
//    NSNotification *n_stop_right;
    int collision_out;
    int ite_draw;
    int rotate_parent_flg;
    int pinchin_kenuki_flg;
    int Score;
    int Combo;
    UILabel *scoreLabel;
    DamageValueLabel *comboLabel;
    UIImage *namihei;
    UIImage *namihei_ite;
    CGRect  window_frame;
    CAEmitterLayer *emitterLayer;
   
}

-(void)void_method_for_wait;
-(void)stopEmitter:(CAEmitterLayer*)emitterLayer;
-(void)setScore:(int)score;

@end



@implementation pinch_touchViewController


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //initialize    first_Touch_Flg = FALSE;
   
    catch_Obj_Flg   = FALSE;
    intersect_Namihei_Flg = FALSE;
    collision_out = FALSE;
    ite_draw = FALSE;
    rotate_parent_flg = FALSE;
    pinchin_kenuki_flg = FALSE;
    self.view.multipleTouchEnabled = TRUE;
    
    /*
    UIDevice *dev = [UIDevice currentDevice];
    NSLog(@"name %@"      , dev.name  );
    NSLog(@"device %@"      , dev.model  );
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platformName = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    NSLog(platformName);
     */
   // CGFloat scale = [UIScreen mainScreen].scale;

#pragma mark draw background image namihei
    window_frame = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(window_frame.size);
    namihei = [UIImage imageNamed:@"namihei_face.png"];
    namihei_ite = [UIImage imageNamed:@"namihei_face_ite.png"];
    
    NSLog(@"%f",namihei.size.height);
    NSLog(@"%f",namihei.size.width);
    CGRect image_frame = CGRectMake(0, 0, namihei.size.width, namihei.size.height);
    [namihei drawInRect:window_frame];
   // [namihei_ite drawInRect:window_frame];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
#pragma mark kenuki image load
    //kenuki gazou
    UIImage *kenuki_ue = [UIImage imageNamed:@"kenuki_real_2.png"];
    
    //parent layer means touch area
    // create parent higenuki layer for rotate all higenuki layer;
    CGPoint origin = CGPointMake(150, 300);
    CGFloat width  = 110;
    CGFloat height = 110;
    CGPoint anchor = CGPointMake(0.5, 0.5);
    CATransform3D trans;
    
   // self.view.layer.transform = CATransform3DMakeRotation(180 * M_PI / 180, 0.0, 0.0, 1);
    
#pragma mark init parent kenuki
    Layer *parent_kenuki_layer = [[Layer alloc] initWithRectLayer:[CALayer layer]
                                                           anchor:anchor origin:origin width:width height:height];
    parent_kenuki_layer.rect_color = [UIColor clearColor];
    trans = CATransform3DMakeRotation(0 * M_PI / 180, 0.0, 0.0, 1);
    parent_kenuki_layer.transform = trans;
    
    [self.view.layer addSublayer:parent_kenuki_layer];
    
    // create upper higenuki sublayer ;
    origin = CGPointMake(12, 0);
    width  = 110;
    height = 15;
    anchor = CGPointMake(1, 0.5);

#pragma mark init upper kenuki
    Layer *upper_kenuki_layer = [[Layer alloc] initWithRectLayer:[CALayer layer] anchor:anchor origin:origin width:width height:height];
    //upper_kenuki_layer.contents = kenuki_ue;
    trans = CATransform3DMakeRotation(105 * M_PI / 180, 0.0, 0.0, 1);
    upper_kenuki_layer.transform = trans;
    upper_kenuki_layer.rect_color = [UIColor clearColor];
    //upper_kenuki_layer.rect_color = [UIColor clearColor];
   // upper_kenuki_layer.contents = (id)kenuki_ue.CGImage;
  //  upper_kenuki_layer.contentsRect = CGRectMake(0,0,100,100);
    
    [parent_kenuki_layer addSublayer:upper_kenuki_layer];
    
    CGFloat radius = height * 0.6;
    origin = CGPointMake(radius, radius);
    Layer *hit_sublayer = [[Layer alloc] initWithLayer:[CALayer layer] center:origin radius:radius];
    hit_sublayer.rect_color = [UIColor clearColor];
    [upper_kenuki_layer addSublayer:hit_sublayer];
    
    CALayer *kenuki_ue_gazou = [CALayer layer];
    kenuki_ue_gazou.frame = CGRectMake(0,0, kenuki_ue.size.width/2, kenuki_ue.size.height/2);
    kenuki_ue_gazou.contents = (id)kenuki_ue.CGImage;
    kenuki_ue_gazou.anchorPoint = CGPointMake(1, 0.6);;
    kenuki_ue_gazou.position = CGPointMake(50, 45);
    trans = CATransform3DMakeRotation(80 * M_PI / 180, 0.0, 0.0, 1);
    kenuki_ue_gazou.transform = trans;
   // kenuki_ue_gazou.contentsRect = CGRectMake(100,100,width+100, width+100);
    [upper_kenuki_layer addSublayer:kenuki_ue_gazou];
 
#pragma mark init under kenuki
  // create under higenuki sublayer ;
    origin = CGPointMake(-12, 0);
    width  = 110;
    height = 15;
    anchor = CGPointMake(1, 0.5);
    Layer *under_kenuki_layer = [[Layer alloc] initWithRectLayer:[CALayer layer] anchor:anchor origin:origin width:width height:height];
    trans = CATransform3DMakeRotation(75 * M_PI / 180, 0.0, 0.0, 1);
    under_kenuki_layer.transform = trans;
    [parent_kenuki_layer addSublayer:under_kenuki_layer];
    under_kenuki_layer.rect_color = [UIColor clearColor];
    
    height = 15;
    radius = height * 0.6;
    origin = CGPointMake(radius, radius);
    Layer *hit_sublayer2 = [[Layer alloc] initWithLayer:[CALayer layer] center:origin radius:radius];
    [under_kenuki_layer addSublayer:hit_sublayer2];
    hit_sublayer2.rect_color = [UIColor clearColor];
    
    
    CALayer *kenuki_sita_gazou = [CALayer layer];
    kenuki_sita_gazou.frame = CGRectMake(0,0, kenuki_ue.size.width/2, kenuki_ue.size.height/2);
    kenuki_sita_gazou.contents = (id)kenuki_ue.CGImage;
    kenuki_sita_gazou.anchorPoint = CGPointMake(1, 0.6);
    kenuki_sita_gazou.position = CGPointMake(50, -30);
    trans = CATransform3DMakeScale(-1.0, 1.0, 0);
    kenuki_sita_gazou.transform = CATransform3DRotate(trans, -100 * M_PI / 180, 0.0, 0.0, 1);
    //CATransform3DMakeRotation(-90 * M_PI / 180, 0.0, 0.0, 1);
    [under_kenuki_layer addSublayer:kenuki_sita_gazou];

#pragma mark init particle
    // particle add
    emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = CGPointMake(100, 100);
    emitterLayer.renderMode = kCAEmitterLayerAdditive;
    [self.view.layer addSublayer:emitterLayer];
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    UIImage *image = [UIImage imageNamed:@"particle1.png"];
    emitterCell.contents = (__bridge id)(image.CGImage);
    emitterCell.emissionLongitude = M_PI * 2;
    emitterCell.emissionRange = M_PI * 2;
    emitterCell.birthRate = 0;
    emitterCell.lifetimeRange = 0;
    emitterCell.lifetime = 0.2;
    emitterCell.duration = 0.1;
    emitterCell.velocity = 100;
    emitterCell.name = @"higegood";
    emitterCell.color = [UIColor colorWithRed:0.2
                                        green:0.8
                                         blue:0.8
                                        alpha:0.8].CGColor;
    emitterLayer.emitterCells = @[emitterCell];

    
#pragma mark init skin
    //CGRect windowSizeNotIncludeStatusBar = [[UIScreen mainScreen] applicationFrame];
    skin_layer = [[skin alloc] initWithSkinLayer:[CAShapeLayer layer] win_frame:image_frame];
    [self.view.layer addSublayer:skin_layer];
    // add namihei face collision dummy layer
    // 114 / image_frame.size.width * window_frame.size.width
    origin = CGPointMake(311.212/(image_frame.size.width) * window_frame.size.width,
                         window_frame.size.height - 1066.727/image_frame.size.height * window_frame.size.height);
    //radius = 129.541/image_frame.size.height * window_frame.size.height;
    radius = 266/image_frame.size.height * window_frame.size.height;
    hit_namihei_face_layer = [[Layer alloc] initWithLayer:[CALayer layer] center:origin radius:radius];
    hit_namihei_face_layer.rect_color = [UIColor clearColor];
   
    [self.view.layer addSublayer:hit_namihei_face_layer];
 
    
#pragma mark init koukoku
    //add iad
    //上側のツールバー部分を除いた部分のフレームサイズを取得
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    //ADBannerViewのインスタンスを作成。初期サイズは０。
    
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    
   // ADBannerViewのサイズをポートレートのサイズにセット
    
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    
    
   // ADBannerViewを画面下側のちょうど隠れる位置に移動
    
    adView.frame = CGRectOffset(adView.frame, 0, screenRect.size.height);
    adView.transform = CGAffineTransformMakeRotation(180 * M_PI / 180);
    
    [self.view addSubview:adView];
    
    adView.delegate = self;
    
    bannerIsVisible = NO;
    
#pragma mark set Label (Score)
    
    Score = 0;
    scoreLabel = [[UILabel alloc] init];
    scoreLabel.frame = CGRectMake(5, screenRect.size.height - adView.frame.size.height - 60, screenRect.size.width, 60);
    scoreLabel.text = [NSString stringWithFormat:@"%d Pt",Score];   //@"0000";
    scoreLabel.textAlignment = UITextAlignmentRight;
    scoreLabel.textColor = [UIColor blueColor];
    scoreLabel.font = [UIFont boldSystemFontOfSize:60];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.transform = CGAffineTransformMakeRotation(180 * M_PI / 180);
    
    [self.view addSubview:scoreLabel];
    
#pragma mark set animation Label
    
    self.animation_Score.transform = CGAffineTransformMakeRotation(180 * M_PI / 180);
    [self.view addSubview:self.animation_Score];
    
    Combo = 0;
    comboLabel = [[DamageValueLabel alloc] init];
    comboLabel.frame = CGRectMake(5, 100, 100, 60);
    comboLabel.text = @"";
    comboLabel.textColor = [UIColor blueColor];
    comboLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.font = [UIFont boldSystemFontOfSize:60];
    comboLabel.transform = CGAffineTransformMakeRotation(180 * M_PI / 180);
    [self.view addSubview:comboLabel];
    
    
#pragma mark set score animation Label
    

}

//
#pragma mark device rotation care
- (BOOL)shouldAutorotate
{
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // single touch
    if ([touches count] == 1) {
#pragma mark hige restart touch namihei
        UITouch *first_obj = [[[event allTouches] allObjects] objectAtIndex:0];
        if ([first_obj tapCount] == 1) {
             [self performSelector:@selector(void_method_for_wait) withObject:nil afterDelay:0.1];
        }
        else {
            CGPoint first_pt  = [first_obj locationInView:self.view];
            if([hit_namihei_face_layer isCircleArea:first_pt]) {
                [skin_layer restart_Skin];
            }
        }
        
    }
    else {
        UITouch *first_obj  =  [[[event allTouches] allObjects] objectAtIndex:0]; 
        UITouch *second_obj =  [[[event allTouches] allObjects] objectAtIndex:1]; 
        CGPoint first_pt  = [first_obj locationInView:self.view];
        CGPoint second_pt = [second_obj locationInView:self.view];
        
        Layer *kenuki_parent = [self.view.layer.sublayers objectAtIndex:0];
        Layer *lay1 = [kenuki_parent.sublayers objectAtIndex:0];
        Layer *lay2 = [kenuki_parent.sublayers objectAtIndex:1];
        
        if( 
            ([lay1 isCircleArea:first_pt] && [lay2 isCircleArea:second_pt] )
           ) {
            first_Touch_Flg = TRUE;
        }
        else if (
                 ([lay2 isCircleArea:first_pt] && [lay1 isCircleArea:second_pt] )
            ){
            first_Touch_Flg = TRUE;
        }
        
       printf("Fisrt Double Touch ");
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  	
    if ([[event allTouches] count] == 1) {
//        printf("Fisrt moving Touch ");
        return;
    }
    else {
        // [touches count] > 1
        NSArray *touches_obj = [[event allTouches] allObjects];
        UITouch *first_obj   = [touches_obj objectAtIndex:0];
        UITouch *second_obj  = [touches_obj objectAtIndex:1];
        CGPoint first_pt     = [first_obj locationInView:self.view];
        CGPoint second_pt    = [second_obj locationInView:self.view];
        Layer *kenuki_parent = [self.view.layer.sublayers objectAtIndex:0];
        Layer *lay1 = [kenuki_parent.sublayers objectAtIndex:0];
        Layer *lay2 = [kenuki_parent.sublayers objectAtIndex:1];
      
        Layer *hit_sub1 = [lay1.sublayers objectAtIndex:0];
        Layer *hit_sub2 = [lay2.sublayers objectAtIndex:0];
       
        //printf("Fisrt Moving Double Touch\n");
   
        
        if (first_Touch_Flg) {
            first_Touch_Flg = FALSE;
            //printf("Fisrt Moving Double Touch First\n");
            return;
        }
        else {
            lay1.pre_pt = [first_obj previousLocationInView:self.view];
            lay2.pre_pt = [second_obj previousLocationInView:self.view];
        }
        
        first_Touch_Flg = FALSE;
        
        CGPoint dist1 = CGPointMake(first_pt.x  - lay1.pre_pt.x, first_pt.y - lay1.pre_pt.y);
        CGPoint dist2 = CGPointMake(second_pt.x - lay2.pre_pt.x, second_pt.y - lay2.pre_pt.y);
        CGFloat dist_now = 
        sqrt( (first_pt.x - second_pt.x)*(first_pt.x - second_pt.x) + (first_pt.y - second_pt.y)*(first_pt.y - second_pt.y));
        CGFloat dist_pre =
        sqrt( (lay1.pre_pt.x - lay2.pre_pt.x)*(lay1.pre_pt.x - lay2.pre_pt.x) + (lay1.pre_pt.y - lay2.pre_pt.y)*(lay1.pre_pt.y - lay2.pre_pt.y));
        
        CGFloat dist_now_x = (first_pt.x - second_pt.x)*(first_pt.x - second_pt.x);
        CGFloat dist_pre_x = (lay1.pre_pt.x - lay2.pre_pt.x)*(lay1.pre_pt.x - lay2.pre_pt.x);
        CGFloat dist_now_y = (first_pt.y - second_pt.y)*(first_pt.y - second_pt.y);
        CGFloat dist_pre_y = (lay1.pre_pt.y - lay2.pre_pt.y)*(lay1.pre_pt.y - lay2.pre_pt.y);
        
        if ( 
            (lay1.circle_flg) && 
            (lay2.circle_flg)
            ) {
            lay1.center = CGPointMake(lay1.center.x + dist1.x, lay1.center.y + dist1.y);
            lay2.center = CGPointMake(lay2.center.x + dist2.x, lay2.center.y + dist2.y);
            lay1.position = CGPointMake(lay1.center.x, lay1.center.y);
            lay2.position = CGPointMake(lay2.center.x, lay2.center.y);
        }
        else if (
                 (!lay1.circle_flg) && 
                 (!lay2.circle_flg)
            ){
            int colision = FALSE;
            int colision_kenuki1_namihei = FALSE;
            int colision_kenuki2_namihei = FALSE;
            CGRect hit_rect1 = [hit_sub1 convertRect:hit_sub1.frame toLayer:self.view.layer];
            CGRect hit_rect2 = [hit_sub2 convertRect:hit_sub2.frame toLayer:self.view.layer];

            if (CGRectIntersectsRect(hit_rect1, hit_rect2)) {
               // printf("collision lay1 and lay2\n");
                colision = TRUE;
            }
            
            if ([lay1 is_intersect_circlelay:hit_namihei_face_layer layer2:hit_sub1]) {
                if(hit_sub1.center.y >= hit_namihei_face_layer.center.y) {
                    colision_kenuki1_namihei = -1;
                }
                else {
                    colision_kenuki1_namihei = 1;
                }
                intersect_Namihei_Flg = TRUE;
            }
            
           if( [lay1 is_intersect_circlelay:hit_namihei_face_layer layer2:hit_sub2]) {
               if(hit_sub2.center.y >= hit_namihei_face_layer.center.y) {
                   colision_kenuki2_namihei = -1;
               }
               else {
                   colision_kenuki2_namihei = 1;
               }
               intersect_Namihei_Flg = TRUE;
            }
            
            #pragma mark pinch kenuki
            // pinch kenuki (rotate kenuki layer)
            
            CGFloat abs_diff_x = (dist_now_x - dist_pre_x)*(dist_now_x - dist_pre_x) ;
            CGFloat abs_diff_y = (dist_now_y - dist_pre_y)*(dist_now_y - dist_pre_y) ;
            if ( abs_diff_x > abs_diff_y ) {
                pinchin_kenuki_flg = TRUE;
            }
            else {
                pinchin_kenuki_flg = FALSE;
            }
            
            CGFloat angle = atanf(2* dist1.x/lay1.width);
            
            if (dist_now - dist_pre > 0) {
                angle = atanf((dist_now - dist_pre)/lay1.width);
            }
            else {
                angle = atanf((dist_now - dist_pre)/lay1.width);
            }
        
            if (colision) {
                 angle = 0;
            }
            
            if (colision_kenuki1_namihei == 1) {
                angle = 0.01;
            }
            else if (colision_kenuki1_namihei== -1) {
                angle = -0.01;
            }
            
            CATransform3D rotationTransform1 = [lay1 transform];
            CGFloat theta;
            if(rotationTransform1.m11 < 0.0f) {
                theta = (180.0f - (asin(rotationTransform1.m12))*180.0f/M_PI);
            }
            else {
                theta = asin(rotationTransform1.m12)*180.0f/M_PI;
            }

            if (theta <= 15 + 90) {
                [lay1 rotate_Layer:angle];
            }
                        
            angle = atanf(2* dist2.x/lay2.width);

            if (dist_now - dist_pre > 0) {
                angle = -atanf((dist_now - dist_pre)/lay1.width);
            }
            else {
                angle = -atanf((dist_now - dist_pre)/lay1.width);
            }

            if (colision) {
                angle = 0;
            }
            
            if (colision_kenuki2_namihei == 1) {
                angle = 0.01;
            }
            else if (colision_kenuki2_namihei== -1) {
                angle = -0.01;
            }
            
            rotationTransform1 = [lay2 transform];
            if(rotationTransform1.m11 < 0.0f) {
                theta = (180.0f - (asin(rotationTransform1.m12))*180.0f/M_PI);
            }
            else {
                theta = asin(rotationTransform1.m12)*180.0f/M_PI;
            }
            
            if (theta >= -15 + 90) {
                [lay2 rotate_Layer:angle];
            }
            
            // frame has size (width * cos(theta), width * sin(theta))
            
            //hit_sub is under lay sublayer so need convert pos ;
            hit_rect1 = [hit_sub1 convertRect:hit_sub1.frame toLayer:self.view.layer];
            hit_rect2 = [hit_sub2 convertRect:hit_sub2.frame toLayer:self.view.layer];
            
            // convert hit_sub1_center to view.layer position
            hit_sub1.center = CGPointMake(hit_rect1.origin.x + hit_rect1.size.width/2,
                                          hit_rect1.origin.y + hit_rect1.size.height/2);
            hit_sub2.center = CGPointMake(hit_rect2.origin.x + hit_rect2.size.width/2,
                                          hit_rect2.origin.y + hit_rect2.size.height/2);
            
#pragma mark rotate parent kenuki
            // rotate parent kenuki direction
            
            if(dist1.y * dist2.y < 0 && !pinchin_kenuki_flg){
                
                CGFloat parent_angle;
                if (dist1.y < 0) {
                    parent_angle = atanf(1 * dist1.y/lay1.width);
                }
                else {
                    parent_angle = atanf(1 * dist1.y/lay2.width);
                }
                
                if (!colision) {
                    CATransform3D rotationTransform1 = [kenuki_parent transform];
                    CGFloat theta;
                    
                    rotate_parent_flg = TRUE;
                    if(rotationTransform1.m11 < 0.0f) {
                        theta = (180.0f - (asin(rotationTransform1.m12))*180.0f/M_PI);
                    }
                    else {
                        theta = asin(rotationTransform1.m12)*180.0f/M_PI;
                    }
                    
                    if (theta < 0) {
                        [kenuki_parent rotate_Layer:parent_angle];
                        
                        if (theta < -25) {
                            [kenuki_parent set_Layer_angle:-20];
                        }
                        
                        
                    }
                    else {
                        [kenuki_parent rotate_Layer:(parent_angle)];
                        if (theta > 25) {
                            [kenuki_parent set_Layer_angle:20];
                        }
                    }
                    
                    
                }
                
            }

            #pragma mark move kenuki
            //judge window
            NSNotification *n_toggle_flg = [NSNotification notificationWithName:@"Toggle_lock" object:self];
            NSNotification *n_toggle_stack_stop = [NSNotification notificationWithName:@"Toggle_Stack_Stop" object:self];
           
            [[NSNotificationCenter defaultCenter] postNotification:n_toggle_flg];
            [[NSNotificationCenter defaultCenter] postNotification:n_toggle_stack_stop];
            if ([in_window_wall_judge is_in_window:lay1
                                      window_frame: [[UIScreen mainScreen] bounds] top_layer:self.view.layer]) {
                NSLog(@"lay1 out");
                collision_out = TRUE;
            }
           
            else if ([in_window_wall_judge is_in_window:lay2
                                           window_frame: [[UIScreen mainScreen] bounds] top_layer:self.view.layer]) {
                NSLog(@"lay2 out");
                collision_out = TRUE;
            }
           
            else if ([is_collision_face_judge reflection:lay1 face:hit_namihei_face_layer top_layer:self.view.layer]) {
                collision_out = TRUE;
                NSLog(@"hit face");
            }
            else if ([is_collision_face_judge reflection:lay2 face:hit_namihei_face_layer top_layer:self.view.layer]) {
                collision_out = TRUE;
                NSLog(@"hit face");
            }
            else {
                collision_out = FALSE;
            }
            [[NSNotificationCenter defaultCenter] postNotification:n_toggle_flg];
            
            if (!collision_out) {
                [[NSNotificationCenter defaultCenter] postNotification:n_toggle_stack_stop];
            }
            
            if (!colision_kenuki1_namihei || !colision_kenuki2_namihei) {
                [kenuki_parent move_Layer:CGPointMake((dist1.x + dist2.x)*0.5, (dist1.y + dist2.y)*0.5) pull:!collision_out];
            }
            
            if (collision_out) {
                [[NSNotificationCenter defaultCenter] postNotification:n_toggle_stack_stop];
            }
            
            
            #pragma mark judge collision with hige and kenuki
            // hair catch with kenuki
            int i = 0;
           // higeLayer *delete_lay;
            for ( higeLayer *hithige_lay in skin_layer.sublayers ) {
                
                if (hithige_lay.fallout_flg==2) {
                    continue;
                }
                
                if (i==0) {
                    hithige_lay.tag = 1;
                }
                i++;
                if (catch_Obj_Flg) {
                    if (hithige_lay.touch_flg == FALSE) {
                        continue;
                    }
                    [hithige_lay move_hige:CGPointMake((dist1.x + dist2.x)*0.5, (dist1.y + dist2.y)*0.5 )];
                }
                else if ( [kenuki_parent is_intersect_layer:lay1 layer2:hithige_lay] &&
                         [kenuki_parent is_intersect_layer:lay2 layer2:hithige_lay]
                         ){
                    printf("In in_insersect_layer in viewcontroller\n");
                    
                    catch_Obj_Flg = TRUE;
                    hithige_lay.touch_flg = TRUE;
                    
                    CATransform3D rotationTransform1;
                    CGFloat parent_theta, hige_theta;
                    
                    rotationTransform1 = [kenuki_parent transform];
                    if(rotationTransform1.m11 < 0.0f) {
                        parent_theta = (180.0f - (asin(rotationTransform1.m12))*180.0f/M_PI);
                    }
                    else {
                        parent_theta = asin(rotationTransform1.m12)*180.0f/M_PI;
                    }

                    rotationTransform1 = [hithige_lay transform];
                    if(rotationTransform1.m11 < 0.0f) {
                        hige_theta = (180.0f - (asin(rotationTransform1.m12))*180.0f/M_PI);
                    }
                    else {
                        hige_theta = asin(rotationTransform1.m12)*180.0f/M_PI;
                    }

                    CGFloat diff_angle_kenuki_hige = sqrtf((hige_theta - parent_theta)*(hige_theta - parent_theta));
                    if (diff_angle_kenuki_hige < 3) {
                        hithige_lay.good_angle_flg = TRUE;
                    }
                    if (diff_angle_kenuki_hige < 2) {
                        hithige_lay.good_angle_flg = 2;
                    }
                    if (diff_angle_kenuki_hige < 1) {
                        hithige_lay.good_angle_flg = 3;
                    }
                    
                    [hithige_lay move_hige:CGPointMake((dist1.x + dist2.x)*0.5, (dist1.y + dist2.y)*0.5 )];
                    
                }
            
                else {
                     hithige_lay.touch_flg = FALSE;
//                    if (hithige_lay.skinout_flg) {
//                        [hithige_lay move_hige:CGPointMake((dist1.x + dist2.x)*0.5, (dist1.y + dist2.y)*0.5 )];
//                        delete_lay = hithige_lay;
//                    }
                }
            }
        
            [skin_layer update_Skin];
            for (higeLayer *hige in skin_layer.sublayers) {
                if (hige.fallout_flg) {
                    continue;
                }
                self.animation_Score.center = CGPointMake(hige.frame.origin.x, hige.frame.origin.y);
                comboLabel.center = CGPointMake(hige.frame.origin.x, hige.frame.origin.y + 50);
                if (hige.skinout_flg && !ite_draw) {
                    #pragma mark change namihei ite
                    UIGraphicsBeginImageContext(window_frame.size);
                    //[namihei drawInRect:window_frame];
                    [namihei_ite drawInRect:window_frame];
                    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
                    ite_draw = TRUE;
                    
                    #pragma mark score add if kenuki angle is good
                    if (hige.good_angle_flg) {
                        int score = 30;
                        CAEmitterCell *emitterCell;
                        emitterCell = [emitterLayer.emitterCells objectAtIndex:0];
                        
                        emitterLayer.emitterPosition = CGPointMake(hige.position.x, hige.position.y);
                        
                        switch (hige.good_angle_flg) {
                            case 1:
                                [emitterLayer setValue:@10 forKeyPath:@"emitterCells.higegood.birthRate"];
                                emitterCell.color = [UIColor yellowColor].CGColor;
                                self.animation_Score.textColor = [UIColor yellowColor];
                                score = 30;
                                break;
                            case 2:
                                [emitterLayer setValue:@15 forKeyPath:@"emitterCells.higegood.birthRate"];
                                emitterCell.color = [UIColor blueColor].CGColor;
                                self.animation_Score.textColor = [UIColor blueColor];
                                score = 50;
                                break;
                            case 3:
                                [emitterLayer setValue:@20 forKeyPath:@"emitterCells.higegood.birthRate"];
                                emitterCell.color = [UIColor redColor].CGColor;
                                self.animation_Score.textColor = [UIColor redColor];
                                score = 100;
                            default:
                                break;
                        }
                        
                        Combo++;
                        [self performSelector:@selector(stopEmitter:) withObject:emitterLayer afterDelay:1.0f];
                        [self setScore:score];
                        
                    }
                    else {
                        Combo = 0;
                        self.animation_Score.textColor = [UIColor brownColor];
                        [self setScore:5];
                    }
                    
                    break;
                }
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    first_Touch_Flg = FALSE;
    catch_Obj_Flg   = FALSE;
    ite_draw = FALSE;
    
    // redraw namihei
    UIGraphicsBeginImageContext(window_frame.size);
    namihei = [UIImage imageNamed:@"namihei_face.png"];
    [namihei drawInRect:window_frame];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];

    Layer *parent_kenuki_layer = [self.view.layer.sublayers objectAtIndex:0];
    Layer *lay1 = [parent_kenuki_layer.sublayers objectAtIndex:0];
    Layer *lay2 = [parent_kenuki_layer.sublayers objectAtIndex:1];
   
    if (!intersect_Namihei_Flg) {
        [lay1 set_Layer_angle:15 + 90];
        [lay2 set_Layer_angle:-15 + 90];
    }
    intersect_Namihei_Flg = FALSE;
    
    [emitterLayer setValue:@0 forKeyPath:@"emitterCells.higegood.birthRate"];
    
    NSNotification *n_restart = [NSNotification notificationWithName:@"Restart" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n_restart];
    
    for ( higeLayer *hithige_lay in skin_layer.hairs ) {
        if (hithige_lay.skinout_flg == 1) {
            [hithige_lay move_out_display];
        }
        hithige_lay.touch_flg = FALSE;
    }
    
    #pragma mark restart hige if all hige skinout
    int all_hige_sikinout_flg = TRUE;
    for ( higeLayer *hithige_lay in skin_layer.hairs ) {
        all_hige_sikinout_flg *= hithige_lay.skinout_flg;
    }
    
    if (all_hige_sikinout_flg) {
        [skin_layer restart_Skin];
    }
    
}

#pragma mark other method
- (void)void_method_for_wait
{
    
}

#pragma mark set score
-(void)setScore:(int)addscore
{
    if (Combo != 0) {
        addscore = addscore * Combo;
    }
    Score += addscore;
    scoreLabel.text = [NSString stringWithFormat:@"%d Pt", Score];
    self.animation_Score.text = [NSString stringWithFormat:@"Score %d", addscore];
    [self.animation_Score startAnimationWithAnimationType:DamageAnimationType3];
    if(Combo != 0) {
        comboLabel.text = [NSString stringWithFormat:@"%d Combo", Combo];
        [comboLabel startAnimationWithAnimationType:DamageAnimationType3];
    }
}

#pragma mark emitter local method
-(void)stopEmitter:(CAEmitterLayer*)emitterLayer{
    //このbirthRateは、各cellに対するmultiplier
    [emitterLayer setValue:@0 forKeyPath:@"emitterCells.higegood.birthRate"];
}

#pragma mark adview delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!bannerIsVisible)
        
    {
        
        [UIView
         
         animateWithDuration:1.0  //アニメーションの時間を秒単位で指定
         
         animations:^{           // アニメーション内容を記述
             
             //ADBannerViewの高さ分上側に移動
             
             adView.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
             
         }
         
         ];
        
        
        
        bannerIsVisible = YES;
        
    }
}

//iAd広告が表示できない状態になったときに呼ばれるメソッド
//
//ADBannerViewDelegate Protocolのメソッド

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError*)error

{
    
   // バナーが表示されていればバナーを非表示にする。
    
    if (bannerIsVisible)
        
    {
        
        [UIView
         
         animateWithDuration:1.0 // アニメーションの時間を秒単位で指定
         
         animations:^{            //アニメーション内容を記述
             
             //ADBannerViewの高さ分下側に移動
             
             adView.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
             
         }
         
         ];
        
        bannerIsVisible = NO;
        
    }
    
}

@end
