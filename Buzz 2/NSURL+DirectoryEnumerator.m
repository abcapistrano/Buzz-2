//
//  NSURL+DirectoryEnumerator.m
//  Goal Card
//
//  Created by Earl on 8/18/12.
//  Copyright (c) 2012 Earl. All rights reserved.
//

#import "NSURL+DirectoryEnumerator.h"

@implementation NSURL (Extra)
- (NSArray *) files {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    return [fm contentsOfDirectoryAtURL:self
      includingPropertiesForKeys:nil
                         options:NSDirectoryEnumerationSkipsHiddenFiles
                           error:nil];
    
    
}

- (BOOL) contentTypeConformsToUTI: (NSString *) UTI {

    NSString *contentType;
    [self getResourceValue:&contentType forKey:NSURLTypeIdentifierKey error:nil];
    
    return [[NSWorkspace sharedWorkspace] type:contentType conformsToType:UTI];
        
}


 

@end
