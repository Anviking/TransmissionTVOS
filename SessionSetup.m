//
//  SessionSetup.m
//  Transmission
//
//  Created by Johannes Lund on 2016-02-14.
//  Copyright © 2016 The Transmission Project. All rights reserved.
//

#import "SessionSetup.h"


@implementation SessionSetup

- (instancetype)init {
    self = [super init];
    
    NSURL *defaultPrefsFile = [[NSBundle mainBundle]
                               URLForResource:@"Defaults" withExtension:@"plist"];
    NSDictionary *defaultPrefs =
    [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    
     NSUserDefaults *fDefaults = [NSUserDefaults standardUserDefaults];
    
    
    NSLog(@"%i", [fDefaults integerForKey: @"UploadLimit"]);
    
    //checks for old version speeds of -1
    if ([fDefaults integerForKey: @"UploadLimit"] < 0)
    {
        [fDefaults removeObjectForKey: @"UploadLimit"];
        [fDefaults setBool: NO forKey: @"CheckUpload"];
    }
    if ([fDefaults integerForKey: @"DownloadLimit"] < 0)
    {
        [fDefaults removeObjectForKey: @"DownloadLimit"];
        [fDefaults setBool: NO forKey: @"CheckDownload"];
    }
    
    
    struct tr_variant settings;
    tr_variantInitDict(&settings, 41);
    tr_sessionGetDefaultSettings(&settings);
    
    const BOOL usesSpeedLimitSched = [fDefaults boolForKey: @"SpeedLimitAuto"];
    if (!usesSpeedLimitSched)
        tr_variantDictAddBool(&settings, TR_KEY_alt_speed_enabled, [fDefaults boolForKey: @"SpeedLimit"]);
    
    tr_variantDictAddInt(&settings, TR_KEY_alt_speed_up, [fDefaults integerForKey: @"SpeedLimitUploadLimit"]);
    tr_variantDictAddInt(&settings, TR_KEY_alt_speed_down, [fDefaults integerForKey: @"SpeedLimitDownloadLimit"]);
    
//    tr_variantDictAddBool(&settings, TR_KEY_alt_speed_time_enabled, [fDefaults boolForKey: @"SpeedLimitAuto"]);
//    tr_variantDictAddInt(&settings, TR_KEY_alt_speed_time_begin, [PrefsController dateToTimeSum:
//                                                                  [fDefaults objectForKey: @"SpeedLimitAutoOnDate"]]);
//    tr_variantDictAddInt(&settings, TR_KEY_alt_speed_time_end, [PrefsController dateToTimeSum:
//                                                                [fDefaults objectForKey: @"SpeedLimitAutoOffDate"]]);
    tr_variantDictAddInt(&settings, TR_KEY_alt_speed_time_day, [fDefaults integerForKey: @"SpeedLimitAutoDay"]);
    
    tr_variantDictAddInt(&settings, TR_KEY_speed_limit_down, [fDefaults integerForKey: @"DownloadLimit"]);
    tr_variantDictAddBool(&settings, TR_KEY_speed_limit_down_enabled, [fDefaults boolForKey: @"CheckDownload"]);
    tr_variantDictAddInt(&settings, TR_KEY_speed_limit_up, [fDefaults integerForKey: @"UploadLimit"]);
    tr_variantDictAddBool(&settings, TR_KEY_speed_limit_up_enabled, [fDefaults boolForKey: @"CheckUpload"]);
    
    //hidden prefs
    if ([fDefaults objectForKey: @"BindAddressIPv4"])
        tr_variantDictAddStr(&settings, TR_KEY_bind_address_ipv4, [[fDefaults stringForKey: @"BindAddressIPv4"] UTF8String]);
    if ([fDefaults objectForKey: @"BindAddressIPv6"])
        tr_variantDictAddStr(&settings, TR_KEY_bind_address_ipv6, [[fDefaults stringForKey: @"BindAddressIPv6"] UTF8String]);
    
    
    
    tr_variantDictAddBool(&settings, TR_KEY_blocklist_enabled, [fDefaults boolForKey: @"BlocklistNew"]);
    if ([fDefaults objectForKey: @"BlocklistURL"])
        tr_variantDictAddStr(&settings, TR_KEY_blocklist_url, [[fDefaults stringForKey: @"BlocklistURL"] UTF8String]);
    tr_variantDictAddBool(&settings, TR_KEY_dht_enabled, [fDefaults boolForKey: @"DHTGlobal"]);
    tr_variantDictAddStr(&settings, TR_KEY_download_dir, [[[fDefaults stringForKey: @"DownloadFolder"]
                                                           stringByExpandingTildeInPath] UTF8String]);
    tr_variantDictAddBool(&settings, TR_KEY_download_queue_enabled, [fDefaults boolForKey: @"Queue"]);
    tr_variantDictAddInt(&settings, TR_KEY_download_queue_size, [fDefaults integerForKey: @"QueueDownloadNumber"]);
    tr_variantDictAddInt(&settings, TR_KEY_idle_seeding_limit, [fDefaults integerForKey: @"IdleLimitMinutes"]);
    tr_variantDictAddBool(&settings, TR_KEY_idle_seeding_limit_enabled, [fDefaults boolForKey: @"IdleLimitCheck"]);
    tr_variantDictAddStr(&settings, TR_KEY_incomplete_dir, [[[fDefaults stringForKey: @"IncompleteDownloadFolder"]
                                                             stringByExpandingTildeInPath] UTF8String]);
    tr_variantDictAddBool(&settings, TR_KEY_incomplete_dir_enabled, [fDefaults boolForKey: @"UseIncompleteDownloadFolder"]);
    tr_variantDictAddBool(&settings, TR_KEY_lpd_enabled, [fDefaults boolForKey: @"LocalPeerDiscoveryGlobal"]);
    tr_variantDictAddInt(&settings, TR_KEY_message_level, TR_LOG_DEBUG);
    tr_variantDictAddInt(&settings, TR_KEY_peer_limit_global, [fDefaults integerForKey: @"PeersTotal"]);
    tr_variantDictAddInt(&settings, TR_KEY_peer_limit_per_torrent, [fDefaults integerForKey: @"PeersTorrent"]);
    
    const BOOL randomPort = [fDefaults boolForKey: @"RandomPort"];
    tr_variantDictAddBool(&settings, TR_KEY_peer_port_random_on_start, randomPort);
    if (!randomPort)
        tr_variantDictAddInt(&settings, TR_KEY_peer_port, [fDefaults integerForKey: @"BindPort"]);
    
    //hidden pref
    if ([fDefaults objectForKey: @"PeerSocketTOS"])
        tr_variantDictAddStr(&settings, TR_KEY_peer_socket_tos, [[fDefaults stringForKey: @"PeerSocketTOS"] UTF8String]);
    
    tr_variantDictAddBool(&settings, TR_KEY_pex_enabled, [fDefaults boolForKey: @"PEXGlobal"]);
    tr_variantDictAddBool(&settings, TR_KEY_port_forwarding_enabled, [fDefaults boolForKey: @"NatTraversal"]);
    tr_variantDictAddBool(&settings, TR_KEY_queue_stalled_enabled, [fDefaults boolForKey: @"CheckStalled"]);
    tr_variantDictAddInt(&settings, TR_KEY_queue_stalled_minutes, 1);
    tr_variantDictAddReal(&settings, TR_KEY_ratio_limit, [fDefaults floatForKey: @"RatioLimit"]);
    tr_variantDictAddBool(&settings, TR_KEY_ratio_limit_enabled, [fDefaults boolForKey: @"RatioCheck"]);
    tr_variantDictAddBool(&settings, TR_KEY_rename_partial_files, [fDefaults boolForKey: @"RenamePartialFiles"]);
    tr_variantDictAddBool(&settings, TR_KEY_rpc_authentication_required,  [fDefaults boolForKey: @"RPCAuthorize"]);
    tr_variantDictAddBool(&settings, TR_KEY_rpc_enabled,  [fDefaults boolForKey: @"RPC"]);
    tr_variantDictAddInt(&settings, TR_KEY_rpc_port, [fDefaults integerForKey: @"RPCPort"]);
    tr_variantDictAddStr(&settings, TR_KEY_rpc_username,  [[fDefaults stringForKey: @"RPCUsername"] UTF8String]);
    tr_variantDictAddBool(&settings, TR_KEY_rpc_whitelist_enabled,  [fDefaults boolForKey: @"RPCUseWhitelist"]);
    tr_variantDictAddBool(&settings, TR_KEY_seed_queue_enabled, [fDefaults boolForKey: @"QueueSeed"]);
    tr_variantDictAddInt(&settings, TR_KEY_seed_queue_size, [fDefaults integerForKey: @"QueueSeedNumber"]);
    tr_variantDictAddBool(&settings, TR_KEY_start_added_torrents, [fDefaults boolForKey: @"AutoStartDownload"]);
    tr_variantDictAddBool(&settings, TR_KEY_script_torrent_done_enabled, [fDefaults boolForKey: @"DoneScriptEnabled"]);
    tr_variantDictAddStr(&settings, TR_KEY_script_torrent_done_filename, [[fDefaults stringForKey: @"DoneScriptPath"] UTF8String]);
    tr_variantDictAddBool(&settings, TR_KEY_utp_enabled, [fDefaults boolForKey: @"UTPGlobal"]);
    
    
    NSString * kbString, * mbString, * gbString, * tbString;
        NSByteCountFormatter * unitFormatter = [[NSByteCountFormatter alloc] init];
        [unitFormatter setIncludesCount: NO];
        [unitFormatter setAllowsNonnumericFormatting: NO];
        
        [unitFormatter setAllowedUnits: NSByteCountFormatterUseKB];
        kbString = [unitFormatter stringFromByteCount: 17]; //use a random value to avoid possible pluralization issues with 1 or 0 (an example is if we use 1 for bytes, we'd get "byte" when we'd want "bytes" for the generic libtransmission value at least)
        
        [unitFormatter setAllowedUnits: NSByteCountFormatterUseMB];
        mbString = [unitFormatter stringFromByteCount: 17];
        
        [unitFormatter setAllowedUnits: NSByteCountFormatterUseGB];
        gbString = [unitFormatter stringFromByteCount: 17];
        
        [unitFormatter setAllowedUnits: NSByteCountFormatterUseTB];
        tbString = [unitFormatter stringFromByteCount: 17];
        
        [unitFormatter release];
    
    const char * configDir = tr_getDefaultConfigDir("Transmission");
    self.fLib = tr_sessionInit("macosx", configDir, YES, &settings);
    tr_variantFree(&settings);
    
    NSString *fConfigDirectory = [[NSString alloc] initWithUTF8String: configDir];
    
    
//    //register for magnet URLs (has to be in init)
//    [[NSAppleEventManager sharedAppleEventManager] setEventHandler: self andSelector: @selector(handleOpenContentsEvent:replyEvent:)
//                                                     forEventClass: kInternetEventClass andEventID: kAEGetURL];
    
    fTorrents = [[NSMutableArray alloc] init];
    fDisplayedTorrents = [[NSMutableArray alloc] init];
    
    
    //needs to be done before init-ing the prefs controller
//    fFileWatcherQueue = [[VDKQueue alloc] init];
//    [fFileWatcherQueue setDelegate: self];
//    
//    fPrefsController = [[PrefsController alloc] initWithHandle: fLib];
//    
//    fQuitting = NO;
    fGlobalPopoverShown = NO;
    fSoundPlaying = NO;
    
//    tr_sessionSetAltSpeedFunc(fLib, altSpeedToggledCallback, self);
//    if (usesSpeedLimitSched)
//        [fDefaults setBool: tr_sessionUsesAltSpeed(fLib) forKey: @"SpeedLimit"];
//    
//    tr_sessionSetRPCCallback(fLib, rpcCallback, self);
//    
//    [GrowlApplicationBridge setGrowlDelegate: self];
//    
//    [[SUUpdater sharedUpdater] setDelegate: self];
//    fQuitRequested = NO;
//    
//    fPauseOnLaunch = (GetCurrentKeyModifiers() & (optionKey | rightOptionKey)) != 0;
    return self;
}

@end
