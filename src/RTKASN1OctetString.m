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

//- (void)decodeASN1OctetString:(NSData *)data
//{
//    const uint8_t *locationInData = data.bytes;
//    long lengthToRead = (long)data.length;
//    
//    long length = 0;    //hold returnd length of read data
//    int xclass = 0;     //hold type of object
//    
//    int result = ASN1_get_object(&locationInData, &length, &_type, &xclass, lengthToRead);
//    
//    if(result == V_ASN1_CONTEXT_SPECIFIC)
//    {
//        //This ASN.1 Octet String has no type data so we just pass the entire data
//        _data = [data copy];
//    }
//    else if(result == V_ASN1_UNIVERSAL)
//    {
//        _data = [NSData dataWithBytesNoCopy:(void *)locationInData length:length freeWhenDone:NO];
//    }
//    else if(result == V_ASN1_CONSTRUCTED)
//    {
//        NSData *asn1ObjectData = [NSData dataWithBytesNoCopy:(void *)locationInData length:length freeWhenDone:NO];
////#error decoding iap is broken
////        switch(_type)
////        {
////            case V_ASN1_SEQUENCE:
////            {
////                RTKASN1Sequence *sequence = [[RTKASN1Sequence alloc] initWithData:asn1ObjectData];
////                _data = sequence;
////                //[decodedObjects addObject:sequence];
////            }
////                break;
////                
////            case V_ASN1_SET:
////            {
////                RTKASN1Set *set = [[RTKASN1Set alloc] initWithData:asn1ObjectData];
////                _data = set;
////            }
////                break;
////                
////            default:
////                NSLog(@"We found more ASN.1 data of type: %d", _type);
////                break;
////        }
//    }
//    else
//    {
//        //TODO:
//        NSLog(@"I can't handle this type of data. _data will be nil.");
//    }
//}

@end
