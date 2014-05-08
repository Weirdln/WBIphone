//
//  SystemInfoFunc.m
//  iPhoneNewVersion
//
//  Created by Howard on 13-6-14.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import "SystemInfoFunc.h"
#import <sys/utsname.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <sys/socket.h>
#import <net/if.h>
#import <net/if_dl.h>
#include <ifaddrs.h>


@implementation SystemInfoFunc

+ (NSString *)deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);

    NSString * platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

+ (NSString *)systemName
{
    return [UIDevice currentDevice].systemName;
}

+ (NSString *)systemVersion
{
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)systemVersionWithBuildingNo
{
    return [NSProcessInfo processInfo].operatingSystemVersionString;
}

+ (NSString *)deviceDescription
{
    return [UIDevice currentDevice].name;
}

+ (UIDeviceBatteryState)batteryState
{
    return [UIDevice currentDevice].batteryState;
}

+ (float)batteryLevel
{
    return [UIDevice currentDevice].batteryLevel;
}

+ (NSString *)model
{
    return [UIDevice currentDevice].model;
}

+ (NSString *)localizedModel
{
    return [UIDevice currentDevice].localizedModel;
}

+ (NSString *)macAddress
{
    int                    mib[6];
	size_t					len;
	char					*buf;
	unsigned char			*ptr;
	struct if_msghdr		*ifm;
	struct sockaddr_dl		*sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1/n");
		return NULL;
	}
	
	if ((buf = malloc(len)) == NULL) {
		printf("Could not allocate memory. error!/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2");
		free(buf);
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	
	NSString *macAddStr = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
    
	return macAddStr;
}

+ (double)physicalMemory
{
    return [NSProcessInfo processInfo].physicalMemory;
}

+ (NSString *)globallyUniqueStringForProcess
{
    return [NSProcessInfo processInfo].globallyUniqueString;
}

+ (NSString *)hostName
{
    return [NSProcessInfo processInfo].hostName;
}

+ (NSString *)processName
{
    return [NSProcessInfo processInfo].processName;
}

+ (NSString *)bundleName
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleName"];
}

+ (NSString *)appName
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"];
}

+ (NSString *)developmentVersionNumber
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
}

+ (NSString *)marketingVersionNumber
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
}

+ (float)cpuStatus
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
//    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
//    uint32_t stat_thread = 0; // Mach threads
    
//    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
//    if (thread_count > 0)
//        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    return tot_cpu;
}

+ (NSDictionary *)memoryStatus
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
    {
        NSLog(@"Failed to fetch vm statistics");
        return nil;
    }
    
    /* Stats in bytes */
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    float usage = (float)mem_used / (float)mem_total;
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:mem_total], kMemTotal, [NSNumber numberWithUnsignedInteger:mem_free], kMemFreed, [NSNumber numberWithUnsignedInteger:mem_used], kMemUsed, [NSNumber numberWithFloat:usage], kMemUsage, nil];
    
    return dictionary;
}

+ (NSDictionary *)networkUsageStatus
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    unsigned long WiFiSent        = 0;
    unsigned long WiFiReceived    = 0;
    unsigned long WWANSent        = 0;
    unsigned long WWANReceived    = 0;
    
    NSString *name;
    
    success = getifaddrs(&addrs) == 0;
    
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name = [NSString stringWithFormat:@"%s",cursor->ifa_name];
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(WiFiSent/1024)], kSendByWIFI, [NSNumber numberWithInt:(WiFiReceived/1024)], kRecvByWIFI, [NSNumber numberWithInt:(WWANSent/1024)], kSendByWWAN, [NSNumber numberWithInt:(WWANReceived/1024)], kRecvByWWAN, nil];
}

@end
