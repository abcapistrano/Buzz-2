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
NSString * const ALL_MOTIVATIONAL_IMAGES_KEY = @"ALL_IMAGES_KEY";
NSString * const ALL_LONG_MESSAGES_KEY = @"ALL_LONG_MESSAGES_KEY";
NSString * const ALL_SHORT_MESSAGES_KEY = @"ALL_SHORT_MESSAGES_KEY";
NSString * const ALL_SEXY_IMAGES_KEY = @"ALL_SEXY_IMAGES_KEY";
NSString * const PRESENTATION_MODE_KEY = @"presentationMode";

NSString * const IAWRITER_DOCS_DIRECTORY = @"/Users/earltagra/Library/Mobile Documents/74ZAFF46HB~jp~informationarchitects~Writer/Documents/";


typedef NS_ENUM(NSUInteger, DJPresentationMode) {

    DJRulesPresentationMode,
    DJShortMessagesPresentationMode,
    DJLongMessagesPresentationMode,
    DJSexyImagesPresentationMode,
    DJPresentationModesCount

};


@implementation DJAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

        
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
    
    
    NSMutableArray * itemsToShow = [NSMutableArray array];
    
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];

    NSUInteger lastPresentationMode = [userDefaults integerForKey:PRESENTATION_MODE_KEY];
    NSUInteger newPresentationMode = (lastPresentationMode + 1);

    if (newPresentationMode == DJPresentationModesCount) {

        newPresentationMode = DJRulesPresentationMode;
    }

    [userDefaults setInteger:newPresentationMode forKey:PRESENTATION_MODE_KEY];
    NSURL *docsDirectory = [NSURL fileURLWithPath:IAWRITER_DOCS_DIRECTORY];


    if (newPresentationMode == DJRulesPresentationMode) {

        //Get one Rule

        NSMutableArray *allRules = [[userDefaults arrayForKey:ALL_RULES_KEY] mutableCopy];

        NSURL *rulesDirectory = [docsDirectory URLByAppendingPathComponent:@"Rules"];


        if (allRules == nil || [allRules count]== 0 ) {


            allRules = [[rulesDirectory valueForKeyPath:@"files.absoluteString"] mutableCopy];



        }


        NSURL *randomRule =  [NSURL URLWithString: [allRules grab:1][0]];
        [itemsToShow addObject:randomRule];
        [userDefaults setObject:allRules forKey:ALL_RULES_KEY];

    } else if (newPresentationMode == DJShortMessagesPresentationMode) {

        // Get affirmation + image + short message



        //Get one affirmation

        NSMutableArray *allAffirmations = [[userDefaults arrayForKey:ALL_AFFIRMATIONS_KEY] mutableCopy];
        NSURL *affirmationsDirectory = [docsDirectory URLByAppendingPathComponent:@"Affirmations"];

        if (allAffirmations == nil || [allAffirmations count]== 0 ) {


            allAffirmations = [[affirmationsDirectory valueForKeyPath:@"files.absoluteString"]  mutableCopy];



        }


        NSURL *randomAffirmation = [NSURL URLWithString:[allAffirmations grab:1][0]];
        [itemsToShow addObject:randomAffirmation];
        [userDefaults setObject:allAffirmations forKey:ALL_AFFIRMATIONS_KEY];

        
        // Get short message

        NSMutableArray *allShortMessages = [[userDefaults arrayForKey:ALL_SHORT_MESSAGES_KEY] mutableCopy];
        NSURL *shortMessagesDirectory = [docsDirectory URLByAppendingPathComponent:@"Short Messages"];

        if (allShortMessages == nil || [allShortMessages count]== 0 ) {


            allShortMessages = [[shortMessagesDirectory valueForKeyPath:@"files.absoluteString"]  mutableCopy];



        }


        NSURL *randomShortMessage = [NSURL URLWithString:[allShortMessages grab:1][0]];
        [itemsToShow addObject:randomShortMessage];
        [userDefaults setObject:allShortMessages forKey:ALL_SHORT_MESSAGES_KEY];




        //Get one image

        NSMutableArray *allMotivationalImages = [[userDefaults arrayForKey:ALL_MOTIVATIONAL_IMAGES_KEY] mutableCopy];
        NSURL *imagesDirectory = [NSURL fileURLWithPath:@"/Users/earltagra/Dropbox/Goal Card/Motivational Images"];;

        if (allMotivationalImages == nil || [allMotivationalImages count]== 0 ) {

            allMotivationalImages = [[imagesDirectory valueForKeyPath:@"files.absoluteString"] mutableCopy];


        }


        NSURL *randomImage = [NSURL URLWithString: [allMotivationalImages grab:1][0]];
        [itemsToShow addObject:randomImage];
        [userDefaults setObject:allMotivationalImages forKey:ALL_MOTIVATIONAL_IMAGES_KEY];
        
        
        
        





    } else if (newPresentationMode == DJLongMessagesPresentationMode) {

        // get one long message

        //Get one Rule

        NSMutableArray *allLongMessages = [[userDefaults arrayForKey:ALL_LONG_MESSAGES_KEY] mutableCopy];

        NSURL *longMessagesDirectory = [docsDirectory URLByAppendingPathComponent:@"Long Messages"];

        if (allLongMessages == nil || [allLongMessages count]== 0 ) {


            allLongMessages = [[longMessagesDirectory valueForKeyPath:@"files.absoluteString"] mutableCopy];



        }


        NSURL *randomLongMessage =  [NSURL URLWithString: [allLongMessages grab:1][0]];
        [itemsToShow addObject:randomLongMessage];
        [userDefaults setObject:allLongMessages forKey:ALL_LONG_MESSAGES_KEY];
        
    } else if (newPresentationMode == DJSexyImagesPresentationMode) {

        NSMutableArray *allSexyImages = [[userDefaults arrayForKey:ALL_SEXY_IMAGES_KEY] mutableCopy];
        NSURL *sexyImagesDirectory = [NSURL fileURLWithPath:@"/Users/earltagra/Dropbox/Goal Card/Sexy Images"];


        // add the NSFW page

        NSURL *page = [[NSBundle mainBundle] URLForResource:@"NOT SAFE FOR WORK" withExtension:@"pdf"];
        [itemsToShow addObject:page];


        if (allSexyImages == nil || [allSexyImages count]== 0 ) {

            allSexyImages = [[sexyImagesDirectory valueForKeyPath:@"files.absoluteString"] mutableCopy];


        }

        NSArray *randomImages = [allSexyImages grab:5];
        [randomImages enumerateObjectsUsingBlock:^(NSString* anImage, NSUInteger idx, BOOL *stop) {

            NSURL *url = [NSURL URLWithString:anImage];
            [itemsToShow addObject:url];


        }];
        
        [userDefaults setObject:allSexyImages forKey:ALL_SEXY_IMAGES_KEY];
        
        
        
        
    }
    
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
