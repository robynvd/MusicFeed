//
//  AddSongViewController.m
//  Music Feed
//
//  Created by Robyn Van Deventer on 6/01/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "AddSongViewController.h"
#import "AddArtistViewController.h"
#import "AddGenreViewController.h"
static NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface AddSongViewController () <UITableViewDataSource, UITableViewDelegate>
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
    UITableView *addSongTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                                 style:UITableViewStyleGrouped];
    addSongTableView.translatesAutoresizingMaskIntoConstraints = NO;
    addSongTableView.dataSource = self;
    addSongTableView.delegate = self;
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

//Removing the current view controller upon clicking the close button
- (void)closeButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Add song table view


//Setting how many sections are in the table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//How many rows are in each secion
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 3;
    else
        return 1;
}


//Setting the table header for the first section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"song details";
    else
        return nil;
}

//Creating the cells and populating them
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier];
        }
    cell.backgroundColor = [UIColor whiteColor];
    
    //Loop through sections and then rows to set the individual values
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = @"Song:";
                    UITextField *addSongTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 290, 30)];
                    addSongTextField.placeholder = @"Song Name";
                    cell.accessoryView = addSongTextField;
                    break;
                }
                case 1:
                    cell.textLabel.text = @"Artist";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 2:
                    cell.textLabel.text = @"Genre";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            cell.textLabel.text = @"Add";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row)
            {
                case 0:
                {
                    break;
                }
                case 1:
                {
                    [tableView deselectRowAtIndexPath:indexPath animated:NO];
                    AddArtistViewController *addArtistViewController = [[AddArtistViewController alloc] init];
                    [self.navigationController pushViewController:addArtistViewController animated:YES];
                }
                    break;
                case 2:
                {
                    [tableView deselectRowAtIndexPath:indexPath animated:NO];
                    AddGenreViewController *addGenreViewController = [[AddGenreViewController alloc] init];
                    [self.navigationController pushViewController:addGenreViewController animated:YES];
                }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            break;
        default:
            break;
    }

}

@end
