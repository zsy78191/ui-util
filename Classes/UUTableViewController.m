//
//  UUTableViewController.m
//  ui-util
//
//  Created by 张超 on 2019/1/14.
//  Copyright © 2019 orzer. All rights reserved.
//

#import "UUTableViewController.h"
#import "UUHeader.h"
#import <ObjC/Runtime.h>
@import QuickLook;
@interface UUTableViewController () <QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@end

@implementation UUTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.title = @"开发调试";
    
    if (self.type == UUTableViewControllerTypeClass) {
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeMe)];
        self.navigationItem.leftBarButtonItem = item;
    }
    else {
        
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)closeMe
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (self.type == UUTableViewControllerTypeClass) {
        return [self.allChildClass count];
    }
    else if(self.type == UUTableViewControllerTypeMethod)
    {
        NSArray* m = [self.methods valueForKey:self.handleClass];
        return [m count];
    }
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (self.type == UUTableViewControllerTypeClass) {
        NSString* className = [self.allChildClass objectAtIndex:indexPath.row];
        id a = [[NSClassFromString(className) alloc] init];
        if ([a valueForKey:@"displayName"]) {
            cell.textLabel.text = [a valueForKey:@"displayName"];
            cell.detailTextLabel.text = className;
        }
        else {
            cell.textLabel.text = className;
        }
    }
    else if(self.type == UUTableViewControllerTypeMethod)
    {
        NSArray* m = [self.methods valueForKey:self.handleClass];
        NSString* method = [m objectAtIndex:indexPath.row];
        cell.textLabel.text = method;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == UUTableViewControllerTypeClass) {
        UUTableViewController* u = [[UUTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        u.type = UUTableViewControllerTypeMethod;
        u.handleClass = [self.allChildClass objectAtIndex:indexPath.row];
        u.methods = [self.methods copy];
        [self.navigationController pushViewController:u animated:YES];
    }
    else {
        id a = [[NSClassFromString([self handleClass]) alloc] init];
        NSArray* m = [self.methods valueForKey:self.handleClass];
        NSString* method = [m objectAtIndex:indexPath.row];
        id result = nil;
        SEL selector = NSSelectorFromString(method);
        if ([a respondsToSelector:selector]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [[a class] instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:a];
            [invocation invoke];
            
            Method mm = class_getInstanceMethod([a class], selector);
            char type[128];
            method_getReturnType(mm, type, sizeof(type));
            
            NSString* rtype = [[NSString alloc] initWithCString:type encoding:NSUTF8StringEncoding];
            if ([rtype isEqualToString:@"v"]) {
                
            }
            else {
                void *tempResultSet;
                [invocation getReturnValue:&tempResultSet];
                id resultSet = (__bridge id)tempResultSet;
//                NSLog(@"Returned %@", resultSet);
                result = resultSet;
            }
        }

        NSString* filepath = [@"~/Library/Caches/test.txt" stringByExpandingTildeInPath];
        
        if (result) {
            [[result description] writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            QLPreviewController *myQlPreViewController = [[QLPreviewController alloc]init];
            myQlPreViewController.delegate =self;
            myQlPreViewController.dataSource =self;
            [myQlPreViewController setCurrentPreviewItemIndex:0];
            //此处可以带导航栏跳转、也可以不带导航栏跳转、也可以拿到View进行Add
            [self.navigationController pushViewController:myQlPreViewController animated:YES];
        }
        
    }
}

#pragma mark - QLPreviewController代理
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    
    NSString* path = [@"~/Documents/test.txt" stringByExpandingTildeInPath];
    
    return [NSURL fileURLWithPath:path];
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
//    NSLog(@"预览界面已经消失");
}

//文件内部链接点击不进行外部跳转
- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item
{
    return NO;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
