//
//  RTKInAppPurchaseInformation.m
//  ReceiptKit
//
//  Created by Richard Stelling on 30/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "RTKInAppPurchaseInformation.h"
#import "RTKPurchaseInformation.h"
#import "RTKASN1Set.h"
#import "RTKASN1Sequence.h"
#import "RTKASN1OctetString.h"
#import "NSDate+Receipt.h"

@implementation RTKInAppPurchaseInformation

- (instancetype)initWithASN1Object:(RTKASN1Object *)asn1Object
{
    if(self = [super init])
    {
        if([asn1Object isKindOfClass:[RTKASN1Set class]])
        {
            [self decodeIAPProperties:(RTKASN1Set *)asn1Object];
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
    NSString *desc = [NSString stringWithFormat:@"<%@ (Quantity: %@): %@ (%@), %@ (%@)>%@",
                      self.productIdentifier, self.quantity,
                      self.transactionIdentifier, self.originalTransactionIdentifier,
                      self.purchaseDate, self.originalPurchaseDate,
                      self.isOriginalTransaction?@" <-- Original Transaction":@""];
    
    return desc;
}

#pragma mark - Helpers

- (void)decodeIAPProperties:(RTKASN1Set *)iapSetObject
{
    for(RTKASN1Sequence *iapSeq in iapSetObject)
    {
        NSInteger iapTypeID = [iapSeq[0] integerValue];

        switch(iapTypeID)
        {
            case RTKQuantity:
                _quantity = [NSNumber numberWithInteger:[((RTKASN1OctetString *)iapSeq[2]).data integerValue]];
                break;
                
            case RTKProductIdentifier:
                _productIdentifier = ((RTKASN1OctetString *)iapSeq[2]).data;
                break;
                
            case RTKPurchaseDate:
                _purchaseDate = [NSDate dateFromReceiptDateString:((RTKASN1OctetString *)iapSeq[2]).data];
                break;
                
            case RTKTransactionIdentifier:
                _transactionIdentifier = ((RTKASN1OctetString *)iapSeq[2]).data;
                break;
                
            case RTKOriginalTransactionIdentifier:
                _originalTransactionIdentifier = ((RTKASN1OctetString *)iapSeq[2]).data;
                break;
                
            case RTKOriginalPurchaseDate:
                _originalPurchaseDate = [NSDate dateFromReceiptDateString:((RTKASN1OctetString *)iapSeq[2]).data];
                break;

            default:
                //Undocumented
                break;
        }
    }
    
    _originalTransaction = [self.originalTransactionIdentifier isEqualToString:self.transactionIdentifier];
}
    
@end
