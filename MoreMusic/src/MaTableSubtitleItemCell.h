//
//  MaTableSubtitleItem.h
//  WeiboNote
//
//  Created by Accthun He on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Three20/Three20.h"
@class MaTimeLabel;

@interface MaTableSubtitleItemCell : TTTableSubtitleItemCell
{
	MaTimeLabel *_createTimeLabel;
    TTImageView *_messageImageView;

    TTView* _commentView;
    UILabel* _commentLabel;
    TTImageView *_commentImage;
    UILabel *_sourceLabel;
    UILabel *_commentCountLabel;
    
    id delegate;
    SEL touchAction;
    BOOL isIconNameTouched;
    __weak id    parentTableView;

}

- (id)getCellDataSource;

- (void)setParentTableView:(id)tableView;

@end
