//
//  Constants.h
//  ANA
//
//  Created by Minh Thong on 8/21/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#ifndef ANA_Constants_h
#define ANA_Constants_h

#define kNameSQLite         @"Song_Sqlite.db"
/* Notification */
#define NotifCenter                     [NSNotificationCenter defaultCenter]
#define NotifReg(o,s,n)                 [NotifCenter addObserver:o selector:s name:n object:nil]
#define NotifRegMe(o,s,n)               [NotifCenter addObserver:o selector:s name:n object:o]
#define NotifUnreg(o,n)                 [NotifCenter removeObserver:o name:n object:nil]
#define NotifUnregAll(o)                [NotifCenter removeObserver:o]
#define NotifPost2Obj4Info(n,o,i)       [NotifCenter postNotificationName:n object:o userInfo:i]
#define NotifPost2Obj(n,o)              NotifPost2Obj4Info(n,o,nil)
#define NotifPost(n)                    NotifPost2Obj(n,nil)
#define NotifPostNotif(n)               [NotifCenter postNotification:n]


#define CELLSINGER_WIDTH          122
#define CELLSINGER_HEIGHT         160
#define HOST_TCP_ANA              9392
#endif
