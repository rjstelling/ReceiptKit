//
//  RTKReceiptParser.m
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "RTKReceiptParser.h"
#import "NSData+Crypto.h"
//#import <openssl/crypto.h>
#import <openssl/pkcs7.h>

//ASN.1 Object includes
#import "RTKASN1Object.h"
#import "RTKASN1Set.h"
#import "RTKASN1Sequence.h"
#import "RTKOctetString.h" //TODO: refactor name

/*
 ReceiptModule DEFINITIONS ::=
 BEGIN
 
 ReceiptAttribute ::= SEQUENCE {
 type    INTEGER,
 version INTEGER,
 value   OCTET STRING
 }
 
 Payload ::= SET OF ReceiptAttribute
 
 END
 */

@implementation RTKReceiptParser

#pragma mark - Public

+ (BOOL)isReceiptValid:(NSData *)receiptData certificate:(NSData *)certificateData
{
    //Loging Info
    NSDictionary *typeIDDictionary = @{@(RTKBundleID) : @"Bundle ID",
                                       @(RTKVersion) : @"Version",
                                       @(RTKOriginalVersion) : @"Original Version",
                                       /*@(RTKExpiryDate) : @"Expiry Date"*/
                                       @(RTKOpaqueValue) : @"Opaque Value",
                                       @(RTKHash) : @"Hash",
                                       @(RTKInAppPurchase) : @"In App Purchase"};
    
    BOOL success = NO;
    NSError *error = nil;
    
    //This paylod is encoded in ASN.1
    NSData *payload = [receiptData PKCS7Verify:certificateData error:&error];
    
    if(payload)
    {
        //This object will most likly be a RTKASN1Set and contain all
        //of the other decoded objects
        RTKASN1Object *decodedPayload = [RTKASN1Object decodeASN1Data:payload];
        
        for(RTKASN1Sequence *seq in (RTKASN1Set *)decodedPayload)
        {
            NSInteger typeID = [seq[0] integerValue];
            
            //These are the only documented Type IDs
            //https://developer.apple.com/library/mac/releasenotes/General/ValidateAppStoreReceipt/
            
            if(typeID == RTKBundleID || typeID == RTKVersion || typeID == RTKOriginalVersion)
            {
                //UTF8 Strings
                NSString *utf8String = [[NSString alloc] initWithData:((RTKOctetString *)seq[2]).data
                                                             encoding:NSUTF8StringEncoding];
                
                NSLog(@"%@: %@", typeIDDictionary[@(typeID)], utf8String);
                
            }
            else if(typeID == RTKOpaqueValue || typeID == RTKHash || typeID == RTKInAppPurchase)
            {
                 NSLog(@"TODO: Process \"%@\" (data length: %d)", typeIDDictionary[@(typeID)], ((RTKOctetString *)seq[2]).data.length);
            }
            else
            {
                //Ignore these as thay are internal and not documented
            }
        }
        
        success = YES;
    }
    
    return success;
}

#pragma mark - Private

@end
