//
//  skin.h
//  pinch_touch
//
//  Created by オオタ イサオ on 2013/02/28.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "realHigeLayer.h"

@interface skin : CAShapeLayer {
    NSMutableArray *hairs;
    NSMutableArray *init_path;
    NSMutableArray *hairs_path;
    NSMutableArray *hairs_first_last;
    int             skin_width, hige_space;
    CGPoint         limit_pos;
    CGPoint        anchor;
    CGRect         local_win_frame;
}

@property(nonatomic ,strong)  NSMutableArray *hairs;
- (id) initWithSkinLayer:(id)layer win_frame:(CGRect)win_frame;
- (void) update_Skin;
- (void) restart_Skin;
- (void) read_plist:(NSString *)plistname pointname:(NSString *)pointname scale:(CGFloat)scale win_size_y:(CGFloat)win_size_y;

@end
