//
//  UIDevice+retina_judge.m
//  pinch_touch
//
//  Created by オオタ イサオ on 2013/05/18.
//
//

#import "UIDevice+retina_judge.h"
#include <sys/sysctl.h>

@implementation UIDevice (retina_judge)

- (NSString *) platformName
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platformName = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return platformName;
}

@end
