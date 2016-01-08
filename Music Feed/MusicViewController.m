//
//  MusicViewController.m
//  Music Feed
//
//  Created by Robyn Van Deventer on 6/01/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "MusicViewController.h"
#import "AddSongViewController.h"
#import "Song.h"
#import "Artist.h"
#import "Genre.h"
#import <MagicalRecord/MagicalRecord.h>
static NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface MusicViewController () <UITableViewDataSource, NSFetchedResultsControllerDelegate, UITableViewDelegate>
@property (nonatomic, strong) UITableView *musicTable;
@property (nonatomic, strong) UIBarButtonItem *addSongButton;
@property (nonatomic, strong) UIBarButtonItem *deleteSongsButton;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;
@end

@implementation MusicViewController

# pragma mark - Setup


- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetchedResultsController = [Song MR_fetchAllSortedBy:@"name"
                                                      ascending:YES
                                                  withPredicate:nil
                                                        groupBy:nil
                                                       delegate:self];
    [NSFetchedResultsController deleteCacheWithName:@"SongCache"];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
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
    self.musicTable.delegate = self;
    [self.view addSubview:self.musicTable];
    
    //Add song Button
    self.addSongButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
    self.navigationItem.rightBarButtonItem = self.addSongButton;
     
     //Delete songs button
    self.deleteSongsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonTapped)];
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
    AddSongViewController *addSongViewController = [[AddSongViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addSongViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)deleteButtonTapped
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [Song MR_truncateAllInContext:localContext];
    }];
}

# pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
        // Configure the cell
        [self configureCell:cell atIndexPath:indexPath];
    }
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Update cell with song details
    cell.textLabel.text = song.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@", song.artist.name, song.genre.name];
}

# pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.musicTable beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.musicTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.musicTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.musicTable;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.musicTable endUpdates];
}

@end
