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
#import "NSDate+Receipt.h"

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
    NSString *desc = [NSString stringWithFormat:@"<%@: %@ (%@), %lu In App Purchases: %@>",
                      self.bundleIdentifier, self.bundleVersion, self.originalVersion,
                      (unsigned long)[self.inAppPurchases count], self.inAppPurchases.count>0?self.inAppPurchases:@"<empty>"];
    
    return desc;
}

#pragma mark - Helpers

- (void)extractProperties:(RTKASN1Set *)decodedPayload
{
    for(RTKASN1Sequence *seq in (RTKASN1Set *)decodedPayload)
    {        
        switch([seq objectTypeID])
        {
            case RTKBundleID:
                _bundleIdentifier = [seq objectValue];
                NSAssert([_bundleIdentifier isKindOfClass:[NSString class]], @"_bundleIdentifier is not of type NSString");
                break;
                
            case RTKVersion:
                _bundleVersion = [seq objectValue];
                NSAssert([_bundleVersion isKindOfClass:[NSString class]], @"_bundleVersion is not of type NSString");
                break;
                
            case RTKOriginalVersion:
                _originalVersion = [seq objectValue];
                NSAssert([_originalVersion isKindOfClass:[NSString class]], @"_originalVersion is not of type NSString");
                break;
                
            case RTKOpaqueValue:
                _opaqueValue = [seq objectValue];
                NSAssert([_opaqueValue isKindOfClass:[NSData class]], @"_opaqueValue is not of type NSData");
                break;
                
            case RTKHash:
                _hash = [seq objectValue];
                NSAssert([_hash isKindOfClass:[NSData class]], @"_hash is not of type NSData");
                break;
                
            case RTKExpiryDate:
                _expiryDate = [NSDate dateFromReceiptDateString:[seq objectValue]];
                break;
                
            case RTKInAppPurchase:
            {
                RTKInAppPurchaseInformation *iap = [[RTKInAppPurchaseInformation alloc] initWithASN1Object:[seq objectValue]];
                
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
    }
}

@end
