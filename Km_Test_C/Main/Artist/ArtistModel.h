//
//  ArtistModel.h
//  Km_Test_C
//
//  Created by Mr.Xie on 16/5/6.
//  Copyright © 2016年 OMG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumModel.h"

@interface ArtistModel : NSObject
@property (nonatomic,copy) NSString *artistName;
@property (nonatomic,copy) NSString *fansNum;
@property (nonatomic,copy) NSString *albumCount;
@property (nonatomic,strong) NSMutableArray *albumArray;
@property (nonatomic,strong) NSURL *albumImageUrl;
@end
