//
//  UUTest.h
//  ui-util
//
//  Created by 张超 on 2019/1/14.
//  Copyright © 2019 orzer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUTest : NSObject

@property (nonatomic, strong) NSString* displayName;

+ (void)showInView:(__kindof UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
