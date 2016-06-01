/********* AudioLibrary.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AudioLibrary : CDVPlugin {
  // Member variables go here.
}

- (void)getItems:(CDVInvokedUrlCommand*)command;
- (void)play:(CDVInvokedUrlCommand*)command;
- (void)pause:(CDVInvokedUrlCommand*)command;

@end
NSMutableArray *songQueue;
NSMutableArray *arrayResult;
@implementation AudioLibrary

- (void)getItems:(CDVInvokedUrlCommand*)command
{
    NSLog(@"getItem method started..");
    [self.commandDelegate runInBackground:^{
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];

    NSArray *songs = [songsQuery items];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[songs count]];

    for (MPMediaItem *song in songs) {
        NSString *artist = [song valueForProperty: MPMediaItemPropertyArtist];

        if (artist == nil) 
            artist = @"Unknown";

        NSURL *url = [song valueForProperty: MPMediaItemPropertyAssetURL];
        NSString *path = [NSString stringWithFormat:@"%@",[url absoluteString]];
        
        NSString *duration = [NSString stringWithFormat:@"%f",[[song valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue]/60];
        
        MPMediaItemArtwork *itemArtwork = [song valueForProperty:MPMediaItemPropertyArtwork];
        UIImage *artworkUIImage = [itemArtwork imageWithSize:CGSizeMake(64, 64)];
       // NSData *data_of_my_image = UIImagePNGRepresentation(artworkUIImage);
        NSString *imageString = [UIImagePNGRepresentation(artworkUIImage) base64EncodedStringWithOptions:0];

        NSLog(@"SongID: %@",[[song valueForProperty: MPMediaItemPropertyPersistentID] stringValue]);
        NSDictionary *item = @{
            @"id": [[song valueForProperty: MPMediaItemPropertyPersistentID] stringValue],
            @"title" : [song valueForProperty: MPMediaItemPropertyTitle],
            @"artist": artist,
            @"duration": [song valueForProperty: MPMediaItemPropertyPlaybackDuration],
            @"path": path,
            @"album": [song valueForProperty:MPMediaItemPropertyAlbumTitle],
            @"duration": duration,
            @"image": imageString
        };

        [result addObject:item];
    }
    songQueue = [[NSMutableArray alloc] init];
    NSArray *arrayResult = [NSArray arrayWithArray:result];
        NSLog(@"getItem method finished");
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:arrayResult];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
}

- (void)initQueue:(CDVInvokedUrlCommand*)command
{   
    NSString *persistentID = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:0]];

    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    MPMusicPlayerController *player = [MPMusicPlayerController systemMusicPlayer];

    NSArray *items = [songsQuery items];
    NSLog(@"%@",persistentID);
    //songQueue = [[NSMutableArray alloc] init];

    BOOL found = NO;

    for(MPMediaItem *item in items) {
        NSString *itemId = [NSString stringWithFormat:@"%@",[item valueForProperty: MPMediaItemPropertyPersistentID]];

        //NSLog(@"PersistentID: %d",persistentID);
        NSLog(@"ItemID: %@",itemId);
        
        if([persistentID isEqualToString:itemId] ){
            [songQueue addObject:item];
            NSLog(@"Added. Count: %d",[songQueue count]);
        }

    }

    //arrayResult = [NSArray arrayWithArray:songQueue];

    [player setQueueWithItemCollection: [MPMediaItemCollection collectionWithItems: songQueue]];
    [player setNowPlayingItem: songQueue[0]];
    [player pause];
    // [player skipToBeginning];
    
    NSMutableArray *res = [NSMutableArray arrayWithCapacity:[songQueue count]];
    
    for (MPMediaItem *song in songQueue) {
        NSString *artist = [song valueForProperty: MPMediaItemPropertyArtist];
        
        if (artist == nil)
            artist = @"Unknown";
        
        NSURL *url = [song valueForProperty: MPMediaItemPropertyAssetURL];
        NSString *path = [NSString stringWithFormat:@"%@",[url absoluteString]];
        
        NSString *duration = [NSString stringWithFormat:@"%f",[[song valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue]/60];
        
        MPMediaItemArtwork *itemArtwork = [song valueForProperty:MPMediaItemPropertyArtwork];
        UIImage *artworkUIImage = [itemArtwork imageWithSize:CGSizeMake(64, 64)];
        // NSData *data_of_my_image = UIImagePNGRepresentation(artworkUIImage);
        NSString *imageString = [UIImagePNGRepresentation(artworkUIImage) base64EncodedStringWithOptions:0];
        
        
        NSDictionary *item = @{
                               @"id": [[song valueForProperty: MPMediaItemPropertyPersistentID] stringValue],
                               @"title" : [song valueForProperty: MPMediaItemPropertyTitle],
                               @"artist": artist,
                               @"duration": [song valueForProperty: MPMediaItemPropertyPlaybackDuration],
                               @"path": path,
                               @"album": [song valueForProperty:MPMediaItemPropertyAlbumTitle],
                               @"duration": duration,
                               @"image": imageString
                               };
        
        [res addObject:item];
    }

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:res];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)play:(CDVInvokedUrlCommand*)command
{
    MPMusicPlayerController *player = [MPMusicPlayerController systemMusicPlayer];
    [player play];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)pause:(CDVInvokedUrlCommand*)command
{
    MPMusicPlayerController *player = [MPMusicPlayerController systemMusicPlayer];
    [player pause];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
