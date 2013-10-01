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

@property (readonly, nonatomic, getter=isOriginalTransaction) BOOL originalTransaction;
@property (readonly, nonatomic) NSNumber *quantity;
@property (readonly, nonatomic) NSString *productIdentifier;
@property (readonly, nonatomic) NSString *transactionIdentifier;
@property (readonly, nonatomic) NSDate *purchaseDate;
@property (readonly, nonatomic) NSString *originalTransactionIdentifier;
@property (readonly, nonatomic) NSDate *originalPurchaseDate;

- (instancetype)initWithASN1Object:(RTKASN1Object *)asn1Object;

@end
