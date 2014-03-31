//
//  MasterViewController.m
//  HackMatchTalent
//
//  Created by David Fontenot on 3/31/14.
//  Copyright (c) 2014 Dave Fontenot. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "hacker.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    hacker *blah;
    blah.name = @"blah";
    hacker *blah2;
    blah2.name = @"blah2";
    
    self.titles = [NSMutableArray arrayWithObjects: blah, blah2, nil];
                   /*
                   @"The Missing Widget in the Android SDK: SmartImageView",
                   @"Get started with iOS Development",
                   @"An Interview with Shay Howe",
                   @"Treehouse Friends: Paul Irish",
                   @"Getting A Job In Web Design and Development",
                   @"Treehouse Show Episode 13 &#8211; LLJS, Navicons and Framework Flights",
                   nil];
                    */
    
    
    //Load hackers from Parse
    PFQuery *query = [PFQuery queryWithClassName:@"hackers"];
    //[query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *hackers, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d hackers.", hackers.count);
            // Do something with the found objects
            for (PFObject *hacker in hackers) {
                NSLog(@"%@", hacker[@"name"]);
                [self.titles addObject: hacker];
                [self.tableView reloadData];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    [self.tableView reloadData];
    /*
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     */
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    //gets hacker for current row
    NSDictionary *currentObject = [self.titles objectAtIndex:indexPath.row];
    
    //turns the tags array into a comma separated string
    NSString * result = [[currentObject valueForKey:@"tags"] componentsJoinedByString:@", "];
    
    //check if url is a valid string then turn thumbnail url into url->nsdata->uiimage
    if ( [currentObject[@"thumbnail"] isKindOfClass:[NSString class]] ) {
        NSURL *thumbnailUrl = [NSURL URLWithString:currentObject[@"thumbnail"]];
        NSData *imageData = [NSData dataWithContentsOfURL:thumbnailUrl];
        UIImage *image = [UIImage imageWithData:imageData];
        cell.imageView.image = image;
    }
    else {
        //cell.imageView.image = [UIImage ]
    }
    
    //set data
    cell.textLabel.text = currentObject[@"name"];
    cell.detailTextLabel.text = result;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
