//
//  RKAIAPViewController.m
//  receiptkitapp
//
//  Created by Richard Stelling on 25/04/2014.
//  Copyright (c) 2014 Empirical Magic Ltd. All rights reserved.
//

#import "RKAIAPViewController.h"
#import "RTKInAppPurchaseInformation.h"
#import "NSDate+Receipt.h"

@interface RKAIAPViewController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *qty;
@property (weak, nonatomic) IBOutlet UILabel *transID;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *originalTransID;
@property (weak, nonatomic) IBOutlet UILabel *originalPurchaseDate;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionExpiryDate;
@property (weak, nonatomic) IBOutlet UILabel *cancellationDate;
@property (weak, nonatomic) IBOutlet UILabel *webOrderLineItemID;

@end

@implementation RKAIAPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.name.text = self.iap.productIdentifier;
    self.qty.text = [NSString stringWithFormat:@"%@", self.iap.quantity];
    self.transID.text = self.iap.transactionIdentifier;
    self.date.text = [self.iap.purchaseDate shortDate];
    self.originalTransID.text = self.iap.originalTransactionIdentifier;
    self.originalPurchaseDate.text = [self.iap.originalPurchaseDate shortDate];
    self.subscriptionExpiryDate.text = [self.iap.subscriptionExpiryDate shortDate];
    self.cancellationDate.text = [self.iap.cancellationDate shortDate];
    self.webOrderLineItemID.text = [NSString stringWithFormat:@"%@", self.iap.webOrderLineItemID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

@end
