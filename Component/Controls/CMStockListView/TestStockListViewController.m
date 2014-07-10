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
//    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]] autorelease];
    self.dataList = [NSMutableArray array];
    
    for(int i = 0;i < 1; i ++)
        [self.dataList addObject:[NSNumber numberWithInt:i]];

//    testTable = [[CMStockListView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - kSysStatusBarHeight - kNavToolBarHeight) pullDirection:CMTableViewPullDirectionUpDown];
    testTable = [[CMStockListView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - kSysStatusBarHeight - kNavToolBarHeight) cmStyle:CMTableViewStyleNormal];
    testTable.delegate = self;
    testTable.dataSource = self;
    testTable.refreshDataDelegate = (id<CMRefreshTableViewDelegate>)self;
    [self.view addSubview:testTable];
    [testTable release];
    
//    [testTable performSelector:@selector(startManualRefresh) withObject:nil afterDelay:2];
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

- (void)refreshDataView:(CMTableView *)dataView loadType:(CMTableViewLoadType)loadType indexPath:(NSIndexPath*)indexPath
{
    NSLog(@"refreshDataView loadType = %d",loadType);

    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(loadType == CMTableViewLoadType_LoadMore)
        {
            int currentCount = [self.dataList count];
            for(int i = currentCount; i < currentCount + 1; i ++)
                [self.dataList addObject:[NSNumber numberWithInt:i]];
        }
        else
        {
            [self.dataList removeAllObjects];
            for(int i = 0;i < 1; i ++)
                [self.dataList addObject:[NSNumber numberWithInt:i]];
        }
        
        [dataView refreshDone];
    });
}
- (void)refreshDataView:(CMTableView *)dataView visibleRange:(NSDictionary *)rangeDict;
{
    
}


@end
