//
//  RKAViewController.h
//  receiptkitapp
//
//  Created by Richard Stelling on 15/11/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTKReceiptParser;

@interface RKAViewController : UIViewController

@property (strong, nonatomic) RTKReceiptParser *receiptParser;

@end
