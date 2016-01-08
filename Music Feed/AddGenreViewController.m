//
//  AddGenreViewController.m
//  Music Feed
//
//  Created by Robyn Van Deventer on 7/01/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "AddGenreViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Genre.h"
#import "AddSongViewController.h"

static NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface AddGenreViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong)UITableView *genreTable;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;
@end

@implementation AddGenreViewController

# pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetchedResultsController = [Genre MR_fetchAllSortedBy:@"name"
                                                      ascending:NO
                                                  withPredicate:nil
                                                        groupBy:nil
                                                       delegate:self];
    [NSFetchedResultsController deleteCacheWithName:@"ArtistCache"];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }

    self.title = @"Genre";
    self.navigationController.navigationBar.translucent = NO;
    [self setupScreen];
}

- (void)setupScreen {
    
    //Genre table view
    self.genreTable = [[UITableView alloc] init];
    self.genreTable.translatesAutoresizingMaskIntoConstraints = NO;
    self.genreTable.dataSource = self;
    self.genreTable.delegate = self;
    [self.genreTable registerClass:[UITableViewCell class] forCellReuseIdentifier:ReuseIdentifier];
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
    UIAlertController *songAlertController = [UIAlertController alertControllerWithTitle:@"Add New Genre"
                                                                                 message:@"Enter a genre"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertAction *addButton = [UIAlertAction actionWithTitle:@"Add"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                                                              Genre *genre = [Genre MR_createEntityInContext:localContext];
                                                              genre.name = songAlertController.textFields[0].text;
                                                          }];
                                                      }];
    [songAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"E.g Classical";
    }];
    [songAlertController addAction:cancelButton];
    [songAlertController addAction:addButton];
    [self presentViewController:songAlertController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Genre *genre = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate genreToAdd:genre];
    [self.navigationController popViewControllerAnimated:YES];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    Genre *genreName = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Update cell with artist details
    cell.textLabel.text = genreName.name;
}

# pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.genreTable beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.genreTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.genreTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.genreTable;
    
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
    [self.genreTable endUpdates];
}

@end
