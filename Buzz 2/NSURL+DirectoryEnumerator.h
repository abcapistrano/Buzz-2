//
//  NSURL+DirectoryEnumerator.h
//  Goal Card
//
//  Created by Earl on 8/18/12.
//  Copyright (c) 2012 Earl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Extra)

// If the receiver is a directory, the file: method returns the URLs of the files inside the directory. Excludes hidden files.
- (NSArray *) files;
- (BOOL) contentTypeConformsToUTI: (NSString *) UTI;
@end
