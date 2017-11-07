//
//  SearchResultsTableViewCell.m
//  CS_WeiTV
//
//  Created by mariacarter on 13/03/2016.
//  Copyright © 2016 wy. All rights reserved.
//

#import "SearchResultsTableViewCell.h"

#import "UIImageView+WebCache.h"

@implementation SearchResultsTableViewCell


-(void)awakeFromNib
{
    [super awakeFromNib];
    _colorData = [SingleColor sharedInstance];
    
    CGFloat normalSize = [[_colorData.fontDic objectForKey:NAORMAL_SIZE]floatValue];
    CGFloat smallSize = [[_colorData.fontDic objectForKey:SMALL_SIZE]floatValue];
    UIColor *mainColor =  [_colorData.colorDic objectForKey:FONT_MAIN_COLOR];
    
    
    self.movieTitle.textColor = mainColor;//电影标题
    self.movieTitle.font = [UIFont systemFontOfSize:normalSize];
    self.movieTitle.textAlignment = NSTextAlignmentLeft;
    
    self.castLabel.textColor =mainColor;//主演
    self.castLabel.font = [UIFont systemFontOfSize:smallSize];
//    self.castLabel.backgroundColor = [UIColor redColor];
    
    self.typeLabel.textColor = mainColor;//类型
    self.typeLabel.font = [UIFont systemFontOfSize:smallSize];
    
    self.yearLabel.textColor =mainColor;//年代
    self.yearLabel.font = [UIFont systemFontOfSize:smallSize];
    
    self.castMembers.textColor = mainColor;
    self.castMembers.font =[UIFont systemFontOfSize:smallSize];
//    self.castMembers.backgroundColor = [UIColor yellowColor];
  
    self.releaseYear.textColor = mainColor;
    self.releaseYear.font = [UIFont systemFontOfSize:smallSize];
   
    self.movieGenres.textColor = mainColor;
    self.movieGenres.font = [UIFont systemFontOfSize:smallSize];
    self.movieGenres.textAlignment = NSTextAlignmentLeft;

    self.sectionCategory.textColor = HIGHLIGHTED_COLOR;//类别
    self.sectionCategory.font=[UIFont systemFontOfSize:normalSize];
    self.sectionCategory.textAlignment = NSTextAlignmentRight;

}

//-(void)configSearchCellWithModel:(SearchModel *)model
//{
//    NSLog(@"%@-%@-%@-%@-%@",model.programName,model.actor,model.levelTwoTag,model.years,model.videoTypeName);
//    self.movieTitle.text = model.programName;//电影标题
//    self.castMembers.text = model.actor;//主演
//    self.movieGenres.text = model.levelTwoTag;//类型
//    self.releaseYear.text = model.years;//年代
//    self.sectionCategory.text = model.videoTypeName;
//    NSString *jointUrl = [NSString stringWithFormat:PreHttpImage,kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort),model.postUrl];
//    NSLog(@"joinUrl=%@",jointUrl);
//    NSURL *imgUrl = [NSURL URLWithString:jointUrl];
//    [self.moviePoster sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:MAX_IMAGE]];
//
//}

@end
