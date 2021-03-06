//
//  OKAddBottomViewController.h
//  OneKey
//
//  Created by bixin on 2020/10/16.
//  Copyright © 2020 Calin Culianu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum{
    BtnClickTypeCreate,
    BtnClickTypeImport
}BtnClickType;

typedef void(^BtnClickBlock)(BtnClickType type);

@interface OKAddBottomViewController : BaseViewController
- (void)showOnWindowWithParentViewController:(UIViewController *)viewController block:(BtnClickBlock)block;
@end

NS_ASSUME_NONNULL_END
