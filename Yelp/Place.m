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
        self.address = place[@"location"][@"address"][0];
        self.city = place[@"location"][@"city"];
        self.imageUrl = place[@"image_url"];
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
