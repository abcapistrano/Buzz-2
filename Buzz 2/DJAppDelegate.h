//
//  DJAppDelegate.h
//  Buzz
//
//  Created by Earl on 9/19/12.
//  Copyright (c) 2012 Earl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSArray+ConvenienceMethods.h"
#import "NSURL+DirectoryEnumerator.h"
#import <Quartz/Quartz.h>
#import "QLPreviewPanel+Secret.h"

@interface DJAppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate, QLPreviewPanelDataSource, QLPreviewPanelDelegate>
@property QLPreviewPanel *panel;
@property NSArray *quicklookItems;
@property NSTimer *timer;

@end
