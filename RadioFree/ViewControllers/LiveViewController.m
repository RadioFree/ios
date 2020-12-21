//
//  LiveViewController.m
//  RadioFree
//
//  Created by vivek on 13/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//

#import "LiveViewController.h"
#import "SampleQueueId.h"


@interface LiveViewController ()<UIGestureRecognizerDelegate>
{
    IBOutlet UILabel *ArtistLblInMainAudioView;
    IBOutlet UIView *hedderView;
    IBOutlet UILabel *seperateLineInMainAudioView;
    IBOutlet UILabel *DurationLblInMainAudioView;
    IBOutlet UILabel *progressLblInMainAudioView;
    IBOutlet UILabel *titleLblInMainAudioView;
    IBOutlet UIButton *playPauseBtnInMainAudioView;
    IBOutlet UIView *MainAudioView;
    BOOL mainAudioViewIsOpen;
    BOOL wasMainAudioViewOpen;
    
    IBOutlet UILabel *NoDataInNavigationMenuLable;
   // NSTimer* timer;
    NSTimer* timer1;
    IBOutlet UILabel *trackNameLable;
    IBOutlet UIButton *play_pauseButton;
    IBOutlet UILabel *albumNameLable;
    IBOutlet UIImageView *albumImageView;
    IBOutlet UIView *ContentView;
    IBOutlet UIView *tabView;
    IBOutlet UIScrollView *ContentScrollview;
    IBOutlet UILabel *lblTabIndicatorLine;
    IBOutlet UIButton *btnNews;
    IBOutlet UIButton *btnLive;
    IBOutlet UIView *menuView;
    IBOutlet UIView *activityIndicatorView;
    UIActivityIndicatorView *activityIndicator;
    BOOL isMenuOpen;
    UIImageView *LoaderImage;
    BOOL isOpenActivityIndicatorView;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *liveStreamDataArray;
@property (nonatomic, strong) NSString *liveStreamingUrlString;
@property (strong, nonatomic) UIBlurEffect *blurEffect;
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;

@property (strong, nonatomic) IBOutlet UICollectionView *MenuCollectionView;
@property (strong, nonatomic) NSMutableArray *NavigationMenuDataArray;

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTimer];
    _NavigationMenuDataArray = [[NSMutableArray alloc] init];
    [_MenuCollectionView registerNib:[UINib nibWithNibName:@"SettingsMenuCell" bundle:nil] forCellWithReuseIdentifier:@"menucell"];
    [self iphone4sSupport];
    
    if (IS_IPHONE_4_OR_LESS) {
        //  ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
        activityIndicatorView.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview),__HEIGHT__(ContentScrollview));
    }
    
    LoaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 100)];
    LoaderImage.center = CGPointMake(__WIDTH__(activityIndicatorView) / 2.0, __HEIGHT__(activityIndicatorView) / 2.0);
    //NSURL *url = [[NSURL alloc] initWithString:@"https://radiofree.org/wp-content/themes/bigfoot/loader.gif"];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loader" withExtension:@"gif"];
    LoaderImage.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    LoaderImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    [activityIndicatorView addSubview:LoaderImage];
    
    MainAudioView.frame = CGRectMake(0, __HEIGHT__(self.view), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
    [self.view addSubview:MainAudioView];
    
    // hide tabbarcontroller
    APPDELEGATE.mainTabBar.tabBar.hidden = YES;
    menuView.frame = CGRectMake(0, __HEIGHT__(self.view), __WIDTH__(self.view), __HEIGHT__(menuView));
    [self.view addSubview:menuView];
    [self addTapGestureInLiveview];
    
    [play_pauseButton setImage:[UIImage imageNamed:@"LivePlayButton"] forState:UIControlStateNormal];
       
    // Content view add in ContentScrollview
    [ContentScrollview addSubview: ContentView];
    ContentScrollview.contentSize = CGSizeMake(__WIDTH__(ContentView), __HEIGHT__(ContentView));
    [self.view addSubview:ContentScrollview];
    [self.view bringSubviewToFront:tabView];
    albumImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)iphone4sSupport{
    if (IS_IPHONE_4_OR_LESS) {
        ContentScrollview.frame = CGRectMake(ContentScrollview.frame.origin.x, ContentScrollview.frame.origin.y, ContentScrollview.frame.size.width, 378);
        // ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
        
        
        
        tabView.frame = CGRectMake(tabView.frame.origin.x,480 -tabView.frame.size.height, tabView.frame.size.width, tabView.frame.size.height);
        [self.view addSubview:tabView];
        NSLog(@"SELF.VIEW :- %f and tabview Y = %f",self.view.frame.size.height,tabView.frame.origin.y);
        
        //tabView.frame = CGRectMake(__X__(tabView),__HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
    }
}

-(void) setupTimer
{
    self.timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void) tick
{
    
    if (APPDELEGATE.AudioViewControllerStatusId == AudioLiveViewControllerStatusId) {
        titleLblInMainAudioView.text = APPDELEGATE.AudioTitleStr;
        ArtistLblInMainAudioView.text = APPDELEGATE.LockScreenArtistStr;
        ArtistLblInMainAudioView.hidden = NO;
        progressLblInMainAudioView.hidden = YES;
        DurationLblInMainAudioView.hidden = YES;
        seperateLineInMainAudioView.hidden = YES;
    }else{
        ArtistLblInMainAudioView.hidden = YES;
        progressLblInMainAudioView.hidden = YES;
        DurationLblInMainAudioView.hidden = NO;
        seperateLineInMainAudioView.hidden = YES;
        titleLblInMainAudioView.text = APPDELEGATE.AudioTitleStr;
       // progressLblInMainAudioView.text = APPDELEGATE.AudioProgressTimeStr;
        DurationLblInMainAudioView.text = APPDELEGATE.AudioMainProgressString;
        
        if (APPDELEGATE.RemainingTimeInAppDelegate == 0) {
            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            APPDELEGATE.RemainingTimeInAppDelegate = 1;
        }
        
        
//        if ([progressLblInMainAudioView.text isEqualToString:DurationLblInMainAudioView.text] && ![progressLblInMainAudioView.text isEqualToString:@"00:00:00"] && ![DurationLblInMainAudioView.text isEqualToString:@"00:00:00"]) {
//            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
//        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[timer1 invalidate];
   // timer1 = nil;
    
    if (wasMainAudioViewOpen == YES) {
        wasMainAudioViewOpen = NO;
    }
    if (mainAudioViewIsOpen == YES) {
        mainAudioViewIsOpen = NO;
        
        [UIView animateWithDuration:0.1 animations:^{
            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            
            if (IS_IPHONE_4_OR_LESS) {
                ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 378);
            }else{
            ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 466);
            }
            MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
            
            tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)- __HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
//    if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
//        [APPDELEGATE.audioPlayer pause];
//         [play_pauseButton setImage:[UIImage imageNamed:@"LivePlayButton.png"] forState:UIControlStateNormal];
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    ////
    
    ////
    
    if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
        if (APPDELEGATE.AudioViewControllerStatusId == AudioLiveViewControllerStatusId) {
            [play_pauseButton setImage:[UIImage imageNamed:@"LivePaushButton.png"] forState:UIControlStateNormal];
        }else{
            [play_pauseButton setImage:[UIImage imageNamed:@"LivePlayButton.png"] forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.1 animations:^{
                mainAudioViewIsOpen = YES;
                [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
                if (IS_IPHONE_4_OR_LESS) {
                    
                    ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 330);
                    MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                
                
                ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 418);
                MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }else{
        
        [play_pauseButton setImage:[UIImage imageNamed:@"LivePlayButton.png"] forState:UIControlStateNormal];
    }
    
    [self initialSettings];
    [self CallInterNetValidationForNaviagationMenu];
    [self callInternetValidationForLiveStreamingPost];
    NSLog(@"Audio Key == %ld",APPDELEGATE.AudioViewControllerStatusId);
    
    
}
-(void)setupTimer2{
    timer1 = [NSTimer timerWithTimeInterval:9.0 target:self selector:@selector(checkAlbumIsChange) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSRunLoopCommonModes];
}
-(void)checkAlbumIsChange{
    
//    NSDictionary *body = @{@"snippet": @{@"topLevelComment":@{@"snippet":@{@"textOriginal":self.commentToPost.text}},@"videoId":self.videoIdPostingOn}};
   
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:LiveStreamingURL]];
    
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [manager GET:LiveStreamingURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
       
        if (APPDELEGATE.AudioViewControllerStatusId == AudioLiveViewControllerStatusId) {
            if ([APPDELEGATE.AudioTitleStr isEqualToString:[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"album"]]]) {
                
            }else{
                APPDELEGATE.AudioTitleStr = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"album"]];
                
            }
        }
        
        NSMutableArray *temp = [self.liveStreamDataArray mutableCopy];
        [temp removeAllObjects];
        self.liveStreamDataArray = [temp mutableCopy];
        self.liveStreamDataArray = [responseObject mutableCopy];
        
        NSString *compareString = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"album"]];
        
        if ([albumNameLable.text isEqualToString:compareString] && [trackNameLable.text isEqualToString:[responseObject valueForKey:@"track"]]) {
            
        }else{
            
            APPDELEGATE.LockScreenAlbumStr = [NSString stringWithFormat:@"%@",[_liveStreamDataArray valueForKey:@"album"]];
            APPDELEGATE.LockScreenArtistStr = [_liveStreamDataArray valueForKey:@"track"];
            APPDELEGATE.LockScreenArtworkImageUrlStr = [_liveStreamDataArray  valueForKey:@"artwork"];
            
            albumNameLable.text = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"album"]];
            trackNameLable.text = [responseObject valueForKey:@"track"];
            
            _liveStreamingUrlString = [responseObject valueForKey:@"url"];
            
            NSString*  ImageURL = [responseObject  valueForKey:@"artwork"];
            if ([ImageURL isEqualToString:@""]) {
                albumImageView.image=[UIImage imageNamed:@"imagePlaceHolder"];
            }else
            {
                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                [indicator startAnimating];
                indicator.center                   = CGPointMake(albumImageView.frame.size.width / 2.0, albumImageView.frame.size.height / 2.0);
                [albumImageView addSubview:indicator];
                
                [albumImageView sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@", ImageURL] stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    [indicator removeFromSuperview];
                }];
                
            }
            
            
        }
        NSLog(@"RESPONSE = %@",responseObject);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

   
    
    
//    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//
//        if (!error) {
//            NSLog(@"Reply JSON: %@", responseObject);
//            NSMutableArray *temp = [self.liveStreamDataArray mutableCopy];
//            [temp removeAllObjects];
//            self.liveStreamDataArray = [temp mutableCopy];
//            self.liveStreamDataArray = [responseObject mutableCopy];
//
//            NSString *compareString = [NSString stringWithFormat:@"Radio Free: Artist - %@",[responseObject valueForKey:@"album"]];
//
//                    if ([albumNameLable.text isEqualToString:compareString] && [trackNameLable.text isEqualToString:[responseObject valueForKey:@"track"]]) {
//
//                    }else{
//
//                        albumNameLable.text = [NSString stringWithFormat:@"Radio Free: Artist - %@",[responseObject valueForKey:@"album"]];
//                        trackNameLable.text = [responseObject valueForKey:@"track"];
//
//                        _liveStreamingUrlString = [responseObject valueForKey:@"url"];
//
//                        NSString*  ImageURL = [responseObject  valueForKey:@"artwork"];
//                        if ([ImageURL isEqualToString:@""]) {
//                            albumImageView.image=[UIImage imageNamed:@"imagePlaceHolder"];
//                        }else
//                        {
//                            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//                            [indicator startAnimating];
//                            indicator.center                   = CGPointMake(albumImageView.frame.size.width / 2.0, albumImageView.frame.size.height / 2.0);
//                            [albumImageView addSubview:indicator];
//
//                            [albumImageView sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@", ImageURL] stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//                                [indicator removeFromSuperview];
//                            }];
//
//                        }
//
//
//                    }
//                    NSLog(@"RESPONSE = %@",responseObject);
//
//
//        } else {
//            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
//        }
//    }] resume];
    
    
//    NSURL *url = [NSURL URLWithString:LiveStreamingURL];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
//  //  manager.responseSerializer = [AFJSONResponseSerializer serializer];
//   // [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
//   // manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *compareString = [NSString stringWithFormat:@"Radio Free: Artist - %@",[responseObject valueForKey:@"album"]];
//
//        if ([albumNameLable.text isEqualToString:compareString] && [trackNameLable.text isEqualToString:[responseObject valueForKey:@"track"]]) {
//
//        }else{
//
//            albumNameLable.text = [NSString stringWithFormat:@"Radio Free: Artist - %@",[responseObject valueForKey:@"album"]];
//            trackNameLable.text = [responseObject valueForKey:@"track"];
//
//            _liveStreamingUrlString = [responseObject valueForKey:@"url"];
//
//            NSString*  ImageURL = [responseObject  valueForKey:@"artwork"];
//            if ([ImageURL isEqualToString:@""]) {
//                albumImageView.image=[UIImage imageNamed:@"imagePlaceHolder"];
//            }else
//            {
//                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//                [indicator startAnimating];
//                indicator.center                   = CGPointMake(albumImageView.frame.size.width / 2.0, albumImageView.frame.size.height / 2.0);
//                [albumImageView addSubview:indicator];
//
//                [albumImageView sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@", ImageURL] stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//                    [indicator removeFromSuperview];
//                }];
//
//            }
//
//
//        }
//        NSLog(@"RESPONSE = %@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"ERROR = %@",error);
//    }];
    
    
//    [manager POST:[NSString stringWithFormat:@"%@",LiveStreamingURL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
    
    
//    [manager GET:[NSString stringWithFormat:@"%@",LiveStreamingURL] parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
//
//        NSString *compareString = [NSString stringWithFormat:@"Radio Free: Artist - %@",[responseObject valueForKey:@"album"]];
//
//        if ([albumNameLable.text isEqualToString:compareString] && [trackNameLable.text isEqualToString:[responseObject valueForKey:@"track"]]) {
//
//        }else{
//
//            albumNameLable.text = [NSString stringWithFormat:@"Radio Free: Artist - %@",[responseObject valueForKey:@"album"]];
//            trackNameLable.text = [responseObject valueForKey:@"track"];
//
//            _liveStreamingUrlString = [responseObject valueForKey:@"url"];
//
//            NSString*  ImageURL = [responseObject  valueForKey:@"artwork"];
//            if ([ImageURL isEqualToString:@""]) {
//                albumImageView.image=[UIImage imageNamed:@"imagePlaceHolder"];
//            }else
//            {
//                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//                [indicator startAnimating];
//                indicator.center                   = CGPointMake(albumImageView.frame.size.width / 2.0, albumImageView.frame.size.height / 2.0);
//                [albumImageView addSubview:indicator];
//
//                [albumImageView sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@", ImageURL] stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//                    [indicator removeFromSuperview];
//                }];
//
//            }
//
//
//        }
//        NSLog(@"RESPONSE = %@",responseObject);
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"ERROR = %@",error);
//    }];

    
}

-(void)enableActivityIndicator{
    isOpenActivityIndicatorView = YES;
    
    if (IS_IPHONE_4_OR_LESS) {
        //  ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
        activityIndicatorView.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), __HEIGHT__(ContentScrollview));
    }else{
    
    activityIndicatorView.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview),__WIDTH__(ContentScrollview) , __HEIGHT__(ContentScrollview));
    }
//    activityIndicator = [[UIActivityIndicatorView alloc]init];
//    activityIndicator.center  = CGPointMake(__WIDTH__(activityIndicatorView) / 2.0, __HEIGHT__(activityIndicatorView) / 2.0);
//    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    //[activityindicator1 setColor:[UIColor orangeColor]];
//    [activityIndicatorView addSubview:activityIndicator];
//    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicatorView];
    [self.view bringSubviewToFront:tabView];
}
-(void)disableActivityIndicator{
    isOpenActivityIndicatorView = NO;
    //[activityIndicator stopAnimating];
    [activityIndicatorView removeFromSuperview];
}
#pragma mark - WebServices Methods

-(void)CallInterNetValidationForNaviagationMenu{
    if([Utility CheckForInternet]){
        
        [self callWebServerForNaviagationMenuData];
        
    }
    else{
        _MenuCollectionView.hidden = YES;
        NoDataInNavigationMenuLable.hidden = NO;
    }
}
-(void)callWebServerForNaviagationMenuData{
    
    NSString *MainURL = [NSString stringWithFormat:@"%@",MenuURL];
    
    SyncManager *syncmanager = [[SyncManager alloc] init];
    syncmanager.delegate = self;
    
    [syncmanager webServiceCall:MainURL withParams:@{} withTag:NavigationMenuTag];
}


-(void)callInternetValidationForLiveStreamingPost{
    
    if([Utility CheckForInternet]){
        [self enableActivityIndicator];
        [self callWebServicesForLiveStreamingPost];
        
    }
    else{
        
        showAlert(@"Check Connection", @"Internet is not available.");
    }
}
-(void)callWebServicesForLiveStreamingPost{
    
    NSString *MainURL = [NSString stringWithFormat:@"%@",LiveStreamingURL];
    
    SyncManager *syncmanager = [[SyncManager alloc] init];
    syncmanager.delegate = self;
    
    [syncmanager webServiceCall:MainURL withParams:@{} withTag:LiveStreamingTag];
    
}
-(void)syncSuccess:(id)responseObject withTag:(NSInteger)tag{
    
    if (tag == LiveStreamingTag) {
        self.liveStreamDataArray = [responseObject mutableCopy];
        if (isOpenActivityIndicatorView == YES) {
            [self disableActivityIndicator];
        }
        albumNameLable.text = [NSString stringWithFormat:@"%@",[_liveStreamDataArray valueForKey:@"album"]];
        trackNameLable.text = [_liveStreamDataArray valueForKey:@"track"];
        
        _liveStreamingUrlString = [_liveStreamDataArray valueForKey:@"url"];
        
        NSString*  ImageURL = [_liveStreamDataArray  valueForKey:@"artwork"];
        
        APPDELEGATE.LockScreenAlbumStr = [NSString stringWithFormat:@"%@",[_liveStreamDataArray valueForKey:@"album"]];
        APPDELEGATE.LockScreenArtistStr = [_liveStreamDataArray valueForKey:@"track"];
        APPDELEGATE.LockScreenArtworkImageUrlStr = [_liveStreamDataArray  valueForKey:@"artwork"];
        
        if ([ImageURL isEqualToString:@""]) {
            albumImageView.image=[UIImage imageNamed:@"imagePlaceHolder"];
        }else
        {
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [indicator startAnimating];
            indicator.center                   = CGPointMake(albumImageView.frame.size.width / 2.0, albumImageView.frame.size.height / 2.0);
            [albumImageView addSubview:indicator];
            
            [albumImageView sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@", ImageURL] stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [indicator removeFromSuperview];
            }];
            
        }

        [self setupTimer2];
        NSLog(@"Detail == >> %@",self.liveStreamDataArray);
        
    }
    
    if (tag == NavigationMenuTag) {
        
        NoDataInNavigationMenuLable.hidden = YES;
        _MenuCollectionView.hidden = NO;
        
        NSArray *result = [responseObject mutableCopy];
        NSLog(@"COmplete = %@",result);
        self.NavigationMenuDataArray = [[result valueForKey:@"app-navigation"] valueForKey:@"items"];
        [_MenuCollectionView reloadData];
    }
    
}
-(void)syncFailure:(NSError*)error withTag:(NSInteger)tag{
    
    if (tag == LiveStreamingTag) {
        if (isOpenActivityIndicatorView == YES) {
            [self disableActivityIndicator];
        }
        showAlert(@"Error", @"We are unable to connect to our servers.\rPlease check your connection.");
        
        NSLog(@"Error == >> %@",error);
    }
    
    if (tag == NavigationMenuTag) {
        
        NoDataInNavigationMenuLable.hidden = NO;
        _MenuCollectionView.hidden = YES;
    }
    
}


#pragma mark - Others Methods
//-(void)loadAudioPlayer:(STKAudioPlayer *)audioPlayerIn{
//    
//        self.audioPlayer = audioPlayerIn;
//}
-(void)initialSettings{
    
    //tabbar ma indicator line che aene jyare pan view load thay tyare ana news button vada location par set kari che.
    lblTabIndicatorLine.frame = CGRectMake(__X__(btnLive), __Y__(lblTabIndicatorLine), __WIDTH__(lblTabIndicatorLine), __HEIGHT__(lblTabIndicatorLine));
    
    
}

-(void)animationForTabBarIndicatorLineX:(CGFloat)X withTabViewcontrollersIndex:(NSInteger)index{
    
    [UIView animateWithDuration:0.3 animations:^{
        lblTabIndicatorLine.frame = CGRectMake(X, __Y__(lblTabIndicatorLine),__WIDTH__(lblTabIndicatorLine),__HEIGHT__(lblTabIndicatorLine));
    } completion:^(BOOL finished) {
        //condition ma darek potana view ni index set karvani
        //example ke aa news view che to aeni index 0 che ane jo aa live view hot to ahiya 1 set karavano jethi kari ne tabbar load na thay.
        if (index != 1) {
            
            APPDELEGATE.mainTabBar.selectedIndex = index;
            
            
           
            
            
//            NSInteger controllerIndex = index;
//            UIView * fromView = APPDELEGATE.mainTabBar.selectedViewController.view;
//            UIView * toView = [[APPDELEGATE.mainTabBar.viewControllers objectAtIndex:controllerIndex] view];
//
//            // Transition using a page curl.
//            [UIView transitionFromView:fromView
//                                toView:toView
//                              duration:0.5
//                               options:(controllerIndex > APPDELEGATE.mainTabBar.selectedIndex ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft)
//                            completion:^(BOOL finished) {
//                                if (finished) {
//                                    APPDELEGATE.mainTabBar.selectedIndex = controllerIndex;
//                                }
//                            }];
            
        }
        
    }];
    
}
#pragma mark - MenuSettings Methods
// Menu open karva mate aa method no used thay che.
-(void)OpenMenu{
    
    _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:_blurEffect];
    //always fill the view
    _blurEffectView.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview),__WIDTH__(ContentScrollview), __HEIGHT__(ContentScrollview));
    _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_blurEffectView];
    [self.view bringSubviewToFront:tabView];
    [UIView animateWithDuration:0.1 animations:^{
        
        tabView.frame = CGRectMake(__X__(tabView),__HEIGHT__(self.view)-__HEIGHT__(menuView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
        
        menuView.frame = CGRectMake(__X__(menuView),__HEIGHT__(self.view) - __HEIGHT__(menuView), __WIDTH__(menuView), __HEIGHT__(menuView));
        
        [self.view bringSubviewToFront:menuView];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}
// Menu close karva mate aa method no used thay che.
-(void)CloseMenu{
    
    [_blurEffectView removeFromSuperview];
    
    [UIView animateWithDuration:0.1 animations:^{
        
        tabView.frame = CGRectMake(__X__(tabView),__HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
        
        menuView.frame = CGRectMake(__X__(menuView),__HEIGHT__(self.view), __WIDTH__(menuView),__HEIGHT__(menuView));
        
        [self.view bringSubviewToFront:menuView];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}
#pragma mark - TapGesture Methods

-(void)addTapGestureInLiveview{
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NewsBackgroundTap:)];
    tapRecognizer.delegate=self;
    tapRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapRecognizer];
}

-(IBAction)NewsBackgroundTap:(UITapGestureRecognizer*)sender{
    if (isMenuOpen) {
        isMenuOpen = NO;
        [self CloseMenu];
        
        if (wasMainAudioViewOpen == YES) {
            wasMainAudioViewOpen = NO;
            mainAudioViewIsOpen = YES;
            
            [UIView animateWithDuration:0.1 animations:^{
                
                
                if (IS_IPHONE_4_OR_LESS) {
                    
                    ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 330);
                    MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 418);
                MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
    }
}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (CGRectContainsPoint(menuView.bounds, [touch locationInView:menuView]))
        return NO;
    if (CGRectContainsPoint(tabView.bounds, [touch locationInView:tabView]))
        return NO;
    
    return YES;
}


#pragma mark - IBAction Methods
- (IBAction)didActionToplayPauseBtnInMainAudioView:(UIButton *)sender {
    
    NSData *image1 = UIImagePNGRepresentation([UIImage imageNamed:@"play_player"]);
    
    if ([image1 isEqual:UIImagePNGRepresentation(sender.currentImage)]) {
        if ([Utility CheckForInternet]) {
            
            
           
            
            
            
        [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
        //[APPDELEGATE.audioPlayer resume];
                NSURL *url = [NSURL URLWithString:APPDELEGATE.AudioURLStr];
        
                STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
        
                [APPDELEGATE.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
    }else{
        showAlert(@"Check Connection", @"Internet is not available.");
    }
    }else{
        mainAudioViewIsOpen = NO;
        [UIView animateWithDuration:0.1 animations:^{
            
            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            
            
            if (IS_IPHONE_4_OR_LESS) {
                ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 378);
            }else{
            ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 466);
            }
//            if (contentView.frame.size.height<=_ContentScrollview.frame.size.height) {
//                contentView.frame = CGRectMake(__X__(contentView), __Y__(contentView), __WIDTH__(contentView), __HEIGHT__(_ContentScrollview));
//            }
            // [self.view bringSubviewToFront:hedderView];
            MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
            tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            
        } completion:^(BOOL finished) {
            [APPDELEGATE.audioPlayer pause];
        }];
    }
    
}
- (IBAction)didActionToShakeArtImage:(id)sender {
    
    [albumImageView shake:60 withDelta:30 speed:0.30 shakeDirection:ShakeDirectionRotation completion:^{
        
    }];
    
}


- (IBAction)didActionToPlayPauseButton:(id)sender {
    
    if([Utility CheckForInternet]){
        
        UIImage *data1 = play_pauseButton.currentImage;
        NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"LivePlayButton.png"]);
        
        if ([data2 isEqual:UIImagePNGRepresentation(data1)]) {
            
            if ([_liveStreamingUrlString isEqualToString:@""]) {
                showAlert(@"Error", @"We are unable to connect to our servers.\rPlease check your connection.");
            }else{
                [play_pauseButton setImage:[UIImage imageNamed:@"LivePaushButton.png"] forState:UIControlStateNormal];
                APPDELEGATE.AudioViewControllerStatusId = AudioLiveViewControllerStatusId;
                
               // if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
                    
                    
                    
                //}
                
                
                APPDELEGATE.AudioTitleStr = [NSString stringWithFormat:@"%@",[_liveStreamDataArray valueForKey:@"album"]];
                APPDELEGATE.AudioURLStr = [NSString stringWithFormat:@"%@",_liveStreamingUrlString];
                NSURL* url = [NSURL URLWithString:APPDELEGATE.AudioURLStr];//
                
                STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
                
                [APPDELEGATE.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
                
                mainAudioViewIsOpen = NO;
                [UIView animateWithDuration:0.1 animations:^{
                    
                    [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
                    if (IS_IPHONE_4_OR_LESS) {
                        ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 378);
                    }else{
                    ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 466);
                    }
                    MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                    
                } completion:^(BOOL finished) {
                    
                }];
                
            }
            
        }else{
            [play_pauseButton setImage:[UIImage imageNamed:@"LivePlayButton.png"] forState:UIControlStateNormal];
            if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering)
            {
                [APPDELEGATE.audioPlayer pause];
            }
        }
        
    }
    else{
        
        showAlert(@"Check Connection", @"Internet is not available.");
    }
   
}
-(void)didNotifyToPlayButton{
    [play_pauseButton setImage:[UIImage imageNamed:@"LivePlayButton.png"] forState:UIControlStateNormal];
}
//- (IBAction)didActionToMenuInnerButtons:(UIButton *)sender {
//    
//    if (isMenuOpen) {
//        isMenuOpen = NO;
//        [self CloseMenu];
//    }
//    MenuContentViewController *menuViewObj = [[MenuContentViewController alloc] init];
//    
//    switch (sender.tag) {
//        case MenuItemNewsTag:{
//            [menuViewObj menuItemKey:MenuItemNewsTag];
//            APPDELEGATE.mainTabBar.selectedIndex = 5;
//            break;
//        }
//        case MenuItemAboutTag:{
//            [menuViewObj menuItemKey:MenuItemAboutTag];
//            APPDELEGATE.mainTabBar.selectedIndex = 5;
//            break;
//        }
//        case MenuItemPressKitTag:{
//            [menuViewObj menuItemKey:MenuItemPressKitTag];
//            APPDELEGATE.mainTabBar.selectedIndex = 5;
//            break;
//        }
//        case MenuItemSupportTag:{
//            [menuViewObj menuItemKey:MenuItemSupportTag];
//            APPDELEGATE.mainTabBar.selectedIndex = 5;
//            break;
//        }
//        case MenuItemContactTag:{
//            [menuViewObj menuItemKey:MenuItemContactTag];
//            APPDELEGATE.mainTabBar.selectedIndex = 5;
//            break;
//        }
//        case MenuItemListenTag:{
//            [menuViewObj menuItemKey:MenuItemListenTag];
//            APPDELEGATE.mainTabBar.selectedIndex = 5;
//            break;
//        }
//        case MenuItemJobInternshipTag:{
//            [menuViewObj menuItemKey:MenuItemJobInternshipTag];
//            APPDELEGATE.mainTabBar.selectedIndex = 5;
//            break;
//        }
//        case MenuItemFriendsOfRadioFreeTag:{
//            [menuViewObj menuItemKey:MenuItemFriendsOfRadioFreeTag];
//            APPDELEGATE.mainTabBar.selectedIndex = 5;
//            break;
//        }
//        case MenuItemLanguagesTag:{
//            [menuViewObj menuItemKey:MenuItemLanguagesTag];
//            APPDELEGATE.mainTabBar.selectedIndex = 5;
//            break;
//        }
//        case MenuItemTwitterTag:{
//            [menuViewObj menuItemKey:MenuItemTwitterTag];
//            APPDELEGATE.mainTabBar.selectedIndex = 5;
//            break;
//        }
//        default:
//            break;
//    }
//    
//}

- (IBAction)didActionToMenuButton:(id)sender {
    
    if (isMenuOpen) {
        isMenuOpen = NO;
        [self CloseMenu];
        
        if (wasMainAudioViewOpen == YES) {
            wasMainAudioViewOpen = NO;
            mainAudioViewIsOpen = YES;
            
            [UIView animateWithDuration:0.1 animations:^{
                
                if (IS_IPHONE_4_OR_LESS) {
                    
                    ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 330);
                    MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 418);
                MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
        
        
    }else{
        if([Utility CheckForInternet]){
            if (mainAudioViewIsOpen == YES) {
                wasMainAudioViewOpen = YES;
                mainAudioViewIsOpen = NO;
                [UIView animateWithDuration:0.1 animations:^{
                    if (IS_IPHONE_4_OR_LESS) {
                        ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 378);
                    }else{
                    ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 466);
                    }
                    [self.view bringSubviewToFront:hedderView];
                    MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            isMenuOpen = YES;
            [self OpenMenu];
        }
        else{
            showAlert(@"Check Connection", @"Internet is not available.");
        }
    }
}

- (IBAction)didActionToNewsButton:(id)sender {
    if (isMenuOpen) {
        isMenuOpen = NO;
        [self CloseMenu];
    }
    [self animationForTabBarIndicatorLineX:__X__(btnNews) withTabViewcontrollersIndex:0];
}

- (IBAction)didActionToLiveButton:(id)sender {
    if (isMenuOpen) {
        isMenuOpen = NO;
        [self CloseMenu];
    }
    
}

- (IBAction)didActionToBookMarkButtonInMenu:(id)sender {
    if (isMenuOpen) {
        isMenuOpen = NO;
        [self CloseMenu];
    }
    APPDELEGATE.mainTabBar.selectedIndex = 4;
}

- (IBAction)didActionToSettingsButtonInMenu:(id)sender {
    if (isMenuOpen) {
        isMenuOpen = NO;
        [self CloseMenu];
    }
    
    APPDELEGATE.mainTabBar.selectedIndex = 3;
}

#pragma Mark - CollectionView Delegate Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _NavigationMenuDataArray.count;
    //   return _MainDataArr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    SettingsMenuCell *cell = (SettingsMenuCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"menucell" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsMenuCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.MenuTitle.text = [[self.NavigationMenuDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
    // cell.imagePortfolio.image=[UIImage imageNamed:[imagedata objectAtIndex:indexPath.row]];
    //   cell.nameofcontent.text=[[_MainDataArr objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    return cell;
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isMenuOpen) {
        isMenuOpen = NO;
        [self CloseMenu];
    }
    MenuContentViewController *settingsSubview = [[MenuContentViewController alloc] init];
    [settingsSubview getPostTypeValueForSettings:[[_NavigationMenuDataArray objectAtIndex:indexPath.row] objectAtIndex:4]];
    [settingsSubview getPostTypeValueURL:[[_NavigationMenuDataArray objectAtIndex:indexPath.row] objectAtIndex:2]];
    APPDELEGATE.mainTabBar.selectedIndex = 5;
    
    
    
}

@end
