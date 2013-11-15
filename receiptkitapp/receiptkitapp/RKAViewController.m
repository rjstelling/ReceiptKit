//
//  RKAViewController.m
//  receiptkitapp
//
//  Created by Richard Stelling on 15/11/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

@import StoreKit;
#import "RKAViewController.h"
#import "RTKReceiptParser.h"

#define RKANonConsumable @"nonconsumable01"
#define RKAConsumable @"consumable01"

@interface RKAViewController () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation RKAViewController
{
    SKProduct *_nonConsumableProduct;
    SKProduct *_consumableProduct;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [self productsRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)productsRequest
{
    NSSet *prods = [NSSet setWithArray:@[RKANonConsumable, RKAConsumable]];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:prods];
    request.delegate = self;
    
    [request start];
}

- (IBAction)refresh:(id)sender
{
    SKReceiptRefreshRequest *refesh = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:nil];
    [refesh start];
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    for(SKProduct *product in response.products)
    {
        if([product.productIdentifier isEqualToString:RKANonConsumable])
        {
            _nonConsumableProduct = product;
            
            self.nonConsumableTitle.text = product.localizedTitle;
            self.nonConsumableDesc.text = product.localizedDescription;
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setLocale:product.priceLocale];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            
            [self.nonConsumableBuy setTitle:[formatter stringFromNumber:product.price]
                                   forState:UIControlStateNormal];
            
            self.nonConsumableBuy.enabled = YES;
        }
        else if([product.productIdentifier isEqualToString:RKAConsumable])
        {
            _consumableProduct = product;
            
            self.consumableTitle.text = product.localizedTitle;
            self.consumableDesc.text = product.localizedDescription;
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setLocale:product.priceLocale];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            
            [self.consumableBuy setTitle:[formatter stringFromNumber:product.price]
                                   forState:UIControlStateNormal];
            
            self.consumableBuy.enabled = YES;
        }
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Connection Error"
                               message:error.localizedDescription
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil] show];
}

#pragma mark - SKPaymentTransactionObserver

// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
                // Call the appropriate custom method.
            case SKPaymentTransactionStatePurchased:
                self.statusLabel.text = @"Purchased…";
                [self finishTransaction:transaction];
                NSLog(@"SKPaymentTransactionStatePurchased");
                break;
            case SKPaymentTransactionStateFailed:
                self.statusLabel.text = @"Failed…";
                NSLog(@"SKPaymentTransactionStateFailed: %@", transaction.error.localizedDescription);
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"SKPaymentTransactionStateRestored");
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"SKPaymentTransactionStatePurchasing");
                self.statusLabel.text = @"Purchasing…";
                break;
                
            default:
                break;
        }
    }
}

//@optional
//// Sent when transactions are removed from the queue (via finishTransaction:).
//- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
//
//// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
//- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
//
//// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
//- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
//
//// Sent when the download state has changed.
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);

#pragma mark - Purchase Actions

- (IBAction)buyNonConsumable:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self buyProduct:_nonConsumableProduct];
}

- (IBAction)buyConsumable:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self buyProduct:_consumableProduct];
}

- (void)buyProduct:(SKProduct *)basket
{
    if([SKPaymentQueue canMakePayments])
    {
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:basket];
        payment.quantity = 1;
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else
    {
        NSLog(@"CAN NOT MAKE PAYMENTS");
    }
}

- (void)finishTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - Receipt Actions

- (IBAction)getReceipt:(id)sender
{
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    
    if(receiptURL)
    {
        self.statusLabel.text = @"Receipt found…";
        
        NSData *cert = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"apple-cert" withExtension:nil]];
        NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
        RTKReceiptParser *parser = [[RTKReceiptParser alloc] initWithReceipt:receipt certificate:cert];
        
        if([parser isReceiptValidForDevice:@"com.demo.receiptkit"])
        {
            self.statusLabel.text = @"Receipt valid!";
        }
        else
        {
            self.statusLabel.text = @"Receipt invalid :(";
        }
    }
    else
    {
        self.statusLabel.text = @"Receipt missing…";
    }
}

@end
