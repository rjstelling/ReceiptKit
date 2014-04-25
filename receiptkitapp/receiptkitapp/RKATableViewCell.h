//
//  RKATableViewCell.h
//  receiptkitapp
//
//  Created by Richard Stelling on 25/04/2014.
//  Copyright (c) 2014 Empirical Magic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTKInAppPurchaseInformation;

@interface RKATableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *iapName;
@property (weak, nonatomic) IBOutlet UILabel *iapTransID;
@property (weak, nonatomic) IBOutlet UILabel *iapQty;

@property (strong, nonatomic) RTKInAppPurchaseInformation *iap;

@end
