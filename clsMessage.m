//
//  clsMessage.m
//  
//
//  Created by Jp on 7/22/15.
//  Copyright (c) 2015 JayeshPoriya. All rights reserved.
//

#import "clsMessage.h"
#import <sqlite3.h>
#import "AppDelegate.h"

@implementation clsMessage

-(void)insertMessage
{
    
    @try {
        
        /*sqlite3 *db =[AppDelegate getNewDBConnection];
        sqlite3_stmt *compiledStatement;
        
        NSString *query = nil;
        query = [NSString stringWithFormat:@"insert into tblMessage([from],[isRead],[msg],[sender],[time],[to]) values('%@',%d,'%@','%@','%@','%@')",self.form,self.isRead,self.msg,self.sender,self.time,self.to];
        
        NSLog(@"Query.....%@",query);
        
        if(sqlite3_prepare_v2(db, [query UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if(SQLITE_DONE != sqlite3_step(compiledStatement))
            {
                NSLog( @"Error while inserting data: '%s'", sqlite3_errmsg(db));
            }

//            sqlite3_reset(compiledStatement);
        }
        else
        {
            NSLog( @"Error while inserting '%s'", sqlite3_errmsg(db));
        }
        
        //        [[[UIAlertView alloc] initWithTitle:@"Money Manager" message:@"Successfully inserted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        sqlite3_finalize(compiledStatement);
        sqlite3_close(db);*/
        
        
        sqlite3 *db =[AppDelegate getNewDBConnection];
        sqlite3_stmt *stmt;
        
//        NSLog(@" type  ==> %@",self.msgUUID);
        
        NSString *sqlInsert =  [NSString stringWithFormat:@"insert into tblMessage([from],[isRead],[msg],[sender],[time],[to],[isSent],[type],[msgUUID]) values(?,?,?,?,?,?,?,?,?)"];
        
            if(sqlite3_prepare_v2(db, [sqlInsert UTF8String], -1, &stmt, NULL) == SQLITE_OK)
            {
                sqlite3_bind_text(stmt, 1, [self.from UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(stmt, 2, self.isRead);
                sqlite3_bind_text(stmt, 3, [self.msg UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 4, [self.sender UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 5, [self.time UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 6, [self.to UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(stmt, 7, self.isSent);
                sqlite3_bind_text(stmt, 8, [self.type UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 9, [self.msgUUID UTF8String], -1, SQLITE_TRANSIENT);


                sqlite3_reset(stmt); //=======Execute==========

            }
        
//        NSLog(@"sqlInsert ==> %@",sqlInsert);

        
            if(SQLITE_DONE != sqlite3_step(stmt))
            {
                NSLog( @"Error while inserting data: '%s'", sqlite3_errmsg(db));
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"exception ==> %@",exception);
        }
}

-(NSMutableArray *)getAllDataFromTblMessage
{
    @try
    {
        NSMutableArray * arrayOfMessage = [[NSMutableArray alloc]init];
        sqlite3_stmt *select_exceptions=nil;
        NSString *str_exceptions= @"select * from tblMessage";
        const char *sql=[str_exceptions UTF8String];
        sqlite3 *db =[AppDelegate getNewDBConnection];  //open databasa
        
        
        if(sqlite3_prepare_v2(db, sql,-1, &select_exceptions,NULL)==SQLITE_OK)
        {
            NSString *from,*to,*sender,*time,*msg,*msgUUID;
            int isRead,isSent,msgID;
            
            NSInteger ab=0;
            while(sqlite3_step(select_exceptions)==SQLITE_ROW)
            {
                msgID =sqlite3_column_int(select_exceptions,0);

                
                
                if ((char *)sqlite3_column_text(select_exceptions,1) == NULL)
                    from = @"";
                else
                    from=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,1) encoding:NSUTF8StringEncoding];

                
                isRead =sqlite3_column_int(select_exceptions,2);
                
                
                if ((char *)sqlite3_column_text(select_exceptions,3) == NULL)
                    msg = @"";
                else
                    msg=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,3) encoding:NSUTF8StringEncoding];
                
                
                if ((char *)sqlite3_column_text(select_exceptions,4) == NULL)
                    sender = @"";
                else
                    sender=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,4) encoding:NSUTF8StringEncoding];
                
                
                if ((char *)sqlite3_column_text(select_exceptions,5) == NULL)
                    time = @"";
                else
                    time=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,5) encoding:NSUTF8StringEncoding];
                
                if ((char *)sqlite3_column_text(select_exceptions,6) == NULL)
                    to = @"";
                else
                    to=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,6) encoding:NSUTF8StringEncoding];
                
                isSent =sqlite3_column_int(select_exceptions,7);
                
                
                if ((char *)sqlite3_column_text(select_exceptions,8) == NULL)
                    _type = @"";
                else
                    _type=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,8) encoding:NSUTF8StringEncoding];
                
                
                if ((char *)sqlite3_column_text(select_exceptions,9) == NULL)
                    msgUUID = @"";
                else
                    msgUUID=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,9) encoding:NSUTF8StringEncoding];
                

                


                NSMutableDictionary * tempDict = [[NSMutableDictionary alloc]init];
                [tempDict setObject:[NSString stringWithFormat:@"%d",msgID] forKey:@"msgID"];
                [tempDict setObject:from forKey:@"from"];
                [tempDict setObject:[NSString stringWithFormat:@"%d",isRead] forKey:@"isRead"];
                [tempDict setObject:msg forKey:@"msg"];
                [tempDict setObject:sender forKey:@"sender"];
                [tempDict setObject:time forKey:@"time"];
                [tempDict setObject:to forKey:@"to"];
                [tempDict setObject:[NSString stringWithFormat:@"%d",isSent] forKey:@"isSent"];
                [tempDict setObject:_type forKey:@"type"];
                [tempDict setObject:msgUUID forKey:@"msgUUID"];


                [arrayOfMessage addObject:tempDict];
                ab++;
            }
        }
        else
        {
            NSLog(@"Could not Compile Properly.....");
        }
        sqlite3_finalize(select_exceptions);
        sqlite3_close(db);
//        NSLog(@"All User From DBManager arrayOfMessage %@",arrayOfMessage);
        return arrayOfMessage;
    }
    @catch (NSException *exception) {
        NSLog(@"exception ==> %@",exception);
    }
}

-(void)updateIsReadMsg:(NSString *)ids
{
    
    sqlite3 *db =[AppDelegate getNewDBConnection];
    NSString *query = nil;
    
    query = [NSString stringWithFormat:@"update tblMessage set isRead = 1 where id in (%@)",ids];
//    NSLog(@"Query..%@",query);
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2(db, [query UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        if(SQLITE_DONE != sqlite3_step(compiledStatement))
        {
            NSLog( @"Error while updating data: '%s'", sqlite3_errmsg(db));
        }
        sqlite3_reset(compiledStatement);
    }else
    {
        NSLog( @"Error while updating '%s'", sqlite3_errmsg(db));
    }
    sqlite3_finalize(compiledStatement);
    sqlite3_close(db);
}

-(void)updateMsgUUID:(NSString *)ids
{
    
    sqlite3 *db =[AppDelegate getNewDBConnection];
    NSString *query = nil;
    
    query = [NSString stringWithFormat:@"update tblMessage set isSent = 1 where msgUUID in ('%@')",ids];
//        NSLog(@"Query..%@",query);
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2(db, [query UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        if(SQLITE_DONE != sqlite3_step(compiledStatement))
        {
            NSLog( @"Error while updating data: '%s'", sqlite3_errmsg(db));
        }
        sqlite3_reset(compiledStatement);
    }else
    {
        NSLog( @"Error while updating '%s'", sqlite3_errmsg(db));
    }
    sqlite3_finalize(compiledStatement);
    sqlite3_close(db);
}

-(NSMutableArray *)getImageArrayFromTblMessage :(NSString *)strUserJID
{
    @try
    {
        NSMutableArray * arrayOfMessage = [[NSMutableArray alloc]init];
        sqlite3_stmt *select_exceptions=nil;
        NSString *str_exceptions= [NSString stringWithFormat:@"select * from tblMessage where ([from] like '%@%@' or [to] like '%@%@') and type like 'image'",strUserJID,@"%",strUserJID,@"%"];
        
//        NSLog(@"==> %@",str_exceptions);
        
        const char *sql=[str_exceptions UTF8String];
        sqlite3 *db =[AppDelegate getNewDBConnection];  //open databasa
        
        
        if(sqlite3_prepare_v2(db, sql,-1, &select_exceptions,NULL)==SQLITE_OK)
        {
            NSString *from,*to,*sender,*time,*msg,*msgUUID;
            int isRead,isSent,msgID;
            
            NSInteger ab=0;
            while(sqlite3_step(select_exceptions)==SQLITE_ROW)
            {
                msgID =sqlite3_column_int(select_exceptions,0);
                
                
                
                if ((char *)sqlite3_column_text(select_exceptions,1) == NULL)
                    from = @"";
                else
                    from=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,1) encoding:NSUTF8StringEncoding];
                
                
                isRead =sqlite3_column_int(select_exceptions,2);
                
                
                if ((char *)sqlite3_column_text(select_exceptions,3) == NULL)
                    msg = @"";
                else
                    msg=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,3) encoding:NSUTF8StringEncoding];
                
                
                if ((char *)sqlite3_column_text(select_exceptions,4) == NULL)
                    sender = @"";
                else
                    sender=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,4) encoding:NSUTF8StringEncoding];
                
                
                if ((char *)sqlite3_column_text(select_exceptions,5) == NULL)
                    time = @"";
                else
                    time=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,5) encoding:NSUTF8StringEncoding];
                
                if ((char *)sqlite3_column_text(select_exceptions,6) == NULL)
                    to = @"";
                else
                    to=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,6) encoding:NSUTF8StringEncoding];
                
                isSent =sqlite3_column_int(select_exceptions,7);
                
                
                if ((char *)sqlite3_column_text(select_exceptions,8) == NULL)
                    _type = @"";
                else
                    _type=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,8) encoding:NSUTF8StringEncoding];
                
                
                if ((char *)sqlite3_column_text(select_exceptions,9) == NULL)
                    msgUUID= @"";
                else
                    msgUUID=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,9) encoding:NSUTF8StringEncoding];
                
                
                
                NSMutableDictionary * tempDict = [[NSMutableDictionary alloc]init];
                [tempDict setObject:[NSString stringWithFormat:@"%d",msgID] forKey:@"msgID"];
                [tempDict setObject:from forKey:@"from"];
                [tempDict setObject:[NSString stringWithFormat:@"%d",isRead] forKey:@"isRead"];
                [tempDict setObject:msg forKey:@"msg"];
                [tempDict setObject:sender forKey:@"sender"];
                [tempDict setObject:time forKey:@"time"];
                [tempDict setObject:to forKey:@"to"];
                [tempDict setObject:[NSString stringWithFormat:@"%d",isSent] forKey:@"isSent"];
                [tempDict setObject:_type forKey:@"type"];
                [tempDict setObject:msgUUID forKey:@"msgUUID"];

                
                [arrayOfMessage addObject:tempDict];
                ab++;
            }
        }
        else
        {
            NSLog(@"Could not Compile Properly.....");
        }
        sqlite3_finalize(select_exceptions);
        sqlite3_close(db);
//        NSLog(@"All User From DBManager arrayOfMessage %@",arrayOfMessage);
        return arrayOfMessage;
    }
    @catch (NSException *exception) {
        NSLog(@"exception ==> %@",exception);
    }
}

-(NSMutableArray *)getRecentlyChatRosterList :(NSString *)strUserJID
{
    @try
    {
        NSMutableArray * arrayOfMessage = [[NSMutableArray alloc]init];
        sqlite3_stmt *select_exceptions=nil;
        NSString *str_exceptions= [NSString stringWithFormat:@"select * from tblMessage where [from] like '%@%@' or [to] like '%@%@'",strUserJID,@"%",strUserJID,@"%"];
        
//                NSLog(@"==> %@",str_exceptions);
        
        const char *sql=[str_exceptions UTF8String];
        sqlite3 *db =[AppDelegate getNewDBConnection];  //open databasa
        
        
        if(sqlite3_prepare_v2(db, sql,-1, &select_exceptions,NULL)==SQLITE_OK)
        {
            NSString *from,*to,*sender,*time,*msg,*msgUUID;
            int isRead,isSent,msgID;
            
            NSInteger ab=0;
            while(sqlite3_step(select_exceptions)==SQLITE_ROW)
            {
                msgID =sqlite3_column_int(select_exceptions,0);
                
                
                
                if ((char *)sqlite3_column_text(select_exceptions,1) == NULL)
                    from = @"";
                else
                    from=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,1) encoding:NSUTF8StringEncoding];
                
                
                isRead =sqlite3_column_int(select_exceptions,2);
                
                
                if ((char *)sqlite3_column_text(select_exceptions,3) == NULL)
                    msg = @"";
                else
                    msg=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,3) encoding:NSUTF8StringEncoding];
                
                
                if ((char *)sqlite3_column_text(select_exceptions,4) == NULL)
                    sender = @"";
                else
                    sender=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,4) encoding:NSUTF8StringEncoding];
                
                
                if ((char *)sqlite3_column_text(select_exceptions,5) == NULL)
                    time = @"";
                else
                    time=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,5) encoding:NSUTF8StringEncoding];
                
                if ((char *)sqlite3_column_text(select_exceptions,6) == NULL)
                    to = @"";
                else
                    to=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,6) encoding:NSUTF8StringEncoding];
                
                isSent =sqlite3_column_int(select_exceptions,7);
                
                
                if ((char *)sqlite3_column_text(select_exceptions,8) == NULL)
                    _type = @"";
                else
                    _type=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,8) encoding:NSUTF8StringEncoding];
                
                
                if ((char *)sqlite3_column_text(select_exceptions,9) == NULL)
                    msgUUID= @"";
                else
                    msgUUID=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,9) encoding:NSUTF8StringEncoding];
                
                
                
                NSMutableDictionary * tempDict = [[NSMutableDictionary alloc]init];
                [tempDict setObject:[NSString stringWithFormat:@"%d",msgID] forKey:@"msgID"];
                [tempDict setObject:from forKey:@"from"];
                [tempDict setObject:[NSString stringWithFormat:@"%d",isRead] forKey:@"isRead"];
                [tempDict setObject:msg forKey:@"msg"];
                [tempDict setObject:sender forKey:@"sender"];
                [tempDict setObject:time forKey:@"time"];
                [tempDict setObject:to forKey:@"to"];
                [tempDict setObject:[NSString stringWithFormat:@"%d",isSent] forKey:@"isSent"];
                [tempDict setObject:_type forKey:@"type"];
                [tempDict setObject:msgUUID forKey:@"msgUUID"];
                
                
                [arrayOfMessage addObject:tempDict];
                ab++;
            }
        }
        else
        {
            NSLog(@"Could not Compile Properly.....");
        }
        sqlite3_finalize(select_exceptions);
        sqlite3_close(db);
        //        NSLog(@"All User From DBManager arrayOfMessage %@",arrayOfMessage);
        return arrayOfMessage;
    }
    @catch (NSException *exception) {
        NSLog(@"exception ==> %@",exception);
    }
}

-(void)deleteMessage:(int)msgID
{
    sqlite3_stmt *deleteStmt=nil;
    
    NSString *strDelete;
    strDelete=[NSString stringWithFormat:@"delete from tblMessage where id = '%d'",msgID];
//    NSLog(@"setDelete ==> %@",strDelete);
    
    const char *sql=[strDelete UTF8String];
    sqlite3 *db = [AppDelegate getNewDBConnection];
    
    if(sqlite3_prepare_v2(db,sql,-1,&deleteStmt,NULL)==SQLITE_OK)
    {
        if(sqlite3_step(deleteStmt)==SQLITE_DONE)
        {
//            NSLog(@"Message Deleted Successfully...");
        }
        else
        {
            NSLog(@"Problem in Deleting User...");
        }
    }
    else
    {
        NSLog(@"Problem While compiling delete User statement..");
    }
    
    sqlite3_finalize(deleteStmt);
    sqlite3_close(db);
}

-(NSString *)getRecentRosterTime: (NSString *)jidStr
{
    
    
    
    @try
    {
        NSString * strTime = [[NSString alloc]init];
        sqlite3_stmt *select_exceptions=nil;
        NSString *str_exceptions= [NSString stringWithFormat:@"Select [time] from tblMessage where [from] like '%@%@' OR [to] like '%@%@' order by [time] desc limit 1",jidStr, @"%",jidStr,@"%"];//desc
        
//        NSLog(@"==> %@",str_exceptions);
        
        const char *sql=[str_exceptions UTF8String];
        sqlite3 *db =[AppDelegate getNewDBConnection];  //open databasa
        
        
        if(sqlite3_prepare_v2(db, sql,-1, &select_exceptions,NULL)==SQLITE_OK)
        {
            NSInteger ab=0;

            while(sqlite3_step(select_exceptions)==SQLITE_ROW)
            {
                if ((char *)sqlite3_column_text(select_exceptions,0) == NULL)
                    strTime = @"";
                else
                    strTime=[NSString stringWithCString:(char *)sqlite3_column_text(select_exceptions,0) encoding:NSUTF8StringEncoding];
                ab++;
            }
        }
        else
        {
            NSLog(@"Could not Compile Properly.....");
        }
        sqlite3_finalize(select_exceptions);
        sqlite3_close(db);
        //        NSLog(@"All User From DBManager arrayOfMessage %@",arrayOfMessage);
        return strTime;
    }
    @catch (NSException *exception) {
        NSLog(@"exception ==> %@",exception);
    }
    
    
    
    
    
    
}


@end
