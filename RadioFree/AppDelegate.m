//
//  AppDelegate.m
//  RadioFree
//
//  Created by vivek on 13/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//

#import "AppDelegate.h"
#import "STKAutoRecoveringHTTPDataSource.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <AVFoundation/AVAudioSession.h>
@interface AppDelegate ()<UITabBarControllerDelegate>
{
    
}
@property (nonatomic, strong) MPRemoteCommandCenter *remoteCommandCenter;
@end

@implementation AppDelegate
@synthesize PostPageNumber=_PostPageNumber;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _RemainingTimeInAppDelegate = 1;
    sleep(4);
    
    // One Signal Notification Start
    
    
    id notificationOpenedBlock = ^(OSNotificationOpenedResult *result) {
        OSNotificationPayload* payload = result.notification.payload;
        
        NSString* messageTitle = @"OneSignal Example";
        NSString* fullMessage = [payload.body copy];
        
        if (payload.additionalData) {
            
            //  if (payload.title)
            //    messageTitle = payload.title;
            
            //  if (result.action.actionID) {
            //    fullMessage = [fullMessage stringByAppendingString:[NSString stringWithFormat:@"\nPressed ButtonId:%@", result.action.actionID]];
            
            //   UIViewController *vc;
            
            // if ([result.action.actionID isEqualToString: @"id2"]) {
            //  RedViewController *redVC = (RedViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"redVC"];
            
            if (payload.additionalData[@"OpenURL"]){
                
                NSLog(@"URL :- %@",[NSString stringWithFormat:@"%@",payload.additionalData[@"OpenURL"]]);
                //                        redVC.receivedUrl = [NSURL URLWithString:(NSString *)payload.additionalData[@"OpenURL"]];
            }
            //     vc = redVC;
            //  } else if ([result.action.actionID isEqualToString:@"id1"]) {
            //     vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"greenVC"];
            // }
            
            // [self.window.rootViewController presentViewController:vc animated:true completion:nil];
        }
        
        
        
        
        //        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Push Notification" message:fullMessage preferredStyle:UIAlertControllerStyleAlert];
        //        [controller addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil]];
        //
        //        [self.window.rootViewController presentViewController:controller animated:true completion:nil];
        
    };
    
    
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:@"f200325b-6b19-44e2-8d2d-5188658e1093"
            handleNotificationAction:nil
                            settings:@{kOSSettingsKeyAutoPrompt: @false}];
    OneSignal.inFocusDisplayType = OSNotificationDisplayTypeNotification;
    
    // Recommend moving the below line to prompt for push after informing the user about
    //   how your app will use them.
    [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
        NSLog(@"User accepted notifications: %d", accepted);
    }];
    
    //One signal End
    
    
    
    _AudioViewControllerStatusId = 0;
    NSError* error;
    [self createLockscreenAudioPlyer];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    
    
    Float32 bufferLength = 0.1;
    AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(bufferLength), &bufferLength);
    
    self.audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    self.audioPlayer.meteringEnabled = YES;
    self.audioPlayer.volume = 1;
    [self setupTimer];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NewsViewController *newsview = [[NewsViewController alloc] init];
    
    LiveViewController *liveview = [[LiveViewController alloc] initWithNibName:@"LiveViewController" bundle:nil];
  //  [liveview loadAudioPlayer:audioPlayer];
    DetailViewController *detailview = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    SettingsViewController *settingsview = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
    BookMarkViewController *bookmarkview = [[BookMarkViewController alloc] initWithNibName:@"BookMarkViewController" bundle:nil];
    
    MenuContentViewController *menuContentview = [[MenuContentViewController alloc] initWithNibName:@"MenuContentViewController" bundle:nil];
    
    BKDetailViewController *bkDetailview = [[BKDetailViewController alloc] initWithNibName:@"BKDetailViewController" bundle:nil];
    
    SettingsSubViewController *settingsSubView = [[SettingsSubViewController alloc] initWithNibName:@"SettingsSubViewController" bundle:nil];
    
    [self.window makeKeyAndVisible];
    
    self.mainTabBar = [[UITabBarController alloc] init];
    self.mainTabBar.delegate = self;
    self.mainTabBar.viewControllers = @[newsview, liveview, detailview, settingsview, bookmarkview, menuContentview,bkDetailview,settingsSubView];
    
    self.mainNavigation = [[UINavigationController alloc] initWithRootViewController:self.mainTabBar];
    
    self.window.rootViewController = self.mainNavigation;
    
    [self.mainNavigation setNavigationBarHidden:YES];
    
    return YES;
}

-(void) setupTimer
{
    self.timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void) tick
{
    
    if (!self.audioPlayer)
            {
        
                _AudioProgressTimeStr = @"00:00:00";
                _AudioDurationTimeStr = @"00:00:00";
        
                return;
            }
    
            if (self.audioPlayer.currentlyPlayingQueueItemId == nil)
            {
        
        
                _AudioProgressTimeStr = @"00:00:00";
                _AudioDurationTimeStr = @"00:00:00";
                return;
            }
    
    if (self.audioPlayer.state == STKAudioPlayerStateBuffering) {
        StatusBarActivityIndicatorShow;
    }else{
        StatusBarActivityIndicatorHide;
    }
    
    if (self.audioPlayer.duration != 0 && self.audioPlayer.state == STKAudioPlayerStatePlaying)
    {
       
        _AudioMainProgressString = [self FormatTimeFromAudioPlayer:self.audioPlayer.duration withProgress:self.audioPlayer.progress];
        
        //_AudioProgressTimeStr = [NSString stringWithFormat:@"%@",[self formatTimeFromSeconds:self.audioPlayer.progress isDuration:NO]];
        //_AudioDurationTimeStr = [NSString stringWithFormat:@"%@",[self formatTimeFromSeconds:self.audioPlayer.duration isDuration:YES]];
    }
    else
    {
        
    }
    
}

-(NSString *)FormatTimeFromAudioPlayer:(int)Duration withProgress:(int)progress{
    
    int remainingTime = Duration - progress;

    _RemainingTimeInAppDelegate = remainingTime;
    int second = remainingTime % 60;
    int minutes = (remainingTime / 60) % 60;
    int hours = remainingTime / 3600;
    
    if (hours == 0) {
        return [NSString stringWithFormat:@"-%2d:%02d",minutes,second];
    }else{
        return [NSString stringWithFormat:@"-%2d:%2d:%02d", hours, minutes, second];
    }
    
    
}

-(NSString*) formatTimeFromSeconds:(int)totalSeconds isDuration:(BOOL)isDuration
{
    BOOL isHoursAvailable = false;
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if (isDuration == YES) {
        
        if (hours == 0) {
            isHoursAvailable = NO;
            return [NSString stringWithFormat:@"%2d:%2d",minutes, seconds];
        }else{
            isHoursAvailable = YES;
            return [NSString stringWithFormat:@"%2d:%2d:%2d", hours, minutes, seconds];
        }
    }else{
        if (isHoursAvailable == YES) {
            if (hours == 0) {
                
                if (minutes == 0) {
                    return [NSString stringWithFormat:@"%2d", seconds];
                }else{
                    return [NSString stringWithFormat:@"%2d:%2d", minutes, seconds];
                }
                
            }else{
              return [NSString stringWithFormat:@"%2d:%2d:%2d", hours, minutes, seconds];
            }
        }else{
            if (minutes == 0) {
                return [NSString stringWithFormat:@"%2d", seconds];
            }else{
            return [NSString stringWithFormat:@"%2d:%2d",minutes, seconds];
            }
        }
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//-(IBAction)skipForward:(id)sender{
//
//}
-(IBAction)togglePlayPause:(id)sender{
    
    if (self.audioPlayer.state == STKAudioPlayerStatePaused) {
        [self.audioPlayer resume];
    }else{
        [self.audioPlayer pause];
    }
    
    
}
-(IBAction)pause:(id)sender{
    
    NSLog(@"USER PRESS PAUSE BUTTON NOW");
    LiveViewController *live = [[LiveViewController alloc] init];
    [live didNotifyToPlayButton];
    [self.audioPlayer pause];
}
//-(IBAction)like:(id)sender{
    
//}
-(IBAction)play:(id)sender{
    
    NSLog(@"USER PRESS PLAY BUTTON NOW");
    [self.audioPlayer resume];
}
-(void)createLockscreenAudioPlyer{
    _remoteCommandCenter = [MPRemoteCommandCenter sharedCommandCenter];
   // [_remoteCommandCenter pla]
   // [[_remoteCommandCenter skipForwardCommand] addTarget:self action:@selector(skipForward:)];
    [[_remoteCommandCenter togglePlayPauseCommand] addTarget:self action:@selector(togglePlayPause:)];
    [[_remoteCommandCenter pauseCommand] addTarget:self action:@selector(pause:)];
    [[_remoteCommandCenter playCommand] addTarget:self action:@selector(play:)];
   // [[_remoteCommandCenter likeCommand] addTarget:self action:@selector(like:)];
   // [_remoteCommandCenter.likeCommand setEnabled:NO];
   // [_remoteCommandCenter.skipForwardCommand setEnabled:NO];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
    
    if (self.AudioViewControllerStatusId == AudioLiveViewControllerStatusId) {
        
//        NSError *setCategoryErr = nil;
//        NSError *activationErr  = nil;
//        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
//        [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
        
        
        [_remoteCommandCenter.pauseCommand setEnabled:YES];
        [_remoteCommandCenter.playCommand setEnabled:YES];
        if ([APPDELEGATE.LockScreenArtworkImageUrlStr isEqualToString:@""]) {
            UIImage *image = [UIImage imageNamed:@"RadioFreeLogo.png"];
            [self updateMediaCentreWithTitle:APPDELEGATE.LockScreenAlbumStr withArtist:APPDELEGATE.LockScreenArtistStr andArtwork:image];
        }else{
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: APPDELEGATE.LockScreenArtworkImageUrlStr]];
            UIImage *image = [UIImage imageWithData: imageData];
            
            [self updateMediaCentreWithTitle:APPDELEGATE.LockScreenAlbumStr withArtist:APPDELEGATE.LockScreenArtistStr andArtwork:image];
        }
        
        
    }else{
        
        [_remoteCommandCenter.playCommand setEnabled:YES];
        [_remoteCommandCenter.pauseCommand setEnabled:YES];
        [_remoteCommandCenter.togglePlayPauseCommand setEnabled:YES];
         UIImage *image = [UIImage imageNamed:@"RadioFreeLogo.png"];
        [self updateMediaCentreWithTitle:APPDELEGATE.AudioTitleStr withArtist:@" " andArtwork:image];
       
//        NSError *setCategoryErr = nil;
//        NSError *activationErr  = nil;
//        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
//        [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
        
//        _remoteCommandCenter = [MPRemoteCommandCenter sharedCommandCenter];
//        [[_remoteCommandCenter skipForwardCommand] addTarget:self action:@selector(skipForward:)];
//        [[_remoteCommandCenter togglePlayPauseCommand] addTarget:self action:@selector(togglePlayPause:)];
//        [[_remoteCommandCenter pauseCommand] addTarget:self action:@selector(pause:)];
//        [[_remoteCommandCenter playCommand] addTarget:self action:@selector(play:)];
//        [[_remoteCommandCenter likeCommand] addTarget:self action:@selector(like:)];
//        [_remoteCommandCenter.likeCommand setEnabled:NO];
//        [_remoteCommandCenter.skipForwardCommand setEnabled:NO];
        
        //[[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
        
    }
    
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)updateMediaCentreWithTitle:(NSString *)title withArtist:(NSString *)artist andArtwork:(UIImage *)artwork {
    
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: artwork];
        
        [songInfo setObject:@"Radio Free" forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:title forKey:MPMediaItemPropertyArtist];
        [songInfo setObject:artist forKey:MPMediaItemPropertyAlbumTitle];
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        //[songInfo setObject:[NSString stringWithFormat:@"%f",self.audioPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        
        
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return [[window rootViewController] isMemberOfClass:[UIViewController class]] ?
    UIInterfaceOrientationMaskAllButUpsideDown : // If current view is the player, allow landscape
    UIInterfaceOrientationMaskPortrait;          // Otherwise, portrait-only
}

@end
