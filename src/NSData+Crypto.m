//
//  NSData+Crypto.m
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "NSData+Crypto.h"
#import <openssl/x509.h>
#import <openssl/pkcs7.h>
#import <CommonCrypto/CommonDigest.h>

NSString *const RTKDataCryptoErrorDomain = @"com.empiricalmagic.nsdata+crypto.errors";

@implementation NSData (Crypto)

- (BIO *)BIOValue
{
    return BIO_new_mem_buf((void *)[self bytes], (int)[self length]);
}

- (NSData *)PKCS7Verify:(NSData *)certificateData error:(NSError *__autoreleasing *)error
{
    BIO *b_receipt = [self BIOValue]; //We now own these
    BIO *b_x509 = [certificateData BIOValue];
    
    // Convert data to PKCS7
    PKCS7 *p7 = d2i_PKCS7_bio(b_receipt, NULL);
    
    //Create the cert. store
    X509_STORE *store = X509_STORE_new();
    X509 *appleRootCA = d2i_X509_bio(b_x509, NULL);
    X509_STORE_add_cert(store, appleRootCA);
    
    // Verify the signiture
    BIO *b_receiptPayload = BIO_new(BIO_s_mem());
    
    OpenSSL_add_all_digests(); //You need to call this otherwise PKCS7_verify doesn't work
    
    int result = PKCS7_verify(p7, NULL, store, NULL, b_receiptPayload, 0);
    
    //Clean up
    X509_free(appleRootCA);
    X509_STORE_free(store);
    BIO_free(b_receipt);
    BIO_free(b_x509);
    PKCS7_free(p7);
    
    if(result == 1)
    {
        const uint8_t *data = malloc(b_receiptPayload->num_write);
        BIO_read(b_receiptPayload, (void *)data, (int)b_receiptPayload->num_write);
        
        NSData *payload = [NSData dataWithBytes:data length:b_receiptPayload->num_write];
        return payload;
    }
    else
    {
        *error = [NSError errorWithDomain:RTKDataCryptoErrorDomain
                                     code:1
                                 userInfo:@{ NSLocalizedDescriptionKey : @"PKCS7 verifcation failed.", @"open-ssl-error" : @(result) }];
        return nil;
    }
}

- (NSData *)sha1Value
{
    NSData *sha1Data = nil;
    unsigned char sha1[CC_SHA1_DIGEST_LENGTH];
    
    if(CC_SHA1(self.bytes, (int)self.length, sha1))
    {
        sha1Data = [NSData dataWithBytes:sha1 length:CC_SHA1_DIGEST_LENGTH];
    }
    
    return sha1Data;
}

@end
