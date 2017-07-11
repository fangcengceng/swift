//
//  ViewController.m
//  ttt
//
//  Created by 北极星 on 2017/7/10.
//  Copyright © 2017年 aa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) NSArray *dataArray;

@end

@implementation ViewController{
    NSMutableArray *_titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)category
{
    //分好组的数组
    _titleArray=[NSMutableArray array];
    //遍历时，时间相同的装在同一个数组中，先取_dataArray[0]分一组
    NSMutableArray *currentArr=[NSMutableArray array];
    [currentArr addObject:_dataArray[0]];
    [_titleArray addObject:currentArr];
    
    if(_dataArray.count>1)
    {
        
        for (int i=1;i<_dataArray.count;i++)
        {
            //取上一组元素并获取上一组元素的比较日期
            NSMutableArray *preArr=[_titleArray objectAtIndex:_titleArray.count-1];
            
            NSString *pretime=[[preArr objectAtIndex:0] objectForKey:@"birthTime"];
            NSString *premonth=[[[[pretime componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:1];
            NSString *preday=[[[[pretime componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:2];
            NSString *preStr=[premonth stringByAppendingString:preday];
            //取当前遍历的字典中的日期
            NSDictionary *currentDict=[_dataArray objectAtIndex:i];
            NSString *time=[currentDict objectForKey:@"birthTime"];
            NSString *month=[[[[time componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:1];
            NSString *day=[[[[time componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:2];
            NSString *currentStr=[month stringByAppendingString:day];
            //如果遍历当前字典的日期和上一组元素中日期相同则把当前字典分类到上一组元素中
            if([currentStr isEqualToString:preStr])
            {
                [currentArr addObject:currentDict];
            }
            //如果当前字典的日期和上一组元素日期不同，则重新开新的一组，把这组放入到分类数组中
            else
            {
                currentArr=[NSMutableArray array];
                [currentArr addObject:currentDict];
                [_titleArray addObject:currentArr];
                
            }
            
            
        }
        
    }
    
}

@end
