//
//  NSData+Crypto.h
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Crypto)

//Returns the payload, if any
- (NSData *)PKCS7Verify:(NSData *)certificateData error:(NSError **)error;

@end