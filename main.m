#import <Foundation/Foundation.h>
#import <Appkit/Appkit.h>
#import "DelegatingClass.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <Cocoa/Cocoa.h>
#import "HTTPWork.h"

@interface EgClass: DelegatingClass
- (void) threadMethod: (int) a;
- (void) timerFired:(NSTimer *)a;
-(void) taskExample;
-(void) delegateTask:(DelegatingClass *)sender;
-(void) launchDaemon;
-(void) shutDownNotifier;
-(void) logTheFile;
@end
// TO.DO : check whats stopping the NSTimer
@implementation EgClass
-(void) threadMethod:(int) a{ // tried different ways to triggere a repeatitive timer, failed
    NSLog(@"This is a thread method! \n");
   /* NSTimer *fnTrigger=[[NSTimer scheduledTimerWithTimeInterval:2.0f repeats:YES block:^(NSTimer *timer){
        NSLog(@"Block of code \n");
    }];
    [fnTrigger fire];*/
    
    //[timer fire];
    /*NSRunLoop *run=[NSRunLoop currentRunLoop];
    [run addTimer:fnTrigger forMode:NSDefaultRunLoopMode];
    [run run];
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(timerFired:)
                                           userInfo:nil repeats:YES];
    [run addTimer:timer forMode:NSDefaultRunLoopMode];
    
   [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];*/
    NSMethodSignature *sgn=[self methodSignatureForSelector:@selector(timerFired:)];
    NSInvocation *inv=[NSInvocation invocationWithMethodSignature:sgn]; // setting an invocation for timer
    [inv setTarget:self];
    [inv setSelector:@selector(timerFired:)];
    NSTimer *fnCaller=[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];//set interval timer for run loop
    //scheduledTimerWithTimeInterval:2.0 invocation:inv repeats:YES]
    [[NSRunLoop mainRunLoop] addTimer:fnCaller forMode:NSDefaultRunLoopMode];
    
   /* dispatch_async(dispatch_get_main_queue(), ^{
        NSTimer *m_timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                   target:self
                                                 selector:@selector(timerFired)
                                                 userInfo:nil
                                                  repeats:YES];
    });*/
    
    if(![NSThread isMainThread]){
    //is false then start the timer like this:
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    });
    }
}

-(void) timerFired:(NSTimer *)a{
    NSLog(@"please work \n");
}
// TO.DO: learn about commands and arguments
-(void) taskExample{
    
    // asynchronously execute two processes
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSTask *task=[[NSTask alloc] init];
        //[task setExecutableURL:[NSURL fileURLWithPath:@"/bin/sh"]];
        //[task setArguments:[NSArray arrayWithObjects:@"-c",@"open /Applications/iBooks.app", nil]];
        [[NSWorkspace sharedWorkspace] launchApplication:@"iBooks"]; //using shared workspace to open iBooks app
        NSPipe *oPipe=[[NSPipe alloc] init];
        NSPipe *ePipe=[[NSPipe alloc]init];
        [task setStandardOutput:oPipe];
        [task setStandardError:ePipe];
        NSError *error =nil;
        if(![task launchAndReturnError:(&error)]){
            NSLog(@"Error in NSTask! with error :%@ \n",error);
            return;
        }
        [task waitUntilExit]; //block until receiver is finished
        if(task.terminationStatus !=0){
            //ERROR
            NSFileHandle *file=ePipe.fileHandleForReading;
            NSData *data=[file readDataToEndOfFile];
            [file closeFile];
            NSString *errMsg=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"ERROR (%i); %@ ",task.terminationStatus,errMsg);
            return;
        }
        //SUCCESS
        NSFileHandle *file =oPipe.fileHandleForReading;
        NSData *data=[file readDataToEndOfFile];
        [file closeFile];
        NSString *outMsg=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"OUtput is : %@",outMsg);
    });
    NSTask *task=[[NSTask alloc] init];
    [task setExecutableURL:[NSURL fileURLWithPath:@"/bin/ls"]];
    [task setArguments:[NSArray arrayWithObjects:@"-1",@"/", nil]];
    
    
    NSPipe *oPipe=[[NSPipe alloc] init];
    NSPipe *ePipe=[[NSPipe alloc]init];
    [task setStandardOutput:oPipe];
    [task setStandardError:ePipe];
    NSError *error =nil;
    if(![task launchAndReturnError:(&error)]){
        NSLog(@"Error in NSTask! \n");
        return;
    }
    [task waitUntilExit]; //block until receiver is finished
    if(task.terminationStatus !=0){
        //ERROR
        NSFileHandle *file=ePipe.fileHandleForReading;
        NSData *data=[file readDataToEndOfFile];
        [file closeFile];
        NSString *errMsg=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"ERROR (%i); %@ ",task.terminationStatus,errMsg);
        return;
    }
    //SUCCESS
    NSFileHandle *file =oPipe.fileHandleForReading;
    NSData *data=[file readDataToEndOfFile];
    [file closeFile];
    NSString *outMsg=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"OUtput is : %@",outMsg);
    
}

-(void) delegateTask:(DelegatingClass *)sender{
    NSLog(@"Delegated task executed! \n");
}
-(void) launchDaemon{
    NSTask *task=[[NSTask alloc] init];
    [task setExecutableURL:[NSURL fileURLWithPath:@"/bin/sh"]];
    //launchctl load /Library/LaunchDaemons/com.Safari.keepAlive.plist
    [task setArguments:[NSArray arrayWithObjects:@"-c",@"sudo killall shutdown", nil]];
    
    NSPipe *oPipe=[[NSPipe alloc] init];
    NSPipe *ePipe=[[NSPipe alloc]init];
    [task setStandardOutput:oPipe];
    [task setStandardError:ePipe];
    NSError *error =nil;
    if(![task launchAndReturnError:(&error)]){
        NSLog(@"Error in NSTask! with error :%@ \n",error);
        return;
    }
    [task waitUntilExit]; //block until receiver is finished
    if(task.terminationStatus !=0){
        //ERROR
        NSFileHandle *file=ePipe.fileHandleForReading;
        NSData *data=[file readDataToEndOfFile];
        [file closeFile];
        NSString *errMsg=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"ERROR (%i); %@ ",task.terminationStatus,errMsg);
        return;
    }
    //SUCCESS
    NSFileHandle *file =oPipe.fileHandleForReading;
    NSData *data=[file readDataToEndOfFile];
    [file closeFile];
    NSString *outMsg=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"OUtput is : %@",outMsg);
}

-(void) shutDownNotifier{
    [self launchDaemon];
    [self logTheFile];
}

-(void) logTheFile{
    NSLocale* currentLocale = [NSLocale currentLocale];
    NSString *str;
    str=[NSString stringWithFormat:@"\n ShutDown happened at %@",[[NSDate date] descriptionWithLocale:currentLocale]];
    NSLog(@"String is %@ \n",str);
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    //[str writeToFile:@"/Users/sri-7348/Desktop/log.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSFileHandle *log=[NSFileHandle fileHandleForWritingAtPath:@"/Users/sri-7348/Desktop/log.txt" ];
    [log seekToEndOfFile];
    [log writeData:data];
    [log closeFile];
    sleep(1);
}
@end

static void scCallBack(SCDynamicStoreRef dynStore, CFArrayRef changedKeys, void *info) {
    NSLog(@"Ip changed \n");
    // log into a file
    NSLocale* currentLocale = [NSLocale currentLocale];
    NSString *str;
    str=[NSString stringWithFormat:@"\n Login/Logout happened at %@",[[NSDate date] descriptionWithLocale:currentLocale]];
    NSLog(@"String is %@ \n",str);
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    //[str writeToFile:@"/Users/sri-7348/Desktop/log.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSFileHandle *log=[NSFileHandle fileHandleForWritingAtPath:@"/Users/sri-7348/Desktop/log.txt" ];
    [log seekToEndOfFile];
    [log writeData:data];
    [log closeFile];
    sleep(1);
    
}

void shutdownHandler(int signum){ //not being called at shutdown
    [[NSWorkspace sharedWorkspace] launchApplication:@"iBooks"];
    EgClass *inst=[[EgClass alloc]init];
    [inst launchDaemon];
    [inst logTheFile];
    
}

int main(int argv, const char* argc[]){
    int choice;
    NSLog(@"Enter your choice");
    NSLog(@"Choice 1: Create a thread and trigger a timer");
    NSLog(@"Choice 2: Execute command line commands from a process");
    NSLog(@"Choice 3: Execute launchd from this program \n");
    //scanf("%i",&choice);
    choice=7;
    DelegatingClass *boss =[[DelegatingClass alloc]init];
    EgClass *delegatePerson=[[EgClass alloc]init];
    boss.delegate=delegatePerson; //makes egClass conform to Delegate protocol
    [boss someOneDoDelegation]; //when DelegatingClass wants someone to do his task, EgClass does it.
    EgClass *inst=[[EgClass alloc] init];
    //EgDynamicStore *dsInst=[[EgDynamicStore alloc]init];
    if(choice==1){ //thread is triggered but not timer, resolve this issue
        NSThread *egThread=[[NSThread alloc] initWithTarget:inst selector:@selector(threadMethod:) object:NULL];
        [egThread start];
    //[inst threadMethod:10];
    }
    else if(choice==2){ //creates a subprocess
        [inst taskExample];
    }
    else if(choice==3){
        [inst launchDaemon]; // this launches daemon directly
    }
    //TO.DO: Add notification to multiple keys and differentiate them
    else if(choice==4){
        // this part of code notifies whenever a user logins/logouts using SCDynamicStore
        SCDynamicStoreContext context = {0, NULL, NULL, NULL, NULL};
        SCDynamicStoreRef ds = SCDynamicStoreCreate(NULL, CFBundleGetIdentifier(CFBundleGetMainBundle()), scCallBack, &context);
        NSLog(@"Printing the DS ref %@ \n",ds);
        //NSString *key=@"State:/Network/Global/IPv4";
        //const CFStringRef keys[3] = {CFSTR("State:/Network/Global/IPv4")};
        CFStringRef keys[3]={ CFSTR("State:/Users/ConsoleUser")};
        keys[2]= CFSTR("@State:/Network/Global/IPv4");
        
        CFArrayRef watchedKeys = CFArrayCreate(kCFAllocatorDefault,
                                               (const void **)keys,
                                               1,
                                               &kCFTypeArrayCallBacks);
        if(SCDynamicStoreSetNotificationKeys(ds,NULL, watchedKeys)){
            
            CFRunLoopSourceRef src = SCDynamicStoreCreateRunLoopSource(kCFAllocatorDefault, ds, 0);
            CFRunLoopAddSource([[NSRunLoop currentRunLoop] getCFRunLoop],
                               src,
                               kCFRunLoopCommonModes);
            [[NSRunLoop currentRunLoop] run];
        }else{
            CFRelease(watchedKeys);
            fprintf(stderr, "SCDynamicStoreSetNotificationKeys() failed: %s", SCErrorString(SCError()));
            CFRelease(ds);
            ds = NULL;
            
            return 0;
        }
    }
    else if(choice==5){
        [[NSWorkspace sharedWorkspace] launchApplication:@"iTunes"]; //using shared workspace to open iBooks app
        NSNotificationCenter *shutDown=[[NSWorkspace sharedWorkspace]notificationCenter]; //returning notification center for shared workspace,
        [shutDown addObserver:inst selector:@selector(shutDownNotifier) name:NSWorkspaceWillPowerOffNotification object:nil];
        [[NSRunLoop currentRunLoop]run];
        //signal(SIGTERM, shutdownHandler);
        
    }
    else if(choice==6){
        // add a key value to dynamic store,
        SCDynamicStoreContext context = {0, NULL, NULL, NULL, NULL};
        SCDynamicStoreRef ds = SCDynamicStoreCreate(NULL, CFBundleGetIdentifier(CFBundleGetMainBundle()), NULL, &context);
        NSLog(@"Printing the DS ref %@ \n",ds);
        CFStringRef keys={ CFSTR("Setup:/com.apple.myname")};
        CFStringRef value={ CFSTR("Batman")}; //see the doc: value can be any of the given types
        if(!(SCDynamicStoreAddValue(ds,keys,value))){ //do this as root!
            NSLog(@"Error! key not created! \n");
        }
        else{
            NSLog(@"Success! \n");
        }
    }
    else if(choice==7){
        //http upload and download
        HTTPWork *httpTask=[[HTTPWork alloc]init];
        //Download
        [httpTask downloadData];//SessionDownloadTask example
        [httpTask saveFilesInLocalDirectory]; //NSData with URL example
        [httpTask saveFilesFast];// SessionDataTask example
        NSLog(@"back to main \n");
    }
    return 0;
}
