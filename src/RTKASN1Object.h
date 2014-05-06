//
//  RTKASN1Object.h
//  rtk-proto
//
//  Created by Richard Stelling on 03/05/2014.
//  Copyright (c) 2014 Richard Stelling. All rights reserved.
//

#import <Foundation/Foundation.h>

//Types
typedef int RTKANS1ObjectType;
typedef int RTKANS1ObjectXClass;

@interface RTKANS1Object : NSObject

///This can return an OBJECT, SET or SEQUENCE
- (id)initWithData:(NSData *)ans1Data;

- (instancetype)initWithType:(RTKANS1ObjectType)ans1Type tag:(RTKANS1ObjectXClass)ans1Tag data:(NSData *)ans1Data;

///Data Access, these retun nil if the undelying object is not valid
- (NSNumber *)numberValue;
- (NSString *)stringValue;
- (NSData *)dataValue;

@end
