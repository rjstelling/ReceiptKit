//
//  RTKASN1Set.m
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "RTKASN1Set.h"

@implementation RTKASN1Set
{
    NSOrderedSet *_setOrderedSet;
}

- (instancetype)initWithData:(NSData *)asn1Data
{
    if(self = [super initWithData:asn1Data])
    {
        if([_decodedData isKindOfClass:[NSArray class]])
        {
            _setOrderedSet = [NSOrderedSet orderedSetWithArray:_decodedData];
        }
        else //single item
        {
            _setOrderedSet = [NSOrderedSet orderedSetWithObject:_decodedData];
        }
    }
    
    return self;
}

#pragma mark - Accessors

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    if(_setOrderedSet)
        return _setOrderedSet[idx];
    else
        return nil;
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    return [_setOrderedSet countByEnumeratingWithState:state objects:buffer count:len];
}

@end
