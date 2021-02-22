//
//  TodayViewController.m
//  TodayExtension
//
//  Created by Xhorse_iOS3 on 2021/2/20.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <SDAutoLayout.h>

@interface TodayViewController () <NCWidgetProviding, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *avatarV;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIProgressView *progressV;
@property (nonatomic, strong) UIButton *copcBtn;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 可展开
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    
    [self setupViews];
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        weakSelf.progressV.progress -= (CGFloat)1/30;
        if (weakSelf.progressV.progress == 0.0) {
            weakSelf.timer.fireDate = [NSDate distantFuture];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 视图出现在 widgetPerformUpdateWithCompletionHandler: 方法之后
    // 在这里刷新数据
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)setupViews {
    
    self.avatarV = [UIImageView new];
    self.avatarV.image = [UIImage imageNamed:@"bgImage"];
    
    self.nameLab = [UILabel new];
    self.nameLab.font = [UIFont systemFontOfSize:14];
    self.nameLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.nameLab.text = @"Have fun today 😊";
    
    self.copcBtn = [UIButton new];
    [self.copcBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.copcBtn setTitle:@"Copy" forState:UIControlStateNormal];
    [self.copcBtn addTarget:self action:@selector(copcAction:) forControlEvents:UIControlEventTouchUpInside];
    self.copcBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.copcBtn.layer.borderWidth = 1;
    self.copcBtn.layer.borderColor = [UIColor redColor].CGColor;
    
    self.progressV = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressV.progress = 1.0;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self.view sd_addSubviews:@[self.avatarV, self.nameLab, self.tableView, self.copcBtn, self.progressV]];
    
    self.avatarV.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 5)
    .heightIs(50)
    .widthEqualToHeight();
    
    self.nameLab.sd_layout
    .leftSpaceToView(self.avatarV, 10)
    .rightSpaceToView(self.view, 10)
    .topEqualToView(self.avatarV)
    .autoHeightRatio(0);
    
    self.copcBtn.sd_layout
    .leftSpaceToView(self.avatarV, 10)
    .topSpaceToView(self.nameLab, 5)
    .heightIs(20);
    
    self.progressV.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.avatarV, 5)
    .heightIs(10);
    
    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.progressV, 5)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 10);
    
    
}

- (void)copcAction:(UIButton *)sender {
    NSLog(@"cpoy");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"LHQWidget://copy"]];
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        NSLog(@"copy success");
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = @"2";
    return cell;
}

#pragma mark - <NCWidgetProviding>

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    
    /**
     8p : {348, 672}, {348, 105}
     se : {321, 616}, {321, 110}
     
     */
    
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
    } else {
        self.preferredContentSize = CGSizeMake(maxSize.width, 672);
    }
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
