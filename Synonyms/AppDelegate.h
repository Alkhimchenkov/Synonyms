//
//  AppDelegate.h
//  Synonyms
//
//  Created by Андрей on 26.06.17.
//  Copyright © 2017 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL isNet;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

