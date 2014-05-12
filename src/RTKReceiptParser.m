//
//  RTKReceiptParser.m
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

@import StoreKit;

#import "RTKReceiptParser.h"
#import "NSData+Crypto.h"

#import "RTKPurchaseInformation.h"

//ASN.1 Object includes
#import "RTKASN1Object.h"
#import "RTKASN1Set.h"
#import "RTKASN1Sequence.h"

static __strong RTKReceiptParser *_asyncObjectPlaceholder = nil;

@interface RTKReceiptParser () <SKProductsRequestDelegate>

@end

@implementation RTKReceiptParser
{
    RTKASN1Object *_internalDecodedPayloadCache;
    
    RTKPurchaseInformation *_purchaseInfo;
    
    //Cached receipt and cert. data
    NSData *_receiptData;
    NSData *_certificateData;
    
    RTKParserCompletionBlock _cachedCompletionBlock;
    NSURL *_cachedCertificateFile;
}

#pragma mark - Properties

- (RTKPurchaseInformation *)purchaseInfo
{
    if(!_purchaseInfo)
    {
        _internalDecodedPayloadCache = [RTKReceiptParser decodedPayload:_receiptData certificate:_certificateData];
        _purchaseInfo = [[RTKPurchaseInformation alloc] initWithASN1Object:_internalDecodedPayloadCache];
    }
    
    return _purchaseInfo;
}

#pragma mark - Life Cycle

- (instancetype)initWithReceipt:(NSData *)receiptData certificate:(NSData *)certificateData //DEPRICATED
{
    return [self initWithReceiptData:receiptData certificateData:certificateData];
}

- (instancetype)initWithCertificateURL:(NSURL *)certificateFile completion:(RTKParserCompletionBlock)completionBlock
{
    NSParameterAssert(certificateFile);
    
    if(self = [super init])
    {
        _cachedCompletionBlock = completionBlock;
        _cachedCertificateFile = certificateFile;
        
        SKReceiptRefreshRequest *refesh = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:nil];
        refesh.delegate = self;
        [refesh start];
    }
    
    return self;
}

- (instancetype)initWithReceiptData:(NSData *)receiptData certificateData:(NSData *)certificateData
{
    NSParameterAssert(receiptData);
    NSParameterAssert(certificateData);
    
    if(self = [super init])
    {
        _receiptData = [receiptData copy];
        _certificateData = [certificateData copy];
    }
    
    return self;
}

- (instancetype)initWithReceiptURL:(NSURL *)receiptFile certificateURL:(NSURL *)certificateFile
{
    NSParameterAssert(receiptFile);
    NSParameterAssert(certificateFile);
    
    NSData *certData = [NSData dataWithContentsOfURL:certificateFile];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptFile];
    
    NSAssert(certData.length > 0, @"Cannot read certificate file");
    NSAssert(receiptData.length > 0, @"Cannot read receipt file");
    
    return [self initWithReceiptData:receiptData certificateData:certData];
}

- (instancetype)initWithCertificateURL:(NSURL *)certificateFile
{
    NSURL *receiptFile = [[NSBundle mainBundle] appStoreReceiptURL];
    
    return [self initWithReceiptURL:receiptFile certificateURL:certificateFile];
}

#pragma mark - Async Cals

+ (void)receiptParserWithCertificateURL:(NSURL *)certificateFile completion:(RTKParserCompletionBlock)completionBlock
{
    NSURL *receiptFile = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptFile];
    
    NSData *certData = [NSData dataWithContentsOfURL:certificateFile];
    NSAssert(certData.length > 0, @"Cannot read certificate file");
    
    if(receiptData && certData)
    {
        RTKReceiptParser *me = [[RTKReceiptParser alloc] initWithReceiptData:receiptData certificateData:certData];
        
        if(completionBlock)
            completionBlock(me, nil);
    }
    else if(certData)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            _asyncObjectPlaceholder = [[RTKReceiptParser alloc] initWithCertificateURL:certificateFile completion:completionBlock];
        });
    }
    else
    {
        if(completionBlock)
            completionBlock(nil, nil); //TODO: return error
    }
}

- (void)requestDidFinish:(SKRequest *)request
{
    if([request isKindOfClass:[SKReceiptRefreshRequest class]])
    {
        NSLog(@"Successful Receipt Refresh Request...");
        
        RTKParserCompletionBlock completionBlock = [_cachedCompletionBlock copy];
        NSURL *certificateFile = [_cachedCertificateFile copy];
        NSURL *receiptFile = [[NSBundle mainBundle] appStoreReceiptURL];
        
        completionBlock([[RTKReceiptParser alloc] initWithReceiptURL:receiptFile certificateURL:certificateFile], nil);
        
        _asyncObjectPlaceholder = nil;
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    
    //[request cancel];
    
    if(_cachedCompletionBlock)
        _cachedCompletionBlock(nil, nil); //TODO: return error
    
    _asyncObjectPlaceholder = nil;
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)respons {}

#pragma mark - Public

+ (instancetype)defaultParser
{
    static dispatch_once_t onceToken;
    static id defaultParser_ = nil;
    dispatch_once(&onceToken, ^{
        defaultParser_ = [[self alloc] init];
    });
    
    return defaultParser_;
}

+ (BOOL)isReceiptValid:(NSData *)receiptData certificate:(NSData *)certificateData
{
    BOOL success = NO;
    RTKASN1Object *decodedPayload = [self decodedPayload:receiptData certificate:certificateData];
    
    if(decodedPayload)
    {
        success = YES;
    }
    
    return success;
}

+ (RTKASN1Object *)decodedPayload:(NSData *)receiptData certificate:(NSData *)certificateData
{   
    RTKASN1Object *decodedPayload = nil;
    NSError *error = nil;
    
    //This paylod is encoded in ASN.1
    NSData *payload = [receiptData PKCS7Verify:certificateData error:&error];
    
    if(payload)
    {
        //This object will most likly be a RTKASN1Set and contain all
        //of the other decoded objects
        decodedPayload = [[RTKASN1Object alloc] initWithData:payload];
    }
    else
    {
        NSLog(@"Error: %@", error);
    }

    return decodedPayload;
}

//- (BOOL)isBundleIdentifierValid:(NSString *)bundleIdentifier
//{
//#warning TODO
//    
//    return NO;
//}
//
//- (BOOL)isBundleVersionValid:(NSString *)bundleVersion
//{
//#warning TODO
//    
//    return NO;
//}

- (BOOL)isReceiptValidForVendorIdentifier:(NSData *)vendorID bundleIdentifier:(NSString *)bundleIdentifier
{
    NSParameterAssert(bundleIdentifier);
    NSParameterAssert(vendorID);
    NSAssert(_receiptData, @"Missing receipt data.");
    NSAssert(_certificateData, @"Missing cert. data.");
    
    BOOL success = NO;
    
    if(self.purchaseInfo)
    {
        NSMutableData *data = [NSMutableData dataWithCapacity:48];
        
        // Get Device Identifier as bytes
        //uuid + bundle id + opaque
        uuid_t uuidBytes;
        [vendorID getBytes:uuidBytes length:sizeof(uuidBytes)];
        
        //The bundle id needs to be pre-pended with the UTF8 ASN.1 type (12) and
        //the length of the string
        char pre[2] = {12, bundleIdentifier.length};
        NSMutableData *bundleIDData = [NSMutableData dataWithCapacity:bundleIdentifier.length+2];
        [bundleIDData appendBytes:pre length:2];
        [bundleIDData appendBytes:[bundleIdentifier UTF8String] length:bundleIdentifier.length];
        
        [data appendBytes:uuidBytes length:sizeof(uuid_t)];
        
        [data appendBytes:self.purchaseInfo.opaqueValue.bytes length:self.purchaseInfo.opaqueValue.length];
        [data appendData:bundleIDData];
        
        NSData *sha1 = [data sha1Value];
        
        success = [sha1 isEqualToData:self.purchaseInfo.hash];
    }
    
    return success;
}

- (BOOL)isReceiptValidForCurrentDevice:(NSString *)bundleIdentifier
{
    NSParameterAssert(bundleIdentifier);
    NSAssert(_receiptData, @"Missing receipt data.");
    NSAssert(_certificateData, @"Missing cert. data.");
    
    BOOL success = NO;

    NSData *vendorID = [NSData vendorIdentifier:[[UIDevice currentDevice] identifierForVendor]];
    
    success = [self isReceiptValidForVendorIdentifier:vendorID bundleIdentifier:bundleIdentifier];
    
    return success;
}

#pragma mark - Private



@end
