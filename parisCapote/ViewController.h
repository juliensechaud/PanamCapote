//
//  ViewController.h
//  parisCapote
//
//  Created by Julien SECHAUD on 24/03/2015.
//  Copyright (c) 2015 ma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    NSArray *_places;
}
@property (weak, nonatomic) IBOutlet UITableView *placesTableView;


@end

