//
//  RTKASN1Object.m
//  rtk-proto
//
//  Created by Richard Stelling on 03/05/2014.
//  Copyright (c) 2014 Richard Stelling. All rights reserved.
//

#import "RTKANS1Object.h"
#import "RTKANS1Set.h"
#import "RTKANS1Sequence.h"

#import <openssl/pkcs7.h>

@interface RTKANS1Object ()

@property (readonly, nonatomic) RTKANS1ObjectType objectType;
@property (readonly, nonatomic) RTKANS1ObjectXClass objectXClass;
@property (readonly, nonatomic) NSData *objectData;

@property (assign, nonatomic) NSInteger objectSize; //includes tags

// Data Access
+ (NSString *)stringFromData:(NSData *)strData __attribute__((pure));
+ (NSNumber *)numberFromData:(NSData *)intData __attribute__((pure));
+ (NSData *)dataFromData:(NSData *)someData __attribute__((pure));

@end

@implementation RTKANS1Object

#pragma mark - Life Cycle

- (id)initWithData:(NSData *)ans1Data
{
    NSParameterAssert(ans1Data);
    
    @autoreleasepool
    {
        RTKANS1Object *outerObject = [self objectWithData:ans1Data];
        
        if(outerObject.objectType == V_ASN1_SET || outerObject.objectType == V_ASN1_SEQUENCE)
        {
            NSInteger inDataIndex = (long)outerObject.objectData.length;
            NSInteger outDataIndex = 0;
            
            do
            {
                NSData *chunk = [outerObject.objectData subdataWithRange:NSMakeRange(outDataIndex, inDataIndex - outDataIndex)];

                RTKANS1Object *ans1Obj = [[RTKANS1Object alloc] initWithData:chunk];

                NSAssert([outerObject isKindOfClass:[RTKANS1Set class]] || [outerObject isKindOfClass:[RTKANS1Sequence class]], @"Incorrect ANS1 type.");
                
                if([outerObject isKindOfClass:[RTKANS1Set class]])
                    [(RTKANS1Set *)outerObject addObject:ans1Obj];
                else if([outerObject isKindOfClass:[RTKANS1Sequence class]])
                    [(RTKANS1Sequence *)outerObject addObject:ans1Obj];

                outDataIndex += (long)ans1Obj.objectSize;
                
            } while( inDataIndex > outDataIndex );
        }
        
        self = outerObject;
    }
    
    return self;
}

- (instancetype)initWithType:(RTKANS1ObjectType)ans1Type tag:(RTKANS1ObjectXClass)ans1Tag data:(NSData *)ans1Data
{
    NSParameterAssert(ans1Data);
    
    self = [super init];
    
    if(self)
    {
        _objectType = ans1Type;
        _objectXClass = ans1Tag;
        _objectData = [ans1Data copy];
    }
    
    return self;
}

#pragma mark - Data Access

- (NSNumber *)numberValue
{
    return self.objectType==V_ASN1_INTEGER?[RTKANS1Object numberFromData:self.objectData]:nil;
}

- (NSString *)stringValue
{
    return (self.objectType == V_ASN1_UTF8STRING || self.objectType == V_ASN1_IA5STRING)?[RTKANS1Object stringFromData:self.objectData]:nil;
}

- (NSData *)dataValue
{
    return [RTKANS1Object dataFromData:self.objectData];
}

- (id)objectWithData:(NSData *)someData
{
    void *startOfData = (void *)someData.bytes;
    long startIndex = (long)startOfData;
    
    long length = 0;
    int type = 0, xclass = 0;
    
    RTKANS1Object *object = nil;
    
    int result = ASN1_get_object((const unsigned char **)&startOfData, &length, &type, &xclass, (long)someData.length);
    
    //TODO: ERROR CHECKING
    
    if(result == V_ASN1_CONSTRUCTED || result == V_ASN1_UNIVERSAL)
    {
        NSData *rawData = [NSData dataWithBytesNoCopy:startOfData length:length freeWhenDone:NO];
        
        switch(type)
        {
            case V_ASN1_SET:
                object = [[RTKANS1Set alloc] initWithType:type tag:xclass data:rawData];
                break;
          
            case V_ASN1_SEQUENCE:
                object = [[RTKANS1Sequence alloc] initWithType:type tag:xclass data:rawData];
                break;
                
            default:
                object = [[RTKANS1Object alloc] initWithType:type tag:xclass data:rawData];
                break;
        }
        
        object.objectSize = ((long)startOfData - (long)startIndex);
        object.objectSize += length;
    }
    else
    {
        /*
         V_ASN1_APPLICATION
         V_ASN1_CONTEXT_SPECIFIC
         V_ASN1_PRIVATE
         */
        
        NSData *rawData = [NSData dataWithBytesNoCopy:(void *)someData.bytes length:someData.length freeWhenDone:NO];
        object = [[RTKANS1Object alloc] initWithType:V_ASN1_UNDEF tag:xclass data:rawData];
        
        object.objectSize = someData.length;
    }
    
    return object;
}

#pragma mark - Class Methods

+ (NSNumber *)numberFromData:(NSData *)intData
{
    NSUInteger length = intData.length;
    int integer = 0;
    int maxSiftValue = ({
        int shiftVal = (int)pow(2, (length + 1));
        shiftVal = (shiftVal==4?0:shiftVal);
        shiftVal; //return
    });
    
    for(int i = 0; i < intData.length; i++)
    {
        long long value = 0;
        [intData getBytes:&value range:NSMakeRange(i, 1)];
        integer += (value << maxSiftValue);
        maxSiftValue -= 8;
    }
    
    return @(integer);
}

+ (NSString *)stringFromData:(NSData *)strData
{
    NSString *utf8String = [[NSString alloc] initWithData:strData
                                                 encoding:NSUTF8StringEncoding];
    
    return utf8String;
}

+ (NSData *)dataFromData:(NSData *)someData
{
    NSData *data = [NSData dataWithBytes:someData.bytes length:someData.length];
    
    return data;
}

#pragma mark - NSObject

- (NSString *)description //TODO: tiday up
{
    NSString *desc = @"";
    
    if(self.objectType == V_ASN1_OCTET_STRING)
    {
        desc = [NSString stringWithFormat:@"<RTK OCTET STRING : %p> size: %ld", self, (long)self.objectData.length];
    }
    else if(self.objectType == V_ASN1_INTEGER)
    {
        desc = [NSString stringWithFormat:@"<RTK INTEGER : %p> ---> %@", self, [self numberValue]];
    }
    else if(self.objectType == V_ASN1_UTF8STRING)
    {
        desc = [NSString stringWithFormat:@"<RTK UTF8 : %p> ---> %@", self, [self stringValue]];
    }
    else if(self.objectType == V_ASN1_IA5STRING)
    {
        desc = [NSString stringWithFormat:@"<RTK IA5 : %p> ---> %@", self, [self stringValue]];
    }
    else
    {
        desc = [NSString stringWithFormat:@"<RTK UNKNOWN : %p> size: %ld", self, (long)self.objectData.length];
    }
    
    return desc;
}

@end
