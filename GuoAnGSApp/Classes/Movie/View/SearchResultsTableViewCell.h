//
//  SearchResultsTableViewCell.h
//  CS_WeiTV
//
//  Created by mariacarter on 13/03/2016.
//  Copyright © 2016 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ParamFile.h"
//#import "SearchModel.h"

@interface SearchResultsTableViewCell : UITableViewCell
{
    SingleColor *_colorData;
}

// 电影标题：
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
// 主演：
@property (weak, nonatomic) IBOutlet UILabel *castMembers;
// 类型：
@property (weak, nonatomic) IBOutlet UILabel *movieGenres;
// 年代：
@property (weak, nonatomic) IBOutlet UILabel *releaseYear;
// 所属分区：
@property (weak, nonatomic) IBOutlet UILabel *sectionCategory;
// 电影海报：
@property (weak, nonatomic) IBOutlet UIImageView *moviePoster;


@property (weak, nonatomic) IBOutlet UILabel *castLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;


//-(void)configSearchCellWithModel:(SearchModel *)model;

@end
