//
//  clsMessage.h
//  
//
//  Created by Jp on 7/22/15.
//  Copyright (c) 2015 JayeshPoriya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface clsMessage : NSObject

@property (nonatomic,assign) int  isRead;
@property (nonatomic,assign) int  isSent;

@property (nonatomic,retain) NSString * from;
@property (nonatomic,retain) NSString * to;
@property (nonatomic,retain) NSString * msg;
@property (nonatomic,retain) NSString * time;
@property (nonatomic,retain) NSString * sender;
@property (nonatomic,retain) NSString * type;
@property (nonatomic,retain) NSString * msgUUID;





-(void)insertMessage;
-(NSMutableArray *)getAllDataFromTblMessage;
-(void)updateIsReadMsg:(NSString *)ids;
-(void)updateMsgUUID:(NSString *)ids;

-(NSMutableArray *)getImageArrayFromTblMessage :(NSString *)strUserJID;
-(NSMutableArray *)getRecentlyChatRosterList :(NSString *)strUserJID;

-(void)deleteMessage:(int)msgID;

-(NSString *)getRecentRosterTime: (NSString *)jidStr;

@end

