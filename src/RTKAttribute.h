//
//  RTKAttribute.h
//  ReceiptKit
//
//  Created by Richard Stelling on 06/05/2014.
//  Copyright (c) 2014 Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTKASN1Sequence;

// ASN.1 values for the App Store receipt
typedef NS_ENUM(NSInteger, RTKReceiptAttributeTypeID)
{
    RTKBundleID = 2,
    RTKVersion = 3,
    RTKOpaqueValue = 4,
    RTKHash = 5,
    RTKInAppPurchase = 17,
    RTKOriginalVersion = 19,
    RTKExpiryDate = 21, //Volume Purchase Program only
    
    //In App
    RTKQuantity = 1701,
    RTKProductIdentifier = 1702,
    RTKTransactionIdentifier = 1703,
    RTKPurchaseDate = 1704,
    RTKOriginalTransactionIdentifier =1705,
    RTKOriginalPurchaseDate = 1706,
    RTKSubscriptionExpiryDate = 1708,
    RTKWebOrderLineItemID = 1711,
    RTKCancellationDate = 1712,
};

@interface RTKAttribute : NSObject

@property (readonly, nonatomic) RTKReceiptAttributeTypeID attributeType;
@property (readonly, nonatomic) NSInteger attributeVersion;
@property (readonly, nonatomic) id attributeValue;

- (instancetype)initWithSequence:(RTKASN1Sequence *)sequence;

@end
