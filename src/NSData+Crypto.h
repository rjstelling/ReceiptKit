//
//  NSData+Crypto.h
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#error THIS IS LEGACY CODE DO NOT USE

#import <Foundation/Foundation.h>

extern NSString *const RTKDataCryptoErrorDomain;

@interface NSData (Crypto)

//Returns the payload, if any
- (NSData *)PKCS7Verify:(NSData *)certificateData error:(NSError **)error;

- (NSData *)sha1Value;

+ (NSData *)vendorIdentifier:(NSUUID *)vendorUUID;

@end
