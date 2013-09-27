//
//  RTKOctetString.m
//  ReceiptKit
//
//  Created by Richard Stelling on 27/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "RTKOctetString.h"
#import <openssl/pkcs7.h>

@implementation RTKOctetString

- (instancetype)initWithData:(NSData *)strData
{
    if(self = [super init])
    {
        [self decodeASN1OctetString:strData];
    }
    
    return self;
}

- (void)decodeASN1OctetString:(NSData *)data
{
    const uint8_t *locationInData = data.bytes;
    long lengthToRead = (long)data.length;
    
    long length = 0;    //hold returnd length of read data
    int xclass = 0;     //hold type of object
    
    int result = ASN1_get_object(&locationInData, &length, &_type, &xclass, lengthToRead);
    
    _data = [NSData dataWithBytesNoCopy:(void *)locationInData length:length freeWhenDone:NO];
}

@end
