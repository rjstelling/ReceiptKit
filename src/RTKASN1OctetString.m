//
//  RTKOctetString.m
//  ReceiptKit
//
//  Created by Richard Stelling on 27/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "RTKASN1OctetString.h"
//#import <openssl/pkcs7.h>
//#import "RTKASN1Sequence.h"
//#import "RTKASN1Set.h"

@implementation RTKASN1OctetString

- (instancetype)initWithData:(NSData *)strData
{
    if(self = [super init])
    {
        //This should be a set or sequence
        _data = [RTKASN1OctetString decodeASN1Data:strData];
    }
    
    return self;
}

@end
