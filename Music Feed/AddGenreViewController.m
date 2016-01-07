//
//  AddGenreViewController.m
//  Music Feed
//
//  Created by Robyn Van Deventer on 7/01/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "AddGenreViewController.h"
static NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface AddGenreViewController () <UITableViewDataSource>
@property (nonatomic, strong)UITableView *genreTable;
@end

@implementation AddGenreViewController

# pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Genre";
    self.navigationController.navigationBar.translucent = NO;
    [self setupScreen];
}

- (void)setupScreen {
    
    //Genre table view
    self.genreTable = [[UITableView alloc] init];
    self.genreTable.translatesAutoresizingMaskIntoConstraints = NO;
    self.genreTable.dataSource = self;
    [self.view addSubview:self.genreTable];
    
    //Add genre button
    UIBarButtonItem *addGenreButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
    self.navigationItem.rightBarButtonItem =  addGenreButton;
    
    [NSLayoutConstraint activateConstraints:@[
                                              //Genre table view constraints
                                              [NSLayoutConstraint constraintWithItem:self.genreTable
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0
                                                                            constant:0],
                                              [NSLayoutConstraint constraintWithItem:self.genreTable
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:0],
                                              [NSLayoutConstraint constraintWithItem:self.genreTable
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0
                                                                            constant:0],
                                              [NSLayoutConstraint constraintWithItem:self.genreTable
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0
                                                                            constant:0],
                                              ]];
}

#pragma mark - Actions

- (void)addButtonTapped
{
    
}

# pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


@end
