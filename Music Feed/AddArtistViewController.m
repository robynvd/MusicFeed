//
//  AddArtistViewController.m
//  Music Feed
//
//  Created by Robyn Van Deventer on 7/01/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "AddArtistViewController.h"
#import "Artist.h"
#import <MagicalRecord/MagicalRecord.h>
#import "AddSongViewController.h"
static NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface AddArtistViewController () <UITableViewDataSource, NSFetchedResultsControllerDelegate, UITableViewDelegate>
@property (nonatomic, strong)UITableView *artistTable;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;
@end

@implementation AddArtistViewController

# pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetchedResultsController = [Artist MR_fetchAllSortedBy:@"name"
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
    self.title = @"Artist";
    self.navigationController.navigationBar.translucent = NO;
    [self setupScreen];
}

- (void)setupScreen {
    
    //Artist table view
    self.artistTable = [[UITableView alloc] init];
    self.artistTable.translatesAutoresizingMaskIntoConstraints = NO;
    self.artistTable.dataSource = self;
    self.artistTable.delegate = self;
    [self.artistTable registerClass:[UITableViewCell class] forCellReuseIdentifier:ReuseIdentifier];
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
    UIAlertController *songAlertController = [UIAlertController alertControllerWithTitle:@"Add New Artist"
                                                                                  message:@"Enter a name of an artist"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
    [songAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"E.g Beyonce";
    }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil];
    UIAlertAction *addButton = [UIAlertAction actionWithTitle:@"Add"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                                                              Artist *artist = [Artist MR_createEntityInContext:localContext];
                                                              artist.name = songAlertController.textFields[0].text;
                                                          }];
                                                      }];
    [songAlertController addAction:cancelButton];
    [songAlertController addAction:addButton];
    [self presentViewController:songAlertController animated:YES completion:nil];
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
    Artist *artistName = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Update cell with artist details
    cell.textLabel.text = artistName.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Artist *artist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate artistToAdd:artist];
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.artistTable beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.artistTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.artistTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.artistTable;
    
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
    [self.artistTable endUpdates];
}

@end
