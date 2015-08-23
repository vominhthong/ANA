//
//  TCAHPSimpleServer.m
//  TCAHPDemo
//
//  Created by Joachim Bengtsson on 2012-10-06.
//
//

#import "TCAHPSimpleServer.h"
#import "AsyncSocket.h"
#import "TCAsyncHashProtocol.h"

@interface TCAHPSimpleServer () <NSNetServiceDelegate>
@end

@implementation TCAHPSimpleServer {
	AsyncSocket *_listen;
	NSMutableArray *_clients;
	NSTimer *_timer;
    NSNetService *_service;
    id _delegate;
    NSString *_serviceType, *_serviceName; int _port;
}
- (id)initOnBasePort:(int)port serviceType:(NSString*)serviceType serviceName:(NSString*)serviceName delegate:(id)delegate error:(NSError**)err
{
	if(!(self = [super init]))
        return nil;
    
    _delegate = delegate;
    
    _port = port;
	_listen = [[AsyncSocket alloc] initWithDelegate:self];
	_clients = [NSMutableArray new];
    if(![_listen acceptOnPort:_port error:err])
        return nil;
    
    _serviceName = serviceName; _serviceType = serviceType;
    _service = [[NSNetService alloc] initWithDomain:@"" type:_serviceType name:_serviceName port:_port];
    _service.delegate = self;
	[_service publish];
    
	return self;
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket;
{
	// The TCAHP takes ownership of the socket and becomes its delegate. We only need to implement
	// TCAHP's delegate now.
	TCAsyncHashProtocol *proto = [[TCAsyncHashProtocol alloc] initWithSocket:newSocket delegate:_delegate];
	
	// Dispatch on selector of the incoming command instead of using delegate methods.
	proto.autoDispatchCommands = YES;
	
	// Hang on to it, or else it has no owner and will disconnect.
	[_clients addObject:proto];
    
    NSLog(@"Accepted new connection %@", newSocket);
    if([_delegate respondsToSelector:@selector(server:acceptedNewClient:)])
        [_delegate server:self acceptedNewClient:proto];
}
- (void)transportDidDisconnect:(TCAHPTransport*)transport
{
	TCAsyncHashProtocol *proto = nil;
	for(TCAsyncHashProtocol *potential in _clients)
		if(potential.transport == transport) proto = potential;
    
    NSLog(@"Lost connection %@", transport);
    if([_delegate respondsToSelector:@selector(server:lostClient:)])
        [_delegate server:self lostClient:proto];
	[_clients removeObject:proto];
}

- (void)broadcast:(NSDictionary*)hash;
{
	for(TCAsyncHashProtocol *proto in _clients)
		[proto sendHash:hash];
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"Published %@", self);
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict;
{
    NSLog(@"NOTE: Did not publish %@: %@", self, errorDict);
}
- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@:%p %@/%@/%d>", [self class], self, _serviceType, _serviceName, _port];
}
@end
