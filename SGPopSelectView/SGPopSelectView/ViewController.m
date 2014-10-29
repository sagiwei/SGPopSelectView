//
//  ViewController.m
//  SGPopSelectView
//
//  Created by Sagi on 14-10-29.
//  Copyright (c) 2014年 azurelab. All rights reserved.
//

#import "ViewController.h"
#import "SGPopSelectView.h"

@interface ViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *selections;
@property (nonatomic, strong) SGPopSelectView *popView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selections = @[@"Shake It Off",@"All About that Bass",@"Animals",@"Take Me To Church",@"Out Of The Woods",@"Centuries",@"I'm Not the Only One",@"Burnin' It Down"];
    self.popView = [[SGPopSelectView alloc] init];
    self.popView.selections = self.selections;
    __weak typeof(self) weakSelf = self;
    self.popView.selectedHandle = ^(NSInteger selectedIndex){
        NSLog(@"selected index %ld, content is %@", selectedIndex, weakSelf.selections[selectedIndex]);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAction:(id)sender {
    CGPoint p = [(UIButton *)sender center];
    [self.popView showFromView:self.view atPoint:p animated:YES];
}

- (IBAction)tapAction:(UIGestureRecognizer *)sender {
    [self.popView hide:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.view];
    if (self.popView.visible && CGRectContainsPoint(self.popView.frame, p)) {
        return NO;
    }
    return YES;
}

@end
