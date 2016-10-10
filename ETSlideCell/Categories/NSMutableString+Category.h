//
//  NSMutableString+Category.h
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (Category)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * 拼url
 *
 *
 *
 **/
-(void)addQueryDictionary:(NSDictionary *)dictionary;
-(void)appendParameter:(id)paramter forKey:(NSString *)key;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * 替换某个字符串，不关心大小写
 *
 *
 *
 **/
-(void)replaceString:(NSString *)searchString withString:(NSString *)newString;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * 替换某个字符串
 * ignore : 是否关心大小写
 *
 *
 **/
-(void)replaceString:(NSString *)searchString withString:(NSString *)newString ignoringCase:(BOOL)ignore;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * 去掉字符串的空格
 *
 *
 *
 **/
-(void)removeWhitespace;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * 去掉字符串的空格和换行
 *
 *
 *
 **/
-(void)removeWhitespaceAndNewline;
@end