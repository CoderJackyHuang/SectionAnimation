//
//  ViewController.m
//  SectionAnimationDemo
//
//  Created by huangyibiao on 16/6/8.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "ViewController.h"
#import "HYBSectionModel.h"
#import "HYBHeaderView.h"

static NSString *kCellIdentfier = @"UITableViewCell";
static NSString *kHeaderIdentifier = @"HeaderView";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionDataSources;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:self.tableView];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kCellIdentfier];
  [self.tableView registerClass:[HYBHeaderView class] forHeaderFooterViewReuseIdentifier:kHeaderIdentifier];
}

- (NSMutableArray *)sectionDataSources {
  if (_sectionDataSources == nil) {
    _sectionDataSources = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < 20; ++i) {
      HYBSectionModel *sectionModel = [[HYBSectionModel alloc] init];
      sectionModel.isExpanded = NO;
      sectionModel.sectionTitle = [NSString stringWithFormat:@"section: %ld", i];
      NSMutableArray *itemArray = [[NSMutableArray alloc] init];
      for (NSUInteger j = 0; j < 10; ++j) {
        HYBCellModel *cellModel = [[HYBCellModel alloc] init];
        cellModel.title = [NSString stringWithFormat:@"标哥出品：section=%ld, row=%ld", i, j];
        [itemArray addObject:cellModel];
      }
      sectionModel.cellModels = itemArray;
      
      [_sectionDataSources addObject:sectionModel];
    }
  }
  
  return _sectionDataSources;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.sectionDataSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  HYBSectionModel *sectionModel = self.sectionDataSources[section];
  
  return sectionModel.isExpanded ? sectionModel.cellModels.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentfier
                                                          forIndexPath:indexPath];
  HYBSectionModel *sectionModel = self.sectionDataSources[indexPath.section];
  HYBCellModel *cellModel = sectionModel.cellModels[indexPath.row];
  cell.textLabel.text = cellModel.title;
  
  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  HYBHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderIdentifier];
  
  HYBSectionModel *sectionModel = self.sectionDataSources[section];
  view.model = sectionModel;
  view.expandCallback = ^(BOOL isExpanded) {
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
             withRowAnimation:UITableViewRowAnimationFade];
  };
  
  return view;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 44;
}

@end
