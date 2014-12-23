//
//  ADViewController.m
//  Lesson21_HW_tennis
//
//  Created by A D on 1/7/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "ADViewController.h"

@interface ADViewController ()

@property (assign, nonatomic) CGFloat duration;

@property (weak, nonatomic) UIImageView *player1;
@property (weak, nonatomic) UIImageView *player2;
@property (weak, nonatomic) UIImageView *ballView;
@property (weak, nonatomic) UIImageView *fieldView;

@property (strong, nonatomic) NSArray *imagesLeftToRight;
@property (strong, nonatomic) NSArray *imagesRightToLeft;

@property (assign, nonatomic) CGPoint player1Home;
@property (assign, nonatomic) CGPoint player2Home;

@property (weak, nonatomic) UIImageView *playerTurn;

@end

@implementation ADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *manLeftMost = [UIImage imageNamed:@"Left_most.png"];
    UIImage *manLeft = [UIImage imageNamed:@"Left.png"];
    UIImage *manMid = [UIImage imageNamed:@"Mid.png"];
    UIImage *manRight = [UIImage imageNamed:@"Right.png"];
    UIImage *manRightMost = [UIImage imageNamed:@"Right_most.png"];
    UIImage *field = [UIImage imageNamed:@"Field.png"];
    UIImage *ball = [UIImage imageNamed:@"Ball.png"];
    
    self.imagesLeftToRight = [NSArray arrayWithObjects:manLeftMost, manLeft, manMid, manRight, manRightMost, nil];
    self.imagesRightToLeft = [NSArray arrayWithObjects:manRightMost, manRight, manMid, manLeft, manLeftMost, nil];
    
    self.player1Home = CGPointMake(30, 125);
    self.player2Home = CGPointMake(400, 100);
    
    self.fieldView = [self createViewWighImage:field andFrame:CGRectMake(40, 40, 400, 250)];
    self.player1 = [self createViewWighImage:manLeftMost andFrame:CGRectMake(self.player1Home.x, self.player1Home.y, 50, 50)];
    self.player2 = [self createViewWighImage:manRightMost andFrame:CGRectMake(self.player2Home.x, self.player2Home.y, 50, 50)];
    self.ballView = [self createViewWighImage:ball andFrame:CGRectMake(CGRectGetMidX(self.player1.frame), CGRectGetMidY(self.player1.frame), 15, 15)];
    
    self.playerTurn = self.player1;
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self moveBallView:self.ballView
           toPoint:[self  ballDestinationPointWithPlayerTurn:self.playerTurn]
      withDuration:1.f
          andDelay:0.35f
           options:UIViewAnimationCurveEaseIn
       andRotation:[self ballRotationDegree]];
}


#pragma mark - Animations -

- (void) moveBallView:(UIView *)view toPoint:(CGPoint)destination withDuration:(CGFloat)duration andDelay:(CGFloat)delay options:(NSInteger)optionsMask andRotation:(CGFloat)rotation {

    CGPoint ballDestination = [self ballDestinationPointWithPlayerTurn:self.playerTurn];
        
    UIImageView *secondPlayer = [self.playerTurn isEqual:self.player1] ? self.player2 : self.player1;
    
    [self animateView:self.playerTurn
           withImages:[self.playerTurn isEqual:self.player1] ? self.imagesLeftToRight : self.imagesRightToLeft
          andDuration:0.5f
        andRepeaCount:1];

    [self movePlayer:self.playerTurn
             toPoint:[self player:self.playerTurn destinationPointWithPlayerTurn:self.playerTurn andBallDestination:ballDestination]
        withDuration:1.0f
            andDelay:0.3f
             options:UIViewAnimationCurveEaseOut];
    
    [self movePlayer:secondPlayer
           toPoint:[self player:secondPlayer destinationPointWithPlayerTurn:self.playerTurn andBallDestination:ballDestination]
      withDuration:1.0f
          andDelay:0.3f
           options:UIViewAnimationCurveEaseOut];
 
    [UIView animateWithDuration:2 delay:delay options:optionsMask animations:^{

        view.center = ballDestination;
        CGAffineTransform rotate = CGAffineTransformMakeRotation(rotation);
        view.transform = rotate;
        
        [UIView transitionWithView:self.ballView
                          duration:0.75f
                           options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionOverrideInheritedDuration
                        animations:^{
                            
                            CGAffineTransform scale = (duration > 1.5f) ? CGAffineTransformMakeScale(2.2f, 2.2f) : CGAffineTransformMakeScale(1.3f, 1.3f);
                            view.transform = scale;
                            
                        } completion:^(BOOL finished) {
                        }];

    } completion:^(BOOL finished) {
        
        [self changePlayerTurn];
        
        [self moveBallView:self.ballView
               toPoint:[self  ballDestinationPointWithPlayerTurn:self.playerTurn]
          withDuration:[self randomDuration]  //5.f
              andDelay:0.f
               options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionOverrideInheritedDuration
           andRotation:[self ballRotationDegree]];
    }];
}


-(CGFloat) ballRotationDegree{
    
    return (float)(arc4random()%(int)(M_PI*4*10000)) / 10000 - M_PI*2;
}

-(CGFloat) randomDuration{
    NSLog(@"%f", (float)((arc4random()%150)+20)/100);
    return (float)((arc4random()%150)+20)/100;
    
}


- (void) movePlayer:(UIImageView*)player toPoint:(CGPoint)destination withDuration:(CGFloat)duration andDelay:(CGFloat)delay options:(NSInteger)optionsMask{
    
    [UIView animateWithDuration:duration delay:delay options:optionsMask animations:^{
        
        player.center = destination;
        
    } completion:^(BOOL finished) {
    }];
}


- (void) animateView:(UIImageView *) view withImages:(NSArray*) images andDuration:(CGFloat) duration andRepeaCount:(NSInteger) count{
    
    view.animationDuration = duration;
    view.animationImages = images;
    view.animationRepeatCount = count;
    [view startAnimating];
}


#pragma mark - Destination Points -

- (CGPoint) ballDestinationPointWithPlayerTurn:(UIImageView *) turn{

    //return CGPointMake([turn isEqual:self.player1]? CGRectGetMidX(self.player2.frame): CGRectGetMidX(self.player1.frame), (float)(arc4random()%190) +40);
    
    return CGPointMake([turn isEqual:self.player1]?  (float)(arc4random()%150) +300 : (float)(arc4random()%110) +40, (float)(arc4random()%190) +40);
    
}


- (CGPoint) player:(UIView *)player destinationPointWithPlayerTurn:(UIView *)turn andBallDestination:(CGPoint) ballDestination{
    
    if([turn isEqual:player] && [player isEqual:self.player1]){
        return CGPointMake(self.player1Home.x + 25, self.player1Home.y + 25);
    }else if([turn isEqual:player] && [player isEqual:self.player2]){
        return CGPointMake(self.player2Home.x + 25, self.player1Home.y + 25);
    }else{
        return ballDestination;
    }
}


#pragma mark - Change Turn -

- (void) changePlayerTurn{
    self.playerTurn = [self.playerTurn isEqual:self.player1] ? self.player2 : self.player1;
}


#pragma  mark - Create View -

- (UIImageView *) createViewWighImage:(UIImage*) image andFrame:(CGRect)frame{
    
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    [view setFrame:frame];
    [self.view addSubview:view];
    return view;
}

@end
