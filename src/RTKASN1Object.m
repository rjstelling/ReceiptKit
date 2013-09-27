//
//  RTKASN1Object.m
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "RTKASN1Object.h"
#import <openssl/pkcs7.h>

#import "RTKASN1Set.h"
#import "RTKASN1Sequence.h"
#import "RTKOctetString.h"

@implementation RTKASN1Object

+ (id)decodeASN1Data:(NSData *)data
{
    const uint8_t *locationInData = data.bytes;
    const uint8_t *endOfData = (locationInData + data.length);
    const uint8_t *lengthToRead = (data.length + locationInData);
    
    //In the outer container there maybe mutiple objects. In this case
    //this method will return an array of these objects, if only one root
    //object is found that object is returned and this array removed.
    NSMutableArray *decodedObjects = [NSMutableArray arrayWithCapacity:1];
    
    int count = 0;              //count objects
    
    do
    {
        long length = 0;            //hold returnd length of read data
        int type = 0, xclass = 0;   //hold type of object
        
        //Subtract the locationInData from length to read because locationInData will
        //be incremented by ASN1_get_object and by adding the length
        int result = ASN1_get_object(&locationInData, &length, &type, &xclass, (lengthToRead - locationInData));
        
        //NSLog(@"[%d] Type: %d (length: %ld) result: %d", count, type, length, result);
        
        //Remember: locationInData has be incremented pased the tyoe and length,
        //so just reading the data is enough to get the value/data. When creating
        //an ASN.1 type object a copy of the locationInData pointer is taken
        //so we can just jump over the object by adding length to locationInData
        //once processed.
        
        NSData *asn1ObjectData = [NSData dataWithBytesNoCopy:(void *)locationInData length:length freeWhenDone:NO];
        
        switch(type)
        {
            case V_ASN1_SET:
            {
                RTKASN1Set *set = [[RTKASN1Set alloc] initWithData:asn1ObjectData];
                [decodedObjects addObject:set];
            }
                break;
                
            case V_ASN1_SEQUENCE:
            {
                RTKASN1Sequence *sequence = [[RTKASN1Sequence alloc] initWithData:asn1ObjectData];
                [decodedObjects addObject:sequence];
            }
                break;
                
            case V_ASN1_INTEGER:
                //This will only correctly decode integers of one byte
            {
                int integer = 0;
                [asn1ObjectData getBytes:&integer length:length];
                [decodedObjects addObject:@(integer)];
            }
                break;
                
            case V_ASN1_OCTET_STRING: /* TODO: */
            {
                RTKOctetString *octetString = [[RTKOctetString alloc] initWithData:asn1ObjectData];
                //NSData *data = [NSData dataWithBytes:asn1ObjectData.bytes length:length];
                [decodedObjects addObject:octetString];
            }
                break;
            
//            case V_ASN1_UTF8STRING:
//            {
//                //NSString *string = [[NSString alloc] initWithData:asn1ObjectData
//                //                                         encoding:NSUTF8StringEncoding];
//                //[decodedObjects addObject:string];
//            }
                
            default: //We just ignore any other types
                break;
        }
        
        //Advance to next object, ASN1_get_object has already increased
        //locationInData by 2 bytes (type and length)
        locationInData += length;
        count++;
    } while(locationInData < endOfData);
    
    //Return an NSArray if we found more that one root object
    return [decodedObjects count]==1?decodedObjects[0]:[decodedObjects copy];
}

@end
