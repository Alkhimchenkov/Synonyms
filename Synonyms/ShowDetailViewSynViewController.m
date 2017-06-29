//
//  ShowDetailViewSynViewController.m
//  Synonyms
//
//  Created by Андрей on 24.06.17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "ShowDetailViewSynViewController.h"
#import "DataProvider.h"

@interface ShowDetailViewSynViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UINavigationItem *detailnaveigationItem;
@property (strong, nonatomic) IBOutlet UITableView *detailWordSearhViewTable;
@property (strong, nonatomic) NSArray*   detailArray;


@end

@implementation ShowDetailViewSynViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.detailWordSearhViewTable setDelegate:self];
    [self.detailWordSearhViewTable setDataSource:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.detailnaveigationItem setTitle:[[DataProvider sharedInstance] getDetailTitle]];
    self.detailArray = [[DataProvider sharedInstance] getDetailDataItem];
}

- (IBAction)dissMissVew:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Delegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.detailArray count];
}

#pragma mark - Delegate UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.detailWordSearhViewTable dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell.textLabel setText:[self.detailArray objectAtIndex:indexPath.row]];
    return cell;
}


@end
