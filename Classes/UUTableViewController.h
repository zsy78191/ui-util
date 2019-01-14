//
//  UUTableViewController.h
//  ui-util
//
//  Created by 张超 on 2019/1/14.
//  Copyright © 2019 orzer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    UUTableViewControllerTypeClass = 1,
    UUTableViewControllerTypeMethod,
} UUTableViewControllerType;

@interface UUTableViewController : UITableViewController

@property (nonatomic, strong) NSArray* allChildClass;
@property (nonatomic, strong) NSDictionary* methods;
@property (nonatomic, strong) NSString* handleClass;

@property (nonatomic, assign) UUTableViewControllerType type;


@end

NS_ASSUME_NONNULL_END
