//
//  SDMViewController.m
//  PerfTest
//
//  Created by Tyrone Trevorrow on 16/03/18.
//  Copyright (c) 2018 Sudeium. All rights reserved.
//

#import "SDMViewController.h"
#import "SDMTest.h"

@interface SDMViewController ()

@end

@implementation SDMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITextView *tv = [[UITextView alloc] initWithFrame: self.view.bounds];
    tv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview: tv];
    self.textView = tv;
}

- (void) viewDidAppear:(BOOL)animated
{
    self.textView.text = @"";
    [self runTest];
    [self runTest];
    [self runTest];
}

- (void) runTest {
    CFTimeInterval before = CACurrentMediaTime();
    [SDMTest runTest];
    CFTimeInterval after = CACurrentMediaTime();
    [self.textView setText: [self.textView.text stringByAppendingFormat: @"\nTest: %.4f", after - before]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
