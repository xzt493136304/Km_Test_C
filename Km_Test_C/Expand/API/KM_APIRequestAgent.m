//
//  KM_APIRequestAgent.m
//  Km_Test_C
//
//  Created by Mr.Xie on 16/5/6.
//  Copyright © 2016年 OMG. All rights reserved.
//

#import "KM_APIRequestAgent.h"
#import "KM_NetAPManagerDefine.h"

@implementation KM_APIRequestAgent
#pragma mark - Requests
- (NSURLRequest *)apiRequestOfHotSongList{
    //TODO: Parameters/enchance
    return [NSURLRequest requestWithURL:[NSURL URLWithString:kKMHotSongListPath]];
}

- (NSString *)apiRequestOfHotSongListUrl{
    //TODO: Parameters/enchance
    return kKMHotSongListPath;
}
@end
