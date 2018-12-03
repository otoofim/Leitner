//
//  AddViewController.m
//  litner
//
//  Created by Mohammad Otoofi on 10/8/14.
//  Copyright (c) 2014 Mohammad Otoofi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AddViewController.h"
//#import "vocabulary.h"

@interface AddViewController ()

@end

@implementation AddViewController

@synthesize vocab;
@synthesize defi;

- (void)viewDidLoad
{
    [super viewDidLoad];
    vocab.enablesReturnKeyAutomatically=NO;
    vocab.delegate=self;
    defi.enablesReturnKeyAutomatically=NO;
    defi.delegate=self;
}

-(void)process
{
    if(![vocab.text isEqualToString:@""] && ![defi.text isEqualToString:@""])
    {

    
    NSDate *now = [NSDate date];
    int daysToAdd = 1;
    NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:newDate1];
    
    
    
    
     NSString *query = [NSString stringWithFormat:@"insert into mytable(voc,enddate,level,defi) values('%@','%@',%d,'%@')",vocab.text, dateString,1,defi.text];

        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];

        [self.dbManager executeQuery:query];
        if (self.dbManager.affectedRows != 0)
        {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"لغت جدید اضافه شد."
                                                             message:@""
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
            vocab.text=@"";
            defi.text=@"";
            
            
        }
        else
        {
            NSLog(@"Could not execute the query.");
        }
   
        

       


    

    }
    else
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"خطا"
                                                         message:@"لطفا قسمت کلمه و معنی را به طور کامل پر کنید."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];

        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)save:(id)sender
{
    [self process];
    
    
}


- (IBAction)read:(id)sender
{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];

    NSString* query=@"select * from mytable";

    NSArray* test = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"\nresult:%@\n",test);
}

- (IBAction)reset:(id)sender
{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];
    
    NSString* query=@"delete from mytable";
    
    
    [self.dbManager executeQuery:query];
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }


    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(NSString*)getfilename
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *filename=[documentsDirectory stringByAppendingPathComponent:@"me"];
    filename=[filename stringByAppendingString:@".txt"];
    return filename;
    
    
    
}


- (IBAction)convert:(id)sender
{
    NSString* fileContents;
    fileContents =[NSString stringWithContentsOfFile:[self getfilename] encoding:NSUTF8StringEncoding error:nil];
    NSArray* completeword = [fileContents componentsSeparatedByString: @"#"];
    for(int i=0;i<[completeword count]-1;i++)
    {
        NSArray* tokens=[completeword[i] componentsSeparatedByString: @"$"];
        
        NSString *query = [NSString stringWithFormat:@"insert into mytable(voc,enddate,level,defi) values('%@','%@',%d,'%@')",tokens[0],tokens[1],[tokens[2] intValue],tokens[3]];
        
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];
        
        [self.dbManager executeQuery:query];
        if (self.dbManager.affectedRows != 0)
        {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            
        }
        else
        {
            NSLog(@"Could not execute the query.");
        }

        
        NSLog(@"\nfile:\n%@",query);
    }

    
}
@end

