//
//  LoadingView.m
//  ParentsCommunity
//
//  Created by leev on 16/7/1.
//  Copyright © 2016年 XES. All rights reserved.
//

#import "LoadingView.h"
#import <lottie-ios/Lottie/Lottie.h>
#import <Masonry/Masonry.h>
#import "WXCommonMacro.h"
#import <WXToolKit/WXToolKitMacro.h>

static Class<LoadingViewDataSource> DataSource = nil;

@interface LoadingView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) LOTAnimationView *animationImageView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, copy) BackActionBlock block;

@end

@implementation LoadingView

#pragma mark - Override

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupSubviews];
        [self setupSubviewConstraints];
    }
    return self;;
}

#pragma mark - Private Method

- (void)setupSubviews
{
    [self addSubview:self.contentView];
    [self addSubview:self.backButton];
    [self.contentView addSubview:self.animationImageView];
    [self.contentView addSubview:self.textLabel];
}

- (void)setupSubviewConstraints
{
    @WeakObj(self);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(selfWeak.mas_centerX);
        make.centerY.mas_equalTo(selfWeak.mas_centerY);
        make.width.mas_equalTo(@105);
    }];
    
    [self.animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(selfWeak.contentView.mas_centerX);
        make.top.mas_offset(15);
        make.width.and.height.mas_equalTo(@50);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(selfWeak.contentView.mas_centerX);
        make.width.mas_equalTo(selfWeak.contentView.mas_width);
        make.top.mas_equalTo(selfWeak.animationImageView.mas_bottom).offset(8);
        make.bottom.offset(-15);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(8);
        make.width.mas_equalTo(@44);
        make.height.mas_equalTo(@44);
        if (IS_IPHONE_X)
        {
            make.top.mas_offset(40);
        }
        else
        {
            make.top.mas_offset(20);
        }
    }];
}

#pragma mark - Public method

// 上层配置类，当提供的样式不满足业务使用时需要配置
+ (void)setDataSourceClass:(Class<LoadingViewDataSource>)dataSourceClass
{
    DataSource = dataSourceClass;
}


+ (instancetype)loadFromNibWithText:(NSString *)loadingText
{
    LoadingView *loadingView = [[LoadingView alloc] init];

    loadingView.loadingText = loadingText;
    return loadingView;
}

- (void)startLoadingInView:(UIView *)parentView
{
    [self startLoadingInView:parentView backAction:NULL];
}

- (void)startLoadingInView:(UIView *)parentView loadingWidth:(CGFloat)width
{
    [self startLoadingInView:parentView
                loadingWidth:width
              LeftRightspace:0
                textLabelTop:8];
}

- (void)startLoadingInView:(UIView *)parentView
              loadingWidth:(CGFloat)width
            LeftRightspace:(CGFloat)space
              textLabelTop:(CGFloat)top
{
    @WeakObj(self);
    [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.animationImageView.mas_bottom).offset(top);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(width));
    }];
    self.contentView.layer.masksToBounds = NO;
    self.contentView.layer.shadowColor = [UIColor wx_colorWithHEXValue:0x000000 alpha:0.06].CGColor;
    self.contentView.layer.shadowOffset  = CGSizeMake(0, 4);
    self.contentView.layer.shadowOpacity = 1;
    self.contentView.layer.shadowRadius = 10;

    [self startLoadingInView:parentView backAction:NULL];
}

- (void)startLoadingInView:(UIView *)parentView backAction:(BackActionBlock)backActionBlock
{
    if (backActionBlock == NULL || backActionBlock == nil)
    {
        // do nothing
        self.backButton.hidden = YES;
    }
    else
    {
        self.block = [backActionBlock copy];
        self.backButton.hidden = NO;
    }
    
    self.hidden = NO;
    [self.animationImageView play];
    self.frame = parentView.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [parentView addSubview:self];
}

- (void)stopLoading
{
    self.hidden = YES;
    [self.animationImageView stop];
}

#pragma mark --event handle

- (void)backAction:(id)sender
{
    if (self.block != NULL)
    {
        self.block();
    }
}

#pragma mark - Getter

- (UIView *)contentView
{
    if (_contentView == nil)
    {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.layer.cornerRadius = 4.0f;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (LOTAnimationView *)animationImageView
{
    if (_animationImageView == nil)
    {
        NSString *lottieName = [DataSource loadingLottieFileName];
        _animationImageView = [LOTAnimationView animationNamed:lottieName];
        _animationImageView.loopAnimation = YES;
        _animationImageView.animationSpeed = 1.0;
    }
    return _animationImageView;
}

- (UILabel *)textLabel
{
    if (_textLabel == nil)
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont wx_fontPingFangSCWithSize:12];
        _textLabel.textColor = [UIColor wx_FontGrayColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 2;
        _textLabel.text = @"加载中";
    }
    return _textLabel;
}

- (UIButton *)backButton
{
    if (_backButton == nil)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.hidden = YES;
        NSString *backIconName = [DataSource backBtnIconName];
        [_backButton setImage:[UIImage imageNamed:backIconName] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

#pragma mark - Setter

- (void)setLoadingText:(NSString *)loadingText
{
    _loadingText = loadingText;
    self.textLabel.text = _loadingText;
    
    CGFloat constant = 25;
    
    if (_loadingText.length > 0)
    {
        constant = 15;
    }
    [self.animationImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(constant);
    }];
}

- (void)setAttributeLoadingText:(NSString *)attributeLoadingText
{
    _loadingText = attributeLoadingText;
    NSMutableParagraphStyle * style = [NSMutableParagraphStyle new];
    [style setLineSpacing:4.0];
    style.alignment = NSTextAlignmentCenter;

    NSMutableAttributedString* loadingTextAttri = [[NSMutableAttributedString alloc] initWithString:_loadingText];
    [loadingTextAttri addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, loadingTextAttri.length)];
    self.textLabel.attributedText = loadingTextAttri;
}

- (void)setBgColorType:(BackgroundColorType)bgColorType
{
    _bgColorType = bgColorType;
    switch (_bgColorType)
    {
        case BackgroundColorTypeDefault:
        {
            // 默认颜色
            self.backgroundColor = [UIColor whiteColor];
            self.contentView.backgroundColor = [UIColor clearColor];
        }
            break;
        case BackgroundColorTypeTransparent:
        {
            // 全透明
            self.backgroundColor = [UIColor clearColor];
            self.contentView.backgroundColor = [UIColor clearColor];
        }
            break;
        case BackgroundColorTypeTranslucent:
        {
            // 半透明
            self.backgroundColor = [UIColor wx_colorWithHEXValue:0x000000 alpha:0.2f];
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
            break;
        default:
            break;
    }
}

- (void)setContentViewBgColor:(UIColor *)contentViewBgColor
{
    _contentViewBgColor = contentViewBgColor;
    self.contentView.backgroundColor = _contentViewBgColor;
}

@end
