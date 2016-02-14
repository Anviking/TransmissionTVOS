//
//  SessionSetup.h
//  Transmission
//
//  Created by Johannes Lund on 2016-02-14.
//  Copyright © 2016 The Transmission Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "transmission.h"
#import "libtransmission/variant.h"
#import "libtransmission/session.h"

@interface SessionSetup : NSObject
{    
    NSMutableArray                  * fTorrents, * fDisplayedTorrents;
    
    NSUserDefaults                  * fDefaults;
    
    NSString                        * fConfigDirectory;

    NSMutableArray                  * fAutoImportedNames;
    NSTimer                         * fAutoImportTimer;
    
    NSMutableDictionary             * fPendingTorrentDownloads;
    
    NSMutableSet                    * fAddingTransfers;
    
    NSMutableSet                    * fAddWindows;
    
    BOOL                            fGlobalPopoverShown;
    BOOL                            fSoundPlaying;
}

@property (nonatomic, assign) tr_session                      * fLib;

@end
