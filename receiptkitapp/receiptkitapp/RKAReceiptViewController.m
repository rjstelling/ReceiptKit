//
//  RKAReceiptViewController.m
//  receiptkitapp
//
//  Created by Richard Stelling on 25/04/2014.
//  Copyright (c) 2014 Empirical Magic Ltd. All rights reserved.
//

#import "RKAReceiptViewController.h"
#import "RKAViewController.h"
#import "RKATableViewCell.h"
#import "RTKReceiptParser.h"
#import "RTKPurchaseInformation.h"
#import "RTKInAppPurchaseInformation.h"
#import "RKAIAPViewController.h"

@interface RKAReceiptViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *bundleID;
@property (weak, nonatomic) IBOutlet UILabel *bundleVersion;
@property (weak, nonatomic) IBOutlet UILabel *originalVersion;
@property (weak, nonatomic) IBOutlet UILabel *iapCount;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *inAppPurchases;

@end

@implementation RKAReceiptViewController

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
    
    RTKReceiptParser *parser = ((RKAViewController *)self.presentingViewController).receiptParser;
    
    NSLog(@"%@", parser.purchaseInfo);
    
    self.bundleID.text = parser.purchaseInfo.bundleIdentifier;
    self.bundleVersion.text = parser.purchaseInfo.bundleVersion;
    self.originalVersion.text = parser.purchaseInfo.originalVersion;
    self.iapCount.text = [NSString stringWithFormat:@"%d", parser.purchaseInfo.inAppPurchases.count];
    
    self.inAppPurchases = [parser.purchaseInfo.inAppPurchases allObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - table datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.inAppPurchases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RKATableViewCell *cell = (RKATableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.iap = self.inAppPurchases[indexPath.row];
    
    cell.iapName.text = cell.iap.productIdentifier;
    cell.iapTransID.text = cell.iap.transactionIdentifier;
    cell.iapQty.text = [NSString stringWithFormat:@"%@", cell.iap.quantity];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(RKATableViewCell *)sender
{
    RKAIAPViewController *vc = [segue destinationViewController];
    
    vc.iap = sender.iap;
}

@end
