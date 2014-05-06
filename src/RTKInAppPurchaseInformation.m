//
//  RTKInAppPurchaseInformation.m
//  ReceiptKit
//
//  Created by Richard Stelling on 30/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "RTKInAppPurchaseInformation.h"
#import "RTKPurchaseInformation.h"
#import "RTKAttribute.h"
#import "RTKASN1Set.h"
#import "RTKASN1Sequence.h"
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
    NSString *desc = [NSString stringWithFormat:@"<%@ (Qty: %@): %@ (%@), %@ (%@), %@>%@",
                      self.productIdentifier, self.quantity,
                      self.transactionIdentifier, self.originalTransactionIdentifier,
                      [self.purchaseDate shortDate], [self.originalPurchaseDate shortDate],
                      [self.subscriptionExpiryDate shortDate],
                      self.isOriginalTransaction?@" <-- Original Transaction":@""];
    
    return desc;
}

#pragma mark - Helpers

- (void)decodeIAPProperties:(RTKASN1Set *)iapSetObject
{
    for(RTKASN1Sequence *iapSeq in iapSetObject)
    {
        RTKAttribute *attribute = [[RTKAttribute alloc] initWithSequence:iapSeq];

        switch([attribute attributeType])
        {
            case RTKQuantity:
                _quantity = [attribute attributeValue];
                break;
                
            case RTKProductIdentifier:
                _productIdentifier = [attribute attributeValue];
                break;
                
            case RTKPurchaseDate:
                _purchaseDate = [attribute attributeValue];
                break;
                
            case RTKTransactionIdentifier:
                _transactionIdentifier = [attribute attributeValue];
                break;
                
            case RTKOriginalTransactionIdentifier:
                _originalTransactionIdentifier = [attribute attributeValue];
                break;
                
            case RTKOriginalPurchaseDate:
                _originalPurchaseDate = [attribute attributeValue];
                break;
                
            case RTKCancellationDate:
                _cancellationDate = [attribute attributeValue];
                break;
                
            case RTKSubscriptionExpiryDate:
                _subscriptionExpiryDate = [attribute attributeValue];
                break;
                
            case RTKWebOrderLineItemID:
                _webOrderLineItemID = [attribute attributeValue];
                break;
                
            default:
                //Undocumented
                break;
        }
    }
    
    _originalTransaction = [self.originalTransactionIdentifier isEqualToString:self.transactionIdentifier];
}
    
@end
