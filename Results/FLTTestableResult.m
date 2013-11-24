//
//  FLTTestableResult.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTTestableResult.h"
#import "FLTestable.h"

@interface FLTTestableResult ()
@property (readwrite, strong) id<FLTestable> testable;
@end

@implementation FLTTestableResult

@synthesize testable = _unitTest;

#if FL_MRC
- (void) dealloc {
    [_unitTest release];
    [super dealloc];
}
#endif

- (NSString*) runSummary {
    return nil;
}

- (NSString*) failureDescription {

    return nil;
}

- (NSString*) testName {
    return NSStringFromClass([self.testable class]);
}

- (id) initWithUnitTest:(id<FLTestable>) testable {
    self = [super init];
    if(self) {
        self.testable = testable;
    }
    return self;
}

+ (FLTTestableResult*) unitTestResult:(id<FLTestable>) testable {
    return FLAutorelease([[[self class] alloc] initWithUnitTest:testable]);
}


@end
