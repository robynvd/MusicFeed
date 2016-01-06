//
//  MusicViewController.m
//  Music Feed
//
//  Created by Robyn Van Deventer on 6/01/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "MusicViewController.h"
#import "AddSongViewController.h"
static NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface MusicViewController () <UITableViewDataSource>
@property (nonatomic, strong) UITableView *musicTable;
@property (nonatomic, strong) UIBarButtonItem *addSongButton;
@property (nonatomic, strong) UIBarButtonItem *deleteSongsButton;
@end

@implementation MusicViewController

# pragma mark - Setup


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Your Music";
    self.navigationController.navigationBar.translucent = NO;
    [self screenSetup];
    
}

- (void)screenSetup
{
    //Music table view
    self.musicTable = [[UITableView alloc] init];
    self.musicTable.translatesAutoresizingMaskIntoConstraints = NO;
    self.musicTable.dataSource = self;
    [self.view addSubview:self.musicTable];
    
    //Add song Button
    self.addSongButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
    self.navigationItem.rightBarButtonItem = self.addSongButton;
     
     //Delete songs button
    self.deleteSongsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:nil];
    self.navigationItem.leftBarButtonItem = self.deleteSongsButton;
    
    [NSLayoutConstraint activateConstraints:@[
                                              
        //Music table view constraints
        [NSLayoutConstraint constraintWithItem:self.musicTable
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1.0
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:self.musicTable
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1.0
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:self.musicTable
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:self.musicTable
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:0],
        
    ]];
    
}

#pragma mark - Actions

- (void)addButtonTapped
{
    NSLog(@"add button tapped");
    AddSongViewController *addSongViewController = [[AddSongViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addSongViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - tableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

@end
