//
//  ChooseSongHeadView.h
//  Km_Test_C
//
//  Created by 谢展图 on 16/4/24.
//  Copyright © 2016年 OMG. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^actionBlock)(void);
@interface ChooseSongHeadView : UIView
@property (nonatomic,strong) UIButton *button;
@property (nonatomic, copy) actionBlock btnActionBlock;
@end
