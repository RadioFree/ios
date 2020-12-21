//
//  BookMarkViewController.m
//  RadioFree
//
//  Created by vivek on 14/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//

#import "BookMarkViewController.h"

@interface BookMarkViewController ()<UIGestureRecognizerDelegate,YTPlayerViewDelegate>
{
    
    IBOutlet UILabel *ArtistLblInMainAudioView;
    IBOutlet UILabel *seperateLineInMainAudioView;
    IBOutlet UIImageView *NullDataPlaceholderImage;
    IBOutlet UIImageView *noDataAvailableLable;
    IBOutlet UILabel *NoDataInNavigationMenuLable;
    IBOutlet UILabel *durationLableInMainAudioView;
    IBOutlet UILabel *progressLableInMainAudioView;
    IBOutlet UILabel *titleLableInMainAudioView;
    IBOutlet UIButton *playPauseButtonInMainAudioView;
    IBOutlet UIView *mainAudioView;
    BOOL isMainAudioViewOpen;
    BOOL wasMainAudioViewOpen;
   // IBOutlet UILabel *noDataAvailableLable;
    IBOutlet UIView *tabView;
    IBOutlet UILabel *lblTabIndicatorLine;
    IBOutlet UIButton *btnNews;
    IBOutlet UIButton *btnLive;
    IBOutlet UIView *menuView;
    BOOL isMenuOpen;
    NSString *newsTitleString;
}
@property (strong, nonatomic) NSString *AudioUrlString;
@property (nonatomic, strong) DBManager *dbManager;
@property (strong, nonatomic) NSMutableArray *BookMarkDataArray;
@property (strong, nonatomic) IBOutlet UITableView *bookMarkTableView;
@property (strong, nonatomic) UIBlurEffect *blurEffect;
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;

@property (strong, nonatomic) IBOutlet UICollectionView *MenuCollectionView;
@property (strong, nonatomic) NSMutableArray *NavigationMenuDataArray;

@end

@implementation BookMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _NavigationMenuDataArray = [[NSMutableArray alloc] init];
    [_MenuCollectionView registerNib:[UINib nibWithNibName:@"SettingsMenuCell" bundle:nil] forCellWithReuseIdentifier:@"menucell"];
    [self iphone4sSupport];
    [self setupTimer];
    self.BookMarkDataArray = [[NSMutableArray alloc] init];
    // To Do MainAudioView
    mainAudioView.frame = CGRectMake(0, self.view.frame.size.height, __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
    [self.view addSubview:mainAudioView];
    
    // hide tabbarcontroller
    APPDELEGATE.mainTabBar.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    // menuview ni frame set kari ane self.view ma add karyo
    menuView.frame = CGRectMake(0, __HEIGHT__(self.view), __WIDTH__(self.view), __HEIGHT__(menuView));
    [self.view addSubview:menuView];
    [self.view addSubview:_bookMarkTableView];
     self.bookMarkTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addTapGestureInDetailsview];
    [self.view bringSubviewToFront:tabView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)iphone4sSupport{
    if (IS_IPHONE_4_OR_LESS) {
        self.bookMarkTableView.frame = CGRectMake(self.bookMarkTableView.frame.origin.x, self.bookMarkTableView.frame.origin.y, self.bookMarkTableView.frame.size.width, 378);
        // ContentScrollview.frame = CGRectMake(__X__(ContentScrollview), __Y__(ContentScrollview), __WIDTH__(ContentScrollview), 377);
        
        
        
        tabView.frame = CGRectMake(tabView.frame.origin.x,480 -tabView.frame.size.height, tabView.frame.size.width, tabView.frame.size.height);
        
        NSLog(@"SELF.VIEW :- %f and tabview Y = %f",self.view.frame.size.height,tabView.frame.origin.y);
        
        //tabView.frame = CGRectMake(__X__(tabView),__HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [self initialSettings];
    [self CallInterNetValidationForNaviagationMenu];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"radiofree.sqlite"];
    [self InternetValidationForLoadData];
    
    if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
        //if (APPDELEGATE.AudioViewControllerStatusId == AudioBookMarkViewControllerStatusId) {
            [UIView animateWithDuration:0.1 animations:^{
                isMainAudioViewOpen = YES;
                
                [playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
                
                if (IS_IPHONE_4_OR_LESS) {
                    
                    _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView), 330);
                    mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(mainAudioView), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                
                _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView),418);
                
                mainAudioView.frame = CGRectMake(__X__(mainAudioView), __HEIGHT__(self.view) - __HEIGHT__(mainAudioView), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
                
                tabView.frame = CGRectMake(__X__(tabView), __Y__(mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                
                }
            } completion:^(BOOL finished) {
                
            }];
        }
   // }
    
}
-(void)viewWillDisappear:(BOOL)animated{
//    if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying || APPDELEGATE.audioPlayer.state == STKAudioPlayerStateBuffering) {
//        [APPDELEGATE.audioPlayer pause];
//        // [PlayPauseBtnMainAudioview setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//    }
    if (wasMainAudioViewOpen == YES) {
        wasMainAudioViewOpen = NO;
    }
    if (isMainAudioViewOpen == YES) {
        isMainAudioViewOpen = NO;
        
        [UIView animateWithDuration:0.1 animations:^{
            
            [playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            
            
            mainAudioView.frame = CGRectMake(__X__(mainAudioView),__HEIGHT__(self.view), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
            tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            if (IS_IPHONE_4_OR_LESS) {
                _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView), 378);
            }else{
            _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView), 466);
            }
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
#pragma mark - Others Methods
-(void) setupTimer
{
    self.timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void) tick
{
    
    if (APPDELEGATE.AudioViewControllerStatusId == AudioLiveViewControllerStatusId) {
        titleLableInMainAudioView.text = APPDELEGATE.AudioTitleStr;
        ArtistLblInMainAudioView.text = APPDELEGATE.LockScreenArtistStr;
        ArtistLblInMainAudioView.hidden = NO;
        progressLableInMainAudioView.hidden = YES;
        durationLableInMainAudioView.hidden = YES;
        seperateLineInMainAudioView.hidden = YES;
    }else{
        ArtistLblInMainAudioView.hidden = YES;
        progressLableInMainAudioView.hidden = YES;
        durationLableInMainAudioView.hidden = NO;
        seperateLineInMainAudioView.hidden = YES;
        titleLableInMainAudioView.text = APPDELEGATE.AudioTitleStr;
       // progressLableInMainAudioView.text = APPDELEGATE.AudioProgressTimeStr;
        durationLableInMainAudioView.text = APPDELEGATE.AudioMainProgressString;
       
        if (APPDELEGATE.RemainingTimeInAppDelegate == 0) {
            [playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            APPDELEGATE.RemainingTimeInAppDelegate = 1;
        }
        
//        if ([progressLableInMainAudioView.text isEqualToString:durationLableInMainAudioView.text] && ![progressLableInMainAudioView.text isEqualToString:@"00:00:00"] && ![durationLableInMainAudioView.text isEqualToString:@"00:00:00"]) {
//            [playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
//        }
    }
//    if (!APPDELEGATE.audioPlayer)
//    {
//        
//        progressLableInMainAudioView.text = @"00:00:00";
//        
//        
//        return;
//    }
//    
//    if (APPDELEGATE.audioPlayer.currentlyPlayingQueueItemId == nil)
//    {
//        
//        
//        progressLableInMainAudioView.text = @"00:00:00";
//        
//        return;
//    }
//    
//    if (APPDELEGATE.audioPlayer.duration != 0 && APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying && APPDELEGATE.AudioViewControllerStatusId == AudioBookMarkViewControllerStatusId)
//    {
//        progressLableInMainAudioView.text = [NSString stringWithFormat:@"%@",[self formatTimeFromSeconds:APPDELEGATE.audioPlayer.progress]];
//        durationLableInMainAudioView.text = [NSString stringWithFormat:@"%@",[self formatTimeFromSeconds:APPDELEGATE.audioPlayer.duration]];
//        
//    }
//    else
//    {
//        
//    }
//    if ([progressLableInMainAudioView.text isEqualToString:durationLableInMainAudioView.text]&& ![progressLableInMainAudioView.text isEqualToString:@"00:00:00"]&&![durationLableInMainAudioView.text isEqualToString:@"00:00:00"]) {
//        [playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
//    }
}
-(NSString*) formatTimeFromSeconds:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%2d:%2d:%2d", hours, minutes, seconds];
}
-(void)InternetValidationForLoadData{
    
    if([Utility CheckForInternet]){
    
        NSString *data = [NSString stringWithFormat:@"select * from radiotbl"];
        NSArray *BookMarkData = [self.dbManager loadDataFromDB:data];
        NSMutableArray *mainDataArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i< BookMarkData.count; i++) {
            
            NSInteger indexForId = [self.dbManager.arrColumnNames indexOfObject:@"id"];
            NSInteger indexForTitle = [self.dbManager.arrColumnNames indexOfObject:@"title"];
            NSInteger indexForDescription = [self.dbManager.arrColumnNames indexOfObject:@"excerpt"];
            NSInteger indexFordate = [self.dbManager.arrColumnNames indexOfObject:@"date"];
            NSInteger indexForFormat = [self.dbManager.arrColumnNames indexOfObject:@"format"];
            NSInteger indexForAuthor = [self.dbManager.arrColumnNames indexOfObject:@"author"];
            NSInteger indexForLink = [self.dbManager.arrColumnNames indexOfObject:@"link"];
            NSInteger indexForMediaUrl = [self.dbManager.arrColumnNames indexOfObject:@"media_url"];
            NSInteger indexForImageUrl = [self.dbManager.arrColumnNames indexOfObject:@"image_url"];
            NSInteger indexForVideoUrl = [self.dbManager.arrColumnNames indexOfObject:@"video_id"];
            NSInteger indexForImageHeight = [self.dbManager.arrColumnNames indexOfObject:@"image_height"];
            NSInteger indexForImageWidth = [self.dbManager.arrColumnNames indexOfObject:@"image_width"];
            
            NSDictionary *dic = @{@"id":[NSString stringWithFormat:@"%@",[[BookMarkData objectAtIndex:i] objectAtIndex:indexForId]],@"title":[NSString stringWithFormat:@"%@",[[BookMarkData objectAtIndex:i] objectAtIndex:indexForTitle]],@"excerpt":[NSString stringWithFormat:@"%@",[[BookMarkData objectAtIndex:i] objectAtIndex:indexForDescription]],@"date":[NSString stringWithFormat:@"%@",[[BookMarkData objectAtIndex:i] objectAtIndex:indexFordate]],@"format":[NSString stringWithFormat:@"%@",[[BookMarkData objectAtIndex:i] objectAtIndex:indexForFormat]],@"author":[NSString stringWithFormat:@"%@",[[BookMarkData objectAtIndex:i] objectAtIndex:indexForAuthor]],@"link":[NSString stringWithFormat:@"%@",[[BookMarkData objectAtIndex:i] objectAtIndex:indexForLink]],@"media_url":[NSString stringWithFormat:@"%@",[[BookMarkData objectAtIndex:i] objectAtIndex:indexForMediaUrl]],@"image_url":[NSString stringWithFormat:@"%@",[[BookMarkData objectAtIndex:i] objectAtIndex:indexForImageUrl]],@"video_id":[NSString stringWithFormat:@"%@",[[BookMarkData objectAtIndex:i] objectAtIndex:indexForVideoUrl]],@"image_height":[NSString stringWithFormat:@"%@",[[BookMarkData objectAtIndex:i] objectAtIndex:indexForImageHeight]],@"image_width":[NSString stringWithFormat:@"%@",[[BookMarkData objectAtIndex:i] objectAtIndex:indexForImageWidth]]};
            
            [mainDataArray addObject:dic];
        }
        self.BookMarkDataArray = [mainDataArray mutableCopy];
        NSLog(@"Result = %@",self.BookMarkDataArray);
        [self.bookMarkTableView reloadData];
        
        if ( !self.BookMarkDataArray || !self.BookMarkDataArray.count) {
            [self.view setBackgroundColor:[UIColor whiteColor]];
            self.bookMarkTableView.hidden = YES;
            noDataAvailableLable.hidden = YES;
            NullDataPlaceholderImage.hidden = NO;
        }else{
            [self.view setBackgroundColor:UIColorFromRGB(20, 19, 19)];
        self.bookMarkTableView.hidden = NO;
        noDataAvailableLable.hidden = YES;
            NullDataPlaceholderImage.hidden = YES;
            
        }
       
    }
    else{
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.bookMarkTableView.hidden = YES;
        noDataAvailableLable.hidden = NO;
         NullDataPlaceholderImage.hidden = YES;
        showAlert(@"Check Connection", @"Internet is not available.");
    }

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
        if (index != 4) {
            
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
    _blurEffectView.frame = CGRectMake(__X__(self.bookMarkTableView), __Y__(self.bookMarkTableView),__WIDTH__(self.bookMarkTableView), __HEIGHT__(self.bookMarkTableView));
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
            isMainAudioViewOpen = YES;
            
            [UIView animateWithDuration:0.1 animations:^{
                
                //[playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
                
                if (IS_IPHONE_4_OR_LESS) {
                
                    _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView), 330);
                    mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(mainAudioView), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView),418);
                
                mainAudioView.frame = CGRectMake(__X__(mainAudioView), __HEIGHT__(self.view) - __HEIGHT__(mainAudioView), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
                
                tabView.frame = CGRectMake(__X__(tabView), __Y__(mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
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

#pragma mark - IBAction Methods

- (IBAction)didActionToPlayPauseAudioInMainAudioView:(UIButton *)sender {
    
    NSData *playImg = UIImagePNGRepresentation([UIImage imageNamed:@"play_player"]);
    
    if ([playImg isEqual:UIImagePNGRepresentation(sender.currentImage)]) {
        
        if ([Utility CheckForInternet]) {
            
        [playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
        NSURL *url = [NSURL URLWithString:APPDELEGATE.AudioURLStr];
        
        STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
        
        [APPDELEGATE.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
        }else{
            showAlert(@"Check Connection", @"Internet is not available.");
        }
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            isMainAudioViewOpen = NO;
            [playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
            mainAudioView.frame = CGRectMake(__X__(mainAudioView),__HEIGHT__(self.view), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
            tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            
            if (IS_IPHONE_4_OR_LESS) {
            
                _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView), 378);
            }else{
            _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView), 466);
            }
        } completion:^(BOOL finished) {
            [APPDELEGATE.audioPlayer pause];
        }];
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
            isMainAudioViewOpen = YES;
            
            [UIView animateWithDuration:0.1 animations:^{
                
                //[playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
                
                if (IS_IPHONE_4_OR_LESS) {
                    
                    _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView), 330);
                    mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(mainAudioView), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                
                _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView),418);
                
                mainAudioView.frame = CGRectMake(__X__(mainAudioView), __HEIGHT__(self.view) - __HEIGHT__(mainAudioView), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
                
                tabView.frame = CGRectMake(__X__(tabView), __Y__(mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
    }else{
        
        if([Utility CheckForInternet]){
        
        if (isMainAudioViewOpen == YES) {
            isMainAudioViewOpen = NO;
            wasMainAudioViewOpen = YES;
            [UIView animateWithDuration:0.1 animations:^{
                
                //[playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
                mainAudioView.frame = CGRectMake(__X__(mainAudioView),__HEIGHT__(self.view), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                if (IS_IPHONE_4_OR_LESS) {
                    _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView), 378);
                }else{
                _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView), 466);
                }
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
        
        if (wasMainAudioViewOpen == YES) {
            wasMainAudioViewOpen = NO;
            isMainAudioViewOpen = YES;
            
            [UIView animateWithDuration:0.1 animations:^{
                
                //[playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
                
                if (IS_IPHONE_4_OR_LESS) {
                    
                    _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView), 330);
                    mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(mainAudioView), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
                    tabView.frame = CGRectMake(__X__(tabView), __Y__(mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }else{
                
                _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView),418);
                
                mainAudioView.frame = CGRectMake(__X__(mainAudioView), __HEIGHT__(self.view) - __HEIGHT__(mainAudioView), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
                
                tabView.frame = CGRectMake(__X__(tabView), __Y__(mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
                }
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
    }
    
}

- (IBAction)didActionToSettingsButtonInMenu:(id)sender {
    if (isMenuOpen) {
        isMenuOpen = NO;
        [self CloseMenu];
    }
    APPDELEGATE.mainTabBar.selectedIndex = 3;
}
#pragma mark - UITableviewDelegateMethods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.BookMarkDataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
     NSString *format = [[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"format"];
    
    if ([format isEqualToString:StandardPostType]) {
        BKStandardCell *cell=[tableView dequeueReusableCellWithIdentifier:IdentifierForBKStandardCell];
        
        if (cell==nil) {
            [tableView registerNib:[UINib nibWithNibName:@"BKStandardCell" bundle:nil] forCellReuseIdentifier:IdentifierForBKStandardCell];
            cell=[tableView dequeueReusableCellWithIdentifier:IdentifierForBKStandardCell];
        }
        // Cell select karti vakhte gray thai jay che ae effect aa line mukya pachi disable thai jase.
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        NSString *FeatureImageUrlString = [[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"image_url"];
        
        NSString *titleString = [[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        
        cell.dateLable.text = [[UtilFunctions class] getDateFromStringDate:[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"date"]];
        
        cell.TitleLable.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titleString];
        
        cell.TitleLable = setLableSize(cell.TitleLable, [UIFont fontWithName:TitleFontName size:22]);
        
        if ([FeatureImageUrlString isEqualToString:@""]) {
            cell.FeatureImage.hidden = YES;
             cell.TitleLable.frame = CGRectMake(__X__(cell.TitleLable),CellYSpace, __WIDTH__(cell.TitleLable), __HEIGHT__(cell.TitleLable));
        }else{
            
            if ([[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"image_width"]==(id)[NSNull null] ||[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"image_height"]==(id)[NSNull null]) {
                
                cell.FeatureImage.hidden = YES;
                cell.TitleLable.frame = CGRectMake(__X__(cell.TitleLable),CellYSpace, __WIDTH__(cell.TitleLable), __HEIGHT__(cell.TitleLable));
                
            }else{
                float fiwidth = [[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"image_width"] floatValue];
                float ftiheight = [[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"image_height"] floatValue];
                float ratio = fiwidth/tableView.frame.size.width;
                float height4 = ftiheight/ratio;
                //                UIImage *uImage = cell.FeatureImage.image;
                //                float Wid = uImage.size.width;
                //                float retio = Wid/tableView.frame.size.width;
                //                float height11 = uImage.size.height/retio;
                cell.FeatureImage.frame = CGRectMake(0, 0, cell.FeatureImage.frame.size.width, height4);
            
            
            cell.FeatureImage.hidden = NO;
            //[tableView beginUpdates];
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [indicator startAnimating];
            indicator.center                   = CGPointMake(cell.FeatureImage.frame.size.width / 2.0, cell.FeatureImage.frame.size.height / 2.0);
            [cell.FeatureImage addSubview:indicator];
            
            [cell.FeatureImage sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@", FeatureImageUrlString] stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                UIImage *uImage = image;
//                float Wid = uImage.size.width;
//                float retio = Wid/tableView.frame.size.width;
//                float height11 = uImage.size.height/retio;
//                cell.FeatureImage.frame = CGRectMake(0, 0, cell.FeatureImage.frame.size.width, height11);
//                cell.TitleLable.frame = CGRectMake(__X__(cell.TitleLable),__Y__(cell.FeatureImage)+__HEIGHT__(cell.FeatureImage)+SpaceBetweenAudioViewAndTitleLable, __WIDTH__(cell.TitleLable), __HEIGHT__(cell.TitleLable));
//                [indicator removeFromSuperview];
                if (FeatureImageUrlString.length<=0 || error) {
                    cell.FeatureImage.image=[UIImage imageNamed:@"imageplaceholder_1.png"];
                }
                if (FeatureImageUrlString.length<=0 || error) {
                    cell.FeatureImage.frame = CGRectMake(0, 0, cell.FeatureImage.frame.size.width, YouTubeVideoViewHeight);
                    
                }else{
                    
                }
                
                
                [indicator removeFromSuperview];
            }];
            //[cell.FeatureImage setContentMode:UIViewContentModeScaleAspectFit];

            cell.TitleLable.frame = CGRectMake(__X__(cell.TitleLable),__Y__(cell.FeatureImage)+__HEIGHT__(cell.FeatureImage)+SpaceBetweenAudioViewAndTitleLable, __WIDTH__(cell.TitleLable), __HEIGHT__(cell.TitleLable));
           // [tableView endUpdates];
            }
        }
        
       
        
        
        
        cell.dateView.frame = CGRectMake(cell.dateView.frame.origin.x,cell.TitleLable.frame.origin.y+cell.TitleLable.frame.size.height + SpaceBetweenDateViewAndTitleLable,cell.dateView.frame.size.width,cell.dateView.frame.size.height);
        
        NSString *discriptionString = [[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"excerpt"];
        
        cell.descriptionLable.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:discriptionString];
        
        cell.descriptionLable = setLableSize(cell.descriptionLable, [UIFont fontWithName:DescriptionFontName size:14]);
        
        
        cell.descriptionLable.frame = CGRectMake(cell.descriptionLable.frame.origin.x, cell.dateView.frame.origin.y+cell.dateView.frame.size.height+SpaceBetweenDateViewAndDescriptionLable, __WIDTH__(cell.descriptionLable), __HEIGHT__(cell.descriptionLable));
        
//        NSString *authorNameStr = [NSString stringWithFormat:@"Via: %@",[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"author"]];
//
//        cell.AuthorName.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:authorNameStr];
//
//        cell.AuthorName = setLableSize(cell.AuthorName, [UIFont fontWithName:RegularFont size:14]);
//
//        cell.AuthorName.frame = CGRectMake(__X__(cell.AuthorName),cell.descriptionLable.frame.origin.y+cell.descriptionLable.frame.size.height+SpaceBetweenAuthorNameAndDescription, __WIDTH__(cell.AuthorName), __HEIGHT__(cell.AuthorName));
        
        
        return cell;
        
    }else if ([format isEqualToString:AudioPostType]){
        
        BKAudioCell *cell=[tableView dequeueReusableCellWithIdentifier:IdentifierForBKAudioCell];
        
        if (cell==nil) {
            [tableView registerNib:[UINib nibWithNibName:@"BKAudioCell" bundle:nil] forCellReuseIdentifier:IdentifierForBKAudioCell];
            cell=[tableView dequeueReusableCellWithIdentifier:IdentifierForBKAudioCell];
            
            
        }
        
       // cell.AudioURLString = [[self.NewsPostData objectAtIndex:indexPath.row]valueForKey:@"media_url"];
        // Cell select karti vakhte gray thai jay che ae effect aa line mukya pachi disable thai jase.
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.playPauseButton.tag = indexPath.row;
        [cell.playPauseButton addTarget:self action:@selector(didActionToplayAudioFromTableview:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.audioView.frame = CGRectMake(cell.audioView.frame.origin.x, __Y__(cell.audioView), __WIDTH__(cell.audioView), __HEIGHT__(cell.audioView));
        
        NSString *titleString = [[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        
        cell.titleLable.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titleString];
        
        cell.titleLable = setLableSize(cell.titleLable, [UIFont fontWithName:TitleFontName size:22]);
        
        cell.titleLable.frame = CGRectMake(__X__(cell.titleLable),__Y__(cell.audioView)+__HEIGHT__(cell.audioView)+SpaceBetweenAudioViewAndTitleLable, __WIDTH__(cell.titleLable), __HEIGHT__(cell.titleLable));
        
        cell.dateLable.text = [[UtilFunctions class] getDateFromStringDate:[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"date"]];
        
        cell.dateView.frame = CGRectMake(cell.dateView.frame.origin.x,cell.titleLable.frame.origin.y+cell.titleLable.frame.size.height + SpaceBetweenDateViewAndTitleLable,cell.dateView.frame.size.width,cell.dateView.frame.size.height);
        
        NSString * DiscriptionString = [[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"excerpt"];
        
//        NSString *authorNameStr = [NSString stringWithFormat:@"Via: %@",[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"author"]];
//
//        cell.AuthorName.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:authorNameStr];
//
//        cell.AuthorName = setLableSize(cell.AuthorName, [UIFont fontWithName:RegularFont size:14]);
        
        if ([DiscriptionString isEqualToString:@""]) {
            
            cell.descriptionLable.hidden = YES;
           // cell.AuthorName.frame = CGRectMake(__X__(cell.AuthorName), __Y__(cell.dateView)+__HEIGHT__(cell.dateView)+SpaceBetweenAuthorNameAndDescription, __WIDTH__(cell.AuthorName), __HEIGHT__(cell.AuthorName));
//            cell.audioView.frame = CGRectMake(cell.audioView.frame.origin.x, cell.dateView.frame.origin.y+cell.dateView.frame.size.height+SpaceBetweenDateViewAndDescriptionLable, __WIDTH__(cell.audioView), __HEIGHT__(cell.audioView));
            
            
        }else{
            cell.descriptionLable.hidden = NO;
            
            cell.descriptionLable.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:DiscriptionString];
            
            cell.descriptionLable = setLableSize(cell.descriptionLable, [UIFont fontWithName:DescriptionFontName size:14]);
            
            
            cell.descriptionLable.frame = CGRectMake(cell.descriptionLable.frame.origin.x, cell.dateView.frame.origin.y+cell.dateView.frame.size.height+SpaceBetweenDateViewAndDescriptionLable, __WIDTH__(cell.descriptionLable), __HEIGHT__(cell.descriptionLable));
            
           // cell.AuthorName.frame = CGRectMake(__X__(cell.AuthorName),cell.descriptionLable.frame.origin.y+cell.descriptionLable.frame.size.height+SpaceBetweenAuthorNameAndDescription, __WIDTH__(cell.AuthorName), __HEIGHT__(cell.AuthorName));
            
            
           // cell.audioView.frame = CGRectMake(cell.audioView.frame.origin.x, cell.descriptionLable.frame.origin.y+cell.descriptionLable.frame.size.height+SpaceBetweenAudioViewAndDescriptionLable, __WIDTH__(cell.audioView), __HEIGHT__(cell.audioView));
            
        }

        return cell;
        
    }else{
        BKVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:IdentifierForBKVideoCell];
        
        if (cell==nil) {
            [tableView registerNib:[UINib nibWithNibName:@"BKVideoCell" bundle:nil] forCellReuseIdentifier:IdentifierForBKVideoCell];
            cell=[tableView dequeueReusableCellWithIdentifier:IdentifierForBKVideoCell];
        }
        
        // Cell select karti vakhte gray thai jay che ae effect aa line mukya pachi disable thai jase.
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
//        [self loadYouTubeVideo:[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"id"] loadyoutubeview:^(NSString *videoID) {
//            cell.VideoView.delegate = self;
//            NSString *videoId = videoID;
//            NSDictionary *playerVars = @{
//                                         @"controls" : @1,
//                                         @"playsinline" : @1,
//                                         @"autohide" : @1,
//                                         @"showinfo" : @0,
//                                         @"modestbranding" : @1
//                                         };
//
//            [cell.VideoView loadWithVideoId:videoId playerVars:playerVars];
//
//        }];
        
        NSDictionary *playerVars = @{
                                    @"controls" : @1,
                                    @"playsinline" : @1,
                                    @"autohide" : @1,
                                    @"showinfo" : @0,
                                    @"modestbranding" : @1
                                    };
        NSString *videoId = [[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"video_id"];
        [cell.VideoView loadWithVideoId:videoId playerVars:playerVars];
        cell.VideoView.frame = CGRectMake(__X__(cell.VideoView), __Y__(cell.VideoView), __WIDTH__(cell.VideoView),__HEIGHT__(cell.VideoView));
        
        NSString *titleString = [[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        
        cell.titleLable.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titleString];
        
        cell.titleLable = setLableSize(cell.titleLable, [UIFont fontWithName:TitleFontName size:22]);
        
        cell.titleLable.frame = CGRectMake(__X__(cell.titleLable),__Y__(cell.VideoView)+__HEIGHT__(cell.VideoView)+SpaceBetweenAudioViewAndTitleLable, __WIDTH__(cell.titleLable), __HEIGHT__(cell.titleLable));
        
        cell.dateLable.text = [[UtilFunctions class] getDateFromStringDate:[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"date"]];
        
        cell.dateView.frame = CGRectMake(cell.dateView.frame.origin.x,cell.titleLable.frame.origin.y+cell.titleLable.frame.size.height + SpaceBetweenDateViewAndTitleLable,cell.dateView.frame.size.width,cell.dateView.frame.size.height);
        
      //  NSString *authorNameStr = [NSString stringWithFormat:@"Via: %@",[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"author"]];
        
       // cell.AuthorName.text = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:authorNameStr];
        
       // cell.AuthorName = setLableSize(cell.AuthorName, [UIFont fontWithName:RegularFont size:14]);
        
       // cell.AuthorName.frame = CGRectMake(__X__(cell.AuthorName), __Y__(cell.dateView)+__HEIGHT__(cell.dateView)+SpaceBetweenAuthorNameAndDescription, __WIDTH__(cell.AuthorName), __HEIGHT__(cell.AuthorName));
        
        //cell.VideoView.frame = CGRectMake(__X__(cell.VideoView), cell.dateView.frame.origin.y+cell.dateView.frame.size.height+SpaceBetweenDateViewAndDescriptionLable, __WIDTH__(cell.VideoView),__HEIGHT__(cell.VideoView));
        
        
        return cell;
    }
    
}

-(IBAction)didActionToplayAudioFromTableview:(UIButton *)sender{
    
    if ([Utility CheckForInternet]) {
        
        [UIView animateWithDuration:0.1 animations:^{
            isMainAudioViewOpen = YES;
            APPDELEGATE.AudioViewControllerStatusId = AudioBookMarkViewControllerStatusId;
            [playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateNormal];
            
            if (IS_IPHONE_4_OR_LESS) {
                
                _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView), 330);
                mainAudioView.frame = CGRectMake(0,__HEIGHT__(self.view)-__HEIGHT__(mainAudioView), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
                tabView.frame = CGRectMake(__X__(tabView), __Y__(mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            }else{
            
            _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView),418);
            
            mainAudioView.frame = CGRectMake(__X__(mainAudioView), __HEIGHT__(self.view) - __HEIGHT__(mainAudioView), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
            
            tabView.frame = CGRectMake(__X__(tabView), __Y__(mainAudioView)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
            }
            
        } completion:^(BOOL finished) {
            
            //            if (TempYoutubeViewPlayer.playerState == kYTPlayerStatePlaying) {
            //                [TempYoutubeViewPlayer pauseVideo];
            //                NSIndexPath *index = [NSIndexPath indexPathForRow:TempYoutubeViewPlayer.tag inSection:0];
            //                [_newsTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            //            }
            newsTitleString = [NSString stringWithFormat:@"%@",[[_BookMarkDataArray objectAtIndex:sender.tag]valueForKey:@"title"]];
            APPDELEGATE.AudioTitleStr = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:newsTitleString];
            APPDELEGATE.AudioURLStr = [NSString stringWithFormat:@"%@",[[_BookMarkDataArray objectAtIndex:sender.tag]valueForKey:@"media_url"]];
            NSURL *url = [NSURL URLWithString:APPDELEGATE.AudioURLStr];
//
            STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
//
            [APPDELEGATE.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
            
        }];
        
    }else{
        showAlert(ErrorInternetConnectionTitle, ErrorInternetConnectionMessage);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *format = [[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"format"];
    
    if ([format isEqualToString:StandardPostType]) {
        
        UILabel * Title     = [[UILabel alloc] init];
        Title.frame         = CGRectMake( 0, 16, 288, 15);
        Title.numberOfLines = 0;
        
        NSString *titleString = [[self.BookMarkDataArray objectAtIndex:indexPath.row]valueForKey:@"title"];
        
        Title.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titleString];
        
        Title      = setLableSize(Title, [UIFont fontWithName:TitleFontName size:22]);
        
        UILabel * description     = [[UILabel alloc] init];
        description.frame         = CGRectMake( 0, 16, 288, 15);
        description.numberOfLines = 0;
        
        NSString *discriptionString = [[self.BookMarkDataArray objectAtIndex:indexPath.row]valueForKey:@"excerpt"];
        
        description.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:discriptionString];
        
        description      = setLableSize(description, [UIFont fontWithName:DescriptionFontName size:14]);
        
//        UILabel *AuthorLable = [[UILabel alloc] init];
//        AuthorLable.frame         = CGRectMake( 0, 16, 288, 15);
//        AuthorLable.numberOfLines = 0;
//
//        //[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:AuthorKey];
//        NSString *AuthorString = [NSString stringWithFormat:@"Via : %@",[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"author"]];
//
//        AuthorLable.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:AuthorString];
//
//        AuthorLable      = setLableSize(AuthorLable, [UIFont fontWithName:RegularFont size:14]);
        
        float cellHeight = 0.0;
        
        NSString *FeatureImageUrlString = [[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"image_url"];;
        
        if ([FeatureImageUrlString isEqualToString:@""]) {
            cellHeight = CellYSpace+Title.frame.size.height+SpaceBetweenDateViewAndTitleLable+DateViewHeight+SpaceBetweenDateViewAndDescriptionLable+description.frame.size.height+CellBottomSpace;
        }else{
            
            
            if ([[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"image_width"]==(id)[NSNull null] ||[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"image_height"]==(id)[NSNull null]) {
                
                cellHeight = CellYSpace+Title.frame.size.height+SpaceBetweenDateViewAndTitleLable+DateViewHeight+SpaceBetweenDateViewAndDescriptionLable+description.frame.size.height+CellBottomSpace;
                
            }else{
                
                //NSLog(@"HERE ID = %@",[[_NewsPostData objectAtIndex:indexPath.row] valueForKey:@"id"]);
                float imageHeight = 0 ;
                
                float fiwidth = [[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"image_width"] floatValue];
                float ftiheight = [[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"image_height"] floatValue];
                float ratio = fiwidth/tableView.frame.size.width;
                imageHeight = ftiheight/ratio;
//            __block float imageHeight11 = 0;
//
//            UIImageView *imageview11 = [[UIImageView alloc] init];
//            [imageview11 sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@", FeatureImageUrlString] stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                UIImage *uImage = image;
//                float Wid = uImage.size.width;
//                float retio = Wid/tableView.frame.size.width;
//                imageHeight11 = uImage.size.height/retio;
//
//            }];
            
           cellHeight = imageHeight+SpaceBetweenAudioViewAndTitleLable+Title.frame.size.height+SpaceBetweenDateViewAndTitleLable+DateViewHeight+SpaceBetweenDateViewAndDescriptionLable+description.frame.size.height+CellBottomSpace;
        }
        }
        
        
        return cellHeight;

    }else if ([format isEqualToString:AudioPostType]){
        
        UILabel * Title     = [[UILabel alloc] init];
        Title.frame         = CGRectMake( 0, 16, 288, 15);
        Title.numberOfLines = 0;
        NSString *titleString = [[self.BookMarkDataArray objectAtIndex:indexPath.row]valueForKey:@"title"];
        Title.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titleString];
        
        Title      = setLableSize(Title, [UIFont fontWithName:TitleFontName size:22]);
        
        float CellHeight;
        
        NSString * DiscriptionString = [[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"excerpt"];
        
//        UILabel *AuthorLable = [[UILabel alloc] init];
//        AuthorLable.frame         = CGRectMake( 0, 16, 288, 15);
//        AuthorLable.numberOfLines = 0;
//
//        //[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:AuthorKey];
//        NSString *AuthorString = [NSString stringWithFormat:@"Via : %@",[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"author"]];
//
//        AuthorLable.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:AuthorString];
//
//        AuthorLable      = setLableSize(AuthorLable, [UIFont fontWithName:RegularFont size:14]);
        
        if ([DiscriptionString isEqualToString:@""]) {
            
            CellHeight = AudioViewHeight + SpaceBetweenAudioViewAndTitleLable + Title.frame.size.height + SpaceBetweenTitleAndDate + DateViewHeight + CellBottomSpace;
            
            //CellYSpace + Title.frame.size.height + SpaceBetweenDateViewAndTitleLable+DateViewHeight+SpaceBetweenAudioViewAndDescriptionLable+AudioViewHeight+CellBottomSpace;
            
        }else{
            
            UILabel * description     = [[UILabel alloc] init];
            description.frame         = CGRectMake( 0, 16, 288, 15);
            description.numberOfLines = 0;
            
            description.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:DiscriptionString];
            
            description      = setLableSize(description, [UIFont fontWithName:DescriptionFontName size:14]);
            
            CellHeight = AudioViewHeight + SpaceBetweenAudioViewAndTitleLable + Title.frame.size.height + SpaceBetweenTitleAndDate + DateViewHeight +   SpaceBetweenDateViewAndDescriptionLable + description.frame.size.height + CellBottomSpace;
            //CellYSpace+Title.frame.size.height+SpaceBetweenDateViewAndTitleLable+DateViewHeight+SpaceBetweenDateViewAndDescriptionLable+description.frame.size.height+SpaceBetweenAudioViewAndDescriptionLable+AudioViewHeight+CellBottomSpace;
            
            
        }
        
        return CellHeight;
    }else{
        
        
        
        UILabel * Title     = [[UILabel alloc] init];
        Title.frame         = CGRectMake( 0, 16, 288, 15);
        Title.numberOfLines = 0;
        
        NSString *titleString = [[self.BookMarkDataArray objectAtIndex:indexPath.row]valueForKey:@"title"];
        
        Title.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:titleString];
        
        Title      = setLableSize(Title, [UIFont fontWithName:TitleFontName size:22]);
//        UILabel *AuthorLable = [[UILabel alloc] init];
//        AuthorLable.frame         = CGRectMake( 0, 16, 288, 15);
//        AuthorLable.numberOfLines = 0;
//
//        //[[self.NewsPostData objectAtIndex:indexPath.row] valueForKey:AuthorKey];
//        NSString *AuthorString = [NSString stringWithFormat:@"Via : %@",[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:AuthorKey]];
//
//        AuthorLable.text          = [[UtilFunctions class] ConvertHTMLStringAttributeToPlainString:AuthorString];
//
//        AuthorLable      = setLableSize(AuthorLable, [UIFont fontWithName:RegularFont size:14]);
        float cellHeight = YouTubeVideoViewHeight + SpaceBetweenAudioViewAndTitleLable + Title.frame.size.height + SpaceBetweenTitleAndDate + DateViewHeight + CellBottomSpace;
        //Title.frame.size.height+SpaceBetweenDateViewAndTitleLable+DateViewHeight+SpaceBetweenDateViewAndDescriptionLable+YouTubeVideoViewHeight+CellBottomSpace;
        
        return cellHeight;

    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BKDetailViewController *detailview = [[BKDetailViewController alloc] init];
    [detailview detailViewNewsPostId:[NSString stringWithFormat:@"%@",[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"id"] ] postFormat:[[self.BookMarkDataArray objectAtIndex:indexPath.row] valueForKey:@"format"]];
    
    if (isMenuOpen) {
        isMenuOpen = NO;
        [self CloseMenu];
    }
    
    APPDELEGATE.mainTabBar.selectedIndex = 6;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
#pragma mark - YoutubeDelegateMethods

- (void)playerView:(nonnull YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{
    
    // if (state == kYTPlayerStatePlaying){
    //        TempYoutubeViewPlayer = [[YTPlayerView alloc] init];
    //         TempYoutubeViewPlayer = (YTPlayerView*) playerView;
//    if (isMainAudioViewOpen == YES) {
//        isMainAudioViewOpen = NO;
//        [UIView animateWithDuration:0.1 animations:^{
//            
//            [playPauseButtonInMainAudioView setImage:[UIImage imageNamed:@"play_player"] forState:UIControlStateNormal];
//            mainAudioView.frame = CGRectMake(__X__(mainAudioView),__HEIGHT__(self.view), __WIDTH__(mainAudioView), __HEIGHT__(mainAudioView));
//            tabView.frame = CGRectMake(__X__(tabView), __HEIGHT__(self.view)-__HEIGHT__(tabView), __WIDTH__(tabView), __HEIGHT__(tabView));
//            _bookMarkTableView.frame = CGRectMake(__X__(_bookMarkTableView), __Y__(_bookMarkTableView), __WIDTH__(_bookMarkTableView), 460);
//            
//        } completion:^(BOOL finished) {
//            [APPDELEGATE.audioPlayer pause];
//        }];
//    }
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
