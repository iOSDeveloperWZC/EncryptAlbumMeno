//
//  MenoTableViewCell.m
//  EncryptAlbumMeno
//
//  Created by ataw on 16/8/15.
//  Copyright © 2016年 王宗成. All rights reserved.
//

#import "MenoTableViewCell.h"

@implementation MenoTableViewCell
{
    UILabel *titleText;
    UILabel *timeLable;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self creatLable];
    }
    
    return self;
}

-(void)creatLable
{
    titleText = [[UILabel alloc]init];
    titleText.font = [UIFont systemFontOfSize:14];
    titleText.textColor = [UIColor lightGrayColor];
    titleText.userInteractionEnabled = YES;
    [self.contentView addSubview:titleText];
    
    timeLable = [[UILabel alloc]init];
    timeLable.userInteractionEnabled = YES;
    timeLable.font = [UIFont systemFontOfSize:13];
    timeLable.textColor = [UIColor colorWithRed:243.0/255 green:206.0/255 blue:112.0/255 alpha:1];
    [self.contentView addSubview:timeLable];
    
    [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(5);

    }];
    
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(titleText.left);
        make.top.mas_equalTo(titleText.bottom);
        make.bottom.mas_equalTo(-5);
    }];
    
}

-(void)setModel:(MenoModel *)model
{
    _model = model;
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    timeLable.text = _model.time;
    titleText.text = _model.title;
    
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
