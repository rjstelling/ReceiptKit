//
//  RTKANS1ObjectContainer.h
//  rtk-proto
//
//  Created by Richard Stelling on 06/05/2014.
//  Copyright (c) 2014 Richard Stelling. All rights reserved.
//

#import "RTKANS1Object.h"

@interface RTKANS1ObjectContainer : RTKANS1Object <NSFastEnumeration>
{
    id _internal;
}

- (NSUInteger)count;

- (void)addObject:(id)obj;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end
