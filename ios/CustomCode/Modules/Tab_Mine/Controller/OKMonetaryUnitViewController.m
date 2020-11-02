//
//  OKMonetaryUnitViewController.m
//  OneKey
//
//  Created by bixin on 2020/10/30.
//  Copyright © 2020 Calin Culianu. All rights reserved.
//

#import "OKMonetaryUnitViewController.h"
#import "OKUnitTableViewCell.h"
#import "OKUnitTableViewCellModel.h"
#import "OKMoreBtn.h"

@interface OKMonetaryUnitViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *allData;
@end

@implementation OKMonetaryUnitViewController
+ (instancetype)monetaryUnitViewController
{
    return [[UIStoryboard storyboardWithName:@"Tab_Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"OKMonetaryUnitViewController"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = MyLocalizedString(@"Monetary unit", nil);
    self.tableView.tableFooterView = [UIView new];
    
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    view.backgroundColor = HexColor(0xF5F6F7);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 200, 22)];
    switch (section) {
        case 0:
            label.text = MyLocalizedString(@"Legal tender units", nil);
            break;
        case 1:
            label.text = MyLocalizedString(@"Bitcoin unit", nil);
            break;
        case 2:
            label.text = MyLocalizedString(@"Ethereum unit", nil);
            break;
        default:
            break;
    }
    label.textColor = HexColor(0x546370);
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allData[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"OKUnitTableViewCell";
    OKUnitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OKUnitTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.allData[indexPath.section][indexPath.row];
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 67)];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = HexColor(0xF1F1F1);
        [view addSubview:lineView];
        OKMoreBtn *btn = [[OKMoreBtn alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 67)];
        [btn setTitle:MyLocalizedString(@"More and more", nil) forState:UIControlStateNormal];
        [btn setTitleColor:HexColor(0x00B812) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"greenarrow"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(moreMoneyUnitClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 67;
    }
    return 0;
}


- (void)moreMoneyUnitClick
{
    NSLog(@"点击了更多");
}


- (NSArray *)allData
{
    if (!_allData) {
        
        NSMutableArray *allDataM = [NSMutableArray array];
        
        NSMutableArray *moneyUnitGroup = [NSMutableArray array];
        
        OKUnitTableViewCellModel *model1 = [[OKUnitTableViewCellModel alloc]init];
        model1.titleStr = MyLocalizedString(@"人民币（CNY）", nil);
        model1.isSelected = YES;
        
        
        OKUnitTableViewCellModel *model2 = [[OKUnitTableViewCellModel alloc]init];
        model2.titleStr = MyLocalizedString(@"Us Dollar (CNY)", nil);
        model2.isSelected = NO;
        
        OKUnitTableViewCellModel *model3 = [[OKUnitTableViewCellModel alloc]init];
        model3.titleStr = MyLocalizedString(@"Korean Won (CNY)", nil);
        model3.isSelected = NO;
        [moneyUnitGroup addObject:model1];
        [moneyUnitGroup addObject:model2];
        [moneyUnitGroup addObject:model3];
        
        [allDataM addObject:moneyUnitGroup];
        
        NSMutableArray *btcUnitGroup = [NSMutableArray array];
        
        OKUnitTableViewCellModel *model4 = [[OKUnitTableViewCellModel alloc]init];
        model4.titleStr = @"BTC";
        model4.isSelected = YES;
        [btcUnitGroup addObject:model4];
        
        OKUnitTableViewCellModel *model5 = [[OKUnitTableViewCellModel alloc]init];
        model5.titleStr = @"mBTC";
        model5.isSelected = NO;
        model5.descStr = @"=0.001 BTC";
        [btcUnitGroup addObject:model5];
        
        
        OKUnitTableViewCellModel *model6 = [[OKUnitTableViewCellModel alloc]init];
        model6.titleStr = @"bits";
        model6.isSelected = NO;
        model6.descStr = @"=0.000001 BTC";
        [btcUnitGroup addObject:model6];
        
        OKUnitTableViewCellModel *model7 = [[OKUnitTableViewCellModel alloc]init];
        model7.titleStr = @"sat";
        model7.isSelected = YES;
        model7.descStr = @"0.00000001 BTC";
        [btcUnitGroup addObject:model7];
        
        
        NSMutableArray *ethUnitGroup = [NSMutableArray array];
        OKUnitTableViewCellModel *model8 = [[OKUnitTableViewCellModel alloc]init];
        model8.titleStr = @"ETH";
        model8.isSelected = YES;
        [ethUnitGroup addObject:model8];
        
        
        [allDataM addObject:btcUnitGroup];
        [allDataM addObject:ethUnitGroup];
        _allData = allDataM;
    }
    return _allData;
}


@end
