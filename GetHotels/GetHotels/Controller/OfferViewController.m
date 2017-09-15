//
//  OfferViewController.m
//  GetHotels
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "OfferViewController.h"
#import "OfferCollectionViewCell.h"
#import "ReleaseModel.h"
@interface OfferViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger offerNum;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic)UIActivityIndicatorView *aiv;
@property(strong,nonatomic)NSMutableArray *offerArr;
@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self refreshControl];
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//页面将要出现的时候
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationItem];
}

//设置导航样式
- (void)setNavigationItem {
    //设置导航栏的背景颜色
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(23, 115, 232)];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //实例化一个button，类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回3"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
//自定义的返回按钮的事件
- (void)leftButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//创建刷新指示器
-(void)refreshControl{
    UIRefreshControl *didRelaseRefresh = [UIRefreshControl new];
    [didRelaseRefresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    didRelaseRefresh.tag = 300;
    [_collectionView addSubview:didRelaseRefresh];
}
//刷新已发布
-(void)refresh{
    [self request];
}

//报价列表
-(void)request{
    //ReleaseModel *model = [[StorageMgr singletonStorageMgr] objectForKey:@"UserInfo"];
    NSDictionary *para = @{@"Id" : @(_IssueId)};
    [RequestAPI requestURL:@"/selectOffer_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:300];
        [ref endRefreshing];
        NSLog(@"报价列表:%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary *content = responseObject[@"content"];
            if (histroyNum == 1) {
                [_histroyArr removeAllObjects];
            }
            for (NSDictionary *dict in list) {
                ReleaseModel *model = [[ReleaseModel alloc]initWithDictForHistroy:dict];
                [_histroyArr addObject:model];
            }
            [_histroyTableView reloadData];
        }
        e
        }
        else{
            [Utilities popUpAlertViewWithMsg:@"网络错误,请稍后再试" andTitle:@"提示" onView:self];
        }
    }failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:300];
        [ref endRefreshing];
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - conllectionView
//有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
//每组有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
//item长什么样
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OfferCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"offerCell" forIndexPath:indexPath];
    //设置边框阴影
    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.layer.shadowRadius = 4.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    //未选中时的背景颜色
    UIView *bv = [UIView new];
    bv.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = bv;
    return cell;
}
//每个细胞的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //整个屏幕的宽度
    CGFloat x = self.view.frame.size.height / 4.5;
    //间距
    CGFloat space = self.view.frame.size.width - 40;
    return CGSizeMake(space,x);
}

@end
