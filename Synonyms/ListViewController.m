//
//  ListViewController.m
//  Synonyms
//
//  Created by Андрей on 24.06.17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "ListViewController.h"
#import "DataProvider.h"
#import "ShowDetailViewSynViewController.h"
#import "ApiData.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *listWordSearhViewTable;
@property (strong, nonatomic) NSMutableArray   *listWordArray;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.listWordSearhViewTable setDelegate:self];
    [self.listWordSearhViewTable setDataSource:self];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.listWordArray = [NSMutableArray arrayWithArray:[[DataProvider sharedInstance] getSaveData]];
    [self.listWordSearhViewTable reloadData];
}


#pragma mark - Delegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listWordArray count];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        ApiData *apiData = [[ApiData alloc] init];
        [apiData deleteDataModel:[[[self.listWordArray objectAtIndex:indexPath.row] allKeys] firstObject]];
        [self.listWordArray removeObjectAtIndex:indexPath.row];
        [[DataProvider sharedInstance] deleteDataSave:indexPath.row];
        [self.listWordSearhViewTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.listWordSearhViewTable dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell.textLabel setText:[[[self.listWordArray objectAtIndex:indexPath.row] allKeys] firstObject]];
    return cell;
}

#pragma mark - Delegate UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[DataProvider sharedInstance] setDetailDataItem:[[self.listWordArray objectAtIndex:indexPath.row] objectForKey:[[[self.listWordArray objectAtIndex:indexPath.row] allKeys] firstObject]]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ShowDetailViewSynViewController *showDetailViewSynViewController = (ShowDetailViewSynViewController*)[storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
        [[DataProvider sharedInstance] setDetailTitle:[[[self.listWordArray objectAtIndex:indexPath.row] allKeys] firstObject]];
        [showDetailViewSynViewController setModalPresentationStyle:UIModalPresentationCustom];
        [self presentViewController:showDetailViewSynViewController animated:YES completion:nil];
    });
    
}











@end
