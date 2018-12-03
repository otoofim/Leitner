//
//  dailyworkViewController.m
//  litner
//
//  Created by Mohammad Otoofi on 10/8/14.
//  Copyright (c) 2014 Mohammad Otoofi. All rights reserved.
//

#import "dailyworkViewController.h"

@interface dailyworkViewController ()
{
    //NSMutableArray* completeword;
    NSArray* queryarr;
    NSArray* tokens;
}

@end

@implementation dailyworkViewController
@synthesize vocab;
@synthesize defi;



-(void)viewDidLoad
{

    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];

    if ([self.dbManager IsDBexist])
    {
        
        NSDate *now = [NSDate date];
        int daysToAdd = 0;
        NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:newDate1];
        
        NSString *query = [NSString stringWithFormat:@"update mytable set enddate='%@' where enddate<'%@'",dateString,dateString];
        [self.dbManager executeQuery:query];

        if (self.dbManager.affectedRows != 0)
        {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
        }
        else
        {
            NSLog(@"Could not execute the query.");
        }
        [self findnextword];

        
    }
    else
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"خطا"
                                                         message:@"شما کارتی ذخیره نکرده اید."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
    }

}




/*-(NSString*)getfilename
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *filename=[documentsDirectory stringByAppendingPathComponent:@"me"];
    filename=[filename stringByAppendingString:@".txt"];
    return filename;
   
        

}*/




/*-(void)writetofile
{
    int size=[completeword count];
    NSString* file=completeword[0];
    for(int i=1;i<size-1;i++)
    {
        file=[file stringByAppendingString:@"#"];
        file=[file stringByAppendingString:completeword[i]];
    }
    file=[file stringByAppendingString:@"#"];
   // NSLog(@"file:%@",file);
    [file writeToFile:[self getfilename] atomically:YES encoding:NSUTF8StringEncoding error:nil];

}


-(void)readingfile
{
    NSString* fileContents;
    fileContents =[NSString stringWithContentsOfFile:[self getfilename] encoding:NSUTF8StringEncoding error:nil];
    completeword = [fileContents componentsSeparatedByString: @"#"];
}*/

-(void)findnextword
{
    
    queryarr=nil;
    NSDate *now = [NSDate date];
    int daysToAdd = 0;
    NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:newDate1];

    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];

    
    NSString *query = [NSString stringWithFormat:@"select * from mytable where enddate='%@' limit 1",dateString];

    queryarr = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

    if([queryarr count]>0)
    {
        //NSString* querystringresult=[[queryarr objectAtIndex:0]description];
        //tokens = [querystringresult componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString: @"\n,"]];
        vocab.text=[[queryarr objectAtIndex:0] objectAtIndex:0];
    }
    else
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"خطا"
                                                         message:@"کارتی برای امروز وجود ندارد."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        
        
    }
    

}

- (IBAction)showanswer:(id)sender
{
    if([queryarr count]>0)
    {
       
        defi.text=[[queryarr objectAtIndex:0] objectAtIndex:3];
        
    }
    
    
}



- (IBAction)right:(id)sender
{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];
    [defi setTextAlignment:NSTextAlignmentRight];
    if ([self.dbManager IsDBexist])
    {
    if([queryarr count]>0)
    {
        NSString* temp=[self result:[[[queryarr objectAtIndex:0] objectAtIndex:2] intValue]];
        
        NSArray* dateandlev = [temp componentsSeparatedByString: @"$"];
        NSString *query = [NSString stringWithFormat:@"update mytable set enddate='%@', level=%d where id=%d",dateandlev[0],[dateandlev[1] intValue],[[[queryarr objectAtIndex:0] objectAtIndex:4] intValue]];
        [self.dbManager executeQuery:query];
        if (self.dbManager.affectedRows != 0)
        {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
                    }
        else
        {
            NSLog(@"Could not execute the query.");
        }
        vocab.text=@"";
        defi.text=@"";
        
        [self findnextword];

    }
    else
    {
        vocab.text=@"";
        defi.text=@"";
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"خطا"
                                                         message:@"کارتی برای امروز وجود ندارد."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];

        
    }
    }
    else
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"خطا"
                                                         message:@"شما کارتی ذخیره نکرده اید."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        
    }
    
}


- (IBAction)wrong:(id)sender
{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];
    if([self.dbManager IsDBexist])
    {
    if([queryarr count]>0)
    {
        NSDate *newDate1;
        NSDate *now = [NSDate date];
        int daysToAdd = 1;
        newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:newDate1];
        
        
        
        NSString *query = [NSString stringWithFormat:@"update mytable set enddate='%@', level=%d where id=%d",dateString,1,[[[queryarr objectAtIndex:0] objectAtIndex:4] intValue]];
        [self.dbManager executeQuery:query];
        if (self.dbManager.affectedRows != 0)
        {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else
        {
            NSLog(@"Could not execute the query.");
        }
        vocab.text=@"";
        defi.text=@"";
        [self findnextword];
    }
    else
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"خطا"
                                                         message:@"کارتی برای امروز وجود ندارد."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];

    }
    }
    else
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"خطا"
                                                         message:@"شما کارتی ذخیره نکرده اید."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        
    }
}



-(NSString*)result:(int)myInt
{
    NSDate *newDate1;
    int newlevel=0;
    switch (myInt)
    {
        case 1:
        {
            NSDate *now = [NSDate date];
            int daysToAdd = 3;
            newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
            newlevel=2;
            break;
        }
        case 2:
        {
            NSDate *now = [NSDate date];
            int daysToAdd = 4;
            newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
            newlevel=3;
            
            break;
        }
        case 3:
        {
            NSDate *now = [NSDate date];
            int daysToAdd = 8;
            newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
            newlevel=4;
            
            break;
        }
        case 4:
        {
            NSDate *now = [NSDate date];
            int daysToAdd = 16;
            newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
            newlevel=5;
            
            break;
        }
        case 5:
        {
            NSDate *now = [NSDate date];
            int daysToAdd = 32;
            newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
            newlevel=6;
            
            break;
        }
        case 6:
        {
            NSDate *now = [NSDate date];
            int daysToAdd = 64;
            newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
            newlevel=7;
            
            break;
        }
        case 7:
        {
            NSDate *now = [NSDate date];
            int daysToAdd = 128;
            newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
            newlevel=8;
            
            break;
        }
        case 8:
        {
            NSDate *now = [NSDate date];
            int daysToAdd = 256;
            newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
            newlevel=9;
            
            break;
        }
        case 9:
        {
            NSDate *now = [NSDate date];
            int daysToAdd = -1;
            newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
            newlevel=10;
            
            break;
        }
        default:
        {
            NSDate *now = [NSDate date];
            int daysToAdd =-1;
            newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
            newlevel=10;
            break;
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:newDate1];
    NSString *strFromInt = [NSString stringWithFormat:@"%d",newlevel];
    NSString* result=dateString;
    result=[result stringByAppendingString:@"$"];
    result=[result stringByAppendingString:strFromInt];
    return result;

    
    

    
}







@end

