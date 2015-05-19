//
//  NSURL+Extension.h
//  EasyBills
//
//  Created by luojie on 5/17/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Objective-Zip.h"

@interface NSURL (Extension)

+ (NSURL*)zipFolderAtURL:(NSURL*)url withZipfileName:(NSString*)zipFileName;
+ (void)unzipFileAtURL:(NSURL*)zipFileURL toURL:(NSURL*)unzipURL;
+ (NSURL*)renameLastPathComponentOfURL:(NSURL*)url toName:(NSString*)name;
+ (BOOL)deleteFileAtURL:(NSURL*)url;
+ (void)createParentFolderForFile:(NSURL*)url;

@end
