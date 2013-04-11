//
//  DJAppDelegate.m
//  Buzz
//
//  Created by Earl on 9/19/12.
//  Copyright (c) 2012 Earl. All rights reserved.
//

#import "DJAppDelegate.h"
#import "iTunes.H"
NSString * const ALL_AFFIRMATIONS_KEY = @"ALL_AFFIRMATIONS";
NSString * const ALL_RULES_KEY = @"ALL_RULES";
NSString * const ALL_MOTIVATIONAL_IMAGES_KEY = @"ALL_MOTIVATIONAL_IMAGES";
NSString * const ALL_MESSAGES_KEY = @"ALL_MESSAGES";
NSString * const ALL_SEXY_IMAGES_KEY = @"ALL_SEXY_IMAGES";
NSString * const ALL_SEXY_VIDEOS_KEY = @"ALL_SEXY_VIDEOS";

NSString * const PRESENTATION_ORDER_KEY = @"presentationOrder";



NSString * const APP_SUPPORT_DIRECTORY = @"/Users/earltagra/Library/Application Support/com.demonjelly.Buzz-2";


typedef NS_ENUM(NSUInteger, DJPresentationMode) {
    DJRulesPresentationMode,
    DJSexyVideosPresentationMode,
    DJMessagesPresentationMode,
    DJMotivationalImagesPresentationMode,
    DJSexyImagesPresentationMode,
    DJAffirmationsPresentationMode
};

@implementation DJAppDelegate

- (void)applicationDidBecomeActive:(NSNotification *)notification {

    [self prompt];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    [self prompt];
    [self startTimer];


    
}

- (void) startTimer {
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10*60 target:self selector:@selector(prompt) userInfo:nil repeats:NO];

}

- (void) prompt {
    

    
    [NSApp activateIgnoringOtherApps:YES];
    [self.window center];
    [self.window makeKeyAndOrderFront:self];

   

}


- (void) configure:(id)sender {

    NSURL *appSupportDirectory = [NSURL fileURLWithPath:APP_SUPPORT_DIRECTORY];

    [[NSWorkspace sharedWorkspace] openURL:appSupportDirectory];

    [self.window orderOut:self];
    [self startTimer];




}

- (void) delay:(id)sender {
    [self.window orderOut:self];

    //delay for three hours;
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3*60*60 target:self selector:@selector(prompt) userInfo:nil repeats:NO];


}

- (void) dismiss:(id)sender {
    [self.window orderOut:self];
    [self startTimer];
    [NSApp hide:self];



}

// returns an NSArray of NSURLs
- (NSArray *) getResourcesWithKey: (NSString *) resourceKey count: (NSUInteger) max {
    NSURL *appSupportDirectory = [NSURL fileURLWithPath:APP_SUPPORT_DIRECTORY];
    NSURL *resourcesDirectory = [appSupportDirectory URLByAppendingPathComponent:resourceKey];


    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *allResources = [[userDefaults arrayForKey:resourceKey] mutableCopy];

    if ([allResources count]== 0 ) {

        allResources = [[resourcesDirectory valueForKeyPath:@"files.absoluteString"] mutableCopy];



    }


    NSArray *results = [allResources grab:max];
    [userDefaults setObject:allResources forKey:resourceKey];
    [userDefaults synchronize];
    

    NSMutableArray *resourceURLs = [NSMutableArray array];
    [results enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {

        NSURL *url = [NSURL URLWithString:obj];
        [resourceURLs addObject:url];


    }];    
 
    return [resourceURLs copy];


}

- (void) goAhead:(id)sender {



    [self.window orderOut:self];

    NSMutableArray * itemsToShow = [NSMutableArray array];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *presentationOrder = [[userDefaults arrayForKey:PRESENTATION_ORDER_KEY] mutableCopy];

    if ([presentationOrder count] == 0 ) {
        presentationOrder = [@[

                             @(DJRulesPresentationMode),
                             @(DJAffirmationsPresentationMode),

                             @(DJSexyVideosPresentationMode),
                             @(DJAffirmationsPresentationMode),

                             @(DJMessagesPresentationMode),
                             @(DJAffirmationsPresentationMode),

                             @(DJMotivationalImagesPresentationMode),
                             @(DJAffirmationsPresentationMode),

                             @(DJSexyImagesPresentationMode),
                             @(DJAffirmationsPresentationMode)
                             
                             
                             
                             ] mutableCopy];



    }

    NSNumber* top = [presentationOrder objectAtIndex:0];
    [presentationOrder removeObjectAtIndex:0];

    DJPresentationMode newPresentationMode = [top integerValue];

    NSURL *nsfwPage = [[NSBundle mainBundle] URLForResource:@"NOT SAFE FOR WORK" withExtension:@"pdf"];
    switch (newPresentationMode) {
        case DJRulesPresentationMode:


            [itemsToShow addObjectsFromArray:[self getResourcesWithKey:ALL_RULES_KEY count:1]];
            
            break;
        case DJSexyVideosPresentationMode:
            [itemsToShow addObject:nsfwPage];
            [itemsToShow addObjectsFromArray:[self getResourcesWithKey:ALL_SEXY_VIDEOS_KEY count:1]];


            break;
        case DJMessagesPresentationMode:

            [itemsToShow addObjectsFromArray:[self getResourcesWithKey:ALL_MESSAGES_KEY count:1]];


            break;
        case DJMotivationalImagesPresentationMode:

            [itemsToShow addObjectsFromArray:[self getResourcesWithKey:ALL_MOTIVATIONAL_IMAGES_KEY count:1]];

            break;
        case DJSexyImagesPresentationMode:


            [itemsToShow addObject:nsfwPage];
            [itemsToShow addObjectsFromArray:[self getResourcesWithKey:ALL_SEXY_IMAGES_KEY count:5]];


            
            break;
        case DJAffirmationsPresentationMode:

            [itemsToShow addObjectsFromArray:[self getResourcesWithKey:ALL_AFFIRMATIONS_KEY count:1]];

            break;

    }

    
    [userDefaults setObject:presentationOrder forKey:PRESENTATION_ORDER_KEY];
    [userDefaults synchronize];


    self.quicklookItems = itemsToShow;



    self.panel = [QLPreviewPanel sharedPreviewPanel];

    [self.panel makeKeyAndOrderFront:self];
    [self.panel enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];

    


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
    self.panel.dataSource = self;
    self.panel.delegate = self;
    [self.panel setAutostarts:NO];

    if (self.isITunesPlaying) {
        [self.iTunes pause];
    }


}

- (BOOL) isITunesPlaying {

    NSString *identifier = @"com.apple.iTunes";
    if (![[NSRunningApplication runningApplicationsWithBundleIdentifier:identifier] count]) {

        return NO;
    } else {

        if (!_iTunes) {
            _iTunes = [SBApplication applicationWithBundleIdentifier:identifier];
        }


        return self.iTunes.playerState == iTunesEPlSPlaying;
    }


}

- (void) endPreviewPanelControl:(QLPreviewPanel *)panel {

    [self startTimer];
    [NSApp hide:self];

    if (self.isITunesPlaying) {
        [self.iTunes playpause];
    }

}






@end
