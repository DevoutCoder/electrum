//
//  OKHDWalletViewController.m
//  OneKey
//
//  Created by bixin on 2020/10/30.
//  Copyright © 2020 Calin Culianu. All rights reserved.
//

#import "OKHDWalletViewController.h"

@interface OKHDWalletViewController ()

@end

@implementation OKHDWalletViewController
+ (instancetype)hdWalletViewController
{
    return [[UIStoryboard storyboardWithName:@"Tab_Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"OKHDWalletViewController"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
