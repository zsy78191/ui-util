//
//  UUHeader.h
//  ui-util
//
//  Created by 张超 on 2019/1/14.
//  Copyright © 2019 orzer. All rights reserved.
//

#ifndef UUHeader_h
#define UUHeader_h

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#endif /* UUHeader_h */
