//
//  Keys.h
//  RadioFree
//
//  Created by vivek on 14/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//

#ifndef Keys_h
#define Keys_h


static NSString *const StandardPostType = @"standard"; //Standard post type
static NSString *const VideoPostType    = @"video"; // video post type
static NSString *const AudioPostType    = @"audio"; // audio post type

static NSString *const IdentifierForBKStandardCell  = @"BKstandard";//standard cell identifier
static NSString *const IdentifierForBKAudioCell     = @"BKaudio";// audio cell identifier
static NSString *const IdentifierForBKVideoCell     = @"BKvideo";// video cell identifier


static NSString *const IdentifierForStandardCell    = @"standard";//standard cell identifier
static NSString *const IdentifierForAudioCell       = @"audio";// audio cell identifier
static NSString *const IdentifierForVideoCell       = @"video";// video cell identifier
static NSString *const RadioFreePageURL = @"https://radiofree.org/wp-json/wp/v2/pages/";
// Menu content URL

static NSString *const MenuItemNewsURL      = @"https://radiofree.org/";
static NSString *const MenuItemAboutURL     = @"https://radiofree.org/about/";
static NSString *const MenuItemPressKitURL  = @"https://radiofree.org/about/press-kit/";
static NSString *const MenuItemSupportURL        = @"https://radiofree.org/support/";
static NSString *const MenuItemContactURL        = @"https://radiofree.org/contact/";
static NSString *const MenuItemListenURL         = @"https://radiofree.org/listen/";
static NSString *const MenuItemJobInternshipURL  = @"https://radiofree.org/jobs-and-internships/";
static NSString *const MenuItemFriendsOfRadioFreeURL = @"https://radiofree.org/about/friends/";
static NSString *const MenuItemLanguagesURL = @"https://radiofree.org/about/languages/";
static NSString *const MenuItemTwitterURL   = @"http://twitter.com/radiofreeorg";

static NSString *const PostUrlString        = @"https://radiofree.org//wp-json/wp/v2/posts?"; // News post url

static NSString *const YouTubeVideoURL      = @"https://radiofree.org/wp-json/wp/v2/video_url/";

static NSString *const DetailPostURL        = @"https://radiofree.org//wp-json/wp/v2/posts/";

static NSString *const TitleFontName            = @"SourceSansPro-Bold";
static NSString *const DescriptionFontName      = @"SourceSansPro-Light";
static NSString *const RegularFont = @"SourceSansPro-Regular";

static NSString *const GetContentFromAPI        = @"rendered";
static NSString *const GetDiscriptionFromAPI    = @"excerpt";

static NSString *const LiveStreamingURL = @"https://radiofree.org/wp-json/wp/v2/album_art";

static NSString *const TermsOfUseURL = @"https://radiofree.org/terms-of-use";

static NSString *const MenuURL = @"https://radiofree.org/wp-json/wp/v2/menus";

static NSString *const AuthorKey = @"postauthor";

//Some tags for API
static const NSInteger NewsPostTag                      = 1001; // News post tag
static const NSInteger YouTubeVideoTag                  = 1002;
static const NSInteger DetailNewsPostTag                = 1003;
static const NSInteger LiveStreamingTag                 = 1004;

static const NSInteger MenuItemNewsTag                  = 3001;
static const NSInteger MenuItemAboutTag                 = 3002;
static const NSInteger MenuItemPressKitTag              = 3003;
static const NSInteger MenuItemSupportTag               = 3004;
static const NSInteger MenuItemContactTag               = 3005;
static const NSInteger MenuItemListenTag                = 3006;
static const NSInteger MenuItemJobInternshipTag         = 3007;
static const NSInteger MenuItemFriendsOfRadioFreeTag    = 3008;
static const NSInteger MenuItemLanguagesTag             = 3009;
static const NSInteger MenuItemTwitterTag               = 3010;

static const NSInteger SettingsTermsOfUse               = 4001;

static const NSInteger AudioNewsViewcontrollerStatusId = 5001;
static const NSInteger AudioNewsDetailViewControllerStatusId = 5002;
static const NSInteger AudioBookMarkViewControllerStatusId = 5003;
static const NSInteger AudioBookMarkDetailViewControllerStatusId = 5004;
static const NSInteger AudioLiveViewControllerStatusId = 5005;

static const NSInteger MenuTag = 6001;
static const NSInteger NavigationMenuTag = 101;

static NSString *const ErrorInternetConnectionTitle     = @"Check Connection";
static NSString *const ErrorInternetConnectionMessage   = @"Internet is not available.";


#endif /* Keys_h */
