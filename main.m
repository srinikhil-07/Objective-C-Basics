#import <Foundation/Foundation.h>


@interface EgClass: NSObject
- (void) threadMethod: (int) a;
- (void) timerFired:(NSTimer *)a;
-(void) taskExample;
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
        [task setExecutableURL:[NSURL fileURLWithPath:@"/bin/sh"]];
        [task setArguments:[NSArray arrayWithObjects:@"-c",@"ls /Volumes", nil]];
        
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
@end

int main(int argv, const char* argc[]){
    int choice;
    NSLog(@"Enter your choice");
    NSLog(@"Choice 1: Create a thread and trigger a timer");
    NSLog(@"Choice 2: Execute command line commands from a process");
    scanf("%i",&choice);
    EgClass *inst=[[EgClass alloc] init];
    if(choice==1){ //thread is triggered but not timer, resolve this issue
        NSThread *egThread=[[NSThread alloc] initWithTarget:inst selector:@selector(threadMethod:) object:NULL];
        [egThread start];
    //[inst threadMethod:10];
    }
    else if(choice==2){
        [inst taskExample];
    }
    return 0;
}
