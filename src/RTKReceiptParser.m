//
//  RTKReceiptParser.m
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "RTKReceiptParser.h"
#import "NSData+Crypto.h"

#import "RTKPurchaseInformation.h"

//ASN.1 Object includes
#import "RTKASN1Object.h"
#import "RTKASN1Set.h"
#import "RTKASN1Sequence.h"
#import "RTKASN1OctetString.h"

@implementation RTKReceiptParser
{
    RTKASN1Object *_internalDecodedPayloadCache;
    
    RTKPurchaseInformation *_purchaseInfo;
    
    //Cached receipt and cert. data
    NSData *_receiptData;
    NSData *_certificateData;
}

#pragma mark - Properties

- (RTKPurchaseInformation *)purchaseInfo
{
    if(!_purchaseInfo)
    {
        _internalDecodedPayloadCache = [RTKReceiptParser decodedPayload:_receiptData certificate:_certificateData];
        _purchaseInfo = [[RTKPurchaseInformation alloc] initWithASN1Object:_internalDecodedPayloadCache];
    }
    
    return _purchaseInfo;
}

#pragma mark - Life Style

- (instancetype)initWithReceipt:(NSData *)receiptData certificate:(NSData *)certificateData
{
    if(self = [super init])
    {
        _receiptData = [receiptData copy];
        _certificateData = [certificateData copy];
    }
    
    return self;
}

#pragma mark - Public

+ (instancetype)defaultParser
{
    static dispatch_once_t onceToken;
    static id defaultParser_ = nil;
    dispatch_once(&onceToken, ^{
        defaultParser_ = [[self alloc] init];
    });
    
    return defaultParser_;
}

+ (BOOL)isReceiptValid:(NSData *)receiptData certificate:(NSData *)certificateData
{
    BOOL success = NO;
    RTKASN1Object *decodedPayload = [self decodedPayload:receiptData certificate:certificateData];
    
    if(decodedPayload)
    {
        success = YES;
    }
    
    return success;
}

+ (RTKASN1Object *)decodedPayload:(NSData *)receiptData certificate:(NSData *)certificateData
{   
    RTKASN1Object *decodedPayload = nil;
    NSError *error = nil;
    
    //This paylod is encoded in ASN.1
    NSData *payload = [receiptData PKCS7Verify:certificateData error:&error];
    
    if(payload)
    {
        //This object will most likly be a RTKASN1Set and contain all
        //of the other decoded objects
        decodedPayload = [RTKASN1Object decodeASN1Data:payload];
    }
    else
    {
        NSLog(@"Error: %@", error);
    }

    return decodedPayload;
}

//- (BOOL)isBundleIdentifierValid:(NSString *)bundleIdentifier
//{
//#warning TODO
//    
//    return NO;
//}
//
//- (BOOL)isBundleVersionValid:(NSString *)bundleVersion
//{
//#warning TODO
//    
//    return NO;
//}

- (BOOL)isReceiptValidForDevice:(NSString *)bundleIdentifier
{
    NSParameterAssert(bundleIdentifier);
    NSAssert(_receiptData, @"Missing receipt data.");
    NSAssert(_certificateData, @"Missing cert. data.");
    
    BOOL success = NO;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:48];
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    
    if(self.purchaseInfo)
    {
        // Get Device Identifier as bytes
        //uuid + bundle id + opaque
        uuid_t uuidBytes;
        [uuid getUUIDBytes:uuidBytes];

        //The bundle id needs to be pre-pended with the UTF8 ASN.1 type (12) and
        //the length of the string
        char pre[2] = {12, bundleIdentifier.length};
        NSMutableData *bundleIDData = [NSMutableData dataWithCapacity:bundleIdentifier.length+2];
        [bundleIDData appendBytes:pre length:2];
        [bundleIDData appendBytes:[bundleIdentifier UTF8String] length:bundleIdentifier.length];
        
        [data appendBytes:uuidBytes length:sizeof(uuid_t)];
//#error opaque value is array not data
        [data appendBytes:self.purchaseInfo.opaqueValue.bytes length:self.purchaseInfo.opaqueValue.length];
        [data appendData:bundleIDData];
        
        NSData *sha1 = [data sha1Value];
    
        success = [sha1 isEqualToData:self.purchaseInfo.hash];
    }
    
    return success;
}

#pragma mark - Private



@end
