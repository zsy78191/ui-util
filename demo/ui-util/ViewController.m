//
//  ViewController.m
//  ui-util
//
//  Created by 张超 on 2019/1/14.
//  Copyright © 2019 orzer. All rights reserved.
//

#import "ViewController.h"
#import "UUTest.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [UUTest showInView:self];
}


@end
