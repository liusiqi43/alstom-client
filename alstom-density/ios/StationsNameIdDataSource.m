//
//  StationsNameIdDataSource.m
//  ios
//
//  Created by Siqi Liu on 12/19/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StationsNameIdDataSource.h"
#import "DataFetcher.h"

@implementation StationsNameIdDataSource

- (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
      possibleCompletionsForString:(NSString *)string
{
    NSMutableArray *names = [[NSMutableArray alloc] init];
    if (!self.stationNameToId) {
        DataFetcher *fetcher = [DataFetcher sharedInstance];
        self.stationNameToId = [fetcher getStationNameToId];
    }
    for (NSString *key in self.stationNameToId) {
        if ([key containsString:string] || [string length] == 0) {
            [names addObject:key];
        }
    }
    return names;
}

@end