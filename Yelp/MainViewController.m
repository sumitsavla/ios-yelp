//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "YelpClient.h"
#import "PlaceViewCell.h"
#import "Place.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()
@property (strong, nonatomic) NSArray *places;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property UIBarButtonItem *leftButton;

@property (nonatomic, strong) YelpClient *client;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight=120;
    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceViewCell" bundle:nil] forCellReuseIdentifier:@"PlaceCell"];

    self.searchBar.delegate = self;
    
    self.leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:@selector(onLeftButton:)];
    self.navigationItem.leftBarButtonItem = self.leftButton;

  //  [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    // Do any additional setup after loading the view from its nib.
}
                       
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    PlaceViewCell *placeView = [self.tableView dequeueReusableCellWithIdentifier:@"PlaceCell"];
    if (!placeView) {
        placeView = [[PlaceViewCell alloc] init];
    }
    NSLog(@"INDEX PATH %i",indexPath.row);

    Place *place = self.places[indexPath.row];
    NSLog(@"%@",place.name);
    placeView.nameLbl.text = place.name;
    placeView.reviewCLbl.text = [NSString stringWithFormat:@"%@ Reviews",  place.reviewCount];
    NSLog(@"%@",place.reviewCount);
    placeView.distanceLbl.text = place.distance;
    placeView.addrLbl.text = [NSString stringWithFormat:@"%@, %@", place.address, place.city];
    
    NSURL *urlObject = [NSURL URLWithString:place.imageUrl];
    __weak UIImageView *placeImage = placeView.placeImg;
    
    [placeImage
     setImageWithURLRequest:[NSURLRequest requestWithURL:urlObject]
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             placeImage.alpha = 0.0;
             placeImage.image = image;
             [UIView animateWithDuration:0.5
                              animations:^{
                                  placeImage.alpha = 1.0;
                              }];
     }
     failure:nil];
    
    return placeView;
}

- (IBAction)onLeftButton:(id)sender {

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *term = searchBar.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.client searchWithTerm:term success:^(AFHTTPRequestOperation *operation, id response) {
        self.places = [Place placesWithArray:response[@"businesses"]];
        NSLog(@"NO. of places ... %i",self.places.count);
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"response: %@", response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //TODO network error handling
        NSLog(@"error: %@", [error description]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [self.view endEditing:YES];
    [self.searchBar resignFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
