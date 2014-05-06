//
//  RTKPurchaseInformation.h
//  ReceiptKit
//
//  Created by Richard Stelling on 30/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTKInAppPurchaseInformation.h"

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

///Return a dictionary on all non-nil properties
- (NSDictionary *)purchaseInformationDictionary;

@end
