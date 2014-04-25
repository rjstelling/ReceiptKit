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
            
            case RTKExpiryDate:
                _expiryDate = [NSDate dateFromReceiptDateString:((RTKASN1OctetString *)seq[2]).data];
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
    }
}

@end
