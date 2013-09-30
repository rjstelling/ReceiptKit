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
                _purchaseDate = [self formatReceiptDateFromString:((RTKASN1OctetString *)iapSeq[2]).data];
                break;
                
            case RTKTransactionIdentifier:
                _transactionIdentifier = ((RTKASN1OctetString *)iapSeq[2]).data;
                break;
                
            case RTKOriginalTransactionIdentifier:
                _originalTransactionIdentifier = ((RTKASN1OctetString *)iapSeq[2]).data;
                break;
                
            case RTKOriginalPurchaseDate:
                _originalPurchaseDate = [self formatReceiptDateFromString:((RTKASN1OctetString *)iapSeq[2]).data];
                break;

            default:
                //Undocumented
                break;
        }
    }
}

- (NSDate *)formatReceiptDateFromString:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *myDate = [formatter dateFromString:dateStr];
    
    return myDate;
}
    
@end
