//
//  DJAppDelegate.h
//  Buzz
//
//  Created by Earl on 9/19/12.
//  Copyright (c) 2012 Earl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MTRandom.h"
#import "NSURL+FileManagement.h"
#import <Quartz/Quartz.h>
#import "QLPreviewPanel+Secret.h"
@class iTunesApplication;

@interface DJAppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate, QLPreviewPanelDataSource, QLPreviewPanelDelegate>
@property QLPreviewPanel *panel;
@property NSArray *quicklookItems;
@property NSTimer *timer;
@property (weak) IBOutlet NSWindow *window;
@property (readonly) iTunesApplication* iTunes;
@property (readonly) BOOL isITunesPlaying;


// BUTTON ACTIONS
- (IBAction)configure:(id)sender;
- (IBAction)delay:(id)sender;
- (IBAction)dismiss:(id)sender;
- (IBAction)goAhead:(id)sender;

@end
