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

- (instancetype)initWithData:(NSData *)seqData
{
    if(self = [super init])
    {
        id decodedObjects = [RTKASN1Sequence decodeASN1Data:seqData];
        
        if([decodedObjects isKindOfClass:[NSArray class]])
        {
            _seqArray = decodedObjects;
        }
        else //single item
        {
            _seqArray = @[decodedObjects];
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
