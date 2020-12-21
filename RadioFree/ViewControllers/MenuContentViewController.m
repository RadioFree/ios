//
//  MenuContentViewController.m
//  RadioFree
//
//  Created by vivek on 20/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import "MenuContentViewController.h"

@interface MenuContentViewController ()<UIGestureRecognizerDelegate>
{
    
    IBOutlet UILabel *ArtistLblInMainAudioView;
    IBOutlet UIView *hedderview;
    IBOutlet UILabel *seperateLineInMainAudioView;
    IBOutlet UILabel *DurationLblInMainAudioView;
    IBOutlet UILabel *progressLblInMainAudioView;
    IBOutlet UILabel *titleLblInMainAudioView;
    IBOutlet UIButton *playPauseBtnInMainAudioView;
    IBOutlet UIView *MainAudioView;
    BOOL mainAudioViewIsOpen;
    BOOL wasMainAudioViewOpen;
    
    IBOutlet UIWebView *Webview1;
    BOOL WebviewISAddInScrollView;
    IBOutlet UIView *SuperViewOfWebView;
    
    IBOutlet UIImageView *noDataAvailableLbl;
    IBOutlet UILabel *NoDataInNavigationMenuLable;
    //IBOutlet UILabel *noDataAvailableLbl;
    IBOutlet UIView *activityIndicatorView;
        IBOutlet UIWebView *ContentWebview;
    IBOutlet UIView *hedderContentView;
    IBOutlet UILabel *dateLable;
    IBOutlet UILabel *titleLable;
    
    IBOutlet UIView *contentView;
    
    IBOutlet UIView *tabView;
    IBOutlet UILabel *lblTabIndicatorLine;
    IBOutlet UIButton *btnNews;
    IBOutlet UIButton *btnLive;
    IBOutlet UIView *menuView;
    BOOL isMenuOpen;
    UIActivityIndicatorView *activityIndicator;
    UIImageView *LoaderImage;
    BOOL isOpenActivityIndicatorView;
    
}
@property (nonatomic, strong) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UIScrollView *ContentScrollview;
@property (strong, nonatomic) UIBlurEffect *blurEffect;
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;
@property (nonatomic, strong) NSMutableArray *MenuContentDataArray;

@property (strong, nonatomic) IBOutlet UICollectionView *MenuCollectionView;
@property (strong, nonatomic) NSMutableArray *NavigationMenuDataArray;

@end

@implementation MenuContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTimer];
    _NavigationMenuDataArray = [[NSMutableArray alloc] init];
    [_MenuCollectionView registerNib:[UINib nibWithNibName:@"SettingsMenuCell" bundle:nil] forCellWithReuseIdentifier:@"menucell"];
    [self iphone4sSupport];
    if (IS_IPHONE_4_OR_LESS) {
        //  ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
        activityIndicatorView.frame = CGRectMake(__X__(_ContentScrollview), __Y__(_ContentScrollview), __WIDTH__(_ContentScrollview),__HEIGHT__(_ContentScrollview));
    }
    // hide tabbarcontroller
    _MenuContentDataArray = [[NSMutableArray alloc] init];
    LoaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 100)];
    LoaderImage.center = CGPointMake(__WIDTH__(activityIndicatorView) / 2.0, __HEIGHT__(activityIndicatorView) / 2.0);
    //NSURL *url = [[NSURL alloc] initWithString:@"https://radiofree.org/wp-content/themes/bigfoot/loader.gif"];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loader" withExtension:@"gif"];
    LoaderImage.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    LoaderImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    [activityIndicatorView addSubview:LoaderImage];
    
    MainAudioView.frame = CGRectMake(0, __HEIGHT__(self.view), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
    [self.view addSubview:MainAudioView];
    
    [self.navigationController setNavigationBarHidden:YES];
    APPDELEGATE.mainTabBar.tabBar.hidden = YES;
    menuView.frame = CGRectMake(0, __HEIGHT__(self.view), __WIDTH__(self.view), __HEIGHT__(menuView));
    [self.view addSubview:menuView];
    [self addTapGestureInLiveview];
    [self.view addSubview:_ContentScrollview];
    [self.view bringSubviewToFront:tabView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)iphone4sSupport{
    if (IS_IPHONE_4_OR_LESS) {
        _ContentScrollview.frame = CGRectMake(_ContentScrollview.frame.origin.x, _ContentScrollview.frame.origin.y, _ContentScrollview.frame.size.width, 377);
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
      //  progressLblInMainAudioView.text = APPDELEGATE.AudioProgressTimeStr;
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

-(void)viewWillAppear:(BOOL)animated{
    
    if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying  || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
        
        
        [UIView animateWithDuration:0.1 animations:^{
            mainAudioViewIsOpen = YES;
            
            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
            if (IS_IPHONE_4_OR_LESS) {
                
                _ContentScrollview.frame = CGRectMake(0,__Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 329);
                MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            }else{
            
            
            _ContentScrollview.frame = CGRectMake(0,__Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 417);
            MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
            tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            }
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    [self CallInterNetValidationForNaviagationMenu];
//    self.MenuKey = APPDELEGATE.MenuContentItemKey;
//
//    NSLog(@">>>>> Menu Key ==== >>>> %ld",self.MenuKey);
//
//    if([Utility CheckForInternet]){
//        [self enableActivityIndicator];
//        [self loadWebviewFromMenuKey:self.MenuKey];
//        contentWebview.hidden = NO;
//        noDataAvailableLbl.hidden = YES;
//    }
//    else{
//        contentWebview.hidden = YES;
//        noDataAvailableLbl.hidden = NO;
//        showAlert(@"Check Connection", @"Internet is not available.");
//    }
//
    self.NavigationMenuPostTypeValueString = APPDELEGATE.NavigationMenuPostTypeValue;
    self.NavigationMenuPostTypeZeroValueURLString = APPDELEGATE.NavigationMenuPostTypeValueUrl;
    
    [self CheckPostTypeValueIsZero:[NSString stringWithFormat:@"%@",self.NavigationMenuPostTypeValueString]];
    //[self checkForInterNetValidationForSettingsMenuWebServerCall];
    [self initialSettings];
}

-(void)getPostTypeValueForSettings:(NSString *)value{
    APPDELEGATE.NavigationMenuPostTypeValue = value;
}

-(void)getPostTypeValueURL:(NSString *)url{
    APPDELEGATE.NavigationMenuPostTypeValueUrl = url;
}

-(void)CheckPostTypeValueIsZero:(NSString *)value{

    if ([value isEqualToString:@"0"]) {
        
        if ([Utility CheckForInternet]) {
            
            [self enableActivityIndicator];
            WebviewISAddInScrollView = YES;
            NSURL *url = [NSURL URLWithString:self.NavigationMenuPostTypeZeroValueURLString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            [Webview1 loadRequest:urlRequest];
            [_ContentScrollview addSubview:SuperViewOfWebView];
            _ContentScrollview.contentSize = CGSizeMake(__WIDTH__(SuperViewOfWebView), __HEIGHT__(SuperViewOfWebView));
        }else{
            _ContentScrollview.hidden = YES;
            noDataAvailableLbl.hidden = NO;
            [self.view setBackgroundColor:[UIColor whiteColor]];
            showAlert(@"Check Connection", @"Internet is not available.");
        }
        
    }else{
        
        [self checkForInterNetValidationForSettingsMenuWebServerCall];
        
    }
    if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying  || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
        
        
        [UIView animateWithDuration:0.1 animations:^{
            mainAudioViewIsOpen = YES;
             [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
            if (IS_IPHONE_4_OR_LESS) {
                
                _ContentScrollview.frame = CGRectMake(0,__Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 329);
                MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            }else{
            
           
            _ContentScrollview.frame = CGRectMake(0,__Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 417);
            MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
            tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            }
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (WebviewISAddInScrollView == YES) {
        [SuperViewOfWebView removeFromSuperview];
    }else{
        [contentView removeFromSuperview];
    }
    [ContentWebview loadHTMLString:@"" baseURL:nil];
   // [contentWebview loadHTMLString:@"" baseURL:nil];
    
    if (wasMainAudioViewOpen == YES) {
        wasMainAudioViewOpen = NO;
    }
    if (mainAudioViewIsOpen == YES) {
        mainAudioViewIsOpen = NO;
        
        [UIView animateWithDuration:0.1 animations:^{
            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            
            if (IS_IPHONE_4_OR_LESS) {
                _ContentScrollview.frame = CGRectMake(__X__(_ContentScrollview), __Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 377);
            }else{
            _ContentScrollview.frame = CGRectMake(0,__Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 465);
            }
            MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
            
            tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)- __HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
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
    
    return strDate;
}

-(void)initialSettingsContent{
    
    NSString *title = [[self.MenuContentDataArray valueForKey:@"title"] valueForKey:GetContentFromAPI];
    
    titleLable.text = [[[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:title] uppercaseString];
    
    titleLable = setLableSize(titleLable, [UIFont fontWithName:TitleFontName size:27]);
    
    titleLable.frame = CGRectMake(__X__(titleLable),__Y__(titleLable), __WIDTH__(titleLable), __HEIGHT__(titleLable));
    dateLable.text = [self DateSettings:[self.MenuContentDataArray valueForKey:@"date"]];
    dateLable.frame = CGRectMake(dateLable.frame.origin.x,titleLable.frame.origin.y+titleLable.frame.size.height+SpaceBetweenTitleAndDate,dateLable.frame.size.width,dateLable.frame.size.height);
    
    hedderContentView.frame = CGRectMake(__X__(hedderContentView), __Y__(hedderContentView), __WIDTH__(hedderContentView), __Y__(dateLable)+__HEIGHT__(dateLable)+BottomSpaceInHedderContentView);
    
    NSString *content1 = [[_MenuContentDataArray valueForKey:@"content"] valueForKey:GetContentFromAPI];
    NSString *CSSStr = @"<link rel=\"stylesheet\"  type=\"text/css\" href=\"https://radiofree.org/mobileapp-ios.css\" />";
    // NSString *AddContent = @"<style> img { width:100%;} </style>";
    // NSString *demo = [NSString stringWithFormat:@"<html><head><style type='text/css'>.light {font-family: 'SourceSansPro-Light';}</style></head><body><p class=\"light\">%@</p></body></html>",content1];
    NSString *HTMLString =[NSString stringWithFormat:@"<font face='SourceSansPro-Light' size='3.5'>%@%@",CSSStr,content1];
    [ContentWebview loadHTMLString:HTMLString baseURL:nil];
    
    ContentWebview.frame = CGRectMake(__X__(ContentWebview), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView, __WIDTH__(ContentWebview), __HEIGHT__(ContentWebview));
    contentView.frame = CGRectMake(__X__(contentView),__Y__(contentView), __WIDTH__(contentView),  __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView+__HEIGHT__(ContentWebview));
    
    [self.ContentScrollview addSubview:contentView];
    
    _ContentScrollview.contentSize = CGSizeMake(__WIDTH__(_ContentScrollview), __HEIGHT__(contentView) > __HEIGHT__(_ContentScrollview) ? __HEIGHT__(contentView) : __HEIGHT__(_ContentScrollview));
    
    if (contentView.frame.size.height<=_ContentScrollview.frame.size.height) {
        contentView.frame = CGRectMake(__X__(contentView), __Y__(contentView), __WIDTH__(contentView), __HEIGHT__(_ContentScrollview));
    }
    
}

#pragma mark - webview delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if (webView.tag == 101) {
        CGRect frame = webView.frame;
        frame.size.height = 5.0f;
        webView.frame = frame;
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (webView.tag == 101) {
        
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)]; //
    CGRect mWebViewFrame = webView.frame;
    mWebViewFrame.size.height = mWebViewTextSize.height;
    webView.frame = mWebViewFrame;
    
    
    for (id subview in webView.subviews) {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
            [subview setScrollEnabled:NO];
            [subview setBounces:NO];
        }
    }
    
    
    ContentWebview.frame = CGRectMake(__X__(ContentWebview), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView, __WIDTH__(ContentWebview), mWebViewFrame.size.height);
    
    contentView.frame = CGRectMake(__X__(contentView), __Y__(contentView), __WIDTH__(contentView), __Y__(hedderContentView)+__HEIGHT__(hedderContentView)+SpaceBetweenTwoContentView+__HEIGHT__(ContentWebview)+SpaceBetweenTwoContentView);
    
    _ContentScrollview.contentSize = CGSizeMake(__WIDTH__(_ContentScrollview), __HEIGHT__(contentView)>__HEIGHT__(_ContentScrollview)?__HEIGHT__(contentView):__HEIGHT__(_ContentScrollview));
    
    
    if (contentView.frame.size.height<=_ContentScrollview.frame.size.height) {
        contentView.frame = CGRectMake(__X__(contentView), __Y__(contentView), __WIDTH__(contentView), __HEIGHT__(_ContentScrollview));
    }
    
  //  _ContentScrollview.contentOffset = CGPointMake(0,0);
    
    if (isOpenActivityIndicatorView == YES) {
        [self disableActivityIndicator];
    }
     //[self.ContentScrollview addSubview:contentView];
    }
    
    if (webView.tag == 102) {
        
        if (isOpenActivityIndicatorView == YES) {
            [self disableActivityIndicator];
        }
        
    }
    
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

#pragma Mark - WebServices Methods

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

-(void)syncSuccess:(id)responseObject withTag:(NSInteger)tag{
    
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
    
    if (tag == NavigationMenuTag) {
        
        NoDataInNavigationMenuLable.hidden = NO;
        _MenuCollectionView.hidden = YES;
    }
    
}

-(void)checkForInterNetValidationForSettingsMenuWebServerCall{
    
    if([Utility CheckForInternet]){
        [self enableActivityIndicator];
        NSString *urlstr = [NSString stringWithFormat:@"%@%@",RadioFreePageURL,self.NavigationMenuPostTypeValueString];
        [self callForWebServerForSettingsMenuDatawithUrl:urlstr];
        _ContentScrollview.hidden = NO;
        noDataAvailableLbl.hidden = YES;
        [self.view setBackgroundColor:UIColorFromRGB(255, 220, 1)];
    }
    else{
        _ContentScrollview.hidden = YES;
        noDataAvailableLbl.hidden = NO;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        showAlert(@"Check Connection", @"Internet is not available.");
    }
    
}

-(void)callForWebServerForSettingsMenuDatawithUrl:(NSString *)url{
    
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
//    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
//    
//    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    
//    //    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    
//    [manager POST:url parameters:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                if (responseObject) {
//        
//                    _MenuContentDataArray = (NSMutableArray *)[responseObject copy];
//                    NSLog(@"result := %@",_MenuContentDataArray);
//                    [self initialSettingsContent];
//        
//                }else{
//        
//                }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                _ContentScrollview.hidden = YES;
//                noDataAvailableLbl.hidden = NO;
//                if (isOpenActivityIndicatorView == YES) {
//                    [self disableActivityIndicator];
//                }
//                [self.view setBackgroundColor:[UIColor whiteColor]];
//                NSLog(@"Error : %@", error);
//    }];
    
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            
            _MenuContentDataArray = (NSMutableArray *)[responseObject copy];
            NSLog(@"result := %@",_MenuContentDataArray);
            [self initialSettingsContent];
            
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _ContentScrollview.hidden = YES;
        noDataAvailableLbl.hidden = NO;
        if (isOpenActivityIndicatorView == YES) {
            [self disableActivityIndicator];
        }
        [self.view setBackgroundColor:[UIColor whiteColor]];
        NSLog(@"Error : %@", error);
    }];
    
    
    
    
    
//    [manager GET:url parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
//
//
//
//        if (responseObject) {
//
//            _MenuContentDataArray = (NSMutableArray *)[responseObject copy];
//            NSLog(@"result := %@",_MenuContentDataArray);
//            [self initialSettingsContent];
//
//        }else{
//
//        }
//
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//        _ContentScrollview.hidden = YES;
//        noDataAvailableLbl.hidden = NO;
//        if (isOpenActivityIndicatorView == YES) {
//            [self disableActivityIndicator];
//        }
//        [self.view setBackgroundColor:[UIColor whiteColor]];
//        NSLog(@"Error : %@", error);
//
//    }];
    
    
}

#pragma mark - Others Methods
-(void)enableActivityIndicator{
    isOpenActivityIndicatorView = YES;
    
    if (IS_IPHONE_4_OR_LESS) {
        //  ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
        activityIndicatorView.frame = CGRectMake(__X__(_ContentScrollview), __Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), __HEIGHT__(_ContentScrollview));
    }else{
    activityIndicatorView.frame = CGRectMake(__X__(_ContentScrollview), __Y__(_ContentScrollview),__WIDTH__(_ContentScrollview) , __HEIGHT__(_ContentScrollview));
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
   // [activityIndicator stopAnimating];
    [activityIndicatorView removeFromSuperview];
}

//-(void)loadWebviewFromMenuKey:(NSInteger)key{
//
//    switch (key) {
//        case MenuItemNewsTag:{
//            NSURL *url = [NSURL URLWithString:[MenuItemNewsURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *requesturl = [NSURLRequest requestWithURL:url];
//            [contentWebview loadRequest:requesturl];
//            break;
//        }
//        case MenuItemAboutTag:{
//            NSURL *url = [NSURL URLWithString:[MenuItemAboutURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *requesturl = [NSURLRequest requestWithURL:url];
//            [contentWebview loadRequest:requesturl];
//            break;
//
//        }
//        case MenuItemPressKitTag:{
//            NSURL *url = [NSURL URLWithString:[MenuItemPressKitURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *requesturl = [NSURLRequest requestWithURL:url];
//            [contentWebview loadRequest:requesturl];
//
//            break;
//        }
//        case MenuItemSupportTag:{
//            NSURL *url = [NSURL URLWithString:[MenuItemSupportURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *requesturl = [NSURLRequest requestWithURL:url];
//            [contentWebview loadRequest:requesturl];
//
//            break;
//        }
//        case MenuItemContactTag:{
//            NSURL *url = [NSURL URLWithString:[MenuItemContactURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *requesturl = [NSURLRequest requestWithURL:url];
//            [contentWebview loadRequest:requesturl];
//
//            break;
//        }
//        case MenuItemListenTag:{
//            NSURL *url = [NSURL URLWithString:[MenuItemListenURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *requesturl = [NSURLRequest requestWithURL:url];
//            [contentWebview loadRequest:requesturl];
//
//            break;
//        }
//        case MenuItemJobInternshipTag:{
//            NSURL *url = [NSURL URLWithString:[MenuItemJobInternshipURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *requesturl = [NSURLRequest requestWithURL:url];
//            [contentWebview loadRequest:requesturl];
//
//            break;
//        }
//        case MenuItemFriendsOfRadioFreeTag:{
//            NSURL *url = [NSURL URLWithString:[MenuItemFriendsOfRadioFreeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *requesturl = [NSURLRequest requestWithURL:url];
//            [contentWebview loadRequest:requesturl];
//
//            break;
//        }
//        case MenuItemLanguagesTag:{
//            NSURL *url = [NSURL URLWithString:[MenuItemLanguagesURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *requesturl = [NSURLRequest requestWithURL:url];
//            [contentWebview loadRequest:requesturl];
//
//            break;
//        }
//        case MenuItemTwitterTag:{
//            NSURL *url = [NSURL URLWithString:[MenuItemTwitterURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *requesturl = [NSURLRequest requestWithURL:url];
//            [contentWebview loadRequest:requesturl];
//
//            break;
//        }
//        default:
//            break;
//    }
//
//}


//-(void)menuItemKey:(NSInteger)tag{
//    APPDELEGATE.MenuContentItemKey = tag;
//}

-(void)initialSettings{
    
    //tabbar ma indicator line che aene jyare pan view load thay tyare ana news button vada location par set kari che.
    lblTabIndicatorLine.frame = CGRectMake(__X__(btnNews), __Y__(lblTabIndicatorLine), __WIDTH__(lblTabIndicatorLine), __HEIGHT__(lblTabIndicatorLine));
    
    
}

-(void)animationForTabBarIndicatorLineX:(CGFloat)X withTabViewcontrollersIndex:(NSInteger)index{
    
    [UIView animateWithDuration:0.3 animations:^{
        lblTabIndicatorLine.frame = CGRectMake(X, __Y__(lblTabIndicatorLine),__WIDTH__(lblTabIndicatorLine),__HEIGHT__(lblTabIndicatorLine));
    } completion:^(BOOL finished) {
        //condition ma darek potana view ni index set karvani
        //example ke aa news view che to aeni index 0 che ane jo aa live view hot to ahiya 1 set karavano jethi kari ne tabbar load na thay.
        if (index != 5) {
            
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
    _blurEffectView.frame = CGRectMake(__X__(_ContentScrollview), __Y__(_ContentScrollview),__WIDTH__(_ContentScrollview), __HEIGHT__(_ContentScrollview));
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
                    
                    _ContentScrollview.frame = CGRectMake(0,__Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 329);
                    MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                
                _ContentScrollview.frame = CGRectMake(0,__Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 417);
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
//- (IBAction)didActionToMenusInnerButtons:(UIButton *)sender {
//    if (isMenuOpen) {
//        isMenuOpen = NO;
//        [self CloseMenu];
//    }
//    
//    if([Utility CheckForInternet]){
//        [self enableActivityIndicator];
//        [self loadWebviewFromMenuKey:sender.tag];
//        contentWebview.hidden = NO;
//        noDataAvailableLbl.hidden = YES;
//    }
//    else{
//        contentWebview.hidden = YES;
//        noDataAvailableLbl.hidden = NO;
//        showAlert(@"Check Connection", @"Internet is not available.");
//    }
//    
//}

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
                _ContentScrollview.frame = CGRectMake(__X__(_ContentScrollview), __Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 377);
            }else{
            _ContentScrollview.frame = CGRectMake(0,__Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 465);
            }
            
            if (contentView.frame.size.height<=_ContentScrollview.frame.size.height) {
                contentView.frame = CGRectMake(__X__(contentView), __Y__(contentView), __WIDTH__(contentView), __HEIGHT__(_ContentScrollview));
            }
            if (isOpenActivityIndicatorView == YES) {
                activityIndicatorView.frame = CGRectMake(__X__(_ContentScrollview), __Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), __HEIGHT__(_ContentScrollview));
            }
            // [self.view bringSubviewToFront:hedderView];
            MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
            tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            
        } completion:^(BOOL finished) {
            [APPDELEGATE.audioPlayer pause];
        }];
    }
    
}


- (IBAction)didActionToMenuButton:(id)sender {
    
    if (isMenuOpen) {
        isMenuOpen = NO;
        [self CloseMenu];
        
        if (wasMainAudioViewOpen == YES) {
            wasMainAudioViewOpen = NO;
            mainAudioViewIsOpen = YES;
            
            [UIView animateWithDuration:0.1 animations:^{
                
                if (IS_IPHONE_4_OR_LESS) {
                    
                    _ContentScrollview.frame = CGRectMake(0,__Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 329);
                    MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                _ContentScrollview.frame = CGRectMake(0,__Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 417);
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
                        _ContentScrollview.frame = CGRectMake(__X__(_ContentScrollview), __Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 377);
                    }else{
                    _ContentScrollview.frame = CGRectMake(0,__Y__(_ContentScrollview), __WIDTH__(_ContentScrollview), 465);
                    }
                    [self.view bringSubviewToFront:hedderview];
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
    
//    [contentView removeFromSuperview];
//    [ContentWebview loadHTMLString:@"" baseURL:nil];
    
    self.NavigationMenuPostTypeValueString = [[_NavigationMenuDataArray objectAtIndex:indexPath.row] objectAtIndex:4];
    self.NavigationMenuPostTypeZeroValueURLString = [[_NavigationMenuDataArray objectAtIndex:indexPath.row] objectAtIndex:2];
    [self CheckPostTypeValueIsZero:[NSString stringWithFormat:@"%@",self.NavigationMenuPostTypeValueString]];
   // [self checkForInterNetValidationForSettingsMenuWebServerCall];
    
//    MenuContentViewController *settingsSubview = [[MenuContentViewController alloc] init];
//    [settingsSubview getPostTypeValueForSettings:[[_NavigationMenuDataArray objectAtIndex:indexPath.row] objectAtIndex:4]];
//
//    APPDELEGATE.mainTabBar.selectedIndex = 5;
    
    
    
}


@end
