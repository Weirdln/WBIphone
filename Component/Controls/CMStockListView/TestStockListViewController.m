//
//  TestStockListViewController.m
//  DzhIPhone
//
//  Created by Weirdln on 14-6-30.
//
//

#import "TestStockListViewController.h"
#import "CMStockListView.h"


@interface TestStockListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CMStockListView *testTable;
}
@property (nonatomic ,retain)NSMutableArray *dataList;
@end

@implementation TestStockListViewController
@synthesize dataList;

-(void)dealloc
{

    self.dataList = nil;
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self hideToolBarView];
}

-(void)loadUIData
{
    [super loadUIData];
    self.dataList = [NSMutableArray array];
    
    for(int i = 0;i < 100; i ++)
        [self.dataList addObject:[NSNumber numberWithInt:i]];

    testTable = [[CMStockListView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - kSysStatusBarHeight - kNavToolBarHeight) rollingLoad:YES];
    testTable.backgroundColor = [UIColor grayColor];
    testTable.delegate = self;
    testTable.dataSource = self;
    testTable.refreshDataDelegate = (id<CMRefreshTableViewDelegate>)self;
    [self.view addSubview:testTable];
    [testTable release];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identierStr = @"testCell";
    UITableViewCell *testCell = [tableView dequeueReusableCellWithIdentifier:identierStr];
    
    if(testCell == nil)
        testCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identierStr] autorelease];
    testCell.textLabel.text = [[self.dataList objectAtIndex:indexPath.row] stringValue];
    
    return testCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.8;
}

- (BOOL)refreshTableViewReloadTableViewDataSource:(CMTableViewPullType)refreshType
{
    
}
- (void)refreshDataView:(CMTableView *)dataView withRequestInfo:(NSArray *)requestInfos
{
    
}


@end
