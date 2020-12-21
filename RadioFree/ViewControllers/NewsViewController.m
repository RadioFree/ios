//
//  NewsViewController.m
//  RadioFree
//
//  Created by vivek on 13/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//

#import "NewsViewController.h"
#import "SVProgressHUD.h"
@interface UIRefreshControl (AIMP)
-(void)hideActivityIndicator:(BOOL)hide;
@end
@implementation UIRefreshControl (AIMP)

-(void)hideActivityIndicator:(BOOL)hide{
    if (hide) {
        self.tintColor = [UIColor clearColor];
    }
}
@end
@interface NewsViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,YTPlayerViewDelegate>
{
    
    IBOutlet UIView *ipadContentView;
    IBOutlet UIScrollView *ipadScrollview;
    IBOutlet UILabel *ArtistLblInMainAudioView;
    IBOutlet UILabel *seperateLineInMainAudioView;
    IBOutlet UIImageView *lblNoDataAvailable;
    IBOutlet UILabel *NoDataInNavigationMenuLable;
    BOOL wasMainAudioViewOpen;
    YTPlayerView *TempYoutubeViewPlayer;
    BOOL isAudioStopByVideo;
    BOOL mainAudioViewIsOpen;
    IBOutlet UIView *hedderView;
    IBOutlet UIView *activityIndicatorView;
    //IBOutlet UILabel *lblNoDataAvailable;
    BOOL isLoading;
    IBOutlet UIView     *tabView;
    IBOutlet UILabel    *lblTabIndicatorLine;
    IBOutlet UIButton   *btnNews;
    IBOutlet UIButton   *btnLive;
    IBOutlet UIView     *menuView;
    BOOL isMenuOpen;
    
    UIRefreshControl *refreshControl;
    NSString *YouTubeIdString;
    UIActivityIndicatorView *activityIndicator;
    NSInteger *firstCellTag;
    NSInteger *secondCellTag;
    UIImageView *LoaderImage;
    BOOL isOpenActivityIndicatorView;
    
    IBOutlet UIButton *PlayPauseBtnMainAudioview;
    IBOutlet UILabel *ProgressLblMainAudioView;
    IBOutlet UILabel *DurationLblMainAudioView;
    IBOutlet UILabel *newsTitleLable;
    NSString *newsTitleString;
    
}

@property (strong, nonatomic) IBOutlet UIView *mainAudioView;
@property (strong, nonatomic) NSString *AudioUrlString;
@property (strong, nonatomic) NSMutableArray        *NewsPostData;
@property (strong, nonatomic) IBOutlet UITableView  *newsTableView;
@property (strong, nonatomic) UIBlurEffect          *blurEffect;
@property (strong, nonatomic) UIVisualEffectView    *blurEffectView;

@property (strong, nonatomic) IBOutlet UICollectionView *MenuCollectionView;
@property (strong, nonatomic) NSMutableArray *NavigationMenuDataArray;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (device == iphone) {
        
    }else{
        [ipadScrollview addSubview:ipadContentView];
        ipadScrollview.contentSize = CGSizeMake(ipadContentView.frame.size.width, ipadContentView.frame.size.height);
    }
    
    
    //Initialize Arrays
    [self setupTimer];
    _NavigationMenuDataArray = [[NSMutableArray alloc] init];
    [_MenuCollectionView registerNib:[UINib nibWithNibName:@"SettingsMenuCell" bundle:nil] forCellWithReuseIdentifier:@"menucell"];
    [self iphone4sSupport];
    self.NewsPostData = [[NSMutableArray alloc] init];
    
    if (IS_IPHONE_4_OR_LESS) {
        //  ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
        activityIndicatorView.frame = CGRectMake(__X__(self.newsTableView), __Y__(self.newsTableView), __WIDTH__(self.newsTableView),__HEIGHT__(self.newsTableView));
    }
    
    LoaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 100)];
    LoaderImage.center = CGPointMake(__WIDTH__(activityIndicatorView) / 2.0, __HEIGHT__(activityIndicatorView) / 2.0);
    //NSURL *url = [[NSURL alloc] initWithString:@"https://radiofree.org/wp-content/themes/bigfoot/loader.gif"];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loader" withExtension:@"gif"];
    LoaderImage.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    LoaderImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    [activityIndicatorView addSubview:LoaderImage];
   // self.NewsPostData = (NSMutableArray *)[self Dummydata];
   // [_newsTableView reloadData];
    // hide tabbarcontroller
    APPDELEGATE.mainTabBar.tabBar.hidden = YES;
    
    _mainAudioView.frame = CGRectMake(0, __HEIGHT__(self.view), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
    [self.view addSubview:_mainAudioView];
    [self.view bringSubviewToFront:hedderView];
    // menuview ni frame set kari ane self.view ma add karyo
    menuView.frame = CGRectMake(0, __HEIGHT__(self.view), __WIDTH__(self.view), __HEIGHT__(menuView));
    [self.view addSubview:menuView];
    [self.view addSubview:_newsTableView];
    [self.view bringSubviewToFront:tabView];
    [self addTapGestureInNewsview];
    [self internetValidationForNewsPostPageReload:YES];
    
    // UIRefreshControl Settings
    
    refreshControl = [[UIRefreshControl alloc] init];
    
    UIImageView *rcImageView =
    [[UIImageView alloc] init];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"loader" withExtension:@"gif"];
    rcImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url1]];
    // NSURL *url = [[NSURL alloc] initWithString:@"https://radiofree.org/wp-content/themes/bigfoot/loader.gif"];
    rcImageView.image = [UIImage animatedImageWithAnimatedGIFURL:url1];
    rcImageView.frame = CGRectMake(self.view.frame.size.width/2-25, refreshControl.frame.origin.y, 40, 50);
    rcImageView.center = CGPointMake(refreshControl.frame.size.width / 2.0, refreshControl.frame.size.height / 2.0);
    [refreshControl hideActivityIndicator:YES];
    [refreshControl insertSubview:rcImageView atIndex:0];
   // self.newsTableView.estimatedRowHeight = 100.0;
   // self.newsTableView.rowHeight = UITableViewAutomaticDimension;

    //[refreshControl setTintColor:[UIColor blackColor]];
    [self.newsTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshToNewsTableContent) forControlEvents:UIControlEventValueChanged];
    self.newsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)iphone4sSupport{
    if (IS_IPHONE_4_OR_LESS) {
        self.newsTableView.frame = CGRectMake(self.newsTableView.frame.origin.x, self.newsTableView.frame.origin.y, self.newsTableView.frame.size.width, 378);
        // ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
        
        
        
        tabView.frame = CGRectMake(tabView.frame.origin.x,480 -tabView.frame.size.height, tabView.frame.size.width, tabView.frame.size.height);
        
        NSLog(@"SELF.VIEW :- %f and tabview Y = %f",self.view.frame.size.height,tabView.frame.origin.y);
        
        //tabView.frame = CGRectMake(__X__(tabView),__HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
    }
}


-(void)viewWillAppear:(BOOL)animated{
    ////
    
    ////
    
    
    [self initialSettings];
    [self CallInterNetValidationForNaviagationMenu];
    
    if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying  || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
        //TO DO 27
//        if (APPDELEGATE.AudioViewControllerStatusId == AudioNewsViewcontrollerStatusId) {
            [UIView animateWithDuration:0.1 animations:^{
                mainAudioViewIsOpen = YES;
                
                [PlayPauseBtnMainAudioview setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
                
                if (IS_IPHONE_4_OR_LESS) {
                    
                    _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 330);
                    _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(_mainAudioView), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(_mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                
                _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 418);
                _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(_mainAudioView), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(_mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }
            } completion:^(BOOL finished) {
                
            }];
        }
    //}
    
}
-(void)viewWillDisappear:(BOOL)animated
{
   
//    if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
//        [APPDELEGATE.audioPlayer pause];
//       // [PlayPauseBtnMainAudioview setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//    }
    if (wasMainAudioViewOpen == YES) {
        wasMainAudioViewOpen = NO;
    }
    if (mainAudioViewIsOpen == YES) {
        mainAudioViewIsOpen = NO;
        
        [UIView animateWithDuration:0.1 animations:^{
            [PlayPauseBtnMainAudioview setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            
            if (IS_IPHONE_4_OR_LESS) {
                _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 378);
            }else{
            
            _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 466);
            }
            _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
            
            tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)- __HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark - Others Methods

-(void)enableActivityIndicator{
    
    isOpenActivityIndicatorView = YES;

    if (IS_IPHONE_4_OR_LESS) {
        //  ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
        activityIndicatorView.frame = CGRectMake(__X__(self.newsTableView), __Y__(self.newsTableView), __WIDTH__(self.newsTableView), __HEIGHT__(self.newsTableView));
    }else{
    
    activityIndicatorView.frame = CGRectMake(__X__(self.newsTableView), __Y__(self.newsTableView),__WIDTH__(self.newsTableView) , __HEIGHT__(self.newsTableView));
    }
    LoaderImage.center = CGPointMake(__WIDTH__(activityIndicatorView) / 2.0, __HEIGHT__(activityIndicatorView) / 2.0);
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 100)];
//    image.center = CGPointMake(__WIDTH__(activityIndicatorView) / 2.0, __HEIGHT__(activityIndicatorView) / 2.0);
//    //NSURL *url = [[NSURL alloc] initWithString:@"https://radiofree.org/wp-content/themes/bigfoot/loader.gif"];
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loader" withExtension:@"gif"];
//    image.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
//    image.image = [UIImage animatedImageWithAnimatedGIFURL:url];
//    [activityIndicatorView addSubview:image];
    
   // activityIndicator = [[UIActivityIndicatorView alloc]init];
    //activityIndicator.center  = CGPointMake(__WIDTH__(activityIndicatorView) / 2.0, __HEIGHT__(activityIndicatorView) / 2.0);
    //initWithFrame:CGRectMake(__WIDTH__(activityIndicatorView)/2-__WIDTH__(activityIndicator)/2, __HEIGHT__(activityIndicatorView)/2-__HEIGHT__(activityIndicator)/2, 30, 30)];
   // [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //[activityindicator1 setColor:[UIColor orangeColor]];
   // [activityIndicatorView addSubview:activityIndicator];
    //[activityIndicator startAnimating];
    [self.view addSubview:activityIndicatorView];
    [self.view bringSubviewToFront:tabView];
}
-(void)disableActivityIndicator{
    isOpenActivityIndicatorView = NO;
    //[activityIndicator stopAnimating];
    [activityIndicatorView removeFromSuperview];
}
-(void)refreshToNewsTableContent{
   
   // [self.newsTableView reloadData];
     [self internetValidationForNewsPostPageReload:YES];
    
}
-(void)initialSettings{
    
    //tabbar ma indicator line che aene jyare pan view load thay tyare ana news button vada location par set kari che.
    lblTabIndicatorLine.frame = CGRectMake(__X__(btnNews), __Y__(lblTabIndicatorLine), __WIDTH__(lblTabIndicatorLine), __HEIGHT__(lblTabIndicatorLine));
    
    
}
// tabbar ma indicator line che aene animation karva mate aa method used thay che.
-(void)animationForTabBarIndicatorLineX:(CGFloat)X withTabViewcontrollersIndex:(NSInteger)index{
    
    [UIView animateWithDuration:0.3 animations:^{
        lblTabIndicatorLine.frame = CGRectMake(X, __Y__(lblTabIndicatorLine),__WIDTH__(lblTabIndicatorLine),__HEIGHT__(lblTabIndicatorLine));
    } completion:^(BOOL finished) {
        //condition ma darek potana view ni index set karvani
        //example ke aa news view che to aeni index 0 che ane jo aa live view hot to ahiya 1 set karavano jethi kari ne tabbar load na thay.
        if (index != 0) {
            APPDELEGATE.mainTabBar.selectedIndex = index;
//            NSInteger controllerIndex1 = index;
//            UIView * fromView = APPDELEGATE.mainTabBar.selectedViewController.view;
//            UIView * toView = [[APPDELEGATE.mainTabBar.viewControllers objectAtIndex:controllerIndex1] view];
//
//            CGRect viewSize = fromView.frame;
//            BOOL scrollRight = controllerIndex1 > APPDELEGATE.mainTabBar.selectedIndex;
//
//            // Add the to view to the tab bar view.
//            [fromView.superview addSubview:toView];
//
//            // Position it off screen.
//            toView.frame = CGRectMake((scrollRight ? 320 : -320), viewSize.origin.y, 320, viewSize.size.height);
//
//            [UIView animateWithDuration:1.0
//                             animations: ^{
//
//                                 // Animate the views on and off the screen. This will appear to slide.
//                                 fromView.frame =CGRectMake(320, viewSize.origin.y, 320, viewSize.size.height);
//                                 toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
//                             }
//
//                             completion:^(BOOL finished) {
//                                 if (finished) {
//
//                                     // Remove the old view from the tabbar view.
//                                     [fromView removeFromSuperview];
//                                     APPDELEGATE.mainTabBar.selectedIndex = controllerIndex1;
//                                 }
//                             }];
            
            
        }
    }];
       // APPDELEGATE.mainTabBar.selectedIndex = index;
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
//
//        }
        
    //}];

}

#pragma mark - MenuSettings Methods
// Menu open karva mate aa method no used thay che.
-(void)OpenMenu{
    
    _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:_blurEffect];
    //always fill the view
    _blurEffectView.frame = CGRectMake(__X__(self.newsTableView), __Y__(self.newsTableView),__WIDTH__(self.newsTableView), __HEIGHT__(self.newsTableView));
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

-(void)addTapGestureInNewsview{
    
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
                    
                    _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 330);
                    _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(_mainAudioView), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(_mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 418);
                _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(_mainAudioView), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(_mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
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
//             APPDELEGATE.mainTabBar.selectedIndex = 5;
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
                    
                    _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 330);
                    _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(_mainAudioView), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(_mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 418);
                _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(_mainAudioView), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(_mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
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
                    _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 378);
                }else{
                    
                _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 466);
                }
                [self.view bringSubviewToFront:hedderView];
                _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
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
        
        if (wasMainAudioViewOpen == YES) {
            wasMainAudioViewOpen = NO;
            mainAudioViewIsOpen = YES;
            
            [UIView animateWithDuration:0.1 animations:^{
                
                if (IS_IPHONE_4_OR_LESS) {
                    
                    _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 330);
                    _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(_mainAudioView), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(_mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 418);
                _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(_mainAudioView), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(_mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
    }
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
    //Dummy
    //APPDELEGATE.mainTabBar.selectedIndex = 5;
}

#pragma mark - ScrollviewDelegateMethods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _newsTableView) {
        if (isLoading) {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height)
            {
                APPDELEGATE.PostPageNumber = APPDELEGATE.PostPageNumber + 1;
               // NSLog(@"\n\n pageNum %ld \n\n", APPDELEGATE.PostPageNumber);
                isLoading = FALSE;
                
                [self internetValidationForNewsPostPageReload:NO];
            }
        }
        
        //NSLog(@"\n\n Scrollview Method is Call \n\n");
        
//        for (UITableViewCell *cell in [self.newsTableView visibleCells]) {
//            if ([cell.reuseIdentifier isEqualToString:@"audio"]) {
//
//                AudioCell *cell1 =(AudioCell *)cell;
//                NSInteger tag = cell1.playPauseButton.tag;
//                if (tag == APPDELEGATE.selectedIndexPath && APPDELEGATE.isPlayButton == YES) {
//                    [cell1.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
//                }else{
//                     [cell1.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//                }
//
//            }
//        }
        
        
    }
    
    
    
}


#pragma mark - (AFNetworkingDelegate) SyncManager Delegate Methods

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

-(void)internetValidationForNewsPostPageReload:(BOOL)pageReload{
    
    StatusBarActivityIndicatorShow;
   // [SVProgressHUD showWithStatus:@"Loading.."];
   
    if([Utility CheckForInternet]){
        if ([refreshControl isRefreshing]) {
            
        }else{
            if (pageReload == YES) {
                [self enableActivityIndicator];
            }
            
        }
        APPDELEGATE.PostPageNumber = AssignPage(pageReload);
        [self postDataOnWebservicesForNews];
    }
    else{
        self.newsTableView.hidden = YES;
        lblNoDataAvailable.hidden = NO;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        StatusBarActivityIndicatorHide;
        
        showAlert(@"Check Connection", @"Internet is not available.");
    }
    
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
     
//-(NSString *)getYouTubeVideoURL:(NSString *)url{
//    NSArray *strArr = [url componentsSeparatedByString:@"v="];
//    return strArr[1];
//}
//-(void)postDataOnWebservidesForGetYouTubeVideo:(NSString *)PostId{
//    
//     NSString *MainURL = [NSString stringWithFormat:@"%@%@",YouTubeVideoURL,PostId];
//    SyncManager *syncmanager = [[SyncManager alloc] init];
//    syncmanager.delegate = self;
//    
//    [syncmanager webServiceCall:MainURL withParams:@{} withTag:YouTubeVideoTag];
//
//    
//}
-(void)postDataOnWebservicesForNews{
    
    NSString *MainURL = [NSString stringWithFormat:@"%@page=%ld",PostUrlString,APPDELEGATE.PostPageNumber];
    
    SyncManager *syncmanager = [[SyncManager alloc] init];
    syncmanager.delegate = self;
    
    [syncmanager webServiceCall:MainURL withParams:@{} withTag:NewsPostTag];
    
}
-(void)syncSuccess:(id)responseObject withTag:(NSInteger)tag{
    
   
    if (tag == NewsPostTag) {
        
        NSMutableArray *indexpath = [[NSMutableArray alloc] init];
        
        NSArray *newArray = [responseObject mutableCopy];
      //  NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        if (newArray.count>0) {
            
            if (APPDELEGATE.PostPageNumber == 1) {
                NSMutableArray *temp = [_NewsPostData mutableCopy];
                [temp removeAllObjects];
                _NewsPostData = [temp mutableCopy];
            }
            
            for (int i =0 ; i < newArray.count; i++) {
                [self.NewsPostData addObject:[newArray objectAtIndex:i]];
                NSIndexPath *indexpath1 = [NSIndexPath indexPathForRow:i inSection:0];
                [indexpath addObject:indexpath1];
               // [tempArray addObject:<#(nonnull id)#>];
            }
            isLoading = YES;
            
            self.newsTableView.hidden = NO;
            lblNoDataAvailable.hidden = YES;
            if (device == iphone) {
                
            [self.view setBackgroundColor:UIColorFromRGB(20, 19, 19)];
            }else{
               [self.view setBackgroundColor:[UIColor whiteColor]];
            }
        }else{
            [self.view setBackgroundColor:[UIColor whiteColor]];
            self.newsTableView.hidden = YES;
            lblNoDataAvailable.hidden = NO;
        }
        
        
        
        NSLog(@"Result = %@",_NewsPostData);
        StatusBarActivityIndicatorHide;
        if ([refreshControl isRefreshing]) {
           // [_newsTableView setEditing:NO animated:NO];
            [UIView setAnimationsEnabled:false];
           // [_newsTableView reloadData];
           // [self.newsTableView beginUpdates];
            NSRange range = NSMakeRange(0, 1);
            NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
             [self.newsTableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
           // [self.newsTableView endUpdates];
            [refreshControl endRefreshing];
        }else{
            [UIView setAnimationsEnabled:false];
            //[self.newsTableView beginUpdates];
            NSRange range = NSMakeRange(0, 1);
            NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.newsTableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
           // [self.newsTableView endUpdates];
            //[self.newsTableView reloadData];
        }
        
        
       
        if (isOpenActivityIndicatorView == YES) {
            [self disableActivityIndicator];
        }
        
        
      //  _NewsPostData=(NSMutableArray*)result;
       // [_newsTableView reloadData];
              // [SVProgressHUD dismiss];
    }
    
//    if (tag == YouTubeVideoTag) {
//        
//        NSString *result = responseObject;
//        YouTubeIdString = [self getYouTubeVideoURL:result];
//        [_newsTableView reloadData];
//        NSLog(@"YouTube Result = %@",YouTubeIdString);
//        
//    }
    
    if (tag == NavigationMenuTag) {
        
        NoDataInNavigationMenuLable.hidden = YES;
        _MenuCollectionView.hidden = NO;
        
        NSArray *result = [responseObject mutableCopy];
        NSLog(@"COmplete = %@",result);
        self.NavigationMenuDataArray = [[result valueForKey:@"app-navigation"] valueForKey:@"items"];
        NSLog(@"Menu Data == %@",self.NavigationMenuDataArray);
        [_MenuCollectionView reloadData];
    }
    
}
-(void)syncFailure:(NSError*)error withTag:(NSInteger)tag{
    
    if (tag == NewsPostTag) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.newsTableView.hidden = YES;
        lblNoDataAvailable.hidden = NO;
        StatusBarActivityIndicatorHide;
        if ([refreshControl isRefreshing]) {
            [refreshControl endRefreshing];
        }
        if (isOpenActivityIndicatorView == YES) {
            [self disableActivityIndicator];
        }
        showAlert(@"Error", @"We are unable to connect to our servers.\rPlease check your connection.");
        //[SVProgressHUD dismiss];
        NSLog(@"ERROR = %@",error);
    }
//    if (tag == YouTubeVideoTag) {
//        NSLog(@"YouTube Video Error :- %@",error);
//    }
    
    if (tag == NavigationMenuTag) {
        
        NoDataInNavigationMenuLable.hidden = NO;
        _MenuCollectionView.hidden = YES;
    }
}

#pragma mark - UITableviewDelegateMethods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.NewsPostData.count+1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _NewsPostData.count) {
        LoadingCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        if (cell==nil) {
            [tableView registerNib:[UINib nibWithNibName:@"LoadingCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
            cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator startAnimating];
        indicator.center                   = CGPointMake(cell.LoadingActivityView.frame.size.width / 2.0, cell.LoadingActivityView.frame.size.height / 2.0);
        [indicator setTintColor:[UIColor blackColor]];
        [cell.LoadingActivityView addSubview:indicator];
        
        return cell;
    }
    
    NSString *formatString = [[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"format"];
    
    if ([formatString isEqualToString:StandardPostType]) {
       
        StandardCell *cell=[tableView dequeueReusableCellWithIdentifier:IdentifierForStandardCell];
        
        if (cell==nil) {
            [tableView registerNib:[UINib nibWithNibName:@"StandardCell" bundle:nil] forCellReuseIdentifier:IdentifierForStandardCell];
            cell=[tableView dequeueReusableCellWithIdentifier:IdentifierForStandardCell];
        }
        // Cell select karti vakhte gray thai jay che ae effect aa line mukya pachi disable thai jase.
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSString *FeautureImageUrlString = [[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"featured_image_url"];
        
        
        
        NSString *titleString = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"title"] valueForKey:GetContentFromAPI];
        
        cell.dateLable.text = [[UtilFunctions class] getDateFromStringDate:[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"date"]];
        
        cell.TitleLable.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titleString];
        
        cell.TitleLable = setLableSize(cell.TitleLable, [UIFont fontWithName:TitleFontName size:22]);
        
        if ([FeautureImageUrlString isEqualToString:@""]) {
            
            cell.FeatureImage.hidden = YES;
             cell.TitleLable.frame = CGRectMake(__X__(cell.TitleLable),CellYSpace, __WIDTH__(cell.TitleLable), __HEIGHT__(cell.TitleLable));
            
        }else{
            
//            float fiwidth = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"ftiwidth"] floatValue];
//            float ftiheight = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"ftiheight"] floatValue];
//            int intWidth = (int)fiwidth;
//            int intheight = (int)ftiheight;
            if ([[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"ftiwidth"]==(id)[NSNull null] ||[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"ftiheight"]==(id)[NSNull null]) {
                
                cell.FeatureImage.hidden = YES;
                cell.TitleLable.frame = CGRectMake(__X__(cell.TitleLable),CellYSpace, __WIDTH__(cell.TitleLable), __HEIGHT__(cell.TitleLable));
                
            }else{
                float fiwidth = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"ftiwidth"] floatValue];
                float ftiheight = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"ftiheight"] floatValue];
            float ratio = fiwidth/tableView.frame.size.width;
            float height4 = ftiheight/ratio;
            //                UIImage *uImage = cell.FeatureImage.image;
            //                float Wid = uImage.size.width;
            //                float retio = Wid/tableView.frame.size.width;
            //                float height11 = uImage.size.height/retio;
            cell.FeatureImage.frame = CGRectMake(0, 0, cell.FeatureImage.frame.size.width, height4);
            
            
            cell.FeatureImage.hidden = NO;
            //cell.FeatureImage.frame = CGRectMake(0, 0, 0, 0);
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [indicator startAnimating];
            indicator.center                   = CGPointMake(cell.FeatureImage.frame.size.width / 2.0, cell.FeatureImage.frame.size.height / 2.0);
            [cell.FeatureImage addSubview:indicator];
            
            [cell.FeatureImage sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@", FeautureImageUrlString] stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (FeautureImageUrlString.length<=0 || error) {
                    cell.FeatureImage.image=[UIImage imageNamed:@"imageplaceholder_1.png"];
                }
                if (FeautureImageUrlString.length<=0 || error) {
                    cell.FeatureImage.frame = CGRectMake(0, 0, cell.FeatureImage.frame.size.width, YouTubeVideoViewHeight);
                    
                }else{
                    
                }
                
                
                [indicator removeFromSuperview];
                
                
                
            }];
            cell.TitleLable.frame = CGRectMake(__X__(cell.TitleLable),__Y__(cell.FeatureImage)+__HEIGHT__(cell.FeatureImage)+SpaceBetweenAudioViewAndTitleLable, __WIDTH__(cell.TitleLable), __HEIGHT__(cell.TitleLable));
                
            }
           // [cell.FeatureImage setContentMode:UIViewContentModeScaleAspectFit];
            
           // cell.FeatureImage.frame = CGRectMake(__X__(cell.FeatureImage), __Y__(cell.FeatureImage), __WIDTH__(cell.FeatureImage), __HEIGHT__(cell.FeatureImage));
            
           //  cell.TitleLable.frame = CGRectMake(__X__(cell.TitleLable),__Y__(cell.FeatureImage)+__HEIGHT__(cell.FeatureImage)+SpaceBetweenAudioViewAndTitleLable, __WIDTH__(cell.TitleLable), __HEIGHT__(cell.TitleLable));
            
        }
        
       cell.dateView.frame = CGRectMake(cell.dateView.frame.origin.x,cell.TitleLable.frame.origin.y+cell.TitleLable.frame.size.height + SpaceBetweenDateViewAndTitleLable,cell.dateView.frame.size.width,cell.dateView.frame.size.height);
        
        NSString *discriptionString = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:GetDiscriptionFromAPI] valueForKey:GetContentFromAPI];
        
        cell.descriptionLable.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:discriptionString];
        
        cell.descriptionLable = setLableSize(cell.descriptionLable, [UIFont fontWithName:DescriptionFontName size:14]);
        
        
        cell.descriptionLable.frame = CGRectMake(cell.descriptionLable.frame.origin.x, cell.dateView.frame.origin.y+cell.dateView.frame.size.height+SpaceBetweenDateViewAndDescriptionLable, __WIDTH__(cell.descriptionLable), __HEIGHT__(cell.descriptionLable));
        
//        NSString *authorNameStr = [NSString stringWithFormat:@"Via: %@",[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:AuthorKey]];
//
//        cell.AuthorName.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:authorNameStr];
//
//        cell.AuthorName = setLableSize(cell.AuthorName, [UIFont fontWithName:RegularFont size:14]);
//
//        cell.AuthorName.frame = CGRectMake(__X__(cell.AuthorName),cell.descriptionLable.frame.origin.y+cell.descriptionLable.frame.size.height+SpaceBetweenAuthorNameAndDescription, __WIDTH__(cell.AuthorName), __HEIGHT__(cell.AuthorName));
       
        [cell setNeedsLayout];
        
        [cell layoutIfNeeded];
        
        return cell;
        
    }else if ([formatString isEqualToString:AudioPostType]){
        
        AudioCell *cell=[tableView dequeueReusableCellWithIdentifier:IdentifierForAudioCell];
        
        if (cell==nil) {
            [tableView registerNib:[UINib nibWithNibName:@"AudioCell" bundle:nil] forCellReuseIdentifier:IdentifierForAudioCell];
            cell=[tableView dequeueReusableCellWithIdentifier:IdentifierForAudioCell];
            
            
        }
        
        cell.AudioURLString = [[self.NewsPostData objectAtIndex:indexPath.row]valueForKey:@"media_url"];
        // Cell select karti vakhte gray thai jay che ae effect aa line mukya pachi disable thai jase.
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.playPauseButton addTarget:self action:@selector(CallPlayAudioButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.playPauseButton.tag = indexPath.row;
        
        
        cell.audioView.frame = CGRectMake(__X__(cell.audioView), __Y__(cell.audioView), __WIDTH__(cell.audioView), __HEIGHT__(cell.audioView));
        
        
        NSString *titleString = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"title"] valueForKey:GetContentFromAPI];
        
        cell.titleLable.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titleString];
        
        cell.titleLable = setLableSize(cell.titleLable, [UIFont fontWithName:TitleFontName size:22]);
        
        cell.titleLable.frame = CGRectMake(__X__(cell.titleLable),__Y__(cell.audioView)+__HEIGHT__(cell.audioView)+SpaceBetweenAudioViewAndTitleLable, __WIDTH__(cell.titleLable), __HEIGHT__(cell.titleLable));
        
        cell.dateLable.text = [[UtilFunctions class] getDateFromStringDate:[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"date"]];
        
        cell.dateView.frame = CGRectMake(cell.dateView.frame.origin.x,cell.titleLable.frame.origin.y+cell.titleLable.frame.size.height + SpaceBetweenDateViewAndTitleLable,cell.dateView.frame.size.width,cell.dateView.frame.size.height);
        
        NSString * DiscriptionString = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:GetDiscriptionFromAPI] valueForKey:GetContentFromAPI];
        
//        NSString *authorNameStr = [NSString stringWithFormat:@"Via: %@",[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:AuthorKey]];
//
//        cell.AuthorName.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:authorNameStr];
//
//        cell.AuthorName = setLableSize(cell.AuthorName, [UIFont fontWithName:RegularFont size:14]);
        
//        cell.AuthorName.frame = CGRectMake(__X__(cell.AuthorName),cell.descriptionLable.frame.origin.y+cell.descriptionLable.frame.size.height+SpaceBetweenAuthorNameAndDescription, __WIDTH__(cell.AuthorName), __HEIGHT__(cell.AuthorName));
        
        if ([DiscriptionString isEqualToString:@""]) {
            
            cell.descriptionLable.hidden = YES;
            
//            cell.AuthorName.frame = CGRectMake(__X__(cell.AuthorName), __Y__(cell.dateView)+__HEIGHT__(cell.dateView)+SpaceBetweenAuthorNameAndDescription, __WIDTH__(cell.AuthorName), __HEIGHT__(cell.AuthorName));
            
           //  cell.audioView.frame = CGRectMake(cell.audioView.frame.origin.x, cell.dateView.frame.origin.y+cell.dateView.frame.size.height+SpaceBetweenDateViewAndDescriptionLable, __WIDTH__(cell.audioView), __HEIGHT__(cell.audioView));
            
            
        }else{
            cell.descriptionLable.hidden = NO;
            
            cell.descriptionLable.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:DiscriptionString];
            
            cell.descriptionLable = setLableSize(cell.descriptionLable, [UIFont fontWithName:DescriptionFontName size:14]);
            
            
            cell.descriptionLable.frame = CGRectMake(cell.descriptionLable.frame.origin.x, cell.dateView.frame.origin.y+cell.dateView.frame.size.height+SpaceBetweenDateViewAndDescriptionLable, __WIDTH__(cell.descriptionLable), __HEIGHT__(cell.descriptionLable));

//             cell.AuthorName.frame = CGRectMake(__X__(cell.AuthorName),cell.descriptionLable.frame.origin.y+cell.descriptionLable.frame.size.height+SpaceBetweenAuthorNameAndDescription, __WIDTH__(cell.AuthorName), __HEIGHT__(cell.AuthorName));
            //  cell.audioView.frame = CGRectMake(cell.audioView.frame.origin.x, cell.descriptionLable.frame.origin.y+cell.descriptionLable.frame.size.height+SpaceBetweenAudioViewAndDescriptionLable, __WIDTH__(cell.audioView), __HEIGHT__(cell.audioView));
            
        }
        
        return cell;
    }else{
        VideoCell *cell=[tableView dequeueReusableCellWithIdentifier:IdentifierForVideoCell];
        
        if (cell==nil) {
            [tableView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellReuseIdentifier:IdentifierForVideoCell];
            cell=[tableView dequeueReusableCellWithIdentifier:IdentifierForVideoCell];
        }
        
        // Cell select karti vakhte gray thai jay che ae effect aa line mukya pachi disable thai jase.
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
//            [self loadYouTubeVideo:[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"id"] loadyoutubeview:^(NSString *videoID) {
//                cell.VideoView.delegate = self;
//                NSString *videoId = videoID;
//                NSDictionary *playerVars = @{
//                                             @"controls" : @1,
//                                             @"playsinline" : @1,
//                                             @"autohide" : @1,
//                                             @"showinfo" : @0,
//                                             @"modestbranding" : @1
//
//
//                                             };
//
//                [cell.VideoView loadWithVideoId:videoId playerVars:playerVars];
//
//
//                cell.VideoView.tag = indexPath.row;
//            }];
       
        NSDictionary *playerVars = @{
                                     @"controls" : @1,
                                     @"playsinline" : @1,
                                     @"autohide" : @1,
                                     @"showinfo" : @0,
                                     @"modestbranding" : @1
                                     };
        NSString *videoId = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"youtube_video"]valueForKey:@"video_id"];
        [cell.VideoView loadWithVideoId:videoId playerVars:playerVars];
        
        cell.VideoView.frame = CGRectMake(__X__(cell.VideoView), __Y__(cell.VideoView), __WIDTH__(cell.VideoView),__HEIGHT__(cell.VideoView));
        
        NSString *titleString = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"title"] valueForKey:GetContentFromAPI];
        
        cell.titleLable.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titleString];
        
        cell.titleLable = setLableSize(cell.titleLable, [UIFont fontWithName:TitleFontName size:22]);
        
        cell.titleLable.frame = CGRectMake(__X__(cell.titleLable),__Y__(cell.VideoView)+__HEIGHT__(cell.VideoView)+ SpaceBetweenAudioViewAndTitleLable, __WIDTH__(cell.titleLable), __HEIGHT__(cell.titleLable));
        
        cell.dateLable.text = [[UtilFunctions class] getDateFromStringDate:[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"date"]];
        
         cell.dateView.frame = CGRectMake(cell.dateView.frame.origin.x,cell.titleLable.frame.origin.y+cell.titleLable.frame.size.height + SpaceBetweenDateViewAndTitleLable,cell.dateView.frame.size.width,cell.dateView.frame.size.height);
        
//        NSString *authorNameStr = [NSString stringWithFormat:@"Via: %@",[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:AuthorKey]];
//
//        cell.AuthorName.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:authorNameStr];
//
//        cell.AuthorName = setLableSize(cell.AuthorName, [UIFont fontWithName:RegularFont size:14]);
//
//        cell.AuthorName.frame = CGRectMake(__X__(cell.AuthorName), __Y__(cell.dateView)+__HEIGHT__(cell.dateView)+SpaceBetweenAuthorNameAndDescription, __WIDTH__(cell.AuthorName), __HEIGHT__(cell.AuthorName));
      //  cell.VideoView.frame = CGRectMake(__X__(cell.VideoView), cell.dateView.frame.origin.y+cell.dateView.frame.size.height+SpaceBetweenDateViewAndDescriptionLable, __WIDTH__(cell.VideoView),__HEIGHT__(cell.VideoView));
        
        return cell;
    }
    
    

}

-(IBAction)CallPlayAudioButton:(UIButton *)sender{
    
    NSLog(@"Call");
    
    if([Utility CheckForInternet]){
        [UIView animateWithDuration:0.1 animations:^{
            mainAudioViewIsOpen = YES;
            APPDELEGATE.AudioViewControllerStatusId = AudioNewsViewcontrollerStatusId;
            [PlayPauseBtnMainAudioview setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
            
            if (IS_IPHONE_4_OR_LESS) {
                
                _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 330);
                _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(_mainAudioView), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(_mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            }else{
            _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 418);
            _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(_mainAudioView), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
            tabView.frame = CGRectMake(__X__(tabView), __Y__(_mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            }
        } completion:^(BOOL finished) {
            
            newsTitleString = [NSString stringWithFormat:@"%@",[[[_NewsPostData objectAtIndex:sender.tag]valueForKey:@"title"]valueForKey:GetContentFromAPI]];
            APPDELEGATE.AudioTitleStr = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:newsTitleString];
            APPDELEGATE.AudioURLStr = [NSString stringWithFormat:@"%@",[[_NewsPostData objectAtIndex:sender.tag]valueForKey:@"media_url"]];
            NSURL *url = [NSURL URLWithString:APPDELEGATE.AudioURLStr];
            
            STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
            
            [APPDELEGATE.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
            
        }];
    }
    else{
        
        showAlert(@"Check Connection", @"Internet is not available.");
    }
    
    
    

}

- (IBAction)didActionToPlayPauseInMainAudioPlayer:(UIButton *)sender {
    
    NSData *image1 = UIImagePNGRepresentation([UIImage imageNamed:@"play_player"]);
    
    if ([image1 isEqual:UIImagePNGRepresentation(sender.currentImage)]) {
        if ([Utility CheckForInternet]) {
        
        [PlayPauseBtnMainAudioview setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
       
        NSURL *url = [NSURL URLWithString:APPDELEGATE.AudioURLStr];
        
        STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
        
        [APPDELEGATE.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
        }else{
            showAlert(@"Check Connection", @"Internet is not available.");
        }
    }else{
        mainAudioViewIsOpen = NO;
        [UIView animateWithDuration:0.1 animations:^{
            [PlayPauseBtnMainAudioview setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            if (IS_IPHONE_4_OR_LESS) {
                _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 378);
            }else{
            _newsTableView.frame = CGRectMake(0,__Y__(_newsTableView), __WIDTH__(_newsTableView), 466);
            }
            [self.view bringSubviewToFront:hedderView];
            _mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view), __WIDTH__(_mainAudioView), __HEIGHT__(_mainAudioView));
            tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            
        } completion:^(BOOL finished) {
            [APPDELEGATE.audioPlayer pause];
        }];
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
        newsTitleLable.text = APPDELEGATE.AudioTitleStr;
        ArtistLblInMainAudioView.text = APPDELEGATE.LockScreenArtistStr;
        ArtistLblInMainAudioView.hidden = NO;
        ProgressLblMainAudioView.hidden = YES;
        DurationLblMainAudioView.hidden = YES;
        seperateLineInMainAudioView.hidden = YES;
    }else{
        ArtistLblInMainAudioView.hidden = YES;
        ProgressLblMainAudioView.hidden = YES;
        DurationLblMainAudioView.hidden = NO;
        seperateLineInMainAudioView.hidden = YES;
        newsTitleLable.text = APPDELEGATE.AudioTitleStr;
        //ProgressLblMainAudioView.text = APPDELEGATE.AudioProgressTimeStr;
        DurationLblMainAudioView.text = APPDELEGATE.AudioMainProgressString;
        
        if (APPDELEGATE.RemainingTimeInAppDelegate == 0) {
            [PlayPauseBtnMainAudioview setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            APPDELEGATE.RemainingTimeInAppDelegate = 1;
        }
       
//        if ([ProgressLblMainAudioView.text isEqualToString:DurationLblMainAudioView.text] && ![ProgressLblMainAudioView.text isEqualToString:@"00:00:00"] && ![DurationLblMainAudioView.text isEqualToString:@"00:00:00"]) {
//            [PlayPauseBtnMainAudioview setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
//        }
    }
    
//    if (!APPDELEGATE.audioPlayer)
//    {
//
//        ProgressLblMainAudioView.text = @"00:00:00";
//
//
//        return;
//    }
//
//    if (APPDELEGATE.audioPlayer.currentlyPlayingQueueItemId == nil)
//    {
//
//
//        ProgressLblMainAudioView.text = @"00:00:00";
//
//        return;
//    }
//
//    if (APPDELEGATE.audioPlayer.duration != 0 && APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying && APPDELEGATE.AudioViewControllerStatusId == AudioNewsViewcontrollerStatusId)
//    {
//        ProgressLblMainAudioView.text = [NSString stringWithFormat:@"%@",[self formatTimeFromSeconds:APPDELEGATE.audioPlayer.progress]];
//        DurationLblMainAudioView.text = [NSString stringWithFormat:@"%@",[self formatTimeFromSeconds:APPDELEGATE.audioPlayer.duration]];
//
//    }
//    else
//    {
//
//    }
//    if ([ProgressLblMainAudioView.text isEqualToString:DurationLblMainAudioView.text]&& ![ProgressLblMainAudioView.text isEqualToString:@"00:00:00"]&&![DurationLblMainAudioView.text isEqualToString:@"00:00:00"]) {
//        [PlayPauseBtnMainAudioview setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
//    }
}
-(NSString*) formatTimeFromSeconds:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%2d:%2d:%2d", hours, minutes, seconds];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == _NewsPostData.count) {
        return 60;
    }
    
     NSString *formatString = [[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"format"];
    
    if ([formatString isEqualToString:StandardPostType]) {
        
        UILabel * Title     = [[UILabel alloc] init];
        Title.frame         = CGRectMake( 0, 16, 288, 15);
        Title.numberOfLines = 0;
        
        NSString *titleString = [[[self.NewsPostData objectAtIndex:indexPath.row]valueForKey:@"title"] valueForKey:GetContentFromAPI];
        
        Title.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titleString];
        
        Title      = setLableSize(Title, [UIFont fontWithName:TitleFontName size:22]);
        
        UILabel * description     = [[UILabel alloc] init];
        description.frame         = CGRectMake( 0, 16, 288, 15);
        description.numberOfLines = 0;
        
        NSString *discriptionString = [[[self.NewsPostData objectAtIndex:indexPath.row]valueForKey:GetDiscriptionFromAPI] valueForKey:GetContentFromAPI];
        
        description.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:discriptionString];
        
        description      = setLableSize(description, [UIFont fontWithName:DescriptionFontName size:14]);
        
//        UILabel *AuthorLable = [[UILabel alloc] init];
//        AuthorLable.frame         = CGRectMake( 0, 16, 288, 15);
//        AuthorLable.numberOfLines = 0;
//
//        //[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:AuthorKey];
//        NSString *AuthorString = [NSString stringWithFormat:@"Via : %@",[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:AuthorKey]];
//
//        AuthorLable.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:AuthorString];
//
//        AuthorLable      = setLableSize(AuthorLable, [UIFont fontWithName:RegularFont size:14]);
        
        NSString *FeatureImageURLString = [[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"featured_image_url"];
        float cellHeight =0.0;
        if ([FeatureImageURLString isEqualToString:@""]) {
           cellHeight = CellYSpace+Title.frame.size.height+SpaceBetweenDateViewAndTitleLable+DateViewHeight+SpaceBetweenDateViewAndDescriptionLable+description.frame.size.height+CellBottomSpace;
        }else{
            
//            float fiwidth = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"ftiwidth"] floatValue];
//            float ftiheight = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"ftiheight"] floatValue];
//
//            int imgW = (int)fiwidth;
//            int imgH = (int)ftiheight;
            
            if ([[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"ftiwidth"]==(id)[NSNull null] ||[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"ftiheight"]==(id)[NSNull null]) {
                 cellHeight = CellYSpace+Title.frame.size.height+SpaceBetweenDateViewAndTitleLable+DateViewHeight+SpaceBetweenDateViewAndDescriptionLable+description.frame.size.height+CellBottomSpace;
            }else{
                NSLog(@"HERE ID = %@",[[_NewsPostData objectAtIndex:indexPath.row] valueForKey:@"id"]);
                float imageHeight = 0 ;
                
                float fiwidth = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"ftiwidth"] floatValue];
                 float ftiheight = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"ftiheight"] floatValue];
                float ratio = fiwidth/tableView.frame.size.width;
                imageHeight = ftiheight/ratio;
                
                cellHeight = CellYSpace+imageHeight+SpaceBetweenAudioViewAndTitleLable+Title.frame.size.height+SpaceBetweenDateViewAndTitleLable+DateViewHeight+SpaceBetweenDateViewAndDescriptionLable+description.frame.size.height+CellBottomSpace;
            }
            
           // __block float imageHeight11 = 0;
            
//            UIImageView *imageview11 = [[UIImageView alloc] init];
//            [imageview11 sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@", FeatureImageURLString] stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//                if (FeatureImageURLString.length<=0 || error) {
//                    imageHeight11 = YouTubeVideoViewHeight;
//                }else{
//                UIImage *uImage = image;
//                float Wid = uImage.size.width;
//                float retio = Wid/tableView.frame.size.width;
//                imageHeight11 = uImage.size.height/retio;
//            }
//
//            }];
            
        }
        NSLog(@"Height :== %f",cellHeight);
        return cellHeight;
        
    }else if ([formatString isEqualToString:AudioPostType]){
        
        UILabel * Title     = [[UILabel alloc] init];
        Title.frame         = CGRectMake( 0, 16, 288, 15);
        Title.numberOfLines = 0;
        NSString *titleString = [[[self.NewsPostData objectAtIndex:indexPath.row]valueForKey:@"title"] valueForKey:GetContentFromAPI];
        Title.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titleString];
        
        Title      = setLableSize(Title, [UIFont fontWithName:TitleFontName size:22]);
        
        float CellHeight;
        
         NSString * DiscriptionString = [[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:GetDiscriptionFromAPI] valueForKey:GetContentFromAPI];
        
//        UILabel *AuthorLable = [[UILabel alloc] init];
//        AuthorLable.frame         = CGRectMake( 0, 16, 288, 15);
//        AuthorLable.numberOfLines = 0;
//
//        //[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:AuthorKey];
//        NSString *AuthorString = [NSString stringWithFormat:@"Via : %@",[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:AuthorKey]];
//
//        AuthorLable.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:AuthorString];
//
//        AuthorLable      = setLableSize(AuthorLable, [UIFont fontWithName:RegularFont size:14]);
        
        if ([DiscriptionString isEqualToString:@""]) {
            
            CellHeight = AudioViewHeight  + SpaceBetweenAudioViewAndTitleLable + Title.frame.size.height +  SpaceBetweenDateViewAndTitleLable + DateViewHeight+CellBottomSpace;
            
        }else{
            
            UILabel * description     = [[UILabel alloc] init];
            description.frame         = CGRectMake( 0, 16, 288, 15);
            description.numberOfLines = 0;
            
            description.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:DiscriptionString];
            
            description      = setLableSize(description, [UIFont fontWithName:DescriptionFontName size:14]);
            
            CellHeight = AudioViewHeight + SpaceBetweenAudioViewAndTitleLable + Title.frame.size.height + SpaceBetweenDateViewAndTitleLable + DateViewHeight + SpaceBetweenDateViewAndDescriptionLable + description.frame.size.height + CellBottomSpace;
            //CellYSpace+Title.frame.size.height+SpaceBetweenDateViewAndTitleLable+DateViewHeight+SpaceBetweenDateViewAndDescriptionLable+description.frame.size.height+SpaceBetweenAudioViewAndDescriptionLable+AudioViewHeight+CellBottomSpace;
            
            
        }
        
        return CellHeight;

    }else{
        
        UILabel * Title     = [[UILabel alloc] init];
        Title.frame         = CGRectMake( 0, 16, 288, 15);
        Title.numberOfLines = 0;
        
        NSString *titleString = [[[self.NewsPostData objectAtIndex:indexPath.row]valueForKey:@"title"] valueForKey:GetContentFromAPI];
        
        Title.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titleString];
        
        Title      = setLableSize(Title, [UIFont fontWithName:TitleFontName size:22]);

//        UILabel *AuthorLable = [[UILabel alloc] init];
//        AuthorLable.frame         = CGRectMake( 0, 16, 288, 15);
//        AuthorLable.numberOfLines = 0;
//
//        //[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:AuthorKey];
//        NSString *AuthorString = [NSString stringWithFormat:@"Via : %@",[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:AuthorKey]];
//
//        AuthorLable.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:AuthorString];
//
//        AuthorLable      = setLableSize(AuthorLable, [UIFont fontWithName:RegularFont size:14]);
        
        float cellHeight =  YouTubeVideoViewHeight + SpaceBetweenAudioViewAndTitleLable + Title.frame.size.height + SpaceBetweenDateViewAndTitleLable + DateViewHeight + CellBottomSpace;
        //CellYSpace+Title.frame.size.height+SpaceBetweenDateViewAndTitleLable+DateViewHeight+SpaceBetweenDateViewAndDescriptionLable+YouTubeVideoViewHeight+CellBottomSpace;
        
        return cellHeight;
    }
}
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
//    if ([cell isKindOfClass:[VideoCell class]]) {
//        VideoCell *cell1 = (VideoCell*)cell;
//        [cell1.VideoView pauseVideo];
//    }
//
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Call");
    if (indexPath.row == _NewsPostData.count) {
        
    }else{
    DetailViewController *detailview = [[DetailViewController alloc] init];
    [detailview detailViewNewsPostId:[NSString stringWithFormat:@"%@",[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"id"] ] postFormat:[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"format"]];

    if (isMenuOpen) {
        isMenuOpen = NO;
        [self CloseMenu];
    }
    
    APPDELEGATE.mainTabBar.selectedIndex = 2;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - YoutubeDelegateMethods

- (void)playerView:(nonnull YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{
   
    
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
