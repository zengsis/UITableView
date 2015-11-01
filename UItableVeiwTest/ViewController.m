//
//  ViewController.m
//  UItableVeiwTest
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UILabel *_lable;
    UITextField *_textField;
    UITableView *_tableView;
    NSMutableArray *_taskArray;
    NSIndexPath *_deleteIndexPath;
}

@end
@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    _taskArray = [NSMutableArray array];
    CGSize size = self.view.frame.size;//主界面的大小
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, size.width, 40)];
    _lable.text = @"任务列表";
    _lable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lable];
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 125, size.width, size.height-100) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    //创建一个保存按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(size.width-60, 60, 60, 40)];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:20];
    [button addTarget:self action:@selector(didSaveClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //创建一个输入框
     _textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 60, size.width-100, 40)];
    _textField.placeholder = @"输入";
    [self.view addSubview:_textField];
    
    //创建一个删除按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(size.width-60, 120, 60, 40)];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self parseHTMLData];

    
}
-(void)delete:(id)sender{
    _tableView.editing=!_tableView.editing;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return [_taskArray count];
    }
        else return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
   cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_taskArray[indexPath.row]];
    return cell;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section:%ld,Row:%ld",indexPath.section,indexPath.row);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(void)didSaveClicked:(UIButton *)sender
{
    NSString *taskStr = _textField.text;
    if (taskStr == nil || taskStr.length == 0) {
        return;
        
    }
    _textField.text = @"";
    [_taskArray addObject:taskStr];
    [_tableView reloadData];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_taskArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        _deleteIndexPath = indexPath;
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"真的要删除吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];

    }
}
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [_taskArray removeObjectAtIndex:_deleteIndexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[_deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        [_tableView reloadRowsAtIndexPaths:@[_deleteIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        _deleteIndexPath = nil;
    
    }
}
-(void)parseHTMLData
{

    NSData *data=[NSData dataWithContentsOfFile:@"/Users/apple/Desktop/qiushi.html"];
    TFHpple *doc = [[TFHpple alloc]initWithHTMLData:data encoding:@"utf-8"];
    NSArray *result = [doc searchWithXPathQuery:@"//div[@class='article block untagged mb15']"];
    NSInteger count = 1;

    for (TFHppleElement *ele in result) {
       
        TFHppleElement *contEli = [[ele searchWithXPathQuery:@"//div[@class='content']"]firstObject];
        NSString *content = [contEli content];
        NSString *str = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *str2 = [NSString stringWithFormat:@"%ld.%@",(long)count++,str];
        [_taskArray addObject:str2];
    }
    [_tableView reloadData];
}
@end


//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//@end
