//
//  RTKANS1ObjectContainer.m
//  rtk-proto
//
//  Created by Richard Stelling on 06/05/2014.
//  Copyright (c) 2014 Richard Stelling. All rights reserved.
//

#import "RTKANS1ObjectContainer.h"

@implementation RTKANS1ObjectContainer

#pragma mark - Accessors

- (void)addObject:(id)obj
{
    NSAssert(_internal, @"Missing internal container storage");
    
    [self setObject:obj atIndexedSubscript:[_internal count]];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    NSAssert(_internal, @"Missing internal container storage");
    
    return _internal?[_internal objectAtIndexedSubscript:idx]:nil;
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    NSAssert(_internal, @"Missing internal container storage");
    
    [_internal setObject:obj atIndexedSubscript:idx];
}

- (NSUInteger)count
{
    NSAssert(_internal, @"Missing internal container storage");
    
    return [_internal count];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    NSAssert(_internal, @"Missing internal container storage");
    
    return [_internal countByEnumeratingWithState:state objects:buffer count:len];
}

@end
