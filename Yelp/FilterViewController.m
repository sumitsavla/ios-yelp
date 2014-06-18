//
//  FilterViewController.m
//  Yelp
//
//  Created by Savla, Sumit on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "Filter.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (nonatomic, strong) NSMutableDictionary *isExpanded;
@property (nonatomic, strong) NSMutableDictionary *selectedOptions;
@property (nonatomic, strong) NSMutableDictionary *selectedParams;
@property (nonatomic, strong) NSMutableArray *filters;
@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isExpanded = [[NSMutableDictionary alloc] initWithCapacity:4];
        self.selectedOptions = [[NSMutableDictionary alloc] initWithCapacity:4];
        self.selectedParams = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.filterTableView.dataSource = self;
    self.filterTableView.delegate = self;
    self.filterTableView.tintColor =  [UIColor redColor];
    self.title = @"Filters";
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(onSearchButton:)];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    Filter *sortFilter = [[Filter alloc] init];
    sortFilter.heading = @"Sort By";
    sortFilter.name = @"sort";
    sortFilter.type = @"collapsible";
    sortFilter.options = @[@"Distance", @"Best Match", @"Rating"];
    sortFilter.apiParams = @[@"1", @"0", @"2"];
    
    Filter *radiusFilter = [[Filter alloc] init];
    radiusFilter.heading = @"Search Radius";
    radiusFilter.name = @"radius_filter";
    radiusFilter.type = @"collapsible";
    radiusFilter.options = @[@"50 meters", @"100 meters", @"500 meters", @"1000 meters"];
    radiusFilter.apiParams = @[@"50", @"100", @"500", @"1000"];
    
    Filter *popularFilter = [[Filter alloc] init];
    popularFilter.heading = @"Most Popular";
    popularFilter.name = @"deals_filter";
    popularFilter.type = @"switch";
    popularFilter.options = @[@"Deal"];
    popularFilter.apiParams = @[@"false"];

    Filter *catFilter = [[Filter alloc] init];
    catFilter.heading = @"Restaurant Categories";
    catFilter.name = @"category_filter";
    catFilter.type = @"list";
    catFilter.options = @[@"Vegan", @"Vegetarian", @"Indian", @"Thai", @"Mexican", @"Mediterranean"];
    catFilter.apiParams = @[@"vegan", @"vegetarian", @"indpak", @"thai", @"mexican", @"mediterranean"];

    self.filters = [NSMutableArray arrayWithObjects: popularFilter, sortFilter, radiusFilter, catFilter, nil];
}

- (void)onSearchButton:(id)sender {
    NSLog(@"Selected Options :::");
    for (id key in self.selectedParams) {
        NSLog(@"key: %@, value: %@ \n", key, [self.selectedParams objectForKey:key]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    Filter *filter = self.filters[indexPath.section];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = filter.options[indexPath.row];

    if ([filter.type isEqualToString:@"collapsible"]) {
        if ((indexPath.row == 0) && ([self.filterTableView numberOfRowsInSection:indexPath.section] == 1) && ([self.selectedOptions objectForKey:filter.heading])) {
            cell.textLabel.text = [self.selectedOptions objectForKey:filter.heading];//filter.options[indexPath.row];
        }
    } else if ([filter.type isEqualToString:@"switch"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [switchView setTag:indexPath.row];
        if(self.selectedOptions[filter.options[indexPath.row]]){
            switchView.on = YES;
        }
        cell.accessoryView = switchView;
    } else if ([filter.type isEqualToString:@"list"]){
        if (![self.isExpanded[filter.heading] isEqualToValue:@YES] && indexPath.row == 3) {
            cell.textLabel.text = @"See More";
        } else if([self.selectedOptions[filter.options[indexPath.row]]  isEqual: @YES]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

- (IBAction)switchChanged:(id)sender{
    Filter *filter = self.filters[0];
    if(self.selectedOptions[filter.options][[sender tag]]){
        [self.selectedOptions removeObjectForKey:filter.options[[sender tag]]];
        self.selectedParams[filter.name] = @"false";
    } else {
        self.selectedOptions[filter.options[[sender tag]]] = @YES;
        self.selectedParams[filter.name] = @"true";
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filters.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Filter *filter = self.filters[section];
    NSArray *filterOptions = filter.options;
    
    if ([filter.type isEqualToString:@"collapsible"]) {
        if ([filter.type isEqualToString:@"collapsible"]) {
            if ([self.isExpanded[filter.heading] isEqualToValue:@NO]) {
                return filterOptions.count;
            } else {
                return 1;
            }
        }
    } else if ([filter.type isEqualToString:@"switch"]) {
        return 1;
    } else if ([filter.type isEqualToString:@"list"]) {
        if ([self.isExpanded[filter.heading] isEqualToValue:@YES]) {
            return filterOptions.count;
        } else {
            return 4;
        }
        
    }
    return filterOptions.count;
}

/*- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 70)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    return view;
}*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Filter *filter = self.filters[section];
    return filter.heading;
}

- (float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.filterTableView deselectRowAtIndexPath:indexPath animated:YES];
    Filter *filter = self.filters[indexPath.section];

    if ([filter.type isEqualToString:@"collapsible"]) {
        if ([self.isExpanded[filter.heading] isEqualToValue:@NO]) {
            self.isExpanded[filter.heading] = @YES;
            self.selectedParams[filter.name] = filter.apiParams[indexPath.row];
            self.selectedOptions[filter.heading] = filter.options[indexPath.row];
            self.selectedOptions[filter.options[indexPath.row]] = @YES;
        } else {
            self.isExpanded[filter.heading] = @NO;
        }
    } else if ([filter.type isEqualToString:@"list"]) {
        if(![self.isExpanded[filter.heading] isEqualToValue: @YES] && indexPath.row == 3){
            self.isExpanded[filter.heading] = @YES;
        } else {
            if([self.selectedOptions[filter.options[indexPath.row]]  isEqual: @YES]){
                [self.selectedOptions removeObjectForKey:filter.options[indexPath.row]];
            } else {
                self.selectedParams[filter.name] = filter.apiParams[indexPath.row];
                self.selectedOptions[filter.options[indexPath.row]] = @YES;
            }
        }
    }

    [self.filterTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    
}

@end
