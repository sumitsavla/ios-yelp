//
//  PlaceViewCell.h
//  Yelp
//
//  Created by Savla, Sumit on 6/13/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *placeImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *reviewCLbl;
@property (weak, nonatomic) IBOutlet UILabel *addrLbl;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;

@end
