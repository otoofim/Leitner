//
//  FileTableViewController.m
//  Leitner
//
//  Created by Mohammad Otoofi on 11/18/14.
//  Copyright (c) 2014 Mohammad Otoofi. All rights reserved.
//

#import "FileTableViewController.h"
#import "SaveChanges.h"

@interface FileTableViewController ()

@end


@implementation FileTableViewController
{
    NSArray *tableData;
    NSArray* tokens;
    NSMutableArray *searchResults;
    NSInteger* back;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //back=1;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];
    
    NSString* query=@"select * from mytable";
    
    tableData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [searchResults count];
        
    }
    else
    {
        return [tableData count];
        
    }
}




- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    controller.searchResultsTableView.backgroundColor=[UIColor colorWithRed:(56/256.0) green:(116/256.0) blue:(218/256.0) alpha:1.0];
    [controller.searchResultsTableView reloadData];

}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.searchDisplayController isActive])
    {
        
        int* tempid=[[[searchResults objectAtIndex:indexPath.row]objectAtIndex:4] intValue];
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];
        
        NSString* query=[NSString stringWithFormat:@"delete from mytable where id=%d",tempid];
        [self.dbManager executeQuery:query];
        if (self.dbManager.affectedRows != 0)
        {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else
        {
            NSLog(@"Could not execute the query.");
        }
        [self viewDidLoad];

        [self.MytableView reloadData];
        [self.searchDisplayController setActive:NO animated:YES];


        
    }
    else
    {
        
        int* tempid=[[[tableData objectAtIndex:indexPath.row]objectAtIndex:4] intValue];

        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"vocab.sql"];
        
        NSString* query=[NSString stringWithFormat:@"delete from mytable where id=%d",tempid];
        [self.dbManager executeQuery:query];
        if (self.dbManager.affectedRows != 0)
        {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else
        {
            NSLog(@"Could not execute the query.");
        }
        
        [self viewDidLoad];
        [self.MytableView reloadData];


        
    }
    

}



- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
   
    if(!([searchText containsString:@"1"]||[searchText containsString:@"2"]||[searchText containsString:@"3"]||[searchText containsString:@"4"]||[searchText containsString:@"5"]||[searchText containsString:@"6"]||[searchText containsString:@"7"]||[searchText containsString:@"8"]||[searchText containsString:@"9"]||[searchText containsString:@"0"]))
    {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY SELF CONTAINS[c] %@",searchText];

    searchResults = [tableData filteredArrayUsingPredicate:predicate];
        //NSLog(@"\nmmmmmmmmmmmmmmmmmmmmmm:\n%@",searchResults);

    }

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    

    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {



        cell.backgroundColor=[UIColor colorWithRed:(56/256.0) green:(116/256.0) blue:(218/256.0) alpha:1.0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        NSInteger indexOfvoc = [self.dbManager.arrColumnNames indexOfObject:@"voc"];
        NSInteger indexOfdefi = [self.dbManager.arrColumnNames indexOfObject:@"defi"];

        cell.textLabel.text = [NSString stringWithFormat:@"%@:%@", [[searchResults objectAtIndex:indexPath.row]objectAtIndex:indexOfvoc],[[searchResults objectAtIndex:indexPath.row] objectAtIndex:indexOfdefi]];
        //NSLog(@"\nheloooooooooooo\n");
        

    }
    else
    {
        
        NSInteger indexOfvoc = [self.dbManager.arrColumnNames indexOfObject:@"voc"];
        NSInteger indexOfdefi = [self.dbManager.arrColumnNames indexOfObject:@"defi"];
        
        // Set the loaded data to the appropriate cell labels.
        cell.textLabel.text = [NSString stringWithFormat:@"%@:%@", [[tableData objectAtIndex:indexPath.row] objectAtIndex:indexOfvoc], [[tableData objectAtIndex:indexPath.row] objectAtIndex:indexOfdefi]];

    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self performSegueWithIdentifier: @"change" sender: self];
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    SaveChanges *destViewController;
    if ([segue.identifier isEqualToString:@"change"])
    {
        destViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = nil;

        if ([self.searchDisplayController isActive])
        {
            //NSIndexPath *indexPath2 = nil;
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
           destViewController.myid=[[[searchResults objectAtIndex:indexPath.row] objectAtIndex:4] intValue];
            [self.searchDisplayController setActive:NO animated:YES];


            
        }
        else
        {
            indexPath = [self.MytableView indexPathForSelectedRow];
            destViewController.myid=[[[tableData objectAtIndex:indexPath.row] objectAtIndex:4] intValue];
        }
    }
    
    
    



}




- (void)viewWillAppear:(BOOL)animated
{
       [self viewDidLoad];

    [self.MytableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
    

    
}

@end
