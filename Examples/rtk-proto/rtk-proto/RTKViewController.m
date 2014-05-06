//
//  RTKViewController.m
//  rtk-proto
//
//  Created by Richard Stelling on 02/05/2014.
//  Copyright (c) 2014 Richard Stelling. All rights reserved.
//

#import "RTKViewController.h"
#import "RTKASN1Object.h"
#import "RTKASN1Sequence.h"
#import "RTKASN1Set.h"
#import "NSData+Crypto.h"

#import "RTKReceiptParser.h"

@interface RTKViewController ()
{
    NSData *receiptData;
    NSData *certificateData;
}

//@property (strong, nonatomic) RTKASN1Info *info;

@end

@implementation RTKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURL *receiptURL = [[NSBundle mainBundle] URLForResource:@"receipt01" withExtension:@""];
    receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    NSURL *certificateURL = [[NSBundle mainBundle] URLForResource:@"apple-cert" withExtension:@""];
    certificateData = [NSData dataWithContentsOfURL:certificateURL];
    
    RTKReceiptParser *parser = [[RTKReceiptParser alloc] initWithReceipt:receiptData certificate:certificateData];
    
    BOOL b = [parser isReceiptValidForCurrentDevice:@"com.demo.receiptkit"];
    
    NSLog(@"%d :: %@", b, parser.purchaseInfo);
    
    parser = nil;
    
    //[self parse:nil];
    
//    for (int i = 0; i < 100; i++)
//    {
//        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            @autoreleasepool {
//                [self parse:nil];
//            }
//        });
//    }
    
    //receiptData = nil;
    //certificateData = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (IBAction)parse:(id)sender
{
    //self.info = nil;
    
    NSError *error = nil;
    
    NSData *payloadData = [receiptData PKCS7Verify:certificateData error:&error];
    
    //self.info = [[RTKASN1Info alloc] initWithData:payloadData];
    
    id receipt = [[RTKASN1Object alloc] initWithData:payloadData];
    
    //NSLog(@"%@", receipt);
    
    for (RTKASN1Sequence *seq in receipt)
    {
        if([[seq[0] numberValue] integerValue] == 17) //iap
        {
            RTKASN1Object *obj = seq[2];
            
           // NSLog(@"%@", obj);
            
            RTKASN1Set *iap = (id)[[RTKASN1Set alloc] initWithData:[obj dataValue]];
            
            //NSLog(@"%@", iap);
            
            for (RTKASN1Sequence *iapseq in iap)
            {
                if([[iapseq[0] numberValue] integerValue] == 1706) //iap
                {
                    RTKASN1Object *obj2 = iapseq[2];
                    
                    //NSLog(@"%@", obj2);
                    
                    RTKASN1Object *date = [[RTKASN1Object alloc] initWithData:[obj2 dataValue]];
                    
                   // NSLog(@"PID: %@", date);
                }
            }
        }
    }
    
    //self.info = nil;
}*/

@end
