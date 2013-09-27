//
//  RTKASN1Object.h
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTKASN1Object : NSObject

+ (id)decodeASN1Data:(NSData *)data;

@end