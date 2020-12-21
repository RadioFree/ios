//
//  DetailViewController.m
//  RadioFree
//
//  Created by vivek on 13/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//

#import "DetailViewController.h"
#import "YTPlayerView.h"

@interface DetailViewController ()<UIGestureRecognizerDelegate,UIWebViewDelegate>

{
    IBOutlet UILabel *ArtistLblInMainAudioView;
    IBOutlet UILabel *seperateLineInMainAudioView;
    IBOutlet UILabel *DurationLblInMainAudioView;
    IBOutlet UILabel *progressLblInMainAudioView;
    IBOutlet UILabel *titleLblInMainAudioView;
    IBOutlet UIButton *playPauseBtnInMainAudioView;
    IBOutlet UIView *MainAudioView;
    BOOL mainAudioViewIsOpen;
    BOOL wasMainAudioViewOpen;
    
    IBOutlet UIImageView *dataIsNotAvailableLable;
    IBOutlet UILabel *NoDataInNavigationMenuLable;
    IBOutlet UILabel *durationTimeLbl;
    IBOutlet UILabel *progressTimeLbl;
    IBOutlet UIButton *PlayPauseAudioBtn;
    IBOutlet UIButton *shareButton;
   // IBOutlet UILabel *dataIsNotAvailableLable;
    IBOutlet UIButton *bookMarkButton;
    IBOutlet UIWebView *contentWebview;
    IBOutlet UIView *audioView;
    BOOL isFirstTimePlaying;
    IBOutlet YTPlayerView *videoView;
    
    IBOutlet UIView *hedderContentView;
    IBOutlet UILabel *dateLable;
    IBOutlet UILabel *titleLable;
    
    IBOutlet UIView *contentView;
    IBOutlet UIView *activityIndicatorView;
    IBOutlet UIScrollView *ContentScrollview;
    IBOutlet UIView *headderView;
    IBOutlet UIView *tabView;
    
    IBOutlet UILabel *lblTabIndicatorLine;
    IBOutlet UIButton *btnNews;
    IBOutlet UIButton *btnLive;
    IBOutlet UIView *menuView;
    BOOL isMenuOpen;
    UIActivityIndicatorView *activityIndicator;
    CGFloat webviewHeight;
    UIImageView *LoaderImage;
    BOOL isOpenActivityIndicatorView;
}
@property (nonatomic, strong) DBManager *dbManager;
@property (strong, nonatomic) UIBlurEffect *blurEffect;
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;
@property (strong, nonatomic) NSMutableArray *NewsPostDataArray;

@property (strong, nonatomic) IBOutlet UICollectionView *MenuCollectionView;
@property (strong, nonatomic) NSMutableArray *NavigationMenuDataArray;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _NavigationMenuDataArray = [[NSMutableArray alloc] init];
    [_MenuCollectionView registerNib:[UINib nibWithNibName:@"SettingsMenuCell" bundle:nil] forCellWithReuseIdentifier:@"menucell"];
    [self iphone4sSupport];
    [self setupTimer];
    self.NewsPostDataArray = [[NSMutableArray alloc] init];
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
    
    // menuview ni frame set kari ane self.view ma add karyo
    menuView.frame = CGRectMake(0, __HEIGHT__(self.view), __WIDTH__(self.view), __HEIGHT__(menuView));
    [self.view addSubview:menuView];
   
    [self.view addSubview:ContentScrollview];
    [self.view bringSubviewToFront:tabView];
    [self addTapGestureInDetailsview];

}

-(void)iphone4sSupport{
    if (IS_IPHONE_4_OR_LESS) {
        ContentScrollview.frame = CGRectMake(ContentScrollview.frame.origin.x, ContentScrollview.frame.origin.y, ContentScrollview.frame.size.width, 377);
       // ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
        
        
        
        tabView.frame = CGRectMake(tabView.frame.origin.x,480 -tabView.frame.size.height, tabView.frame.size.width, tabView.frame.size.height);
         [self.view addSubview:tabView];
        NSLog(@"SELF.VIEW :- %f and tabview Y = %f",self.view.frame.size.height,tabView.frame.origin.y);
        
        //tabView.frame = CGRectMake(__X__(tabView),__HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self initialSettings];
    if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying  || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
        
        
        [UIView animateWithDuration:0.1 animations:^{
            mainAudioViewIsOpen = YES;
            
            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
            
            if (IS_IPHONE_4_OR_LESS) {
                
                ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 329);
                MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            }else{
            
            ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 417);
            MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
            tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            }
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    
    
    [self CallInterNetValidationForNaviagationMenu];
    //TO DO 26
   // isFirstTimePlaying = YES;
   // progressTimeLbl.text = @"00:00:00";
   // durationTimeLbl.text = @"00:00:00";
    
    self.stringPostId = APPDELEGATE.StringNewsPostId;
    self.stringPostFormat = APPDELEGATE.StringNewsPostFormat;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"radiofree.sqlite"];
     [bookMarkButton setImage:[UIImage imageNamed:@"bookmark"] forState:UIControlStateNormal];
    [self callInternetValidationForNewsPost];
    
    
     NSLog(@"\n\n--------------\n\n postid = %@ \n post Format = %@ \n\n---------------",self.stringPostId,self.stringPostFormat);
    
    NSLog(@"Audio Key == %ld",APPDELEGATE.AudioViewControllerStatusId);
    //TO DO 26
   // if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
    //    if (APPDELEGATE.AudioViewControllerStatusId == AudioNewsDetailViewControllerStatusId) {
    //        [PlayPauseAudioBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
     //   }else{
      //       [PlayPauseAudioBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
      //  }
        
   // }else{
    //    [PlayPauseAudioBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
   // }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [contentView removeFromSuperview];
    if (videoView) {
        [videoView removeWebView];
    }
    [contentWebview loadHTMLString:@"" baseURL:nil];
    
    if (wasMainAudioViewOpen == YES) {
        wasMainAudioViewOpen = NO;
    }
    if (mainAudioViewIsOpen == YES) {
        mainAudioViewIsOpen = NO;
        
        [UIView animateWithDuration:0.1 animations:^{
            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            if (IS_IPHONE_4_OR_LESS) {
                ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
            }else{
                ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 465);
            }
            
            MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
            
            tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)- __HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
//    if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
//        [APPDELEGATE.audioPlayer pause];
//        [PlayPauseAudioBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//        // [PlayPauseBtnMainAudioview setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//    }
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

-(void)loadYouTubeVideo:(NSString *)postid loadyoutubeview:(void(^)(NSString *videoID))completion{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager GET:[NSString stringWithFormat:@"%@%@",YouTubeVideoURL,postid] parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"RESPONSE = %@",responseObject);
        NSArray *strarr = [responseObject componentsSeparatedByString:@"v="];
        NSString *finalId = strarr[1];
        completion(finalId);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"ERROR = %@",error);
    }];
}
-(void)callInternetValidationForNewsPost{
    
    if([Utility CheckForInternet]){
        [self enableActivityIndicator];
        [self callWebServicesForNewsPost];
        dataIsNotAvailableLable.hidden = YES;
        ContentScrollview.hidden = NO;
        [self.view setBackgroundColor:UIColorFromRGB(255, 220, 1)];
        bookMarkButton.hidden = NO;
        shareButton.hidden = NO;
    }
    else{
        dataIsNotAvailableLable.hidden = NO;
        ContentScrollview.hidden = YES;
        bookMarkButton.hidden = YES;
        shareButton.hidden = YES;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        showAlert(@"Check Connection", @"Internet is not available.");
    }
}
-(void)callWebServicesForNewsPost{
    
    NSString *MainURL = [NSString stringWithFormat:@"%@%@",DetailPostURL,APPDELEGATE.StringNewsPostId];
    
    SyncManager *syncmanager = [[SyncManager alloc] init];
    syncmanager.delegate = self;
    
    [syncmanager webServiceCall:MainURL withParams:@{} withTag:DetailNewsPostTag];

}
-(void)syncSuccess:(id)responseObject withTag:(NSInteger)tag{
    
    if (tag == DetailNewsPostTag) {
        self.NewsPostDataArray = [responseObject mutableCopy];
        if (isOpenActivityIndicatorView == YES) {
            [self disableActivityIndicator];
        }
        
        [self initialSettingsForContentFormat:[self.NewsPostDataArray valueForKey:@"format"]];
        NSLog(@"Detail == >> %@",self.NewsPostDataArray);
        
        NSString *postId = [NSString stringWithFormat:@"%@",[self.NewsPostDataArray valueForKey:@"id"]];
        NSString *data = [NSString stringWithFormat:@"select * from radiotbl"];
        NSArray *BookMarkData = [self.dbManager loadDataFromDB:data];
       
       
        
        
        for (int i=0; i<BookMarkData.count; i++) {
            
            NSInteger indexOfpostId = [self.dbManager.arrColumnNames indexOfObject:@"id"];
            NSString *str_id = [NSString stringWithFormat:@"%@", [[BookMarkData objectAtIndex:i] objectAtIndex:indexOfpostId]];
            if ([str_id isEqualToString:postId]) {
                 [bookMarkButton setImage:[UIImage imageNamed:@"bookmarkBlack"] forState:UIControlStateNormal];
                break;
            }
        }
        
        
        
        NSLog(@"BookMark Array == %@",BookMarkData);
        
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
    
    if (tag == DetailNewsPostTag) {
        if (isOpenActivityIndicatorView == YES) {
            [self disableActivityIndicator];
        }
        dataIsNotAvailableLable.hidden = NO;
        ContentScrollview.hidden = YES;
        bookMarkButton.hidden = YES;
        shareButton.hidden = YES;
        [self.view setBackgroundColor:[UIColor whiteColor]];
       showAlert(@"Error", @"We are unable to connect to our servers.\rPlease check your connection.");

         NSLog(@"Error == >> %@",error);
    }
    if (tag == NavigationMenuTag) {
        
        NoDataInNavigationMenuLable.hidden = NO;
        _MenuCollectionView.hidden = YES;
    }
}

#pragma mark - webview delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    CGRect frame = webView.frame;
    frame.size.height = 5.0f;
    webView.frame = frame;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   
//    float height = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] floatValue];
//    NSLog(@"\n\n\n Height>>>> %lf \n\n\n",height);
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)]; // Pass about any size
    CGRect mWebViewFrame = webView.frame;
    mWebViewFrame.size.height = mWebViewTextSize.height;
    webView.frame = mWebViewFrame;
    
    //Disable bouncing in webview
    for (id subview in webView.subviews) {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
            [subview setScrollEnabled:NO];
            [subview setBounces:NO];
        }
    }
    
   // [contentWebview.scrollView setScrollEnabled:NO];
    NSString *format = [_NewsPostDataArray valueForKey:@"format"];
    if ([format isEqualToString:StandardPostType]) {
        
        contentWebview.frame = CGRectMake(__X__(contentWebview), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView, __WIDTH__(contentWebview), mWebViewFrame.size.height);
        
        contentView.frame = CGRectMake(__X__(contentView), __Y__(contentView), __WIDTH__(contentView), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView+__HEIGHT__(contentWebview)+SpaceBetweenTwoContentView);
        
        ContentScrollview.contentSize = CGSizeMake(__WIDTH__(ContentScrollview), __HEIGHT__(contentView)>__HEIGHT__(ContentScrollview)?__HEIGHT__(contentView):__HEIGHT__(ContentScrollview));
    }else if ([format isEqualToString:VideoPostType]){
        
        contentWebview.frame = CGRectMake(__X__(contentWebview), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView+__HEIGHT__(videoView)+SpaceBetweenTwoContentView, __WIDTH__(contentWebview), mWebViewFrame.size.height);
        
        contentView.frame = CGRectMake(__X__(contentView), __Y__(contentView), __WIDTH__(contentView), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView+__HEIGHT__(videoView)+SpaceBetweenTwoContentView+__HEIGHT__(contentWebview)+SpaceBetweenTwoContentView);
        
        ContentScrollview.contentSize = CGSizeMake(__WIDTH__(ContentScrollview), __HEIGHT__(contentView)>__HEIGHT__(ContentScrollview)?__HEIGHT__(contentView):__HEIGHT__(ContentScrollview));

        
    }else if ([format isEqualToString:AudioPostType]){
        
        contentWebview.frame = CGRectMake(__X__(contentWebview), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView+__HEIGHT__(audioView)+SpaceBetweenTwoContentView, __WIDTH__(contentWebview), mWebViewFrame.size.height);
        
        contentView.frame = CGRectMake(__X__(contentView), __Y__(contentView), __WIDTH__(contentView), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView+__HEIGHT__(audioView)+SpaceBetweenTwoContentView+__HEIGHT__(contentWebview)+SpaceBetweenTwoContentView);
        
        ContentScrollview.contentSize = CGSizeMake(__WIDTH__(ContentScrollview), __HEIGHT__(contentView)>__HEIGHT__(ContentScrollview)?__HEIGHT__(contentView):__HEIGHT__(ContentScrollview));
        
    }
    if (contentView.frame.size.height<=ContentScrollview.frame.size.height) {
        contentView.frame = CGRectMake(__X__(contentView), __Y__(contentView), __WIDTH__(contentView), __HEIGHT__(ContentScrollview));
    }
//    if (ContentScrollview.contentSize.height<= ContentScrollview.frame.size.height) {
//        [self.view setBackgroundColor:[UIColor whiteColor]];
//    }else{
//        [self.view setBackgroundColor:[UIColor colorWithRed:255 green:220 blue:1 alpha:1]];
//    }
    ContentScrollview.contentOffset = CGPointMake(0,0);
    

}
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest: (NSURLRequest *)request navigationType: (UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request URL];
        NSString *param = [url query];
        
        if ([param rangeOfString: @"openInSafari=true"].location != NSNotFound){
            [[UIApplication sharedApplication] openURL: url];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Others Methods
-(NSString *)getMonthFullName:(NSInteger)month
{
    switch (month) {
        case 1:
            return @"JANUARY";
            break;
        case 2:
            return @"FEBRUARY";
            break;
        case 3:
            return @"MARCH";
            break;
        case 4:
            return @"APRIL";
            break;
        case 5:
            return @"MAY";
            break;
        case 6:
            return @"JUNE";
            break;
        case 7:
            return @"JULY";
            break;
        case 8:
            return @"AUGUST";
            break;
        case 9:
            return @"SEPTEMBER";
            break;
        case 10:
            return @"OCTOBER";
            break;
        case 11:
            return @"NOVEMBER";
            break;
        case 12:
            return @"DECEMBER";
            break;
        default:
            break;
    }
    return nil;
}
-(NSString *)DateSettings:(NSString *)date{
    
    NSArray *dateArray = [date componentsSeparatedByString:@"T"];
    NSString *d1 = [dateArray objectAtIndex:0];
    
    NSArray *datearray1 = [d1 componentsSeparatedByString:@"-"];
    
    NSString *strDate = [NSString stringWithFormat:@"%@ %@, %@",[self getMonthFullName:[[datearray1 objectAtIndex:1] integerValue]],[datearray1 objectAtIndex:2],[datearray1 objectAtIndex:0]];
    
    NSLog(@"DATE :- %@",strDate);
    
//    NSString *dateString =  @"12/10/2017";
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//    NSDate *date1 = [dateFormatter dateFromString:dateString];
//    NSLog(@"Date == %@ ",date1);
    return strDate;
}

-(void)initialSettingsForContentFormat:(NSString *)format{
    
    NSString *title = [[self.NewsPostDataArray valueForKey:@"title"] valueForKey:GetContentFromAPI];
    
    titleLable.text = [[[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:title] uppercaseString];
    
    titleLable = setLableSize(titleLable, [UIFont fontWithName:TitleFontName size:27]);
    
    titleLable.frame = CGRectMake(__X__(titleLable),__Y__(titleLable), __WIDTH__(titleLable), __HEIGHT__(titleLable));
    dateLable.text = [self DateSettings:[self.NewsPostDataArray valueForKey:@"date"]];
    dateLable.frame = CGRectMake(dateLable.frame.origin.x,titleLable.frame.origin.y+titleLable.frame.size.height+SpaceBetweenTitleAndDate,dateLable.frame.size.width,dateLable.frame.size.height);
    
    hedderContentView.frame = CGRectMake(__X__(hedderContentView), __Y__(hedderContentView), __WIDTH__(hedderContentView), __Y__(dateLable)+__HEIGHT__(dateLable)+BottomSpaceInHedderContentView);
    NSString *content1 = [[_NewsPostDataArray valueForKey:@"content"] valueForKey:GetContentFromAPI];
    NSString *CSSStr = @"<link rel=\"stylesheet\"  type=\"text/css\" href=\"https://radiofree.org/mobileapp-ios.css\" />";
   // NSString *AddContent = @"<style> img { width:100%;} </style>";
    NSString *demo = [NSString stringWithFormat:@"<html><head><style type='text/css'>.light {font-family: 'SourceSansPro-Light';}</style></head><body><p class=\"light\">%@</p></body></html>",content1];
    NSString *AuthorNameStr = [NSString stringWithFormat:@"<b>Via: %@</b>",[_NewsPostDataArray valueForKey:AuthorKey]];
    NSString *HTMLString =[NSString stringWithFormat:@"<font face='SourceSansPro-Light' size='3.5'>%@%@%@",CSSStr,content1,AuthorNameStr];
    [contentWebview loadHTMLString:HTMLString baseURL:nil];
    
    if ([format isEqualToString:StandardPostType]) {
        
        videoView.hidden = YES;
        audioView.hidden = YES;
        
        contentWebview.frame = CGRectMake(__X__(contentWebview), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView, __WIDTH__(contentWebview), __HEIGHT__(contentWebview));
        contentView.frame = CGRectMake(__X__(contentView),__Y__(contentView), __WIDTH__(contentView),  __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView+__HEIGHT__(contentWebview));
        
        
    }else if ([format isEqualToString:VideoPostType]){
        
        videoView.hidden = NO;
        audioView.hidden = YES;
        
        [self loadYouTubeVideo:[_NewsPostDataArray valueForKey:@"id"] loadyoutubeview:^(NSString *videoID) {
            NSString *videoId = videoID;
            NSDictionary *playerVars = @{
                                         @"controls" : @1,
                                         @"playsinline" : @1,
                                         @"autohide" : @1,
                                         @"showinfo" : @0,
                                         @"modestbranding" : @1
                                         };
            
            [videoView loadWithVideoId:videoId playerVars:playerVars];
        }];
        
        videoView.frame = CGRectMake(__X__(videoView), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView, __WIDTH__(videoView), __HEIGHT__(videoView));
        
        contentWebview.frame = CGRectMake(__X__(contentWebview), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView+__HEIGHT__(videoView)+SpaceBetweenTwoContentView, __WIDTH__(contentWebview), __HEIGHT__(contentWebview));
        
        contentView.frame = CGRectMake(__X__(contentView),__Y__(contentView), __WIDTH__(contentView),  __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView+SpaceBetweenTwoContentView+__HEIGHT__(videoView)+__HEIGHT__(contentWebview));
        
    }else if ([format isEqualToString:AudioPostType]){
        
        videoView.hidden = YES;
        audioView.hidden = NO;
        
        audioView.frame = CGRectMake(__X__(audioView), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView, __WIDTH__(audioView), __HEIGHT__(audioView));
        
        contentWebview.frame = CGRectMake(__X__(contentWebview), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView+__HEIGHT__(audioView)+SpaceBetweenTwoContentView, __WIDTH__(contentWebview), __HEIGHT__(contentWebview));
        
        contentView.frame = CGRectMake(__X__(contentView),__Y__(contentView), __WIDTH__(contentView),  __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView+SpaceBetweenTwoContentView+__HEIGHT__(audioView)+__HEIGHT__(contentWebview));
        
    }
    
    
    [ContentScrollview addSubview:contentView];
    
    ContentScrollview.contentSize = CGSizeMake(__WIDTH__(ContentScrollview), __HEIGHT__(contentView) > __HEIGHT__(ContentScrollview) ? __HEIGHT__(contentView) : __HEIGHT__(ContentScrollview));

    if (contentView.frame.size.height<=ContentScrollview.frame.size.height) {
        contentView.frame = CGRectMake(__X__(contentView), __Y__(contentView), __WIDTH__(contentView), __HEIGHT__(ContentScrollview));
    }
//    if (ContentScrollview.contentSize.height<= ContentScrollview.frame.size.height) {
//        [self.view setBackgroundColor:[UIColor whiteColor]];
//    }else{
//        [self.view setBackgroundColor:[UIColor colorWithRed:255 green:220 blue:1 alpha:1]];
//    }
    
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

-(void)detailViewNewsPostId:(NSString *)postId postFormat:(NSString *)format{
    APPDELEGATE.StringNewsPostId = postId;
    APPDELEGATE.StringNewsPostFormat = format;
}

-(void)initialSettings{
    
//જયારે પણ viewload થશે એટલે tabbar ની indicator line છે એ News પર સેટ થઇ જશે.
    lblTabIndicatorLine.frame = CGRectMake(__X__(btnNews), __Y__(lblTabIndicatorLine), __WIDTH__(lblTabIndicatorLine), __HEIGHT__(lblTabIndicatorLine));
    
   
    
}
// tabbar ma indicator line che aene animation karva mate aa method used thay che.
-(void)animationForTabBarIndicatorLineX:(CGFloat)X withTabViewcontrollersIndex:(NSInteger)index{
    
    [UIView animateWithDuration:0.3 animations:^{
        lblTabIndicatorLine.frame = CGRectMake(X, __Y__(lblTabIndicatorLine),__WIDTH__(lblTabIndicatorLine),__HEIGHT__(lblTabIndicatorLine));
    } completion:^(BOOL finished) {
        //condition ma darek potana view ni index set karvani
        //example ke aa news view che to aeni index 0 che ane jo aa live view hot to ahiya 1 set karavano jethi kari ne tabbar load na thay.
        if (index != 2) {
            
            APPDELEGATE.mainTabBar.selectedIndex = index;
            
//            if (index == 0) {
//                APPDELEGATE.mainTabBar.selectedIndex = index;
//            }else{
//                NSInteger controllerIndex = index;
//                UIView * fromView = APPDELEGATE.mainTabBar.selectedViewController.view;
//                UIView * toView = [[APPDELEGATE.mainTabBar.viewControllers objectAtIndex:controllerIndex] view];
//
//                // Transition using a page curl.
//                [UIView transitionFromView:fromView
//                                    toView:toView
//                                  duration:0.5
//                                   options:(controllerIndex > APPDELEGATE.mainTabBar.selectedIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight)
//                                completion:^(BOOL finished) {
//                                    if (finished) {
//                                        APPDELEGATE.mainTabBar.selectedIndex = controllerIndex;
//                                    }
//                                }];
//
//            }
            
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

-(void)addTapGestureInDetailsview{
    
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
                    
                    ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 329);
                    MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 417);
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
    if (CGRectContainsPoint(headderView.bounds, [touch locationInView:headderView]))
        return NO;

    return YES;
}

#pragma mark - IBAction Methods

- (IBAction)didActionToplayPauseBtnInMainAudioView:(UIButton *)sender {
    
    NSData *image1 = UIImagePNGRepresentation([UIImage imageNamed:@"play_player"]);
    
    if ([image1 isEqual:UIImagePNGRepresentation(sender.currentImage)]) {
        if ([Utility CheckForInternet]) {
            
        [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
       // [APPDELEGATE.audioPlayer resume];
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
                ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
            }else{
            ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 465);
            }
            if (contentView.frame.size.height<=ContentScrollview.frame.size.height) {
                contentView.frame = CGRectMake(__X__(contentView), __Y__(contentView), __WIDTH__(contentView), __HEIGHT__(ContentScrollview));
            }
            if (isOpenActivityIndicatorView == YES) {
                activityIndicatorView.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), __HEIGHT__(ContentScrollview));
            }
            // [self.view bringSubviewToFront:hedderView];
            MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
            tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            
        } completion:^(BOOL finished) {
            [APPDELEGATE.audioPlayer pause];
        }];
    }
    
}

- (IBAction)didActionToPlayOrPuaseAudio:(UIButton *)sender {
    
    if([Utility CheckForInternet]){
        [UIView animateWithDuration:0.1 animations:^{
            mainAudioViewIsOpen = YES;
            APPDELEGATE.AudioViewControllerStatusId = AudioNewsViewcontrollerStatusId;
            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
            
            if (IS_IPHONE_4_OR_LESS) {
                ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 329);
                MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            }else{
            ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 417);
            MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
            tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            }
            
        } completion:^(BOOL finished) {
            APPDELEGATE.AudioViewControllerStatusId = AudioNewsDetailViewControllerStatusId;
            NSString *titlestr = [[_NewsPostDataArray valueForKey:@"title"] valueForKey:GetContentFromAPI];
            APPDELEGATE.AudioTitleStr = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titlestr];
            APPDELEGATE.AudioURLStr = [NSString stringWithFormat:@"%@",[_NewsPostDataArray valueForKey:@"media_url"]];
//            newsTitleString = [NSString stringWithFormat:@"%@",[[[_NewsPostData objectAtIndex:sender.tag]valueForKey:@"title"]valueForKey:GetContentFromAPI]];
//            newsTitleLable.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:newsTitleString];
//            self.AudioUrlString = [NSString stringWithFormat:@"%@",[[_NewsPostData objectAtIndex:sender.tag]valueForKey:@"media_url"]];
            NSURL *url = [NSURL URLWithString:APPDELEGATE.AudioURLStr];
            
            STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
            
            [APPDELEGATE.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
            
        }];
    }
    else{
        
        showAlert(@"Check Connection", @"Internet is not available.");
    }
    
    //TO DO 26
    // if([Utility CheckForInternet]){
   // NSData *imgPlay = UIImagePNGRepresentation([UIImage imageNamed:@"play"]);
    
   // if ([imgPlay isEqual:UIImagePNGRepresentation(sender.currentImage)]) {
    //    APPDELEGATE.AudioViewControllerStatusId = AudioNewsDetailViewControllerStatusId;
    //    if (isFirstTimePlaying == YES) {
    //        isFirstTimePlaying = NO;
     //       NSString *StrUrl = [_NewsPostDataArray valueForKey:@"media_url"];
            
      //      NSURL *url = [NSURL URLWithString:StrUrl];
            
       //     STKDataSource *dataSource = [STKAudioPlayer dataSourceFromURL:url];
            
       //     [APPDELEGATE.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
       // }else{
       //     [APPDELEGATE.audioPlayer resume];
      //  }
        
        
      //  [PlayPauseAudioBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        
        // set pause Button
   // }else{
        
     //   [APPDELEGATE.audioPlayer pause];
        
      //  [PlayPauseAudioBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        // set play button
  //  }
   //  }
   //  else{
         
    //     showAlert(@"Check Connection", @"Internet is not available.");
   //  }
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
        //progressLblInMainAudioView.text = APPDELEGATE.AudioProgressTimeStr;
        DurationLblInMainAudioView.text = APPDELEGATE.AudioMainProgressString;
        
        if (APPDELEGATE.RemainingTimeInAppDelegate == 0) {
            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            APPDELEGATE.RemainingTimeInAppDelegate = 1;
        };
        
//        if ([progressLblInMainAudioView.text isEqualToString:DurationLblInMainAudioView.text] && ![progressLblInMainAudioView.text isEqualToString:@"00:00:00"] && ![DurationLblInMainAudioView.text isEqualToString:@"00:00:00"]) {
//            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
//        }
    }
    
    //TO DO 26
//    if (!APPDELEGATE.audioPlayer)
//    {
//
//        progressTimeLbl.text = @"00:00:00";
//
//
//        return;
//    }
//
//    if (APPDELEGATE.audioPlayer.currentlyPlayingQueueItemId == nil)
//    {
//
//
//        progressTimeLbl.text = @"00:00:00";
//
//        return;
//    }
//
//    if (APPDELEGATE.audioPlayer.duration != 0 && APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying && APPDELEGATE.AudioViewControllerStatusId == AudioNewsDetailViewControllerStatusId)
//    {
//        progressTimeLbl.text = [NSString stringWithFormat:@"%@",[self formatTimeFromSeconds:APPDELEGATE.audioPlayer.progress]];
//        durationTimeLbl.text = [NSString stringWithFormat:@"%@",[self formatTimeFromSeconds:APPDELEGATE.audioPlayer.duration]];
//
//    }
//    else
//    {
//
//    }
//    if ([progressTimeLbl.text isEqualToString:durationTimeLbl.text]&& ![progressTimeLbl.text isEqualToString:@"00:00:00"]&&![durationTimeLbl.text isEqualToString:@"00:00:00"]) {
//        isFirstTimePlaying = YES;
//        [PlayPauseAudioBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//    }
}
//-(NSString*) formatTimeFromSeconds:(int)totalSeconds
//{
//    
//    int seconds = totalSeconds % 60;
//    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
//    
//    return [NSString stringWithFormat:@"%2d:%2d:%2d", hours, minutes, seconds];
//}


- (IBAction)didActionToShareNewsPostLink:(id)sender {
    
    if([Utility CheckForInternet]){
        
        
        NSString *shareUrl = [self.NewsPostDataArray valueForKey:@"link"];
        NSArray * activityItems = @[[NSURL URLWithString:shareUrl]];
        NSArray * applicationActivities = nil;
        NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypePostToWeibo, UIActivityTypePrint];
        
        UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
        activityController.excludedActivityTypes = excludeActivities;
        
        [self presentViewController:activityController animated:YES completion:nil];
        
    }
    else{
        
        showAlert(@"Check Connection", @"Internet is not available.");
    }
    
    
    
}
- (IBAction)didActionToBookMarkButtonPress:(UIButton *)sender {
    
    if([Utility CheckForInternet]){
    
    NSData *image1 = UIImagePNGRepresentation([UIImage imageNamed:@"bookmark.png"]);

    if ([image1 isEqual:UIImagePNGRepresentation(sender.currentImage)]) {
        
        NSString *str_id,*str_title,*str_excerpt,*str_date,*str_format,*str_author,*str_link,*str_media_URL,*str_image_URL,*str_VideoID,*str_image_height,*str_image_width;
        
        str_id = [NSString stringWithFormat:@"%@",[self.NewsPostDataArray valueForKey:@"id"]];
        str_title = [NSString stringWithFormat:@"%@",[[self.NewsPostDataArray valueForKey:@"title"] valueForKey:GetContentFromAPI]];
        str_excerpt =[NSString stringWithFormat:@"%@",[[self.NewsPostDataArray valueForKey:@"excerpt"] valueForKey:GetContentFromAPI]];
        str_date = [NSString stringWithFormat:@"%@",[self.NewsPostDataArray valueForKey:@"date"]];
        str_format = [NSString stringWithFormat:@"%@",[self.NewsPostDataArray valueForKey:@"format"]];
        str_author = [NSString stringWithFormat:@"%@",[self.NewsPostDataArray valueForKey:AuthorKey]];
        str_link = [NSString stringWithFormat:@"%@",[self.NewsPostDataArray valueForKey:@"link"]];
        str_media_URL = [NSString stringWithFormat:@"%@",[self.NewsPostDataArray valueForKey:@"media_url"]];
        str_VideoID = [NSString stringWithFormat:@"%@",[[self.NewsPostDataArray valueForKey:@"youtube_video"]valueForKey:@"video_id"]];
        str_image_URL = [NSString stringWithFormat:@"%@",[self.NewsPostDataArray valueForKey:@"featured_image_url"]];
        str_image_width = [NSString stringWithFormat:@"%@",[self.NewsPostDataArray valueForKey:@"ftiwidth"]];
        str_image_height = [NSString stringWithFormat:@"%@",[self.NewsPostDataArray valueForKey:@"ftiheight"]];
        
            NSString *query = [NSString stringWithFormat:@"insert into radiotbl values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",str_id,str_title,str_excerpt,str_date,str_format,str_author,str_link,str_media_URL,str_image_URL,str_VideoID,str_image_height,str_image_width];
            [self.dbManager executeQuery:query];
            [bookMarkButton setImage:[UIImage imageNamed:@"bookmarkBlack"] forState:UIControlStateNormal];
        
        
        //insert code
        
    }else{
        NSString *str_id =[NSString stringWithFormat:@"%@",[self.NewsPostDataArray valueForKey:@"id"]];
        NSString *deleteQuery = [NSString stringWithFormat:@"delete from radiotbl where id = '%@'",str_id];
        [self.dbManager executeQuery:deleteQuery];
        //delete code
        [bookMarkButton setImage:[UIImage imageNamed:@"bookmark"] forState:UIControlStateNormal];
    }
        
    }else{
        
        showAlert(@"Check Connection", @"Internet is not available.");
    }
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
                    ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 329);
                    MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 417);
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
                        ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
                    }else{
                        ContentScrollview.frame = CGRectMake(0,__Y__(ContentScrollview), __WIDTH__(ContentScrollview), 465);
                    }
                    [self.view bringSubviewToFront:headderView];
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
    [self animationForTabBarIndicatorLineX:__X__(btnLive) withTabViewcontrollersIndex:1];
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
- (IBAction)didActionToBackButton:(id)sender {
    
    if (isMenuOpen) {
        isMenuOpen = NO;
        [self CloseMenu];
    }
    APPDELEGATE.mainTabBar.selectedIndex = 0;
    
    
   
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
