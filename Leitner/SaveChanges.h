//
//  SaveChanges.h
//  Leitner
//
//  Created by Mohammad Otoofi on 2/9/15.
//  Copyright (c) 2015 Mohammad Otoofi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface SaveChanges : UIViewController

//@property (nonatomic,strong) NSArray *tableData;
@property (nonatomic,assign) int *myid;
//@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UITextField *word;
@property (weak, nonatomic) IBOutlet UITextField *meaning;
- (IBAction)SaveChangesButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *level;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (nonatomic, strong) DBManager *dbManager;


@end

