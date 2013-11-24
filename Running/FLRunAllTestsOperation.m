//
//  FLRunAllTestsOperationBot.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLRunAllTestsOperation.h"
#import "FLAsyncQueue.h"
#import "FLTStaticTestMethodRunner.h"
#import "FLObjcRuntime.h"
#import "FLTestable.h"
#import "FLDispatchQueue.h"

#import "FLTTestOrganizer.h"
#import "FLTTestFactoryList.h"

#import "FLTTestFactory.h"
#import "FLTestableOperation.h"

@implementation FLRunAllTestsOperation

+ (id) testRunner {
    return FLAutorelease([[[self class] alloc] init]);
}

- (FLPromisedResult) runSynchronously {

    FLAssertNotNil(self.context);

    FLTTestOrganizer* organizer = [FLTTestOrganizer testOrganizer];
    [organizer organizeTests];

    FLTSortedTestGroupList* sortedGroupList = [organizer sortedGroupList];

    [[FLTestLoggingManager instance] appendLineWithFormat:@"Found %ld unit test classes in %ld groups",
        (unsigned long) sortedGroupList.testCount,
        (unsigned long) sortedGroupList.count];
    
    NSMutableArray* resultArray = [NSMutableArray array];

    for(FLTTestFactoryList* group in sortedGroupList) {
    
        [[FLTestLoggingManager instance] appendLineWithFormat:@"Testable Group: %@", group.groupName];

        for(id<FLTTestFactory> factory in group) {

            @autoreleasepool {
                FLTestableOperation* test = [factory createTest];

                [FLTestLogger() indentLinesInBlock:^{

                    FLPromisedResult result = [self.context runSynchronously:test];

//                    FLTTestResultCollection* result =
//                        [FLTTestResultCollection fromPromisedResult:
//                            ];

                    [resultArray addObject:result];
                }];
            }
        }
    }

//    if(results.testResults.count) {
//        NSArray* failedResults = [results failedResults];
//        if(failedResults && failedResults.count) {
//            FLTestOutput(@"%@: %d test cases failed", test.testName, failedResults.count);
//        }
//        else {
//            FLTestOutput(@"%@: %d test cases passed", test.testName, results.testResults.count);
//        }
//    }

    return resultArray;
}

@end

