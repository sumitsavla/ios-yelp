//
//  Place.h
//  Yelp
//
//  Created by Savla, Sumit on 6/13/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *ratingImageUrl;
@property (nonatomic, strong) NSString *reviewCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)placesWithArray:(NSArray *)array;

@end
