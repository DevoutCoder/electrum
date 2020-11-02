//
//  OKNSObject.m
//  OneKey
//
//  Created by bixin on 2020/10/29.
//  Copyright © 2020 Calin Culianu. All rights reserved.
//

#import "OKNSObject.h"

@implementation OKNSObject

- (instancetype)init
{
    if (self = [super init]) {
//        self.walletVC = [[UIViewController alloc]init];
    }
    return self;
}

- (void)callback:(NSString *)str1
{
    
    NSLog(@"callbackxxx %@",str1);
}
@end
