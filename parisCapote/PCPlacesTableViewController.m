//
//  PCPlacesTableViewController.m
//  Pods
//
//  Created by Julien SECHAUD on 25/03/2015.
//
//

#import "PCPlacesTableViewController.h"
#import <MapKit/MapKit.h>
#import <RestKit/RestKit.h>
#import "PCPlace.h"

@interface PCPlacesTableViewController ()
@property (nonatomic, strong)   RKObjectManager *objectManager;

@end

@implementation PCPlacesTableViewController

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setTitle:@"capoteList"];
    [self launchRequest];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) launchRequest {
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
    // Init our base URL
    NSURL *baseURL = [NSURL URLWithString:@"http://opendata.paris.fr"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    //Configure Restkit
    RKObjectMapping *logMapping = [RKObjectMapping mappingForClass:[PCPlace class]];
    [logMapping addAttributeMappingsFromArray:@[@"datasetid", @"recordid", @"fields", @"geometry", @"record_timestamp"]];
    RKResponseDescriptor *logResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:logMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:nil
                                                keyPath:@"records"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [self.objectManager addResponseDescriptor:logResponseDescriptor];
    
    
    
    // Load the object model via RestKit
    
    [self.objectManager getObjectsAtPath:@"/api/records/1.0/search?dataset=distributeurspreservatifsmasculinsparis2012&facet=annee_installation&facet=arrond&facet=acces"
                              parameters:@{@"rows":@"31"}
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                     NSArray* places = [mappingResult array];
                                     _places = places;
                                     if(self.isViewLoaded) {
                                         [_placesTableView reloadData];
                                     }
                                     
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                     message:[error localizedDescription]
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"OK"
                                                                           otherButtonTitles:nil];
                                     [alert show];
                                     NSLog(@"Hit error: %@", error);
                                 }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark -
#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    __weak PCPlace *currentPlace = [_places objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentPlace.fields objectForKey:@"site"];
    return cell;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
