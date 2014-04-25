//
//  RKAIAPViewController.h
//  receiptkitapp
//
//  Created by Richard Stelling on 25/04/2014.
//  Copyright (c) 2014 Empirical Magic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTKInAppPurchaseInformation;

@interface RKAIAPViewController : UIViewController

@property (strong, nonatomic) RTKInAppPurchaseInformation *iap;

@end
