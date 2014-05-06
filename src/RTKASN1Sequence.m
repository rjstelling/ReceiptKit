//
//  RTKASN1Sequence.m
//  ReceiptKit
//
//  Created by Richard Stelling on 03/05/2014.
//  Copyright (c) 2014 Richard Stelling. All rights reserved.
//

#import "RTKASN1Sequence.h"
#import "RTKASN1Set.h"

@implementation RTKASN1Sequence

#pragma mark - Life Cycle

- (instancetype)initWithData:(NSData *)ans1Data
{
    self = [super initWithData:ans1Data];
    
    if(self)
    {
        _internal = [NSMutableArray arrayWithCapacity:1];
    }
    
    return self;
}

- (instancetype)initWithType:(RTKANS1ObjectType)ans1Type tag:(RTKANS1ObjectXClass)ans1Tag data:(NSData *)ans1Data
{
    self = [super initWithType:ans1Type tag:ans1Tag data:ans1Data];
    
    if(self)
    {
        _internal = [NSMutableArray arrayWithCapacity:1];
    }
    
    return self;
}

#pragma mark - NSObject

- (NSString *)description
{
    NSString *desc = @"";
    
    desc = [NSString stringWithFormat:@"<RTK SEQUENCE : %p> count: %ld", self, (unsigned long)[self count]];
    
    for (RTKASN1Object *obj in _internal)
    {
        desc = [desc stringByAppendingFormat:@"\t\n%@", [obj description]];
    }
    
    return desc;
    
}

@end
