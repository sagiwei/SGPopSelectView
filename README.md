SGPopSelectVIew
===============

一个简洁、美观的单选弹出视图

###特点
- 自适应选项内容调整自身大小，不用担心选项标题过长被截断显示。
- 根据传入基准点自适应在父试图中显示的位置。

###用法
1. 初始化
```objective-c
    self.selections = @[@"Shake It Off",@"All About that Bass",@"Animals",@"Take Me To Church",@"Out Of The Woods",@"Centuries",@"I'm Not the Only One",@"Burnin' It Down"];
    self.popView = [[SGPopSelectView alloc] init];
    self.popView.selections = self.selections;
    __weak typeof(self) weakSelf = self;
    self.popView.selectedHandle = ^(NSInteger selectedIndex){
        NSLog(@"selected index %ld, content is %@", selectedIndex, weakSelf.selections[selectedIndex]);
    };
```
2. 显示
```objective-c
    CGPoint p = [(UIButton *)sender center];
    [self.popView showFromView:self.view atPoint:p animated:YES];
```
3. 隐藏
```objective-c
    [self.popView hide:YES];
```

