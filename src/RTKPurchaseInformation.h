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
    RTKHash = 5,
    RTKInAppPurchase = 17,
    RTKOriginalVersion = 19,
    RTKExpiryDate = 21, //Volume Purchase Program
    
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

///The bundle identifier of the app this receipt was created for
@property (readonly, nonatomic) NSString *bundleIdentifier;

///The version string
@property (readonly, nonatomic) NSString *bundleVersion;
@property (readonly, nonatomic) NSString *originalVersion;

///Raw bytes used when computing the hash
@property (readonly, nonatomic) NSData *opaqueValue;

///Raw bytes of a SHA-1 hash, compare the computed has to this, if they match bundleIdentifier is valid
@property (readonly, nonatomic) NSData *hash;

///This key is present only for apps purchased through the Volume Purchase Program.
@property (readonly, nonatomic) NSDate *expiryDate;

///An NSSet of RTKInAppPurchase objects
@property (readonly, nonatomic) NSSet *inAppPurchases;

- (instancetype)initWithASN1Object:(RTKASN1Object *)asn1Object;

@end
