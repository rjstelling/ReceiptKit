//
//  RTKASN1Sequence.m
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "RTKASN1Sequence.h"

@implementation RTKASN1Sequence
{
    NSArray *_seqArray;
}

- (instancetype)initWithData:(NSData *)asn1Data
{
    if(self = [super initWithData:asn1Data])
    {
        if([_decodedData isKindOfClass:[NSArray class]])
        {
            _seqArray = _decodedData;
        }
        else //single item
        {
            _seqArray = @[_decodedData];
        }
    }
    
    return self;
}

#pragma mark - Accessors

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    if(_seqArray)
        return _seqArray[idx];
    else
        return nil;
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    return [_seqArray countByEnumeratingWithState:state objects:buffer count:len];
}

@end

@implementation RTKASN1Sequence (ReceiptKit)

#pragma mark - Naive access

- (NSInteger)objectTypeID
{
    return [_seqArray[0] integerValue];
}

@end