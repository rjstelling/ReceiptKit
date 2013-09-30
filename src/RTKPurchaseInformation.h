//
//  RTKPurchaseInformation.h
//  ReceiptKit
//
//  Created by Richard Stelling on 30/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTKInAppPurchaseInformation.h"

// ASN.1 values for the App Store receipt
typedef NS_ENUM(NSInteger, RTKReceiptID)
{
    RTKBundleID = 2,
    RTKVersion = 3,
    RTKOpaqueValue = 4,
    RTKHash = 5, //https://developer.apple.com/library/mac/releasenotes/General/ValidateAppStoreReceipt/#//apple_ref/doc/uid/TP40010573-CH1-SW14
    RTKInAppPurchase = 17,
    RTKOriginalVersion = 19,
    //RTKExpiryDate = 21,
    
    //In App
    RTKQuantity = 1701,
    RTKProductIdentifier = 1702,
    RTKTransactionIdentifier = 1703,
    RTKPurchaseDate = 1704,
    RTKOriginalTransactionIdentifier =1705,
    RTKOriginalPurchaseDate = 1706,
};

@class RTKASN1Object;

@interface RTKPurchaseInformation : NSObject

@property (readonly, nonatomic) NSString *bundleIdentifier;
@property (readonly, nonatomic) NSString *bundleVersion;
@property (readonly, nonatomic) NSString *originalVersion;
@property (readonly, nonatomic) NSData *opaqueValue;
@property (readonly, nonatomic) NSData *hash; //SHA-1

@property (readonly, nonatomic) NSSet *inAppPurchases; //NSSet of RTKInAppPurchase

- (instancetype)initWithASN1Object:(RTKASN1Object *)asn1Object;

@end
