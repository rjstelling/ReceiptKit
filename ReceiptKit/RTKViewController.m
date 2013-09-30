//
//  RTKViewController.m
//  ReceiptKit
//
//  Created by Richard Stelling on 26/09/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "RTKViewController.h"
#import "RTKReceiptParser.h"

@implementation RTKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURL *receiptURL = [[NSBundle mainBundle] URLForResource:@"receipt" withExtension:@""];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    
    NSAssert(receipt, @"Missing Receipt Data");
    
    NSURL *certURL = [[NSBundle mainBundle] URLForResource:@"apple-cert" withExtension:@""];
    NSData *cert = [NSData dataWithContentsOfURL:certURL];

    NSAssert(cert, @"Missing Cert. Data");
    
    RTKReceiptParser *parser = [[RTKReceiptParser alloc] initWithReceipt:receipt certificate:cert];
    BOOL isBundleIDValid = [parser isReceiptValidForDevice:@"com.empiricalmagic.mustard-mag"];
    
    NSLog(@"Purchase Info: %@", parser.purchaseInfo);
    
    if(isBundleIDValid)
    {
        NSLog(@"Bundle ID is valid.");
    }
    else
    {
        NSLog(@"ERROR");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
