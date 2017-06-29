//
//  HistoryViewController.m
//  Synonyms
//
//  Created by Андрей on 24.06.17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "HistoryViewController.h"
#import "DataProvider.h"

@interface HistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *historySearhViewTable;
@property (strong, nonatomic) NSArray*   historyArray;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.historySearhViewTable setDelegate:self];
    [self.historySearhViewTable setDataSource:self];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.historyArray = [[DataProvider sharedInstance] getHistoryRequest];
    [self.historySearhViewTable reloadData];
}


#pragma mark - Delegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.historyArray count];
}

#pragma mark - Delegate UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.historySearhViewTable dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell.textLabel setText:[self.historyArray objectAtIndex:indexPath.row]];
    return cell;
}


@end
