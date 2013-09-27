//
//  RTKOctetString.h
//  ReceiptKit
//
//  Created by Richard Stelling on 27/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTKASN1Object.h"

@interface RTKOctetString : RTKASN1Object

@property (readonly, nonatomic) int type;
@property (readonly, nonatomic) NSData *data;

- (instancetype)initWithData:(NSData *)seqData;

@end
