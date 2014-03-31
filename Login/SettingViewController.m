//
//  SettingViewController.m
//  BulidMap
//
//  Created by Mac on 14-1-20.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController (){
    NSUserDefaults *ud;
    UITextField *textField;
}

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItem = back;
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClick:)];
    self.navigationItem.rightBarButtonItem = refresh;
    
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 100, 40)];
    label.text = @"服务器地址";
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, 250, 35)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    
    ud = [NSUserDefaults standardUserDefaults];
    NSString *url = [ud stringForKey:@"url"];
    if(url == nil){
        url = @"http://192.168.203.129";
        [ud setValue:url forKey:@"url"];
        [ud synchronize];
    }
    textField.text = url;
    [self.view addSubview:label];
    [self.view addSubview:textField];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButtonClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)doneButtonClick:(id)sender{
    if(textField.text == nil || textField.text.length == 0 ){
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写服务地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }else{
        [ud setValue:textField.text forKey:@"url"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
@end
