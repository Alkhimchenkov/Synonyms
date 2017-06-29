//
//  MainViewController.m
//  Synonyms
//
//  Created by Андрей on 24.06.17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "MainViewController.h"
#import "SearchViewController.h"
#import "HistoryViewController.h"
#import "ListViewController.h"
#import "Button+Border.h"
#import "DataProvider.h"
#import "ApiData.h"

#define GLOBAL_APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

typedef enum {
    ESearch, EHistory, EList
} ViewActiveInContainer;


@interface MainViewController ()

@property (strong, nonatomic) SearchViewController  *searchViewController;
@property (strong, nonatomic) HistoryViewController *historyViewController;
@property (strong, nonatomic) ListViewController    *listViewController;

@property (assign, nonatomic) ViewActiveInContainer viewActiveInContainer;

@property (strong, nonatomic) IBOutlet UIView *containerViewController;
@property (strong, nonatomic) IBOutlet Button_Border *btnSearch;
@property (strong, nonatomic) IBOutlet Button_Border *btnHistory;
@property (strong, nonatomic) IBOutlet Button_Border *btnList;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.searchViewController  = (SearchViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SearchID"];
    self.historyViewController = (HistoryViewController*)[storyboard instantiateViewControllerWithIdentifier:@"HistoryID"];
    self.listViewController    = (ListViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ListID"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    ApiData *apiData = [[ApiData alloc] init];
    [apiData getDataFromBase];
    [apiData internetConnect];
    
    [self showFirstTabViewControllerStart];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


- (void)viewDidLayoutSubviews{
    [[self returnActiveButton:self.viewActiveInContainer] addBottomBorderWithColor:[UIColor redColor]
                                                                    andWidth:2.0 ];
}


#pragma mark - Action
- (IBAction)btnSearch:(id)sender {
    [self jumpFromView:sender toViewController:self.searchViewController];
}


- (IBAction)btnHistory:(id)sender {
    [self jumpFromView:sender toViewController:self.historyViewController];
}


- (IBAction)btnList:(id)sender {
    [self jumpFromView:sender toViewController:self.listViewController];
}


#pragma mark - custom method
-(void)showFirstTabViewControllerStart{
    [self addChildViewController:self.searchViewController];
    self.searchViewController.view.frame = self.containerViewController.bounds;
    [self.containerViewController addSubview:self.searchViewController.view];
    [self.searchViewController didMoveToParentViewController:self];
}


-(void)switchFromViewController:(UIViewController*)oldViewController toViewController:(UIViewController*)newViewController{
    
    [oldViewController willMoveToParentViewController:nil];
    [oldViewController.view removeFromSuperview];
    [oldViewController removeFromParentViewController];
    
    [self addChildViewController:newViewController];
    newViewController.view.frame = self.containerViewController.bounds;
    [self.containerViewController addSubview:newViewController.view];
    [newViewController didMoveToParentViewController:self];
    

    if ([newViewController isKindOfClass:[SearchViewController class]]){
        self.viewActiveInContainer = ESearch;
    } else if ([newViewController isKindOfClass:[HistoryViewController class]]){
        self.viewActiveInContainer = EHistory;
    } else {
        self.viewActiveInContainer = EList;
    }
    
}

-(UIViewController*)returnActiveViewController:(ViewActiveInContainer) viewActiveInContainer{
    switch (viewActiveInContainer) {
        case ESearch:
            return self.searchViewController;
            break;
        case EHistory:
            return self.historyViewController;
            break;
        case EList:
            return self.listViewController;
            break;
    }
    return nil;
}

-(Button_Border*)returnActiveButton:(ViewActiveInContainer) viewActiveInContainer{
    switch (viewActiveInContainer) {
        case ESearch:
            return self.btnSearch;
            break;
        case EHistory:
            return self.btnHistory;
            break;
        case EList:
            return self.btnList;
            break;
            
    }
}

-(void)jumpFromView:(Button_Border*)activeBtnTouch toViewController:(UIViewController*)viewController{
    [activeBtnTouch addBottomBorderWithColor:[UIColor redColor] andWidth:2.0 ];
    [[self returnActiveButton:self.viewActiveInContainer] removeBottomBorder];
    [self switchFromViewController:[self returnActiveViewController:self.viewActiveInContainer]
                  toViewController:viewController];

}


@end
