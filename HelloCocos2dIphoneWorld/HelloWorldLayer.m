//
//  HelloWorldLayer.m
//  HelloCocos2dIphoneWorld
//
//  Created by Jair Rillo Junior on 11/2/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

//Needed to Handle Touch Events -- look at registerWithTouchDispatcher method
#import "CCTouchDispatcher.h"

CCSprite *seeker1;
CCSprite *cocosGuy;

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        //Create the seeker
        seeker1 = [CCSprite spriteWithFile: @"seeker.png"];
        seeker1.position = ccp(50,100);
        [self addChild:seeker1];
        
        //Create the cocosGuy
        cocosGuy = [CCSprite spriteWithFile: @"Icon.png"];
        cocosGuy.position = ccp(200, 300);
        [self addChild:cocosGuy];
        
        //Schedulling a callback
        [self schedule:@selector(nextFrame:)];
        
        //Ativa o touch
        self.isTouchEnabled = YES;

	}
	return self;
}

-(void) nextFrame:(ccTime)dt
{
    seeker1.position = ccp(seeker1.position.x + 100 * dt, seeker1.position.y);
    //Recupera os dados da tela
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //Se chegou no final da tela, volta para o inicio
    //Tamanho da tela + tamanho da imagem
    if (seeker1.position.x > winSize.width + 32) {
        seeker1.position = ccp(-32, seeker1.position.y);
    }
}

//Metodo 
-(void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //Recupera a localizacao do touch
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	touchLocation = [self convertToNodeSpace:touchLocation];
    
    //Para as acoes
    [cocosGuy stopAllActions];
    
    //Roda a action
    [cocosGuy runAction: [CCMoveTo actionWithDuration:1 position:touchLocation]];
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
