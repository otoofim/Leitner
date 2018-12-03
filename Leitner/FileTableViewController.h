//
//  FileTableViewController.h
//  Leitner
//
//  Created by Mohammad Otoofi on 11/18/14.
//  Copyright (c) 2014 Mohammad Otoofi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface FileTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *MytableView;
@property (nonatomic, strong) DBManager *dbManager;



@end
