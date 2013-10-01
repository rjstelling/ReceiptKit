//
//  RTKASN1Set.h
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTKASN1Object.h"

@interface RTKASN1Set : RTKASN1Object <NSFastEnumeration>

//Access
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end
