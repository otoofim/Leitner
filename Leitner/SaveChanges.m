//
//  SaveChanges.m
//  Leitner
//
//  Created by Mohammad Otoofi on 2/9/15.
//  Copyright (c) 2015 Mohammad Otoofi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaveChanges.h"

@interface SaveChanges ()

@end

@implementation SaveChanges
{
    NSArray *RowOfTable;
    
    

}
@synthesize level;
@synthesize date;
@synthesize word;
@synthesize meaning;
@synthesize myid;

- (void)viewDidLoad
{
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];
    
    NSString* query=[ NSString stringWithFormat:@"select * from mytable where id=%d",myid];
    
    RowOfTable = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    word.enablesReturnKeyAutomatically=NO;
    meaning.enablesReturnKeyAutomatically=NO;

    
    self.word.text=[[RowOfTable objectAtIndex:0] objectAtIndex:0];
    self.meaning.text=[[RowOfTable objectAtIndex:0] objectAtIndex:3];
    level.text=[[RowOfTable objectAtIndex:0] objectAtIndex:2];
    date.text=[[RowOfTable objectAtIndex:0] objectAtIndex:1];
    
    
}


- (IBAction)SaveChangesButton:(id)sender
{
    if([self.word.text isEqualToString:[[RowOfTable objectAtIndex:0] objectAtIndex:0]] && [self.meaning.text isEqualToString:[[RowOfTable objectAtIndex:0] objectAtIndex:3]])
    {
        
    }
    else
    {
        
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];

        NSString *query = [NSString stringWithFormat:@"update mytable set voc='%@', defi='%@' where id=%d",word.text,meaning.text ,myid ] ;
        
        [self.dbManager executeQuery:query];

        if (self.dbManager.affectedRows != 0)
        {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"تغییرات انجام شد."
                                                             message:@""
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
            
            
        }
        else
        {
            NSLog(@"Could not execute the query.");
        }

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


@end
