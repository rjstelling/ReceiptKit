//
//  RTKInAppPurchaseInformation.h
//  ReceiptKit
//
//  Created by Richard Stelling on 30/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTKASN1Object;

@interface RTKInAppPurchaseInformation : NSObject

///Convenience property set to YES if this stranaction ws the original
@property (readonly, nonatomic, getter=isOriginalTransaction) BOOL originalTransaction;

///The number of items purchased.
@property (readonly, nonatomic) NSNumber *quantity;

///The product identifier of the item that was purchased.
@property (readonly, nonatomic) NSString *productIdentifier;

///The transaction identifier of the item that was purchased.
@property (readonly, nonatomic) NSString *transactionIdentifier;

///The date and time that the item was purchased.
@property (readonly, nonatomic) NSDate *purchaseDate;

///For a transaction that restores a previous transaction, the transaction identifier of the original transaction. Otherwise, identical to the transaction identifier.
@property (readonly, nonatomic) NSString *originalTransactionIdentifier;

///For a transaction that restores a previous transaction, the date of the original transaction.
@property (readonly, nonatomic) NSDate *originalPurchaseDate;

///The expiration date for the subscription
@property (readonly, nonatomic) NSDate *subscriptionExpiryDate;

///For a transaction that was canceled by Apple customer support, the time and date of the cancellation.
@property (readonly, nonatomic) NSDate *cancellationDate;

///The primary key for identifying subscription purchases.
@property (readonly, nonatomic) NSNumber *webOrderLineItemID;

- (instancetype)initWithASN1Object:(RTKASN1Object *)asn1Object;

@end
