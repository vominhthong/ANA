//
//  MorinitoringMemory.m
//  ANA
//
//  Created by Minh Thong on 8/26/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import "MorinitoringMemory.h"
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/task_info.h>
#import <mach/task.h>
#import <sys/sysctl.h>
@interface MorinitoringMemory (){
    dispatch_queue_t queueMemoryHandler;
    void *queueMemoryTag;
    dispatch_source_t timerSource;
}
@end

@implementation MorinitoringMemory
-(instancetype)init{
    if (self = [super init]) {
        queueMemoryTag = &queueMemoryTag;
        queueMemoryHandler = dispatch_queue_create("QueueMemoryTracking", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_set_specific(queueMemoryHandler, queueMemoryTag, queueMemoryTag, NULL);
    }
    return self;
}
-(void)startMornitoringRAMWithTimer:(int)timer{
    __weak typeof(self) wSelf = self;
    dispatch_block_t block = ^{
        timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queueMemoryHandler);
        dispatch_time_t tt = dispatch_time(DISPATCH_TIME_NOW, timer* NSEC_PER_SEC);
        dispatch_source_set_timer(timerSource, tt, DISPATCH_TIME_FOREVER, 0);
        dispatch_source_set_event_handler(timerSource, ^{
            
            /* timer null */
            timerSource = NULL;
            
            /* tracking memory */
            [wSelf trackingMemory];
            
            /* start again */
            [wSelf startMornitoringRAMWithTimer:10];
        });
        dispatch_source_set_cancel_handler(timerSource, ^{
            timerSource = NULL;
        });
        dispatch_resume(timerSource);
    };
    if (dispatch_get_specific(queueMemoryTag)) {
        block();
    }else{
        dispatch_async(queueMemoryHandler, block);
    }
}
-(void)trackingMemory{
    int mib[6];
    mib[0] = CTL_HW;
    mib[1] = HW_PAGESIZE;
    
    int pagesize;
    size_t length;
    length = sizeof (pagesize);
    if (sysctl (mib, 2, &pagesize, &length, NULL, 0) < 0)
    {
        fprintf (stderr, "getting page size");
    }
    
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    
    vm_statistics_data_t vmstat;
    if (host_statistics (mach_host_self (), HOST_VM_INFO, (host_info_t) &vmstat, &count) != KERN_SUCCESS)
    {
        fprintf (stderr, "Failed to get VM statistics.");
    }
//    double total = vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count;
//    double wired = vmstat.wire_count / total;
//    double active = vmstat.active_count / total;
//    double inactive = vmstat.inactive_count / total;
//    double free = vmstat.free_count / total;
    task_basic_info_64_data_t info;
    unsigned size = sizeof (info);
    task_info (mach_task_self (), TASK_BASIC_INFO_64, (task_info_t) &info, &size);
    double unit = 1024 * 1024;
    
    NSLog(@"%@",[NSString stringWithFormat: @"% 3.1f MB\n% 3.1f MB\n% 3.1f MB", vmstat.free_count * pagesize / unit, (vmstat.free_count + vmstat.inactive_count) * pagesize / unit, info.resident_size / unit]);
}
-(void)stopMornitoringRAM{
    if (timerSource) {
        dispatch_source_cancel(timerSource);
    }
}
@end
