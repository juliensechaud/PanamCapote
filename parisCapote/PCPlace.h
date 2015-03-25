//
//  PCPlace.h
//  Pods
//
//  Created by Julien SECHAUD on 24/03/2015.
//
//

#import <Foundation/Foundation.h>

@interface PCPlace : NSObject
@property (nonatomic, copy) NSString *datasetid;
@property (nonatomic, copy) NSString *recordid;
@property (nonatomic, copy) NSDictionary *fields;
@property (nonatomic, copy) NSDictionary *geometry;
@property (nonatomic, copy) NSString *record_timestamp;

//@property (nonatomic, assign) NSInteger *nhits;
//@property (nonatomic, copy) NSDictionary *parameters;
//@property (nonatomic, copy) NSArray *records;
//@property (nonatomic, copy) NSArray *facet_groups;





@end
