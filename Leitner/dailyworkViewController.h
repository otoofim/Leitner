//
//  dailyworkViewController.h
//  litner
//
//  Created by Mohammad Otoofi on 10/8/14.
//  Copyright (c) 2014 Mohammad Otoofi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface dailyworkViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *vocab;
@property (weak, nonatomic) IBOutlet UITextField *defi;
- (IBAction)right:(id)sender;
- (IBAction)wrong:(id)sender;
- (IBAction)showanswer:(id)sender;
@property (nonatomic, strong) DBManager *dbManager;


@end
