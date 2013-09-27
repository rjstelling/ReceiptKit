//
//  RTKReceiptParser.h
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

// ASN.1 values for the App Store receipt
typedef NS_ENUM(NSInteger, RTKReceiptID)
{
    RTKBundleID = 2,
    RTKVersion = 3,
    RTKOpaqueValue = 4,
    RTKHash = 5,
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

@interface RTKReceiptParser : NSObject

+ (BOOL)isReceiptValid:(NSData *)receiptData certificate:(NSData *)certificateData;

@end
