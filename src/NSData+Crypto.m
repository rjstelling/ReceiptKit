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

@implementation NSData (Crypto)

- (BIO *)BIOValue
{
    return BIO_new_mem_buf((void *)[self bytes], [self length]);
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
        BIO_read(b_receiptPayload, (void *)data, b_receiptPayload->num_write);
        
        NSData *payload = [NSData dataWithBytes:data length:b_receiptPayload->num_write];
        return payload;
    }
    else
    {
        //TODO: Make error here
        return nil;
    }
}


@end