//
//  RTKPurchaseInformation.m
//  ReceiptKit
//
//  Created by Richard Stelling on 30/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "RTKPurchaseInformation.h"
#import "RTKASN1Set.h"
#import "RTKASN1Sequence.h"
#import "RTKASN1OctetString.h"

@implementation RTKPurchaseInformation

- (instancetype)initWithASN1Object:(RTKASN1Object *)asn1Object
{
    if(self = [super init])
    {
        if([asn1Object isKindOfClass:[RTKASN1Set class]])
        {
            [self extractProperties:(RTKASN1Set *)asn1Object];
        }
        else
        {
            self = nil;
        }
    }
    
    return self;
}

#pragma mark - NSObject 

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"<%@: %@ (%@), %d In App Purchases: %@>",
                      self.bundleIdentifier, self.bundleVersion, self.originalVersion,
                      [self.inAppPurchases count], self.inAppPurchases];
    
    return desc;
}

#pragma mark - Helpers

- (void)extractProperties:(RTKASN1Set *)decodedPayload
{
    //Loging Info
//    NSDictionary *typeIDDictionary = @{@(RTKBundleID) : @"Bundle ID",
//                                       @(RTKVersion) : @"Version",
//                                       @(RTKOriginalVersion) : @"Original Version",
//                                       /*@(RTKExpiryDate) : @"Expiry Date"*/
//                                       @(RTKOpaqueValue) : @"Opaque Value",
//                                       @(RTKHash) : @"Hash",
//                                       @(RTKInAppPurchase) : @"In App Purchase",
//                                       @(RTKQuantity) : @"Quantity",
//                                       @(RTKProductIdentifier) : @"Product Identifier",
//                                       @(RTKTransactionIdentifier) : @"Transaction Identifier",
//                                       @(RTKPurchaseDate) : @"Purchase Date",
//                                       @(RTKOriginalTransactionIdentifier) : @"Original Transaction Identifier",
//                                       @(RTKOriginalPurchaseDate) : @"Original Purchase Date"};
    
    for(RTKASN1Sequence *seq in (RTKASN1Set *)decodedPayload)
    {
        NSInteger typeID = [seq[0] integerValue];
        
        switch(typeID)
        {
            case RTKBundleID:
                _bundleIdentifier = ((RTKASN1OctetString *)seq[2]).data;
                break;

            case RTKVersion:
                _bundleVersion = ((RTKASN1OctetString *)seq[2]).data;
                break;
                
            case RTKOriginalVersion:
                _originalVersion = ((RTKASN1OctetString *)seq[2]).data;
                break;
                
            case RTKOpaqueValue:
                _opaqueValue = ((RTKASN1OctetString *)seq[2]).data;
                break;
                
            case RTKHash:
                _hash = ((RTKASN1OctetString *)seq[2]).data;
                break;
            
            case RTKInAppPurchase:
            {
                RTKInAppPurchaseInformation *iap = [[RTKInAppPurchaseInformation alloc] initWithASN1Object:((RTKASN1OctetString *)seq[2]).data];
                
                if(_inAppPurchases)
                {
                    _inAppPurchases = [_inAppPurchases setByAddingObject:iap];
                }
                else
                {
                    _inAppPurchases = [NSSet setWithObject:iap];
                }
            }
                break;
                
            default:
                //Undocumented types
                break;
        }
        
//        //These are the only documented Type IDs
//        //https://developer.apple.com/library/mac/releasenotes/General/ValidateAppStoreReceipt/
//        if(typeID == RTKBundleID || typeID == RTKVersion || typeID == RTKOriginalVersion)
//        {
//            NSLog(@"%@: %@", typeIDDictionary[@(typeID)], ((RTKASN1OctetString *)seq[2]).data);
//        }
//        else if(typeID == RTKOpaqueValue || typeID == RTKHash)
//        {
//            //These are just data so we cant print them out
//            NSData *data = ((RTKASN1OctetString *)seq[2]).data;
//            NSLog(@"%@ -> (length: %d)", typeIDDictionary[@(typeID)], data.length);
//        }
//        else if(typeID == RTKInAppPurchase)
//        {
//            static int count = 0; count++;
//            if([((RTKASN1OctetString *)seq[2]).data isKindOfClass:[RTKASN1Set class]])
//            {
//                for(RTKASN1Sequence *iapSeq in ((RTKASN1OctetString *)seq[2]).data)
//                {
//                    NSInteger iapTypeID = [iapSeq[0] integerValue];
//                    
//                    if(iapTypeID >= RTKQuantity && iapTypeID <= RTKOriginalPurchaseDate)
//                    {
//                        NSLog(@"%@ (%d): %@: %@", typeIDDictionary[@(typeID)], count,
//                              typeIDDictionary[@(iapTypeID)],
//                              ((RTKASN1OctetString *)iapSeq[2]).data);
//                    }
//                }
//            }
//            //                id obj = ((RTKASN1OctetString *)seq[2]).data;
//            //                NSLog(@"%@", obj);
//        }
//        else
//        {
//            //Ignore these as thay are internal and not documented
//        }
    }
}

@end
