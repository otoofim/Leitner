//
//  AddViewController.h
//  litner
//
//  Created by Mohammad Otoofi on 10/8/14.
//  Copyright (c) 2014 Mohammad Otoofi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AddViewController : UIViewController
- (IBAction)convert:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *vocab;
@property (weak, nonatomic) IBOutlet UITextField *defi;
- (IBAction)save:(id)sender;
- (IBAction)read:(id)sender;
- (IBAction)reset:(id)sender;
@property (nonatomic, strong) DBManager *dbManager;

@end
