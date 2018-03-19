//
//  SDMViewController.m
//  PerfTest
//
//  Created by Tyrone Trevorrow on 16/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import "SDMViewController.h"
#import "SDMTest.h"
#import "SDMHorizontalLayoutView.h"

@interface SDMViewController ()

@end

@implementation SDMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // Create TextView
    CGRect tvFrame = self.view.bounds;
    tvFrame.size.height -= 44;
    UITextView *tv = [[UITextView alloc] initWithFrame: tvFrame];
    tv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview: tv];
    self.textView = tv;

    // Create button container
    CGRect btnContainerFrame = self.view.bounds;
    btnContainerFrame.origin.y = self.view.bounds.size.height - 44;
    btnContainerFrame.size.height = 44;
    SDMHorizontalLayoutView *btnContainer = [[SDMHorizontalLayoutView alloc] initWithFrame: btnContainerFrame];
    btnContainer.spacing = 8;
    [self.view addSubview: btnContainer];

    // Create buttons
    {
        UIButton *treeTest = [[UIButton alloc] initWithFrame: CGRectMake(0,0,44,44)];
        [treeTest setTitle: @"Euler Test" forState: UIControlStateNormal];
        [treeTest addTarget: self action: @selector(eulerTestAction:) forControlEvents: UIControlEventTouchUpInside];
        [btnContainer addSubview: treeTest];
    }

    {
        UIButton *sqliteTest = [[UIButton alloc] initWithFrame: CGRectMake(0,0,44,44)];
        [sqliteTest setTitle: @"SQLite Test" forState: UIControlStateNormal];
        [sqliteTest addTarget: self action: @selector(sqliteTestAction:) forControlEvents: UIControlEventTouchUpInside];
        [btnContainer addSubview: sqliteTest];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    self.textView.text = @"";
}

- (void) eulerTestAction: (id) sender
{
    [self appendText: [SDMTest runEulerTest]];
}

- (void) sqliteTestAction: (id) sender
{
    [self appendText: [SDMTest runSqliteTest]];
}

- (void) appendText: (NSString*) text {
    [self.textView setText: [self.textView.text stringByAppendingFormat: @"\n%@", text]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
