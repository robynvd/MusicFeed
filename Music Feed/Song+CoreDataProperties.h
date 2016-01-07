//
//  Song+CoreDataProperties.h
//  Music Feed
//
//  Created by Robyn Van Deventer on 7/01/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface Song (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *genre;
@property (nullable, nonatomic, retain) NSSet<Artist *> *artist;

@end

@interface Song (CoreDataGeneratedAccessors)

- (void)addGenreObject:(NSManagedObject *)value;
- (void)removeGenreObject:(NSManagedObject *)value;
- (void)addGenre:(NSSet<NSManagedObject *> *)values;
- (void)removeGenre:(NSSet<NSManagedObject *> *)values;

- (void)addArtistObject:(Artist *)value;
- (void)removeArtistObject:(Artist *)value;
- (void)addArtist:(NSSet<Artist *> *)values;
- (void)removeArtist:(NSSet<Artist *> *)values;

@end

NS_ASSUME_NONNULL_END
