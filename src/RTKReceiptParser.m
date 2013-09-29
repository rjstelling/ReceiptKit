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
//#import <IOKit/IOKitLib.h>

//ASN.1 Object includes
#import "RTKASN1Object.h"
#import "RTKASN1Set.h"
#import "RTKASN1Sequence.h"
#import "RTKASN1OctetString.h" //TODO: refactor name

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
                                       @(RTKInAppPurchase) : @"In App Purchase",
                                       @(RTKQuantity) : @"Quantity",
                                       @(RTKProductIdentifier) : @"Product Identifier",
                                       @(RTKTransactionIdentifier) : @"Transaction Identifier",
                                       @(RTKPurchaseDate) : @"Purchase Date",
                                       @(RTKOriginalTransactionIdentifier) : @"Original Transaction Identifier",
                                       @(RTKOriginalPurchaseDate) : @"Original Purchase Date"};
    
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
                NSLog(@"%@: %@", typeIDDictionary[@(typeID)], ((RTKASN1OctetString *)seq[2]).data);
            }
            else if(typeID == RTKOpaqueValue || typeID == RTKHash)
            {
                //These are just data so we cant print them out
                NSData *data = ((RTKASN1OctetString *)seq[2]).data;
                NSLog(@"%@ -> (length: %d)", typeIDDictionary[@(typeID)], data.length);
            }
            else if(typeID == RTKInAppPurchase)
            {
                static int count = 0; count++;
                if([((RTKASN1OctetString *)seq[2]).data isKindOfClass:[RTKASN1Set class]])
                {
                    for(RTKASN1Sequence *iapSeq in ((RTKASN1OctetString *)seq[2]).data)
                    {
                        NSInteger iapTypeID = [iapSeq[0] integerValue];
                        
                        if(iapTypeID >= RTKQuantity && iapTypeID <= RTKOriginalPurchaseDate)
                        {
                            NSLog(@"%@ (%d): %@: %@", typeIDDictionary[@(typeID)], count,
                                                    typeIDDictionary[@(iapTypeID)],
                                                    ((RTKASN1OctetString *)iapSeq[2]).data);
                        }
                    }
                }
//                id obj = ((RTKASN1OctetString *)seq[2]).data;
//                NSLog(@"%@", obj);
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

// Returns a CFData object, containing the computer's GUID.
// https://developer.apple.com/library/mac/releasenotes/General/ValidateAppStoreReceipt/#//apple_ref/doc/uid/TP40010573-CH1-SW14
//CFDataRef copy_mac_address(void)
//{
//    kern_return_t             kernResult;
//    mach_port_t               master_port;
//    CFMutableDictionaryRef    matchingDict;
//    io_iterator_t             iterator;
//    io_object_t               service;
//    CFDataRef                 macAddress = nil;
//    
//    kernResult = IOMasterPort(MACH_PORT_NULL, &master_port);
//    if (kernResult != KERN_SUCCESS) {
//        printf("IOMasterPort returned %d\n", kernResult);
//        return nil;
//    }
//    
//    matchingDict = IOBSDNameMatching(master_port, 0, "en0");
//    if (!matchingDict) {
//        printf("IOBSDNameMatching returned empty dictionary\n");
//        return nil;
//    }
//    
//    kernResult = IOServiceGetMatchingServices(master_port, matchingDict, &iterator);
//    if (kernResult != KERN_SUCCESS) {
//        printf("IOServiceGetMatchingServices returned %d\n", kernResult);
//        return nil;
//    }
//    
//    while((service = IOIteratorNext(iterator)) != 0) {
//        io_object_t parentService;
//        
//        kernResult = IORegistryEntryGetParentEntry(service, kIOServicePlane,
//                                                   &parentService);
//        if (kernResult == KERN_SUCCESS) {
//            if (macAddress) CFRelease(macAddress);
//            
//            macAddress = (CFDataRef) IORegistryEntryCreateCFProperty(parentService,
//                                                                     CFSTR("IOMACAddress"), kCFAllocatorDefault, 0);
//            IOObjectRelease(parentService);
//        } else {
//            printf("IORegistryEntryGetParentEntry returned %d\n", kernResult);
//        }
//        
//        IOObjectRelease(service);
//    }
//    IOObjectRelease(iterator);
//    
//    return macAddress;
//}


@end
