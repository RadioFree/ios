//
//  SettingsViewController.m
//  RadioFree
//
//  Created by vivek on 14/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate>
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
    
    IBOutlet UILabel *NoDataInNavigationMenuLable;
    
    IBOutlet UIImageView *NoDataAvailableLable;
    // IBOutlet UILabel *NoDataAvailableLable;
    //IBOutlet UISwitch *notificationSwitch;
    IBOutlet UIView *hedderview;
   // IBOutlet UIView *settingsContentView;
   IBOutlet UIView *activityIndicatorView;
    IBOutlet UIView *tabView;
    IBOutlet UILabel *lblTabIndicatorLine;
    IBOutlet UIButton *btnNews;
    IBOutlet UIButton *btnLive;
    IBOutlet UIView *menuView;
    BOOL isMenuOpen;
    UIImageView *LoaderImage;
    BOOL isOpenActivityIndicatorView;
}
@property (nonatomic, strong) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UITableView *settingsTableview;
@property (strong, nonatomic) IBOutlet UICollectionView *MenuCollectionView;

@property (strong, nonatomic) UIBlurEffect *blurEffect;
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;
//@property (strong, nonatomic) IBOutlet UIScrollView *settingsScrollview;
@property (strong, nonatomic) NSMutableArray *SettingMenuDataArray;
@property (strong, nonatomic) NSMutableArray *NavigationMenuDataArray;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTimer];
    [_MenuCollectionView registerNib:[UINib nibWithNibName:@"SettingsMenuCell" bundle:nil] forCellWithReuseIdentifier:@"menucell"];
    
    [self iphone4sSupport];
    
    _NavigationMenuDataArray = [[NSMutableArray alloc] init];
    if (IS_IPHONE_4_OR_LESS) {
        //  ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
        activityIndicatorView.frame = CGRectMake(__X__(self.settingsTableview), __Y__(self.settingsTableview), __WIDTH__(self.settingsTableview),__HEIGHT__(self.settingsTableview));
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
    _SettingMenuDataArray = [[NSMutableArray alloc] init];
    // menuview ni frame set kari ane self.view ma add karyo
    menuView.frame = CGRectMake(0, __HEIGHT__(self.view), __WIDTH__(self.view), __HEIGHT__(menuView));
    [self.view addSubview:menuView];
    
    [self addTapGestureInDetailsview];

    _settingsTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // content scrollview nu settings
//    _settingsScrollview.frame = CGRectMake(0, __HEIGHT__(hedderview), __WIDTH__(_settingsScrollview), __HEIGHT__(_settingsScrollview));
//    settingsContentView.frame = CGRectMake(0, 0, __WIDTH__(settingsContentView), __HEIGHT__(settingsContentView));
//    [_settingsScrollview addSubview:settingsContentView];
//    _settingsScrollview.contentSize = CGSizeMake(__WIDTH__(_settingsScrollview), __HEIGHT__(_settingsScrollview));
//    [self.view addSubview:_settingsScrollview];
//    [self.view bringSubviewToFront:tabView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)iphone4sSupport{
    if (IS_IPHONE_4_OR_LESS) {
        self.settingsTableview.frame = CGRectMake(self.settingsTableview.frame.origin.x, self.settingsTableview.frame.origin.y, self.settingsTableview.frame.size.width, 378);
        // ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
        
        
        
        tabView.frame = CGRectMake(tabView.frame.origin.x,480 -tabView.frame.size.height, tabView.frame.size.width, tabView.frame.size.height);
        
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
        //progressLblInMainAudioView.text = APPDELEGATE.AudioProgressTimeStr;
        DurationLblInMainAudioView.text = APPDELEGATE.AudioMainProgressString;
        
        if (APPDELEGATE.RemainingTimeInAppDelegate == 0) {
            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            APPDELEGATE.RemainingTimeInAppDelegate = 1;
        }
        
        
//        if ([progressLblInMainAudioView.text isEqualToString:DurationLblInMainAudioView.text] && ![progressLblInMainAudioView.text isEqualToString:@"00:00:00"] && ![DurationLblInMainAudioView.text isEqualToString:@"00:00:00"]) {
//            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
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
-(void)viewWillAppear:(BOOL)animated{
    
    if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying  || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
        
        
            [UIView animateWithDuration:0.1 animations:^{
                mainAudioViewIsOpen = YES;
                
                [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
                if (IS_IPHONE_4_OR_LESS) {
                    
                   _settingsTableview.frame = CGRectMake(0,__Y__(_settingsTableview), __WIDTH__(_settingsTableview), 330);
                    MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                
                _settingsTableview.frame = CGRectMake(0,__Y__(_settingsTableview), __WIDTH__(_settingsTableview), 418);
                MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }
            } completion:^(BOOL finished) {
                
            }];
        
    }
    
    [self initialSettings];
    [self callInternetValidationForSettingsMenuData];
    [self CallInterNetValidationForNaviagationMenu];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    if (_settingsTableview.hidden == NO) {
        _settingsTableview.hidden = YES;
    }
    
    if (wasMainAudioViewOpen == YES) {
        wasMainAudioViewOpen = NO;
    }
    if (mainAudioViewIsOpen == YES) {
        mainAudioViewIsOpen = NO;
        
        [UIView animateWithDuration:0.1 animations:^{
            [playPauseBtnInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            
            if (IS_IPHONE_4_OR_LESS) {
                _settingsTableview.frame = CGRectMake(0,__Y__(_settingsTableview), __WIDTH__(_settingsTableview), 378);
            }else{
                _settingsTableview.frame = CGRectMake(0,__Y__(_settingsTableview), __WIDTH__(_settingsTableview), 466);
            }
            
            MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
            
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
        activityIndicatorView.frame = CGRectMake(__X__(self.settingsTableview), __Y__(self.settingsTableview), __WIDTH__(self.settingsTableview), __HEIGHT__(self.settingsTableview));
    }else{
    
    activityIndicatorView.frame = CGRectMake(__X__(self.settingsTableview), __Y__(self.settingsTableview),__WIDTH__(self.settingsTableview) , __HEIGHT__(self.settingsTableview));
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
        if (index != 3) {
            
            APPDELEGATE.mainTabBar.selectedIndex = index;
//            if (index == 0) {
//                 APPDELEGATE.mainTabBar.selectedIndex = index;
//            }else{
//            NSInteger controllerIndex = index;
//            UIView * fromView = APPDELEGATE.mainTabBar.selectedViewController.view;
//            UIView * toView = [[APPDELEGATE.mainTabBar.viewControllers objectAtIndex:controllerIndex] view];
//
//            // Transition using a page curl.
//            [UIView transitionFromView:fromView
//                                toView:toView
//                              duration:0.5
//                               options:(controllerIndex > APPDELEGATE.mainTabBar.selectedIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight)
//                            completion:^(BOOL finished) {
//                                if (finished) {
//                                    APPDELEGATE.mainTabBar.selectedIndex = controllerIndex;
//                                }
//                            }];
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
    _blurEffectView.frame = CGRectMake(__X__(_settingsTableview), __Y__(_settingsTableview),__WIDTH__(_settingsTableview), __HEIGHT__(_settingsTableview));
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
    
                    _settingsTableview.frame = CGRectMake(0,__Y__(_settingsTableview), __WIDTH__(_settingsTableview), 330);
                    MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{

                _settingsTableview.frame = CGRectMake(0,__Y__(_settingsTableview), __WIDTH__(_settingsTableview), 418);
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

//- (IBAction)didActionToFeedBack:(id)sender {
//
//    NSString *emailTitle = @"Feedback";
//    // Email Content
//    NSString *messageBody = @"";
//    // To address chase@chaselang.com
//    NSArray *toRecipents = [NSArray arrayWithObject:@"chase@chaselang.com"];
//
//    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//    mc.mailComposeDelegate = self;
//    [mc setSubject:emailTitle];
//    [mc setMessageBody:messageBody isHTML:NO];
//    [mc setToRecipients:toRecipents];
//
//    // Present mail view controller on screen
//    [self presentViewController:mc animated:YES completion:NULL];
//
//}
//- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
//{
//    switch (result)
//    {
//        case MFMailComposeResultCancelled:
//            NSLog(@"Mail cancelled");
//            break;
//        case MFMailComposeResultSaved:
//            NSLog(@"Mail saved");
//            break;
//        case MFMailComposeResultSent:
//            NSLog(@"Mail sent");
//            break;
//        case MFMailComposeResultFailed:
//            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
//            break;
//        default:
//            break;
//    }
//
//    // Close the Mail Interface
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}

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
                _settingsTableview.frame = CGRectMake(0,__Y__(_settingsTableview), __WIDTH__(_settingsTableview), 378);
            }else{
                _settingsTableview.frame = CGRectMake(0,__Y__(_settingsTableview), __WIDTH__(_settingsTableview), 466);
            }
            
            
            if (isOpenActivityIndicatorView == YES) {
                activityIndicatorView.frame = CGRectMake(__X__(_settingsTableview), __Y__(_settingsTableview), __WIDTH__(_settingsTableview), __HEIGHT__(_settingsTableview));
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
                    
                    _settingsTableview.frame = CGRectMake(0,__Y__(_settingsTableview), __WIDTH__(_settingsTableview), 330);
                    MainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(MainAudioView), __WIDTH__(MainAudioView), __HEIGHT__(MainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(MainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                _settingsTableview.frame = CGRectMake(0,__Y__(_settingsTableview), __WIDTH__(_settingsTableview), 418);
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
                        _settingsTableview.frame = CGRectMake(0,__Y__(_settingsTableview), __WIDTH__(_settingsTableview), 378);
                    }else{
                        _settingsTableview.frame = CGRectMake(0,__Y__(_settingsTableview), __WIDTH__(_settingsTableview), 466);
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
}

//- (IBAction)didActionToTermsOfuseButton:(UIButton *)sender {
//    if (isMenuOpen) {
//        isMenuOpen = NO;
//        [self CloseMenu];
//    }
//    SettingsSubViewController *settingsSubview = [[SettingsSubViewController alloc] init];
//    [settingsSubview getSettingsKey:sender.tag];
//    APPDELEGATE.mainTabBar.selectedIndex = 7;
//
//}

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

-(void)callInternetValidationForSettingsMenuData{
    
    if([Utility CheckForInternet]){
        [self enableActivityIndicator];
       
        
        [self callWebServicesForSettingsMenuData];
        
    }
    else{
        NoDataAvailableLable.hidden = NO;
        _settingsTableview.hidden = YES;
        showAlert(@"Check Connection", @"Internet is not available.");
    }
}

-(void)callWebServerForNaviagationMenuData{
    
    NSString *MainURL = [NSString stringWithFormat:@"%@",MenuURL];
    
    SyncManager *syncmanager = [[SyncManager alloc] init];
    syncmanager.delegate = self;
    
    [syncmanager webServiceCall:MainURL withParams:@{} withTag:MenuTag];
}

-(void)callWebServicesForSettingsMenuData{
    
    NSString *MainURL = [NSString stringWithFormat:@"%@",MenuURL];
    
    SyncManager *syncmanager = [[SyncManager alloc] init];
    syncmanager.delegate = self;
    
    [syncmanager webServiceCall:MainURL withParams:@{} withTag:NavigationMenuTag];
    
}
-(void)syncSuccess:(id)responseObject withTag:(NSInteger)tag{
    
    if (tag == MenuTag) {
        
        if (responseObject) {
            NSArray *result = [responseObject mutableCopy];
            self.SettingMenuDataArray = [[result valueForKey:@"app-settings"] valueForKey:@"items"];
            NSLog(@"Data = %@",self.SettingMenuDataArray);
            NSLog(@"COmplete = %@",result);
            [_settingsTableview reloadData];
        }else{
            
        }
        NoDataAvailableLable.hidden = YES;
        _settingsTableview.hidden = NO;
        if (isOpenActivityIndicatorView == YES) {
            [self disableActivityIndicator];
        }
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
    
    if (tag == MenuTag) {
//        if (isOpenActivityIndicatorView == YES) {
//            [self disableActivityIndicator];
//        }
        if (isOpenActivityIndicatorView == YES) {
            [self disableActivityIndicator];
        }
        _settingsTableview.hidden = YES;
        NoDataAvailableLable.hidden = NO;
        showAlert(@"Error", @"We are unable to connect to our servers.\rPlease check your connection.");
        
        NSLog(@"Error == >> %@",error);
    }
    
    if (tag == NavigationMenuTag) {
        
        NoDataInNavigationMenuLable.hidden = NO;
         _MenuCollectionView.hidden = YES;
    }
    
}

#pragma mark - UITableviewDelegateMethods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.SettingMenuDataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SettingsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"settingscell"];
    
    if (cell==nil) {
        [tableView registerNib:[UINib nibWithNibName:@"SettingsCell" bundle:nil] forCellReuseIdentifier:@"settingscell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"settingscell"];
    }
    
    cell.SettingsTitle.text = [[self.SettingMenuDataArray objectAtIndex:indexPath.row] objectAtIndex:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Call");
    
//        DetailViewController *detailview = [[DetailViewController alloc] init];
//        [detailview detailViewNewsPostId:[NSString stringWithFormat:@"%@",[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"id"] ] postFormat:[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:@"format"]];
//
 //       if (isMenuOpen) {
//            isMenuOpen = NO;
//            [self CloseMenu];
//        }
//
//        APPDELEGATE.mainTabBar.selectedIndex = 2;
  
    SettingsSubViewController *settingsSubview = [[SettingsSubViewController alloc] init];
    [settingsSubview getPostTypeValueForSettings:[[_SettingMenuDataArray objectAtIndex:indexPath.row] objectAtIndex:4]];
    [settingsSubview getPostTypeValueForZeroUrl:[[_SettingMenuDataArray objectAtIndex:indexPath.row] objectAtIndex:2]];
    APPDELEGATE.mainTabBar.selectedIndex = 7;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
