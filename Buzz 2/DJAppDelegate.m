//
//  DJAppDelegate.m
//  Buzz
//
//  Created by Earl on 9/19/12.
//  Copyright (c) 2012 Earl. All rights reserved.
//

#import "DJAppDelegate.h"

NSString * const ALL_AFFIRMATIONS_KEY = @"ALL_AFFIRMATIONS_KEY";
NSString * const ALL_RULES_KEY = @"ALL_RULES_KEY";
//NSString * const ALL_IMAGES_KEY = @"ALL_IMAGES_KEY";
NSString * const ALL_INSPIRATIONAL_TEXTS_KEY = @"ALL_INSPIRATIONAL_TEXTS_KEY";

NSString * const IAWRITER_DOCS_DIRECTORY = @"/Users/earltagra/Library/Mobile Documents/74ZAFF46HB~jp~informationarchitects~Writer/Documents/";





@implementation DJAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    self.goalCardDirectory = [NSURL fileURLWithPath:[@"~/Dropbox/Goal Card" stringByExpandingTildeInPath]];
    
        
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
    note.informativeText = @"Wollen Sie etwas zu motivieren?";
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


- (void) showItems {
    
    /*
     
     Two items in quick look shall be shown: (1) one text and (2) one image
     
     
     */
    
    NSMutableArray * itemsToShow = [NSMutableArray array];
    
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@", userDefaults);
    
    //Get one affirmation
    
    NSMutableArray *allAffirmations = [[userDefaults arrayForKey:ALL_AFFIRMATIONS_KEY] mutableCopy];
    NSURL *affirmationsDirectory = [self.goalCardDirectory URLByAppendingPathComponent:@"Affirmations"];
    
    if (allAffirmations == nil || [allAffirmations count]== 0 ) {
        
        
        allAffirmations = [[affirmationsDirectory valueForKeyPath:@"files.absoluteString"]  mutableCopy];
     
        
        
    }
    
    
    NSURL *randomAffirmation = [NSURL URLWithString:[allAffirmations grab:1][0]];
    [itemsToShow addObject:randomAffirmation];
    [userDefaults setObject:allAffirmations forKey:ALL_AFFIRMATIONS_KEY];    
    
    
    //Get one Rule
    
    NSMutableArray *allRules = [[userDefaults arrayForKey:ALL_RULES_KEY] mutableCopy];
    
    NSURL *docsDirectory = [NSURL fileURLWithPath:IAWRITER_DOCS_DIRECTORY];
    NSURL *rulesDirectory = [docsDirectory URLByAppendingPathComponent:@"Rules"];
    NSURL *privateRulesDirectory = [docsDirectory URLByAppendingPathComponent:@"Private Rules"];

    
    if (allRules == nil || [allRules count]== 0 ) {
        
        
        allRules = [[rulesDirectory valueForKeyPath:@"files.absoluteString"] mutableCopy];
        [allRules addObjectsFromArray:[privateRulesDirectory valueForKeyPath:@"files.absoluteString"]];
        
        
        
    }
    
    
    NSURL *randomRule =  [NSURL URLWithString: [allRules grab:1][0]];
    [itemsToShow addObject:randomRule];
    [userDefaults setObject:allRules forKey:ALL_RULES_KEY];

    
    //Get one inspirational text
    
    NSMutableArray *allInspirationalTexts = [[userDefaults arrayForKey:ALL_INSPIRATIONAL_TEXTS_KEY] mutableCopy];
    NSURL *inspirationalTextsDirectory = [self.goalCardDirectory URLByAppendingPathComponent:@"Inspirational Texts"];
    
    if (allInspirationalTexts == nil || [allInspirationalTexts count]== 0 ) {
        
        allInspirationalTexts = [[inspirationalTextsDirectory valueForKeyPath:@"files.absoluteString"] mutableCopy];
               
        
    }
    
    
    NSURL *randomInspirationalText = [NSURL URLWithString: [allInspirationalTexts grab:1][0]];
    [itemsToShow addObject:randomInspirationalText];
    [userDefaults setObject:allInspirationalTexts forKey:ALL_INSPIRATIONAL_TEXTS_KEY];


    
    
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
