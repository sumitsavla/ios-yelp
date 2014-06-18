//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSDictionary *parameters = @{@"term": term, @"location" : @"San Francisco"};
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)searchWithOptions:(NSString *)term options:(NSDictionary *)options success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSLog(@"Applying Filters.....");

    NSMutableDictionary *parameters = [@{@"term": term, @"location" : @"San Francisco"} mutableCopy];
    
    if (options[@"deals_filter"]) {
        parameters[@"deals_filter"] = options[@"deals_filter"];
    }
    if (options[@"sort"]) {
        parameters[@"sort"] = options[@"sort"];
    }
    if (options[@"radius_filter"]) {
        parameters[@"radius_filter"] = options[@"radius_filter"];
    }
    if (options[@"category_filter"]) {
        parameters[@"category_filter"] = options[@"category_filter"];
    }
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}


@end
