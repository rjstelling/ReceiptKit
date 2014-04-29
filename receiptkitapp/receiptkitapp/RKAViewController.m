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
#import "IACClient.h"

#define RKANonConsumable @"nonconsumable01"
#define RKAConsumable @"consumable01"

@interface RKAViewController () <SKProductsRequestDelegate, SKPaymentTransactionObserver, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nonConsumableTitle;
@property (weak, nonatomic) IBOutlet UILabel *nonConsumableDesc;
@property (weak, nonatomic) IBOutlet UIButton *nonConsumableBuy;
@property (weak, nonatomic) IBOutlet UILabel *consumableTitle;
@property (weak, nonatomic) IBOutlet UILabel *consumableDesc;
@property (weak, nonatomic) IBOutlet UIButton *consumableBuy;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *viewReceipt;
@property (weak, nonatomic) IBOutlet UIButton *refreshReceipt;
@property (weak, nonatomic) IBOutlet UIButton *checkReceipt;

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
    [self verifyReceipt];
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

- (void)requestDidFinish:(SKRequest *)request
{
    if([request isKindOfClass:[SKReceiptRefreshRequest class]])
    {
        NSLog(@"Successful Receipt Refresh Request...");
        
        [self verifyReceipt];
    }
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


- (void)buyProduct:(SKProduct *)basket
{
    if([SKPaymentQueue canMakePayments])
    {
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:basket];
        payment.quantity = 8;
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

#pragma mark - Receipt Helpers

- (void)verifyReceipt
{
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:receiptURL.path])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLabel.text = @"Receipt found…";
            
            
            [[[UIAlertView alloc] initWithTitle:@"Receipt Found"
                                        message:@"Would you like to verify the receipt?"
                                       delegate:self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Yes", nil] show];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLabel.text = @"Receipt missing…";
            self.viewReceipt.enabled = NO;
        });
    }
}

#pragma mark - Actions

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

- (IBAction)getReceipt:(id)sender
{
    [self verifyReceipt];
}

- (IBAction)refresh:(id)sender
{
    //Properties can be set for testing
    // see SKReceiptRefreshRequest.h for a list
    
    //SKReceiptRefreshRequest is a subclass of SKRequest
    SKReceiptRefreshRequest *refesh = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:nil];
    refesh.delegate = self;
    [refesh start];
}

- (IBAction)onViewReceipt:(id)sender
{
    [self performSegueWithIdentifier:@"viewreceipt" sender:self];
}

- (IBAction)onOpenWIthReceiptSpy:(id)sender
{
    IACClient *client = [IACClient clientWithURLScheme:@"receiptspy"];
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    NSString *receiptBase64Data = [receiptData base64EncodedStringWithOptions:0];
    NSString *bundleID = @"com.demo.receiptkit";
    
    [client performAction:@"process-receipt" parameters:@{@"receipt_data" : receiptBase64Data,
                                                @"bundle_id": bundleID}];
    
//    NSURL *url = [NSURL URLWithString:@"receiptspy://x-callback-url"];
//    
//    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSLog(@"Verify");
        
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *cert = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"apple-cert" withExtension:nil]];
        NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
        self.receiptParser = [[RTKReceiptParser alloc] initWithReceipt:receipt certificate:cert];
        
        if([self.receiptParser isReceiptValidForCurrentDevice:@"com.demo.receiptkit"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statusLabel.text = @"Receipt valid!";
                self.viewReceipt.enabled = YES;
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statusLabel.text = @"Receipt invalid :(";
                self.viewReceipt.enabled = NO;
            });
        }
    }
    else
    {
        NSLog(@"**DO NOT** verify");
    }
}

@end
