//
//  AddArtistViewController.h
//  Music Feed
//
//  Created by Robyn Van Deventer on 7/01/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artist.h"

@protocol AddArtistViewControllerDelegate <NSObject>

- (void)artistToAdd:(Artist*)artist;

@end

@interface AddArtistViewController : UIViewController
@property (nonatomic, weak) id<AddArtistViewControllerDelegate> delegate;
@end
