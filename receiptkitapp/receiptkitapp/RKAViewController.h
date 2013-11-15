//
//  RKAViewController.h
//  receiptkitapp
//
//  Created by Richard Stelling on 15/11/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKAViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nonConsumableTitle;
@property (weak, nonatomic) IBOutlet UILabel *nonConsumableDesc;
@property (weak, nonatomic) IBOutlet UIButton *nonConsumableBuy;
@property (weak, nonatomic) IBOutlet UILabel *consumableTitle;
@property (weak, nonatomic) IBOutlet UILabel *consumableDesc;
@property (weak, nonatomic) IBOutlet UIButton *consumableBuy;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
