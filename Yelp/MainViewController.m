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
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()
@property (strong, nonatomic) NSArray *places;
@property (strong, nonatomic) NSString *term;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property UIBarButtonItem *leftButton;
@property (nonatomic, strong) PlaceViewCell *stubCell;

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

- (void) viewDidAppear
{
    FilterViewController *f = [[FilterViewController alloc] init];
    f.delegate = self;
}

- (void)filterViewController:(FilterViewController *)viewController didChooseFilters:(NSMutableDictionary *)values {
    
    NSLog(@"didChooseValues 1");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.client searchWithOptions:self.term options:values success:^(AFHTTPRequestOperation *operation, id response) {
        self.places = [Place placesWithArray:response[@"businesses"]];
        NSLog(@"NO. of places ... %i",self.places.count);
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //TODO network error handling
        NSLog(@"error: %@", [error description]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
   // self.tableView.rowHeight=120;
    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceViewCell" bundle:nil] forCellReuseIdentifier:@"PlaceCell"];
    self.stubCell = [[UINib nibWithNibName:@"PlaceViewCell" bundle:nil] instantiateWithOwner:nil options:nil][0];
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor redColor];

    self.leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:@selector(onLeftButton:)];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    
    self.term = @"indian";
    self.searchBar.text = @"Indian";
    [self searchByTerm:@"indian"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceViewCell *placeView = [self.tableView dequeueReusableCellWithIdentifier:@"PlaceCell"];
    [self configureCell:placeView atIndexPath:indexPath];
    
    return placeView;
}

- (PlaceViewCell *)stubCell
{
    if (!_stubCell)
    {
        _stubCell = [self.tableView dequeueReusableCellWithIdentifier:@"PlaceCell"];
    }
    return _stubCell;
}

- (void)configureCell:(PlaceViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Place *place = self.places[indexPath.row];
    
    cell.nameLbl.text = [NSString stringWithFormat:@"%@", place.name];
    cell.reviewCLbl.text = [NSString stringWithFormat:@"%@ Reviews",  place.reviewCount];
    cell.addrLbl.text = [NSString stringWithFormat:@"%@, %@", place.address, place.city];
    
    NSURL *placeUrl = [NSURL URLWithString:place.imageUrl];
    __weak UIImageView *placeImage = cell.placeImg;
    
    [placeImage
     setImageWithURLRequest:[NSURLRequest requestWithURL:placeUrl]
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
    
    NSURL *ratingUrl = [NSURL URLWithString:place.ratingImageUrl];
    __weak UIImageView *ratingImage = cell.ratingImg;
    
    [ratingImage
     setImageWithURLRequest:[NSURLRequest requestWithURL:ratingUrl]
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         ratingImage.image = image;
     }
     
     failure:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:self.stubCell atIndexPath:indexPath];
    [self.stubCell layoutSubviews];
    [self.stubCell layoutIfNeeded];
    
    CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (IBAction)onLeftButton:(id)sender {
    
    FilterViewController *fvc = [[FilterViewController alloc] init];
    fvc.delegate = self;
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void) searchByTerm:(NSString *)term{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.client searchWithTerm:term success:^(AFHTTPRequestOperation *operation, id response) {
        self.places = [Place placesWithArray:response[@"businesses"]];
        NSLog(@"NO. of places ... %i",self.places.count);
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //TODO network error handling
        NSLog(@"error: %@", [error description]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *term = searchBar.text;
    self.term = term;
    [self searchByTerm:term];
    [self.view endEditing:YES];
    [self.searchBar resignFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
