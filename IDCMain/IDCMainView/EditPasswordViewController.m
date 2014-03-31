//
//  EditPasswordViewController.m
//  IDCForIOS
//
//  Created by Mac on 14-3-31.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "EditPasswordViewController.h"

@interface EditPasswordViewController (){

    IBOutlet UITableView *tableView;
}

@end

@implementation EditPasswordViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
