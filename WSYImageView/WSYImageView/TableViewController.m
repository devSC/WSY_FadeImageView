//
//  TableViewController.m
//  WSYImageView
//
//  Created by YSC on 15/5/13.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "TableViewController.h"
#import "MyTableViewCell.h"
#import "WSYImageView.h"
#import "WSYImageCache.h"

@interface TableViewController ()


@end

@implementation TableViewController
{
    NSArray *_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _dataArray = @[@"http://f.hiphotos.baidu.com/image/w%3D2048/sign=f8f44f7d2a34349b74066985fdd214ce/2fdda3cc7cd98d10dc30a256233fb80e7aec90f5.jpg", @"http://h.hiphotos.baidu.com/image/w%3D400/sign=e9d4bc7593529822053338c3e7cb7b3b/b3119313b07eca80cacfb955922397dda04483be.jpg", @"http://e.hiphotos.baidu.com/image/w%3D400/sign=953deecd5066d0167e199f28a72ad498/b8014a90f603738d05916122b11bb051f919ecd3.jpg", @"http://e.hiphotos.baidu.com/image/w%3D400/sign=7d30048d6359252da3171c04049a032c/2fdda3cc7cd98d10a520eaa6223fb80e7aec90b5.jpg", @"http://g.hiphotos.baidu.com/image/w%3D400/sign=6d57c7d134d12f2ece05af607fc3d5ff/d058ccbf6c81800a0f632f08b33533fa828b4735.jpg",@"http://f.hiphotos.baidu.com/image/w%3D2048/sign=f8f44f7d2a34349b74066985fdd214ce/2fdda3cc7cd98d10dc30a256233fb80e7aec90f5.jpg", @"http://h.hiphotos.baidu.com/image/w%3D400/sign=e9d4bc7593529822053338c3e7cb7b3b/b3119313b07eca80cacfb955922397dda04483be.jpg", @"http://e.hiphotos.baidu.com/image/w%3D400/sign=953deecd5066d0167e199f28a72ad498/b8014a90f603738d05916122b11bb051f919ecd3.jpg", @"http://e.hiphotos.baidu.com/image/w%3D400/sign=7d30048d6359252da3171c04049a032c/2fdda3cc7cd98d10a520eaa6223fb80e7aec90b5.jpg", @"http://g.hiphotos.baidu.com/image/w%3D400/sign=6d57c7d134d12f2ece05af607fc3d5ff/d058ccbf6c81800a0f632f08b33533fa828b4735.jpg",@"http://f.hiphotos.baidu.com/image/w%3D2048/sign=f8f44f7d2a34349b74066985fdd214ce/2fdda3cc7cd98d10dc30a256233fb80e7aec90f5.jpg", @"http://h.hiphotos.baidu.com/image/w%3D400/sign=e9d4bc7593529822053338c3e7cb7b3b/b3119313b07eca80cacfb955922397dda04483be.jpg", @"http://e.hiphotos.baidu.com/image/w%3D400/sign=953deecd5066d0167e199f28a72ad498/b8014a90f603738d05916122b11bb051f919ecd3.jpg", @"http://e.hiphotos.baidu.com/image/w%3D400/sign=7d30048d6359252da3171c04049a032c/2fdda3cc7cd98d10a520eaa6223fb80e7aec90b5.jpg", @"http://g.hiphotos.baidu.com/image/w%3D400/sign=6d57c7d134d12f2ece05af607fc3d5ff/d058ccbf6c81800a0f632f08b33533fa828b4735.jpg",@"http://e.hiphotos.baidu.com/image/w%3D400/sign=8b347e407c3e6709be0044ff0bc69fb8/e7cd7b899e510fb32396f5f0da33c895d0430ccd.jpg", @"http://e.hiphotos.baidu.com/image/w%3D400/sign=c87b38112d2eb938ec6d7bf2e56385fe/cdbf6c81800a19d820a2bff531fa828ba71e4698.jpg", @"http://h.hiphotos.baidu.com/image/w%3D400/sign=a63609fe39c79f3d8fe1e5308aa1cdbc/0e2442a7d933c895be48d47ad31373f0820200f8.jpg"];
//    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"MyTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell" forIndexPath:indexPath];
    [cell.myImageView resetView];
    [cell.myImageView ws_setImageWithUrlString:_dataArray[indexPath.row] placeholderImage:[UIImage imageNamed:@"sgk_course_default_200"]];
    
    // Configure the cell...
    
    return cell;
}
- (IBAction)reload:(id)sender {
    [[WSYImageCache sharedImageCache] removeAllCache];
    [self.tableView reloadData];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
