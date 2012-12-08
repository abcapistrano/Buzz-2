//
//  DJAppDelegate.m
//  Buzz
//
//  Created by Earl on 9/19/12.
//  Copyright (c) 2012 Earl. All rights reserved.
//

#import "DJAppDelegate.h"

NSString * const GOAL_CARD_DIRECTORY_KEY = @"GOAL_CARD_DIRECTORY";

NSString * const ALL_AFFIRMATIONS_KEY = @"ALL_AFFIRMATIONS_KEY";
NSString * const ALL_RULES_KEY = @"ALL_RULES_KEY";
NSString * const ALL_IMAGES_KEY = @"ALL_IMAGES_KEY";
NSString * const ALL_INSPIRATIONAL_TEXTS_KEY = @"ALL_INSPIRATIONAL_TEXTS_KEY";





@implementation DJAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    
    [self initializeGoalCardViewer];
    
    [self configureNotifications];

    NSUserNotification *note = aNotification.userInfo[NSApplicationLaunchUserNotificationKey];
    if (note) {
        
        NSUserNotificationCenter *nc = [NSUserNotificationCenter defaultUserNotificationCenter];
        [nc removeDeliveredNotification:note];
        
        [self showItems];
        
        
    } else {
        

#ifdef RELEASE
        
        

        [NSApp terminate:self];

        
#endif
        

        


        
    }
    
    

    
}

- (void) configureNotifications {
    
    NSUserNotificationCenter *nc = [NSUserNotificationCenter defaultUserNotificationCenter];
    [nc removeAllDeliveredNotifications];
    nc.delegate = self;
    nc.scheduledNotifications = nil;
 //   [nc removeAllDeliveredNotifications];
    
        
    
    NSUserNotification *note = [[NSUserNotification alloc] init];
    note.title = @"Buzz 2";
    note.informativeText = @"Wollen Sie etwas zu motivieren? 2";
    // deliver notification after 10 minutes
    
#ifdef DEBUG
    
    [nc deliverNotification:note];
    
#else
    
    NSInteger delay = 10;
    
    note.deliveryDate = [NSDate dateWithTimeIntervalSinceNow:delay*60];
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    
    dc.minute = delay;
    note.deliveryRepeatInterval = dc;
    [nc scheduleNotification:note];
    
#endif
    

    
    
    
    
}


- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    
    return YES;
}

#ifdef DEBUG

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    
    NSUserNotificationCenter *nc = [NSUserNotificationCenter defaultUserNotificationCenter];
    [nc removeDeliveredNotification:notification];
    
    [self showItems];
    
    
}

#endif

# pragma mark methods relating to displaying the goal card

// This method asks the user where the location of Goal Card data

- (void) initializeGoalCardViewer {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *aliasForGoalCardDirectory = [userDefaults dataForKey:GOAL_CARD_DIRECTORY_KEY];
    if (!aliasForGoalCardDirectory) {
        
        NSOpenPanel *open = [NSOpenPanel openPanel];
        [open setCanChooseFiles:NO];
        [open setCanChooseDirectories:YES];
        
        open.title = @"Where are the contents of the Goal Card located?";
        [open runModal];
        
        NSURL *url = [[open URLs] lastObject];
        
        NSError *error;
        NSData *bookmarkData = [url bookmarkDataWithOptions:0
                             includingResourceValuesForKeys:nil
                                              relativeToURL:nil
                                                      error:nil];
        
        if (bookmarkData) {
            
            NSLog(@"%@", @"success");
            
            self.goalCardDirectory = url;
            
            [userDefaults setObject:bookmarkData forKey:GOAL_CARD_DIRECTORY_KEY];
            [userDefaults synchronize];
            
        } else {
            
            
            NSLog(@"error: %@", [error localizedDescription]);
            
        }
        
    }
    if (!self.goalCardDirectory) {
        
        NSError *error;
        self.goalCardDirectory = [NSURL URLByResolvingBookmarkData:aliasForGoalCardDirectory options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:nil error:&error];
        
    }

    
    
    
    
}




- (void) showItems {
    
    /*
     
     Two items in quick look shall be shown: (1) one text and (2) one image
     
     
     */
    
    NSMutableArray * itemsToShow = [NSMutableArray array];
    
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    //Get one affirmation
    
    NSMutableArray *allAffirmations = [[userDefaults arrayForKey:ALL_AFFIRMATIONS_KEY] mutableCopy];
    NSURL *affirmationsDirectory = [self.goalCardDirectory URLByAppendingPathComponent:@"Affirmations"];
    
    if (allAffirmations == nil || [allAffirmations count]== 0 ) {
        
        
        allAffirmations = [[affirmationsDirectory.files valueForKey:@"lastPathComponent"] mutableCopy];
        
        
        
    }
    
    
    NSString *randomAffirmation = [allAffirmations grab:1][0];
    [itemsToShow addObject:[affirmationsDirectory URLByAppendingPathComponent:randomAffirmation]];
    [userDefaults setObject:allAffirmations forKey:ALL_AFFIRMATIONS_KEY];    
    
    
    //Get one Rule
    
    NSMutableArray *allRules = [[userDefaults arrayForKey:ALL_RULES_KEY] mutableCopy];
    NSURL *rulesDirectory = [self.goalCardDirectory URLByAppendingPathComponent:@"Rules"];
    
    if (allRules == nil || [allRules count]== 0 ) {
        
        
        allRules = [[rulesDirectory.files valueForKey:@"lastPathComponent"] mutableCopy];
        
        
        
    }
    
    
    NSString *randomRule = [allRules grab:1][0];
    [itemsToShow addObject:[rulesDirectory URLByAppendingPathComponent:randomRule]];
    [userDefaults setObject:allRules forKey:ALL_RULES_KEY];

    
    //Get one inspirational text
    
    NSMutableArray *allInspirationalTexts = [[userDefaults arrayForKey:ALL_INSPIRATIONAL_TEXTS_KEY] mutableCopy];
    NSURL *inspirationalTextsDirectory = [self.goalCardDirectory URLByAppendingPathComponent:@"Inspirational Texts"];
    
    if (allInspirationalTexts == nil || [allInspirationalTexts count]== 0 ) {
        
        
        allInspirationalTexts = [[inspirationalTextsDirectory.files valueForKey:@"lastPathComponent"] mutableCopy];
               
        
    }
    
    
    NSString *randomInspirationalText = [allInspirationalTexts grab:1][0];
    [itemsToShow addObject:[inspirationalTextsDirectory URLByAppendingPathComponent:randomInspirationalText]];
    [userDefaults setObject:allInspirationalTexts forKey:ALL_INSPIRATIONAL_TEXTS_KEY];




    //Get three images
    
    NSMutableArray *allImages = [[userDefaults arrayForKey:ALL_IMAGES_KEY] mutableCopy];
    NSURL *imagesDirectory = [self.goalCardDirectory URLByAppendingPathComponent:@"images"];
    
    if (allImages == nil || [allImages count]== 0 ) {
        
        allImages = [[imagesDirectory.files valueForKey:@"lastPathComponent"] mutableCopy];
        
        
    }
    
    NSArray *randomImages = [allImages grab:5];
    
    for (NSString *image in randomImages) {
        [itemsToShow addObject:[imagesDirectory URLByAppendingPathComponent:image]];

    }
    
    [userDefaults setObject:allImages forKey:ALL_IMAGES_KEY];
    
    
    [userDefaults synchronize];
    
    self.quicklookItems = itemsToShow;
    
    
    self.panel = [QLPreviewPanel sharedPreviewPanel];
    self.panel.dataSource = self;
    self.panel.delegate = self;
    [self.panel updateController];
    [self.panel setAutostarts:NO];

    
    [self.panel makeKeyAndOrderFront:self];
    [self.panel enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
    
    // Remove delivered notifications
    

    
  
    
    
}



- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
    
    
    return self.quicklookItems.count;
    
}


- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
    
    return self.quicklookItems[index];
    
}


- (BOOL) acceptsPreviewPanelControl: (QLPreviewPanel *) p {
    
    return YES;
}

- (void) beginPreviewPanelControl:(QLPreviewPanel *)panel {
    
    
    
}

- (void) endPreviewPanelControl:(QLPreviewPanel *)panel {
  
    [NSApp terminate:self];

    
    
}






@end
