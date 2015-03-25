//
//  ViewController.m
//  parisCapote
//
//  Created by Julien SECHAUD on 24/03/2015.
//  Copyright (c) 2015 ma. All rights reserved.
//

#import "ViewController.h"
#import <RestKit/RestKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "PCPlace.h"

#import <MapKit/MapKit.h>


@interface ViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate> {
    MKMapView* mapview;
}
@property (nonatomic, strong)   RKObjectManager *objectManager;

@end

@implementation ViewController

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setTitle:@"capoteMap"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self launchRequest];
    
}

- (void) buildMap {
    mapview = [MKMapView new];
    CLLocationCoordinate2D coord;
    coord.longitude = (CLLocationDegrees)[[NSNumber numberWithFloat:2.3488000] doubleValue];

    coord.latitude = (CLLocationDegrees)[[NSNumber numberWithFloat:48.8534100] doubleValue];

    [mapview setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(coord.latitude, coord.longitude), MKCoordinateSpanMake(0.1, 0.1))];
    [mapview setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    for (PCPlace* currentPlace in _places) {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D coord;
        coord.longitude = (CLLocationDegrees)[[[currentPlace.fields objectForKey:@"geo_coordinates"] objectAtIndex:1] doubleValue];
        coord.latitude = (CLLocationDegrees)[[[currentPlace.fields objectForKey:@"geo_coordinates"] objectAtIndex:0] doubleValue];
        NSString *snippetString = [currentPlace.fields objectForKey:@"site"];
        point.coordinate = coord;
        point.title = snippetString;
        point.subtitle = @"I'm here!!!";
        
        [mapview addAnnotation:point];
    }
    
    self.view = mapview;

}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}

- (void) constructMap {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:48.8534100
                                                            longitude:2.3488000
                                                                 zoom:12];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    for (PCPlace* currentPlace in _places) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        CLLocationCoordinate2D coord;
        coord.longitude = (CLLocationDegrees)[[[currentPlace.fields objectForKey:@"geo_coordinates"] objectAtIndex:1] doubleValue];
        coord.latitude = (CLLocationDegrees)[[[currentPlace.fields objectForKey:@"geo_coordinates"] objectAtIndex:0] doubleValue];
        NSString *snippetString = [currentPlace.fields objectForKey:@"site"];
        marker.position = coord;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.snippet = snippetString;
        marker.icon = [UIImage imageNamed:@"flag_icon"];
        marker.map = mapView;
    }
    
    self.view = mapView;
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
                                    [self buildMap];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
