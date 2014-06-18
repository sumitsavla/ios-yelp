//
//  Place.m
//  Yelp
//
//  Created by Savla, Sumit on 6/13/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Place.h"

@implementation Place

- (id)initWithDictionary:(NSDictionary *)place {
    self = [super init];
    if (self) {
        self.name = place[@"name"];
        self.distance = [NSString stringWithFormat:@"%@",place[@"distance"]];
        self.rating = [NSString stringWithFormat:@"%@",place[@"rating"]];
        self.reviewCount = [NSString stringWithFormat:@"%@",place[@"review_count"]];
        NSArray *locations = place[@"location"][@"address"];
        self.address = locations.count ? locations[0] : @"";
        self.city = place[@"location"][@"city"];
        self.imageUrl = place[@"image_url"];
        self.ratingImageUrl = place[@"rating_img_url"];
        for (NSArray *category in place[@"categories"]){
            [self.categories addObject:(NSString *)category[0]];
        }
    }
    
    return self;
}

+ (NSArray *)placesWithArray:(NSArray *)array {
    NSMutableArray *places = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        Place *place = [[Place alloc] initWithDictionary:dictionary];
        [places addObject:place];
    }
    
    return places;
}

@end
