//
//  RTKASN1Object.h
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#error THIS IS LEGACY CODE DO NOT USE

#import <Foundation/Foundation.h>

@interface RTKASN1Object : NSObject
{
    @protected
    id _decodedData;
}

+ (id)decodeASN1Data:(NSData *)data;
- (instancetype)initWithData:(NSData *)asn1Data;

@end
