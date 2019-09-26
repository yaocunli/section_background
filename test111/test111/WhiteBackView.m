//
//  WhiteBackView.m
//


#import "WhiteBackView.h"
#import "Masonry.h"


@interface WhiteBackView ()


@property (nonatomic, strong) UIView *backGroundView;

@end
@implementation WhiteBackView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
    }
    return self;
}

- (void)prepareForReuse
{
    [self setupUI];
}

- (void)setupUI {
    [self addSubview:self.backGroundView];
    [self.backGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset((0));
        make.right.equalTo(self).offset((0));
        make.bottom.equalTo(self).offset((-10));
        make.top.equalTo(self).offset((0));
    }];
}


-(UIView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] init];
        _backGroundView.layer.cornerRadius = 12;
        _backGroundView.layer.masksToBounds = YES;
        [_backGroundView setBackgroundColor: [UIColor lightGrayColor]];
        
    }
    return _backGroundView;
}

@end
