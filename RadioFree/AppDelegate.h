//
//  AppDelegate.h
//  RadioFree
//
//  Created by vivek on 13/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STKAudioPlayer.h"
#import "Header.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, assign) BOOL isFirstTimeTableviewLoading;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *mainNavigation;

@property (strong, nonatomic) UITabBarController *mainTabBar;

@property (nonatomic, strong) STKAudioPlayer* audioPlayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger PostPageNumber;
@property (nonatomic, strong) NSString *StringNewsPostId;
@property (nonatomic, strong) NSString *StringNewsPostFormat;
@property (nonatomic, strong) NSString *StringBKNewsPostId;
@property (nonatomic, strong) NSString *StringBKNewsPostFormat;
@property (nonatomic, assign) NSInteger MenuContentItemKey;
@property (nonatomic, assign) NSInteger selectedIndexPath;
@property (nonatomic, assign) NSInteger SettingsKeys;
@property (nonatomic, assign) BOOL isPlayButton;
@property (nonatomic, assign) NSInteger AudioViewControllerStatusId;
@property (nonatomic, strong) NSString *SettingsPostTypeValue;
@property (nonatomic, strong) NSString *settingsPostTypeValueZeroForURL;
@property (nonatomic, strong) NSString *NavigationMenuPostTypeValue;
@property (nonatomic, strong) NSString *NavigationMenuPostTypeValueUrl;
@property (nonatomic, strong) NSString *AudioDurationTimeStr;
@property (nonatomic, strong) NSString *AudioProgressTimeStr;
@property (nonatomic, strong) NSString *AudioTitleStr;
@property (nonatomic, strong) NSString *AudioURLStr;
@property (nonatomic, strong) NSString *AudioMainProgressString;
@property (nonatomic, strong) NSString *LockScreenAlbumStr;
@property (nonatomic, strong) NSString *LockScreenArtistStr;
@property (nonatomic, strong) NSString *LockScreenArtworkImageUrlStr;
@property (nonatomic, assign) NSInteger RemainingTimeInAppDelegate;
@end

