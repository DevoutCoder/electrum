//
//  OKWalletViewController.m
//  Electron-Cash
//
//  Created by bixin on 2020/9/28.
//  Copyright © 2020 Calin Culianu. All rights reserved.
//

#import "OKWalletViewController.h"
#import <OKPythonExecute.h>
#import "OKSelectCellModel.h"
#import "OKSelectTableViewCell.h"
#import "OKCreateHDCell.h"
#import "OKFirstUseViewController.h"
#import "OKPwdViewController.h"
#import "OKWordImportVC.h"
#import "OKAssetTableViewCell.h"
#import "OKTxListViewController.h"
#import "OKWalletDetailViewController.h"
#import "OKWalletListViewController.h"
#import "OKReceiveCoinViewController.h"
#import "OKBackUpTipsViewController.h"
#import "OKSendCoinViewController.h"


@interface OKWalletViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

//顶部切换钱包视图

@property (weak, nonatomic) IBOutlet UIView *topLeftBgView;

//无钱包的创建页面
@property (weak, nonatomic) IBOutlet UIView *createBgView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *coinImage;
@property (weak, nonatomic) IBOutlet UILabel *walletName;
@property (weak, nonatomic) IBOutlet UITableView *selectCreateTableView;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

@property (nonatomic,strong) OKPythonExecute * execute;
@property (nonatomic,strong) OKPythonExecute * execute1;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *leftViewBg;

@property (nonatomic,strong)NSArray *allData;

//有钱包的界面
@property (weak, nonatomic) IBOutlet UIView *walletHomeBgView;
@property (weak, nonatomic) IBOutlet UIView *walletTopBgView;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *myassetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eyeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *eyeBtnClick;

@property (weak, nonatomic) IBOutlet UIView *srBgView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (IBAction)sendBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
- (IBAction)receiveBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *assetTableView;


//备份提醒
@property (weak, nonatomic) IBOutlet UIView *backupBgView;
@property (weak, nonatomic) IBOutlet UILabel *backupTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *backupDescLabel;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;

//assetTableViewHeader
@property (weak, nonatomic) IBOutlet UIView *assettableViewHeader;
@property (weak, nonatomic) IBOutlet UILabel *tableViewHeaderTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *tableViewHeaderSearch;
@property (weak, nonatomic) IBOutlet UIButton *tableViewHeaderAddBtn;
- (IBAction)tableViewHeaderAddBtnClick:(UIButton *)sender;


- (IBAction)assetListBtnClick:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIView *tableViewHeaderView;




@end

@implementation OKWalletViewController

+ (instancetype)walletViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Tab_Wallet" bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:@"OKWalletViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self stupUI];
    //[self showFirstUse];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notiWalletCreateComplete) name:kNotiWalletCreateComplete object:nil];
}


#pragma mark -  初始化UI
- (void)stupUI
{
    [self checkWalletResetUI];
    [self.topView setLayerDefaultRadius];
    [self.bottomView setLayerDefaultRadius];
    [self.leftViewBg setLayerRadius:14];
    [self.scanBtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    [self.leftView addGestureRecognizer:tapGesture];
    self.navigationController.delegate = self;
    

    //asset界面
    [self.walletTopBgView setCornerWith:20 side:OKCornerPathTopLeft|OKCornerPathTopRight withSize:CGSizeMake(SCREEN_WIDTH - 40, 168)];
    [self.srBgView setCornerWith:20 side:OKCornerPathBottomLeft|OKCornerPathBottomRight withSize:CGSizeMake(SCREEN_WIDTH - 40, 68)];
    [self.assettableViewHeader setCornerWith:20 side:OKCornerPathTopLeft|OKCornerPathTopRight withSize:CGSizeMake(SCREEN_WIDTH - 40, 74)];
    [self.backupBgView setLayerDefaultRadius];
    [self.tableViewHeaderSearch setLayerBoarderColor:HexColor(0xF2F2F2) width:1 radius:self.tableViewHeaderSearch.height * 0.5];
    self.assetTableView.rowHeight = 75;
    if (@available(iOS 11.0, *)) {
        [self.stackView setCustomSpacing:0 afterView:self.walletTopBgView];
    } else {
        // Fallback on earlier versions
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backUpBgClick)];
    [self.backupBgView addGestureRecognizer:tap];
    
    self.assetTableView.tableFooterView = [UIView new];
    
}
#pragma mark - 检查钱包状态并重置UI
- (void)checkWalletResetUI
{
    //是否创建过钱包
    if (1) {
        self.createBgView.hidden = YES;
        self.walletHomeBgView.hidden = NO;
    }else{
        self.createBgView.hidden = NO;
        self.walletHomeBgView.hidden = YES;
    }
    //是否备份过钱包
    if (0) {
        self.backupBgView.hidden = YES;
        self.tableViewHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 348);
        [self.assetTableView setTableHeaderView:self.tableViewHeaderView];
    }else{
        self.tableViewHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 490);
        [self.assetTableView setTableHeaderView:self.tableViewHeaderView];
        self.backupBgView.hidden = NO;
    }
}

- (void)showFirstUse
{
    OKFirstUseViewController *firstUseVc = [OKFirstUseViewController firstUseViewController];
    BaseNavigationController *navVc = [[BaseNavigationController alloc]initWithRootViewController:firstUseVc];
    navVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:navVc animated:NO completion:nil];
}

- (void)backUpBgClick
{
    NSLog(@"点击了备份");
}


#pragma mark - 切换钱包
- (void)tapGestureClick
{
    OKWalletListViewController *walletListVc = [OKWalletListViewController walletListViewController];
    BaseNavigationController *baseVc = [[BaseNavigationController alloc]initWithRootViewController:walletListVc];
    [self.view.window.rootViewController presentViewController:baseVc animated:YES completion:nil];
    
    
    
    NSLog(@"切换钱包");
        NSLog(@"切换钱包");
        OKPythonExecute *pythonExecute = [[OKPythonExecute alloc] initWithModuleDirName:@"onekey" moduleName:@"testxx"];
        _execute1 = pythonExecute;
        NSDictionary *params = @{@"kkkk":@"helo"};
        [pythonExecute executeWithClass:@"OCToPY" methodName:@"testoctopy" parameter:params success:^(id result) {

            NSLog(@"===resutl = %@",result);
        } fail:^(NSError *error) {
            NSLog(@"====error = %@",error.domain);
        }];
}
#pragma mark - 扫描二维码
- (void)scanBtnClick
{
        OKPythonExecute *pythonExecute = [[OKPythonExecute alloc] initWithModuleDirName:@"onekey" moduleName:@"testbx"];
        _execute = pythonExecute;
    
        NSDictionary *params = @{@"xxx":@"hello"};
        [pythonExecute executeWithClass:@"TokenForiOS" methodName:@"createtoken" parameter:params success:^(id result) {
    
            NSLog(@"===resutl = %@",result);
        } fail:^(NSError *error) {
            NSLog(@"====error = %@",error.domain);
        }];

    NSLog(@"扫描二维码");
}
#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.selectCreateTableView) {
        return 1;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.selectCreateTableView) {
        return self.allData.count;
    }
    return  1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.selectCreateTableView) {
        if (indexPath.row == 0) {
            static NSString *ID = @"OKCreateHDCell";
            OKCreateHDCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[OKCreateHDCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            cell.model = [self.allData firstObject];
            return cell;
        }else{
            static NSString *ID = @"OKSelectTableViewCell";
            OKSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[OKSelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            OKSelectCellModel *model = self.allData[indexPath.row];
            cell.model = model;
            return cell;
        }
    }
    
    //assetTableView
    static NSString *ID = @"OKAssetTableViewCell";
    OKAssetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OKAssetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectCreateTableView) {
        OKWeakSelf(self)
        OKSelectCellModel *model = self.allData[indexPath.row];
        if (model.type == OKSelectCellTypeCreateHD) { //创建
            OKPwdViewController *pwdVc = [OKPwdViewController pwdViewController];
            BaseNavigationController *baseVc = [[BaseNavigationController alloc]initWithRootViewController:pwdVc];
            [weakself.view.window.rootViewController presentViewController:baseVc animated:YES completion:nil];
        }else if (model.type == OKSelectCellTypeRestoreHD){ //恢复
            OKWordImportVC *wordImport = [OKWordImportVC initViewController];
            BaseNavigationController *baseVc = [[BaseNavigationController alloc]initWithRootViewController:wordImport];
            [weakself.view.window.rootViewController presentViewController:baseVc animated:YES completion:nil];
        }else if (model.type == OKSelectCellTypeMatchHD){ //匹配硬件
            NSLog(@"匹配硬件钱包");
            
        }
        return;
    }
    OKTxListViewController *txListVc = [OKTxListViewController initViewControllerWithStoryboardName:@"Tab_Wallet"];
    [self.navigationController pushViewController:txListVc animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.assetTableView) {
        CGFloat offY = scrollView.contentOffset.y;
        if (offY < 0) {
            scrollView.contentOffset = CGPointZero;
        }
    }
}

- (IBAction)testClick:(UIButton *)sender {
    
    PyGILState_STATE state =  PyGILState_Ensure();
    PyObject *pModule = PyImport_ImportModule([@"electroncash.testbx" UTF8String]);//导入模块
    PyObject *pyClass = PyObject_GetAttrString(pModule, [@"TokenForiOS" UTF8String]);//获取类
    PyObject *pyInstance = PyInstanceMethod_New(pyClass); //创建实例
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"123" forKey:@"access_key"];
    [params setObject:@"456" forKey:@"secret_key"];
    [params setObject:@"jake" forKey:@"bucket_name"];
    [params setObject:@"pic" forKey:@"file_name"];
        
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *paramterJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //PyObject_CallMethod(self.pyInstance, [methodName UTF8String], "(N,s)",self.pyClass,[paramterJsonString UTF8String]);
    PyObject *result = NULL;
    result = PyObject_CallMethod(pyInstance, [@"createtoken" UTF8String], "(N,s)",pyClass, [paramterJsonString UTF8String] );

    char * resultCString = NULL;
    PyArg_Parse(result, "s", &resultCString); //将python类型的返回值转换为c
     
    PyGILState_Release(state);
    
    NSLog(@"%s", resultCString);
    
    
//    OKPythonExecute *pythonExecute = [[OKPythonExecute alloc] initWithModuleDirName:@"electroncash" moduleName:@"testbx"];
//    _execute = pythonExecute;
//
//    NSDictionary *params = @{@"xxx":@"hello"};
//    [pythonExecute executeWithClass:@"TokenForiOS" methodName:@"createtoken" parameter:params success:^(id result) {
//
//        NSLog(@"===resutl = %@",result);
//    } fail:^(NSError *error) {
//        NSLog(@"====error = %@",error.domain);
//    }];
}
- (IBAction)test:(UIButton *)sender {
    
    PyGILState_STATE state =  PyGILState_Ensure();
    
    PyObject *pModule = PyImport_ImportModule([@"electroncash.testxx" UTF8String]);//导入模块
        
    PyObject *pyClass = PyObject_GetAttrString(pModule, [@"OCToPY" UTF8String]);//获取类
        
    PyObject *pyInstance = PyInstanceMethod_New(pyClass); //创建实例
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"123" forKey:@"access_key"];
    [params setObject:@"456" forKey:@"secret_key"];
    [params setObject:@"jake" forKey:@"bucket_name"];
    [params setObject:@"pic" forKey:@"file_name"];
        
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *paramterJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //PyObject_CallMethod(self.pyInstance, [methodName UTF8String], "(N,s)",self.pyClass,[paramterJsonString UTF8String]);
    PyObject *result = NULL;
    result = PyObject_CallMethod(pyInstance, [@"testoctopy" UTF8String], "(N,s)",pyClass, [paramterJsonString UTF8String] );

    char * resultCString = NULL;
    PyArg_Parse(result, "s", &resultCString); //将python类型的返回值转换为c
     
    PyGILState_Release(state);
    
    NSLog(@"%s", resultCString);

    
    
//    if ([_execute1 isRuning]) {
//        return;
//    }
//    OKPythonExecute *pythonExecute = [[OKPythonExecute alloc] initWithModuleDirName:@"electroncash" moduleName:@"testxx"];
//    _execute1 = pythonExecute;
//    NSDictionary *params = @{@"kkkk":@"helo"};
//    [pythonExecute executeWithClass:@"OCToPY" methodName:@"testoctopy" parameter:params success:^(id result) {
//
//        NSLog(@"===resutl = %@",result);
//    } fail:^(NSError *error) {
//        NSLog(@"====error = %@",error.domain);
//    }];
}

- (NSArray *)allData
{
    if (!_allData) {
        _allData = [NSArray array];
        OKSelectCellModel *model1 = [OKSelectCellModel new];
        model1.titleStr = MyLocalizedString(@"Create HD Wallet", nil);
        model1.descStr = MyLocalizedString(@"Completely free and unlimited quantity", nil);
        model1.imageStr = @"add";
        model1.descStrL = MyLocalizedString(@"It takes just a few minutes to create a wallet for free and quickly, and then you're free to send and receive assets, make transactions, and explore the blockchain world", nil);
        model1.type = OKSelectCellTypeCreateHD;
        
        OKSelectCellModel *model2 = [OKSelectCellModel new];
        model2.titleStr = MyLocalizedString(@"Recover HD Wallet", nil);
        model2.descStr = MyLocalizedString(@"Recovery by mnemonic", nil);
        model2.imageStr = @"import";
        model2.descStrL = @"";
        model2.type = OKSelectCellTypeRestoreHD;
        
        OKSelectCellModel *model3 = [OKSelectCellModel new];
        model3.titleStr = MyLocalizedString(@"Paired hardware wallet", nil);
        model3.descStr = MyLocalizedString(@"Support BixinKey", nil);
        model3.imageStr = @"match_hardware";
        model3.descStrL = @"";
        model3.type = OKSelectCellTypeMatchHD;
        
        _allData = @[model1,model2,model3];
    }
    return  _allData;
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
#pragma mark - 转账
- (IBAction)sendBtnClick:(UIButton *)sender {
    OKSendCoinViewController *sendCoinVc = [OKSendCoinViewController sendCoinViewController];
    [self.navigationController pushViewController:sendCoinVc animated:YES];
}
#pragma mark - 收款
- (IBAction)receiveBtnClick:(UIButton *)sender {
    OKReceiveCoinViewController *receiveCoinVc = [OKReceiveCoinViewController receiveCoinViewController];
    [self.navigationController pushViewController:receiveCoinVc animated:YES];
}
#pragma mark - 钱包详情
- (IBAction)assetListBtnClick:(UIButton *)sender {
    OKWalletDetailViewController *walletDetailVc = [OKWalletDetailViewController walletDetailViewController];
    [self.navigationController pushViewController:walletDetailVc animated:YES];
}
#pragma mark - 添加资产
- (IBAction)tableViewHeaderAddBtnClick:(UIButton *)sender {
    NSLog(@"添加资产");
}

#pragma mark - NotiWalletCreateComplete
- (void)notiWalletCreateComplete
{
    NSLog(@"NotiWalletCreateComplete");
    OKBackUpTipsViewController *backUpTips = [OKBackUpTipsViewController backUpTipsViewController:^(BackUpBtnClickType type) {
            if (type == BackUpBtnClickTypeClose) {
                //下次再说  关闭窗口
            }else if (type == BackUpBtnClickTypeBackUp){
                
            }
    }];
    
    UINavigationController *navVc = [[UINavigationController alloc]initWithRootViewController:backUpTips];
    navVc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.view.window.rootViewController presentViewController:navVc animated:NO completion:nil];
}

@end
