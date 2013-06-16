//
//  main_menu.m
//  pinch_touch
//
//  Created by オオタ イサオ on 13/02/12.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "main_menu.h"

@implementation main_menu
@synthesize modalViewController, option_Table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect window_frame = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(window_frame.size);
    UIImage *title_view = [UIImage imageNamed:@"title_1136x960.png"];
    
    NSLog(@"%f",title_view.size.height);
    NSLog(@"%f",title_view.size.width);
    [title_view drawInRect:window_frame];
    // [namihei_ite drawInRect:window_frame];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
//}
//
//- (NSUInteger)supportedInterfaceOrientations{
//    
//    
//    // UIInterfaceOrientationMaskLandscape　→　Left+Rightの横限定回転
//    // return  UIInterfaceOrientationMaskAll;//　→　すべての回転
//    // UIInterfaceOrientationMaskAllButUpsideDown　→　UpDown以外のすべて
//    //return UIInterfaceOrientationMaskAllButUpsideDown;
//    return UIInterfaceOrientationPortraitUpsideDown;
//}

-(IBAction) start_Button:(id)sender
{
    //[pinch_touchViewController class];
    modalViewController = [[pinch_touchViewController alloc] initWithNibName:@"pinch_touchViewController" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:modalViewController animated:YES];
    
}

-(IBAction) option_Button:(id)sender
{
    option_Table = [[Option_Table alloc] initWithNibName:@"Option_Table" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:option_Table animated:YES];
}

@end
