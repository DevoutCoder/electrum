//
//  OKUnitTableViewCellModel.h
//  OneKey
//
//  Created by bixin on 2020/10/30.
//  Copyright © 2020 Calin Culianu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OKUnitTableViewCellModel : NSObject
@property (nonatomic,copy) NSString* titleStr;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,copy) NSString* descStr;
@end

NS_ASSUME_NONNULL_END
