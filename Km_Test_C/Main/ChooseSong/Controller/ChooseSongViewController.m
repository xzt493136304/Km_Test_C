//
//  ChooseSongViewController.m
//  Km_Test_C
//
//  Created by Mr.Xie on 16/4/22.
//  Copyright © 2016年 OMG. All rights reserved.
//

#import "ChooseSongViewController.h"
#import "ChooseAlwaysViewController.h"
#import "RankingListViewController.h"
#import "PhoneSendViewController.h"
#import "ArtistClassViewController.h"
#import "QRCodeViewController.h"
#import "AlbumRecListViewController.h"
#import "SearchViewController.h"

#import "KM_NetAPIManager.h"

#import "ChooseSongCell.h"
#import "ChooseSongHeadView.h"
#import "UINavigationBar+expanded.h"
#import "MJRefresh.h"

#define kCellIdentifier_TitleDisclosure @"TitleDisclosureCell"

@interface ChooseSongViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ChooseSongHeadView *headerView;

@property (nonatomic,strong) UIColor *navColor;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation ChooseSongViewController

#pragma mark - LifeCycle
CGFloat kGirdViewHeight = 480.0f;
static const CGFloat kTimerInterval = 5.0f;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//状态栏
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [self.navigationController.navigationBar cnSetBackgroundColor:self.navColor];
    self.timer = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:kTimerInterval target:self selector:@selector(connnectButtionTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar cnReset];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];//状态栏
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhone6Plus) {
        kGirdViewHeight = 520;
    }
    self.navigationItem.title = @"KTV点歌";
    [self layoutSubViews];
    [self refresh];
}

- (void)refresh{
    KM_NetAPIManager *apiManager = [KM_NetAPIManager defaultManage];
    [apiManager fetchHotSongListWithCompletion:^(NSArray *results, NSInteger total, NSError *error) {
        
    }];
}
#pragma mark - Init
-(void)layoutSubViews{
    [self.view addSubview:self.tableView];
//    _tableView.contentInset = UIEdgeInsetsMake(-35,  0,  0,  0);
}
#pragma mark - Navigation


#pragma mark - UITablewViewDelegate
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
//    [button setTitle:@"最新歌曲" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
//    return button;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

static const CGFloat kTopGridViewMargin = 5.0f;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [ChooseSongCell heightWithSerachView];
        }
        return kSCREEN_WIDTH/2;
    }else{
        if (indexPath.row == 0 ||indexPath.row ==7) {
            return 50;
        }else if (indexPath.row == 8){
            return kGirdViewHeight;
        }
        return 60;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SearchViewController *search = [[SearchViewController alloc]init];
            [self.navigationController pushViewController:search animated:YES];
        }
    }
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ////TODO: tablewcell fix
    static NSString *chooseSongTopGridCellIdentifier = @"chooseSongTopGridCell";
    static NSString *chooseSongBottomGirdCellIdentifier = @"chooseSongBottomGirdCell";
    ChooseSongCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [ChooseSongCell cellWithSerachView:tableView];
        }else if (indexPath.row == 1){
            cell = (ChooseSongCell *)[tableView dequeueReusableCellWithIdentifier:chooseSongTopGridCellIdentifier];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0 || indexPath.row == 7) {
            cell = [ChooseSongCell cellWithTabelView:tableView];
        }else if (indexPath.row == 8){
            cell = (ChooseSongCell *)[tableView dequeueReusableCellWithIdentifier:chooseSongBottomGirdCellIdentifier];
        }else{
            cell = [ChooseSongCell cellWithHotCell:tableView];
        }
    }

    if (!cell) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
            }else if (indexPath.row == 1){
                cell = [[ChooseSongCell alloc]initWithCustomView:[self chooseSongTopGridView] reuseIdentifier:chooseSongTopGridCellIdentifier];
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0 || indexPath.row == 7) {
            }else if (indexPath.row == 8){
                cell = [[ChooseSongCell alloc]initWithCustomView:self.chooseSongBottomGirdView reuseIdentifier:chooseSongBottomGirdCellIdentifier];
                cell.contentView.backgroundColor = RGB(240, 240, 240);
            }else{
            }
        }
    }
    
    if (indexPath.row == 0 ) {
        cell.titleLabel.text = @"最热新歌";
    } else if (indexPath.row == 7 ) {
        cell.titleLabel.text = @"推荐歌单";
    }else{
        cell.titleLabel.text = @"鲁冰花[我是歌手第四季]";
        cell.detailLabel.text = @"徐佳莹";
    }
    
  
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
        return 9;
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UIColor * color = [UIColor colorWithRed:0/255.0 green:13/255.0 blue:42/255.0 alpha:1];
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 50) {
            CGFloat alpha = MIN(0.9, 0.9 - ((50 + 64 - offsetY) / 64));
            //~todo runtime
            self.navColor = [color colorWithAlphaComponent:alpha];
            [self.navigationController.navigationBar cnSetBackgroundColor:[color colorWithAlphaComponent:alpha]];
        } else {
            [self.navigationController.navigationBar cnSetBackgroundColor:[color colorWithAlphaComponent:0]];
        }
    }
}
#pragma mark - ActionTarget
- (void)connnectButtionTimer:(NSTimer *)timer{
    [self connnectButtionLoopAnimate];
}

- (void)topButtonTapAction:(UIButton *)btn{
    if (btn.tag == 101) {
        ArtistClassViewController *artistClasssVC = [[ArtistClassViewController alloc] init];
        [self.navigationController pushViewController:artistClasssVC animated:YES];
    }else if (btn.tag == 102){
        PhoneSendViewController *phoneSendVC = [[PhoneSendViewController alloc]init];
        [self.navigationController pushViewController:phoneSendVC animated:YES];
    }else if (btn.tag == 103){
        ChooseAlwaysViewController *chooseAlwayVC = [[ChooseAlwaysViewController alloc]init];
        [self.navigationController pushViewController:chooseAlwayVC animated:YES];
    }else if (btn.tag == 104){
        RankingListViewController *rankingListVC = [[RankingListViewController alloc]init];
        [self.navigationController pushViewController:rankingListVC animated:YES];
    }
}

- (void)nineViewTapAction:(UITapGestureRecognizer *)tap{
    AlbumRecListViewController *AlbumRecListVC = [[AlbumRecListViewController alloc]init];
    [self.navigationController pushViewController:AlbumRecListVC animated:YES];
}

#pragma mark - UITextFieldDelegate
#pragma mark - Private Method
static const CGFloat KAnimateDuration = 0.1;
- (void)connnectButtionLoopAnimate{
    __weak ChooseSongViewController *weakSelf = self;
    [UIView animateWithDuration:KAnimateDuration animations:^{
        weakSelf.headerView.button.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:KAnimateDuration animations:^{
            weakSelf.headerView.button.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:KAnimateDuration animations:^{
                weakSelf.headerView.button.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:KAnimateDuration animations:^{
                    weakSelf.headerView.button.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }];
        }];
    }];
}


- (UIView *)chooseSongTopGridView{
    int sidesMargin = 10;
    int leftWidth = kSCREEN_WIDTH/2 - kTopGridViewMargin/2 - sidesMargin;
    int rightWidth = (kSCREEN_WIDTH/2 - kTopGridViewMargin/2 - kTopGridViewMargin -sidesMargin)/2;
    UIView *chooseSongTopGridView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, (leftWidth)+20)];
    UIButton *button1 = [UIButton new];
    UIButton *button2 = [UIButton new];
    UIButton *button3 = [UIButton new];
    UIButton *button4 = [UIButton new];
    
    [button1 setTag:101];
    [button2 setTag:102];
    [button3 setTag:103];
    [button4 setTag:104];
    
    __weak ChooseSongViewController *weakSelf = self;
    void (^viewBlock)() = ^(UIButton *btn,NSString *title,NSString *imageName){
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//        [view setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn addTarget:weakSelf action:@selector(topButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *iconLabel = [[UILabel alloc]init];
        iconLabel.text = title;
        iconLabel.font = [UIFont systemFontOfSize:16];
        iconLabel.textColor = [UIColor whiteColor];
        [btn addSubview:iconLabel];
        [chooseSongTopGridView addSubview:btn];
        [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_left).with.offset(kTopGridViewMargin);
            make.bottom.equalTo(btn.mas_bottom).with.offset(-kTopGridViewMargin);
        }];
    };
    
    viewBlock(button1,@"歌手",@"angelababy");
    viewBlock(button2,@"",@"new_wan_picksong_local");
    viewBlock(button3,@"",@"new_wan_picksong_common");
    viewBlock(button4,@"",@"new_wan_picksong_rank");
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chooseSongTopGridView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(leftWidth, leftWidth));
        make.left.equalTo(chooseSongTopGridView).with.offset(sidesMargin);
    }];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chooseSongTopGridView).with.offset(0);
        make.left.equalTo(button1.mas_right).with.offset(kTopGridViewMargin);
        make.size.mas_equalTo(CGSizeMake(rightWidth, rightWidth));
    }];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(chooseSongTopGridView).with.offset(0);
        make.left.equalTo(button2.mas_right).with.offset(kTopGridViewMargin);
        make.size.mas_equalTo(CGSizeMake(rightWidth, rightWidth));
    }];
    [button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(leftWidth, rightWidth));
        make.left.equalTo(button1.mas_right).with.offset(kTopGridViewMargin);
        make.top.equalTo(button2.mas_bottom).with.offset(kTopGridViewMargin);
    }];
    return chooseSongTopGridView;
}

#pragma mark - Getter/Setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.backgroundColor = RGB(246, 246, 246);
    }
    return _tableView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[ChooseSongHeadView alloc]init];
        __weak ChooseSongViewController *weakSelf = self;
        _headerView.btnActionBlock = ^{
            QRCodeViewController *QRCodeVC = [[QRCodeViewController alloc]init];
            QRCodeVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:QRCodeVC animated:YES];
        };
    }
    return _headerView;
}

- (UIView *)chooseSongBottomGirdView{
        CGFloat gridViewHeight = 130;
        int intes = 10;
        int num = 3;
        if(kDevice_Is_iPhone6Plus){
            gridViewHeight = 150;
            intes = 12;
        }
        __block UIView *lastView = nil;
        UIView *nineButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kGirdViewHeight - 30)];
        nineButtonView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < 9; i++) {
            UIView *view = [UIView new];
            [view setTag:i];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nineViewTapAction:)];
            [view addGestureRecognizer:singleTap];
            
            [nineButtonView addSubview:view];
            UIImageView *icon= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhuanjitest"]];
            icon.layer.masksToBounds = YES;
            icon.layer.cornerRadius = 8;
            UILabel *iconLabel = [[UILabel alloc]init];
            
            iconLabel.text = @"好声音第一季";
            iconLabel.font = [UIFont systemFontOfSize:14];
            iconLabel.textColor = [UIColor blackColor];
            [view addSubview:icon];
            [view addSubview:iconLabel];
            
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(0, 0, 20, 0));
            }];
            [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(icon.mas_bottom).with.offset(5);
                make.width.mas_offset(gridViewHeight);
                make.left.equalTo(iconLabel.superview.mas_left).with.offset(5);
            }];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(gridViewHeight);
                if (lastView) {
                    make.width.equalTo(lastView);
                } else {
                    if (i % num != 0) {
                        make.width.mas_equalTo((view.superview.frame.size.width - (num + 1)* intes)/4);
                    }
                }
                // 2. 判断是否是第一列
                if (i % num == 0) {
                    // 一：是第一列时 添加左侧与父视图左侧约束
                    make.left.mas_equalTo(view.superview).offset(intes);
                } else {
                    // 二： 不是第一列时 添加左侧与上个view左侧约束
                    make.left.mas_equalTo(lastView.mas_right).offset(intes);
                }
                // 3. 判断是否是最后一列 给最后一列添加与父视图右边约束
                if (i % num == (num - 1)) {
                    make.right.mas_equalTo(view.superview).offset(-intes);
                }
                // 4. 判断是否为第一列
                if (i / num == 0) {
                    // 第一列添加顶部约束
                    make.top.mas_equalTo(view.superview).offset(intes);
                } else {
                    // 其余添加顶部约束 intes*10 是我留出的距顶部高度
                    make.top.mas_equalTo(intes + ( i / num )* (100 + intes*5));
                }
                
            }];
            // 每次循环结束 此次的View为下次约束的基准
            lastView = view;
        }
        return nineButtonView;
}
@end
