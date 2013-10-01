ReceiptKit
==========

Simple StoreKit receipt validation and processing for iOS 7. This only supports the universal receipt format.

##Receipt Data

Under iOS 7 receipt data can be accessed like this:

    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];

##Apple Root Certificate

You should download your own version of the CA root certificate:

See: http://www.apple.com/certificateauthority/

Certificate can be found here: http://www.apple.com/appleca/AppleIncRootCertificate.cer

##Usage

To verify a receipt and decode the payload:

    NSData *receipt = ..., cert = ...
    RTKReceiptParser *parser = [[RTKReceiptParser alloc] initWithReceipt:receipt certificate:cert];
    BOOL isBundleIDValid = [parser isReceiptValidForDevice:@"com.example-corp.app-name"];

Access the purchase info:

    parser.purchaseInfo

##Getting Started

This is just a stand alone project for now. You should replace the receipt file with your own to test it. 

`isReceiptValidForDevice:` returns a BOOL if the receipt data is valid and accessing `purchaseInfo` will create an `RTKPurchaseInformation` object.
The properties of this object can be used to query the receipt and any in-app purchases (IAP).

Let me know any issues or questions; richard@empiricalmagic.com or @rjstelling

##OpenSSL

**WARNING**: You _must_ compile your own versions of libssl and libcrypto. 

Known Issues
============

- Will not run under 64-bit Simulator in Xcode 5. Missing OpenSSL symbols. 
