//
//  AddSongViewController.m
//  Music Feed
//
//  Created by Robyn Van Deventer on 6/01/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "AddSongViewController.h"
static NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface AddSongViewController () <UITableViewDataSource>

@end

@implementation AddSongViewController

# pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self setupView];
}

- (void)setUpNavigationBar
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeButton)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.title = @"Add Song";
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Add song table view
    UITableView *addSongTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    addSongTableView.translatesAutoresizingMaskIntoConstraints = NO;
    addSongTableView.dataSource = self;
    [self.view addSubview:addSongTableView];
    
    //Add song table view constraints
    [NSLayoutConstraint activateConstraints:@[
        [NSLayoutConstraint constraintWithItem:addSongTableView
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:addSongTableView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:addSongTableView
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1.0
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:addSongTableView
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1.0
                                      constant:0],
    ]];
}

# pragma mark - Actions

- (void)closeButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Add song table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
