//
//  DDRootTableViewController.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDRootTableViewController.h"
#import "DDAlertView.h"

@interface DDRootTableViewController ()

@end

@implementation DDRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/** 抛出异常消息 */
- (void)showForErrorMsg:(NSError *)objMsg
{
    NSString *errorMSg = @"网络错误!";
    if (objMsg.code == ErrorNoReachable) {
        errorMSg = @"没有连接网络!";
    } else if (objMsg.code == ErrorNetWorkError) {
        errorMSg = @"网络错误!";
    } else if(objMsg.code == ErrorHostDisConnect) {
        errorMSg = @"服务器断开连接!";
    } else if (objMsg.code == 404 ){
        errorMSg = @"404-服务器错误，还没做";
    }
    DDAlertView *alertView = [[DDAlertView alloc] initWithTitle:errorMSg delegate:nil cancelTitle:@"确  定" nextTitle:nil];
    [alertView show];
}

/** 获取随机的UUID字符串*/
- (NSString *)generateUuidString
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    
    return uuidString;
}

/** 降低图片的分辨率，以减少流量的传输*/
- (UIImage *)scaleImage:(UIImage *)image
{
    if (MAX(image.size.height, image.size.width) < 1280.0f)
    {
        return image;
    }
    
    CGSize newImageS = CGSizeZero;
    if (image.size.height > image.size.width) {
        newImageS.height = 1280.0f;
        float ratio = 1280.0f / image.size.height;
        newImageS.width = image.size.width * ratio;
    } else {
        newImageS.width = 1280.0f;
        float ratio = 1280.0f / image.size.width;
        newImageS.height = image.size.height * ratio;
    }
    
    UIGraphicsBeginImageContext(newImageS);
    [image drawInRect:CGRectMake(0, 0, newImageS.width, newImageS.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
