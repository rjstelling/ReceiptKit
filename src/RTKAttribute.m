//
//  RTKAttribute.m
//  ReceiptKit
//
//  Created by Richard Stelling on 06/05/2014.
//  Copyright (c) 2014 Empirical Magic Ltd. All rights reserved.
//

#import "RTKAttribute.h"
#import "RTKASN1Set.h"
#import "RTKASN1Sequence.h"
#import "NSDate+ReceiptKit.h"

#pragma mark - RTKASN1Sequence Category

@interface RTKASN1Sequence (ReceiptKit)

- (NSNumber *)attributeTypeID;
- (NSNumber *)attributeVersion;
- (id)attributeValue;

@end

@implementation RTKASN1Sequence (ReceiptKit)

- (NSNumber *)attributeTypeID
{
    return [self[0] numberValue];
}

- (NSNumber *)attributeVersion
{
    return [self[1] numberValue];
}

- (id)attributeValue
{
    return [self[2] dataValue];
}

@end

#pragma mark - Class Clusters

@interface RTKAttributeNumber : RTKAttribute @end
@interface RTKAttributeString : RTKAttribute @end
@interface RTKAttributeDate : RTKAttribute @end
@interface RTKAttributeData : RTKAttribute @end

#pragma mark - RTKAttribute

@interface RTKAttribute ()

- (instancetype)initConcreteWithSequence:(RTKASN1Sequence *)sequence;

@end

@implementation RTKAttribute

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ : %p> type: %d, version: %d, value: %@", NSStringFromClass([self class]), self, (int)self.attributeType, (int)self.attributeVersion, self.attributeValue];
}

- (instancetype)initWithSequence:(RTKASN1Sequence *)sequence
{
    RTKReceiptAttributeTypeID attributeTypeID = [[sequence attributeTypeID] integerValue];
    
    RTKAttribute *me = nil;
    
    switch(attributeTypeID)
    {
        //Strings
        case RTKBundleID:
        case RTKVersion:
        case RTKProductIdentifier:
        case RTKTransactionIdentifier:
        case RTKOriginalTransactionIdentifier:
        case RTKOriginalVersion:
            me = [[RTKAttributeString alloc] initConcreteWithSequence:sequence];
            break;
            
        //Dates
        case RTKExpiryDate:
        case RTKPurchaseDate:
        case RTKOriginalPurchaseDate:
        case RTKSubscriptionExpiryDate:
        case RTKCancellationDate:
            me = [[RTKAttributeDate alloc] initConcreteWithSequence:sequence];
            break;
            
        //Data
        case RTKOpaqueValue:
        case RTKHash:
        case RTKInAppPurchase:
            me = [[RTKAttributeData alloc] initConcreteWithSequence:sequence];
            break;
            
        //Numbers
        case RTKQuantity:
        case RTKWebOrderLineItemID:
            me = [[RTKAttributeNumber alloc] initConcreteWithSequence:sequence];
            break;
            
        default:
            break;
    }
    
    self = me;
    
    return self;
}

- (instancetype)initConcreteWithSequence:(RTKASN1Sequence *)sequence
{
    self = [super init];
    
    if(self)
    {
        _attributeType = [[sequence attributeTypeID] integerValue];
        _attributeVersion = [[sequence attributeVersion] integerValue];
    }
    
    return self;
}

- (void)setAttributeValue:(id)attributeValue
{
    _attributeValue = attributeValue;
}

@end

#pragma mark - Class Clusters

@implementation RTKAttributeNumber

- (instancetype)initConcreteWithSequence:(RTKASN1Sequence *)sequence
{
    self = [super initConcreteWithSequence:sequence];
    
    if(self)
    {
        RTKASN1Object *numberObj = [[RTKASN1Object alloc] initWithData:[sequence attributeValue]];
        
        [self setAttributeValue:[numberObj numberValue]];
    }
    
    return self;
}

@end

@implementation RTKAttributeString

- (instancetype)initConcreteWithSequence:(RTKASN1Sequence *)sequence
{
    self = [super initConcreteWithSequence:sequence];
    
    if(self)
    {
        RTKASN1Object *strObj = [[RTKASN1Object alloc] initWithData:[sequence attributeValue]];
        
        //TODO: Error checking
        
        [self setAttributeValue:[strObj stringValue]];
    }
    
    return self;
}

@end


@implementation RTKAttributeDate

- (instancetype)initConcreteWithSequence:(RTKASN1Sequence *)sequence
{
    self = [super initConcreteWithSequence:sequence];
    
    if(self)
    {
        RTKASN1Object *strObj = [[RTKASN1Object alloc] initWithData:[sequence attributeValue]];
        NSString *dateStr = [strObj stringValue];
        
        //TODO: Error checking
        
        [self setAttributeValue:[NSDate dateFromReceiptDateString:dateStr]];
    }
    
    return self;
}

@end


@implementation RTKAttributeData

- (instancetype)initConcreteWithSequence:(RTKASN1Sequence *)sequence
{
    self = [super initConcreteWithSequence:sequence];
    
    if(self)
    {
        NSData *attrData = [sequence attributeValue];
        
        //TODO: Error checking
        
        [self setAttributeValue:[attrData copy]];
    }
    
    return self;
}

@end
