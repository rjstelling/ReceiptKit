//
//  RTKASN1Object.h
//  ReceiptKit
//
//  Created by Richard Stelling on 03/05/2014.
//  Copyright (c) 2014 Richard Stelling. All rights reserved.
//

#import <Foundation/Foundation.h>

//Types
typedef int RTKANS1ObjectType;
typedef int RTKANS1ObjectXClass;

@interface RTKASN1Object : NSObject

///This can return an OBJECT, SET or SEQUENCE
- (id)initWithData:(NSData *)asn1Data;

- (instancetype)initWithType:(RTKANS1ObjectType)asn1Type tag:(RTKANS1ObjectXClass)asn1Tag data:(NSData *)asn1Data;

///Data Access, these retun nil if the undelying object is not valid
- (NSNumber *)numberValue;
- (NSString *)stringValue;
- (NSData *)dataValue;

@end
