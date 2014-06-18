//
//  Filter.h
//  Yelp
//
//  Created by Savla, Sumit on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject

@property (nonatomic, strong) NSString *heading;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSArray *apiParams;
@end
