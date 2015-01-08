//
//  SGPopSelectView.m
//  SGPopSelectView
//
//  Created by Sagi on 14-10-28.
//  Copyright (c) 2014年 azurelab. All rights reserved.
//

#import "SGPopSelectView.h"

#define SGPOP_DEFAULT_FONT_SIZE     13
#define SGPOP_DEFAULT_ROW_HEIHGT    30
#define SGPOP_DEFAULT_MAX_HEIGHT    200

@interface SGPopSelectView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
// data
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation SGPopSelectView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _selectedIndex = NSNotFound;
        
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = NO;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)setSelectedHandle:(PopViewSelectedHandle)handle
{
    _selectedHandle = handle;
}

- (void)showFromView:(UIView *)view atPoint:(CGPoint)point animated:(BOOL)animated
{
    if (self.visible) {
        [self removeFromSuperview];
    }
    [view addSubview:self];
    [self _setupFrameWithSuperView:view atPoint:point];
    [self _showFromView:view animated:animated];
}

- (void)hide:(BOOL)animated
{
    [self _hideWithAnimated:animated];
}

- (BOOL)visible
{
    if (self.superview) {
        return YES;
    }
    return NO;
}

- (void)setSelections:(NSArray *)selections
{
    _selections = selections;
    _selectedIndex = NSNotFound;
    [_tableView reloadData];
}

#pragma mark - Private Methods

static CAAnimation* _showAnimation()
{
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    transform.values = values;
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacity setFromValue:@0.0];
    [opacity setToValue:@1.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setAnimations:@[transform, opacity]];
    return group;
}

static CAAnimation* _hideAnimation()
{
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    transform.values = values;
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacity setFromValue:@1.0];
    [opacity setToValue:@0.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setAnimations:@[transform, opacity]];
    return group;
}

- (void)_showFromView:(UIView *)view animated:(BOOL)animated
{
    if (animated) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.tableView flashScrollIndicators];
        }];
        [self.layer addAnimation:_showAnimation() forKey:nil];
        [CATransaction commit];
    }
}

- (void)_hideWithAnimated:(BOOL)animated
{
    if (animated) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.layer removeAnimationForKey:@"transform"];
            [self.layer removeAnimationForKey:@"opacity"];
            [self removeFromSuperview];
        }];
        [self.layer addAnimation:_hideAnimation() forKey:nil];
        [CATransaction commit];
    }else {
        [self removeFromSuperview];
    }
}

- (void)_setupFrameWithSuperView:(UIView *)view atPoint:(CGPoint)point
{
    CGFloat totalHeight = _selections.count * SGPOP_DEFAULT_ROW_HEIHGT;
    CGFloat height = totalHeight > SGPOP_DEFAULT_MAX_HEIGHT ? SGPOP_DEFAULT_MAX_HEIGHT : totalHeight;
    CGFloat width = [self _preferedWidth];
    width = width > view.bounds.size.width * 0.9 ? view.bounds.size.width * 0.9 : width;
    CGFloat left = (point.x + width) > view.bounds.size.width ? (view.bounds.size.width - width - 10) : point.x;
    CGFloat y = point.y - height / 2;
    if (point.y - height / 2 < 20) {
        y = 20;
    }else if (point.y + height / 2 > view.bounds.size.height - 10) {
        y = view.bounds.size.height - height - 10;
    }
    self.frame = CGRectMake(left, y, width, height);
}

- (CGFloat)_preferedWidth
{
    NSPredicate *maxLength = [NSPredicate predicateWithFormat:@"SELF.length == %@.@max.length", _selections];
    NSString *maxString = [_selections filteredArrayUsingPredicate:maxLength][0];
    CGFloat strWidth;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        strWidth = [maxString sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:SGPOP_DEFAULT_FONT_SIZE]}].width;
    }else {
        strWidth = [maxString sizeWithFont:[UIFont systemFontOfSize:SGPOP_DEFAULT_FONT_SIZE]].width;
    }
    return strWidth + 15 * 2 + 30;
}

#pragma mark - UITableview DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SelectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:SGPOP_DEFAULT_FONT_SIZE];
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    if (_selectedIndex == indexPath.row) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oval_selected"]];
    }else {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oval_unselected"]];
    }
    cell.textLabel.text = _selections[indexPath.row];
    return cell;
}

#pragma mark - UITableview Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SGPOP_DEFAULT_ROW_HEIHGT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    [tableView reloadData];
    
    if (_selectedHandle) {
        _selectedHandle(indexPath.row);
    }
}


@end
