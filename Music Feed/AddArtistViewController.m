//
//  AddArtistViewController.m
//  Music Feed
//
//  Created by Robyn Van Deventer on 7/01/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "AddArtistViewController.h"
static NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface AddArtistViewController () <UITableViewDataSource>
@property (nonatomic, strong)UITableView *artistTable;
@end

@implementation AddArtistViewController

# pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Artist";
    self.navigationController.navigationBar.translucent = NO;
    [self setupScreen];
}

- (void)setupScreen {
    
    //Artist table view
    self.artistTable = [[UITableView alloc] init];
    self.artistTable.translatesAutoresizingMaskIntoConstraints = NO;
    self.artistTable.dataSource = self;
    self.artistTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.artistTable];
    
    //Add artist button
    UIBarButtonItem *addArtistButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
    self.navigationItem.rightBarButtonItem =  addArtistButton;
    
    [NSLayoutConstraint activateConstraints:@[
        //Artist table view constraints
        [NSLayoutConstraint constraintWithItem:self.artistTable
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:self.artistTable
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:self.artistTable
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1.0
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:self.artistTable
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
