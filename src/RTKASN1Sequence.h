//
//  RTKASN1Sequence.h
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTKASN1Object.h"

@interface RTKASN1Sequence : RTKASN1Object <NSFastEnumeration>

- (instancetype)initWithData:(NSData *)seqData;

//Access
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end

@interface RTKASN1Sequence (ReceiptKit)

//Naive access
- (NSInteger)objectTypeID;
- (NSInteger)objectVersion;
- (id)objectValue;

@end