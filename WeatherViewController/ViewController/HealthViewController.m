//
//  HealthViewController.m
//  WeatherViewController
//
//  Created by Macx on 16/3/8.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "HealthViewController.h"
#import <HealthKit/HealthKit.h>

@interface HealthViewController ()

@property (nonatomic, strong)UILabel *stepLabel;
@property (nonatomic, strong)UIView *customBar;

@end

@implementation HealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self createCustomBar];
    
    self.stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 100)];
    self.stepLabel.textColor = [UIColor redColor];
    self.stepLabel.textAlignment = NSTextAlignmentCenter;
    self.stepLabel.backgroundColor =[UIColor orangeColor];
    self.stepLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.stepLabel];
    
    [self getSteps];
}

#pragma mark - Custom Bar

- (void)createCustomBar {
    self.customBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.customBar.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.customBar];
}

#pragma mark - 获取今日步数

- (void)getSteps {
    //healthKit
    if ([HKHealthStore isHealthDataAvailable]) {
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        NSSet *readObjectTypes = [NSSet setWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount], nil];
        [healthStore requestAuthorizationToShareTypes:nil readTypes:readObjectTypes completion:^(BOOL success, NSError * _Nullable error) {
            if (success == YES) {
                //授权成功
            }else {
                //授权失败
            }
        }];
        
        HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.day = 1;
        
        HKStatisticsCollectionQuery *collectionQuery = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:nil options:HKStatisticsOptionCumulativeSum | HKStatisticsOptionSeparateBySource anchorDate:[NSDate dateWithTimeIntervalSince1970:0] intervalComponents:dateComponents];
        
        collectionQuery.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error) {
            
            HKStatistics *statistic = result.statistics.lastObject;
            
            for (HKSource *source in statistic.sources) {
                if ([source.name isEqualToString:[UIDevice currentDevice].name]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.stepLabel.text = [NSString stringWithFormat:@"%.0f", [[statistic sumQuantityForSource:source] doubleValueForUnit:[HKUnit countUnit]]];
                    });
                }
            }
        };
        [healthStore executeQuery:collectionQuery];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
