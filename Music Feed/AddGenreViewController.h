//
//  AddGenreViewController.h
//  Music Feed
//
//  Created by Robyn Van Deventer on 7/01/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Genre.h"

@protocol AddGenreViewControllerDelegate <NSObject>

- (void)genreToAdd:(Genre*)genre;

@end

@interface AddGenreViewController : UIViewController
@property (nonatomic, weak) id<AddGenreViewControllerDelegate> delegate;
@end
