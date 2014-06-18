//
//  MainViewController.h
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"

@interface MainViewController : UIViewController <FilterViewControllerDelegate,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@end
