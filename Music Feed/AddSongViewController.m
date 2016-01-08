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
#import <MagicalRecord/MagicalRecord.h>
#import "Song.h"
static NSString *const ReuseIdentifier = @"ReuseIdentifier";


@interface AddSongViewController () <UITableViewDataSource, UITableViewDelegate, AddGenreViewControllerDelegate, AddArtistViewControllerDelegate>
@property (nonatomic, strong)UITableView *addSongTableView;
@property (nonatomic, strong)Genre *genre;
@property (nonatomic, strong)Artist *artist;
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
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                  target:self
                                                                                  action:@selector(closeButton)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.title = @"Add Song";
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Add song table view
    self.addSongTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                                 style:UITableViewStyleGrouped];
    self.addSongTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.addSongTableView.dataSource = self;
    self.addSongTableView.delegate = self;
    [self.view addSubview:self.addSongTableView];
    
    
    //Add song table view constraints
    [NSLayoutConstraint activateConstraints:@[
        [NSLayoutConstraint constraintWithItem:self.addSongTableView
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:self.addSongTableView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:self.addSongTableView
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1.0
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:self.addSongTableView
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
            cell.indentationLevel = 15;
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
                    addArtistViewController.delegate = self;
                    [self.navigationController pushViewController:addArtistViewController animated:YES];
                }
                    break;
                case 2:
                {
                    [tableView deselectRowAtIndexPath:indexPath animated:NO];
                    AddGenreViewController *addGenreViewController = [[AddGenreViewController alloc] init];
                    addGenreViewController.delegate = self;
                    [self.navigationController pushViewController:addGenreViewController animated:YES];
                }
                    break;
                default:
                    break;
            }
            break;
        case 1:{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *cell = [self.addSongTableView cellForRowAtIndexPath:indexPath];
            UITextField *field = (UITextField *)cell.accessoryView;
           [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                Song *song = [Song MR_createEntityInContext:localContext];
                song.name = field.text;
                song.genre = [self.genre MR_inContext:localContext];
                song.artist = [self.artist MR_inContext:localContext];
            }];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        default:
            break;
    }

}

# pragma mark - addGenreDelegate

- (void)genreToAdd:(Genre *)genre
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *cell = [self.addSongTableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = genre.name;
    self.genre = genre;
}

# pragma mark - addSongDelegate

- (void)artistToAdd:(Artist *)artist
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.addSongTableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = artist.name;
    self.artist = artist;
}

@end


