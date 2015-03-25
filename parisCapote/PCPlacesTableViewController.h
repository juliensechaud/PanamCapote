//
//  PCPlacesTableViewController.h
//  Pods
//
//  Created by Julien SECHAUD on 25/03/2015.
//
//

#import <UIKit/UIKit.h>

@interface PCPlacesTableViewController : UITableViewController {
    NSArray *_places;
}
@property (weak, nonatomic) IBOutlet UITableView *placesTableView;

@end
