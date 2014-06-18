//
//  FilterViewController.h
//  Yelp
//
//  Created by Savla, Sumit on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewControllerDelegate;

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;

@end

@protocol FilterViewControllerDelegate <NSObject>

- (void)filterViewController:(FilterViewController*)viewController
             didChooseFilters:(NSMutableDictionary*)values;

@end

