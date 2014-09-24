// Checkers Game

#import "CHKViewController.h"

@interface CHKViewController (){
    
    UIImageView *gridCell[65];
    UIImageView *onTopofCell[65];
    
}

@property NSInteger selectedCircle;

@end

int cellWidth = 57;
int cellHeight = 57;
int squares = 64;
int leftX = 100;
int topY = 100;

int currentMove = 0;
int player1Checkers = 12;
int player1CrownedCheckers = 0;
int player2Checkers = 12;
int player2CrownedCheckers = 0;

int distance = 0;

@implementation CHKViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    int i;
    int row = 0,col = 0;
    int firstColor = 0;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        cellWidth = 30;
        cellHeight = cellWidth;
        topY = 230 - 4 * cellHeight;
        leftX = 160 - 4 * cellWidth;
    } else {
        cellWidth = 57;
        cellHeight = cellWidth;
        topY = 500 - 4 * cellHeight;
        leftX = 384 - 4 * cellWidth;
    }
    
    for (i = 1;i <= 64;i++){
        
        if (firstColor == 0) {
            gridCell[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RedSq.jpg"]];
        } else {
            gridCell[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blackSq.jpg"]];
        }
        
        gridCell[i].frame = CGRectMake(leftX+cellWidth*col, topY+cellHeight*row, cellWidth, cellHeight);
        [self.view addSubview:gridCell[i]];
        [self.view addSubview:onTopofCell[i]];
        
        col += 1;
        firstColor = 1 - firstColor;
        if (col > 7) {
            row += 1;
            firstColor = 1 - firstColor;
            col = 0;
        }
    }
    
    col = 0;
    row = 0;
    
    for (i = 1;i <= 64;i++) {
        int swagger = 0;
        swagger = row % 2;
        if (i % 2 == swagger) {
            if (i < 25) {
                onTopofCell[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RedCheckr.png"]];
            } else if (i > 40) {
                onTopofCell[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WhiteCheckr.png"]];
            } else {
                onTopofCell[i] = [[UIImageView alloc] initWithImage:nil];
            }
            onTopofCell[i].frame = CGRectMake(leftX+cellWidth*col, topY+cellHeight*row, cellWidth, cellHeight);
            [self.view addSubview:onTopofCell[i]];
            onTopofCell[i].userInteractionEnabled = YES;
            gridCell[i].userInteractionEnabled = NO;
        } else {
            onTopofCell[i] = [[UIImageView alloc] initWithImage:nil];
            onTopofCell[i].frame = CGRectMake(leftX+cellWidth*col, topY+cellHeight*row, cellWidth, cellHeight);
            [self.view addSubview:onTopofCell[i]];
            onTopofCell[i].userInteractionEnabled = YES;
            gridCell[i].userInteractionEnabled = NO;
        }
        col += 1;
        if (col > 7) {
            row += 1;
            col = 0;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    int i;
    
    for (i = 1;i <= squares;i++) {
        if ([touch view] == onTopofCell[i]) {
            onTopofCell[i].center = [touch locationInView:self.view];
            self.selectedCircle = i;
            return;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGFloat l = 0.0;
    CGFloat min = 100000000000000000000000000.0;
    int bestSquare = 0;
    UITouch *touch = [touches anyObject];
    
    for (int i = 1;i <= squares;i++) {
        int row = ceilf(i / 8);
        int swagger = 0;
        swagger = row % 2;
        if (i % 2 == swagger) {
                l = hypotf(gridCell[i].center.x - [touch view].center.x, gridCell[i].center.y - [touch view].center.y);
                if (l < min) {
                    min = l;
                    bestSquare = i;
                }
        }
    }
    
    if (bestSquare != 0) {
        
        distance = bestSquare - self.selectedCircle;
        
        if (((distance == -14 || distance == -18) && onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"WhiteCheckr.png"]) ||
            ((distance == 14 || distance == 18) && onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"RedCheckr.png"]) ||
            ((abs(distance) == 14 || abs(distance) == 18) && (onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"RedCrown.png"] ||
            onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"WhiteCrown.png"]))) {
            
            if (currentMove == 0 && (onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"WhiteCrown.png"] ||
                                     onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"WhiteCheckr.png"])
                        && (onTopofCell[self.selectedCircle + (distance/2)].image == [UIImage imageNamed:@"RedCheckr.png"] ||
                            onTopofCell[self.selectedCircle + (distance/2)].image == [UIImage imageNamed:@"RedCrown.png"])) {
                
                onTopofCell[self.selectedCircle].center = gridCell[self.selectedCircle].center;
                onTopofCell[bestSquare].image = onTopofCell[self.selectedCircle].image;
                
                if (ceil(bestSquare / 8) == 0) {
                    if (onTopofCell[bestSquare].image != [UIImage imageNamed:@"WhiteCrown.png"]) {
                        onTopofCell[bestSquare].image = [UIImage imageNamed:@"WhiteCrown.png"];
                        player1Checkers--;
                        player1CrownedCheckers++;
                    }
                }
                
                [self takePiece:bestSquare withPiece:self.selectedCircle];
                            
                onTopofCell[self.selectedCircle].image = nil;
                
            } else if (currentMove == 1 && (onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"RedCrown.png"] ||
                                            onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"RedCheckr.png"])
                       && (onTopofCell[self.selectedCircle + (distance/2)].image == [UIImage imageNamed:@"WhiteCrown.png"] ||
                           onTopofCell[self.selectedCircle + (distance/2)].image == [UIImage imageNamed:@"WhiteCheckr.png"])) {
                
                onTopofCell[self.selectedCircle].center = gridCell[self.selectedCircle].center;
                onTopofCell[bestSquare].image = onTopofCell[self.selectedCircle].image;
                
                if (ceil(bestSquare / 8) == 7) {
                    if (onTopofCell[bestSquare].image != [UIImage imageNamed:@"RedCrown.png"]) {
                        onTopofCell[bestSquare].image = [UIImage imageNamed:@"RedCrown.png"];
                        player2Checkers--;
                        player2CrownedCheckers++;
                    }
                }
                           
                [self takePiece:bestSquare withPiece:self.selectedCircle];
                
                onTopofCell[self.selectedCircle].image = nil;
                
            } else {
                onTopofCell[self.selectedCircle].center = gridCell[self.selectedCircle].center;
                UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                                   message:@"Move Is Incompatible!"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Continue"
                                                         otherButtonTitles:nil];
                [theAlert show];
                currentMove = (currentMove - 1) % 2;
            }

            currentMove = (currentMove + 1) % 2;
            
        } else if ((onTopofCell[bestSquare].image == nil) && (((distance == -7 || distance == -9) && onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"WhiteCheckr.png"]) ||
                   ((distance == 7 || distance == 9) && onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"RedCheckr.png"]) ||
                   ((abs(distance) == 7 || abs(distance) == 9) && (onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"RedCrown.png"] ||
                                                                     onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"WhiteCrown.png"])))) {
            
            if (currentMove == 0 && (onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"WhiteCrown.png"] ||
                                     onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"WhiteCheckr.png"])) {
                
                onTopofCell[self.selectedCircle].center = gridCell[self.selectedCircle].center;
                onTopofCell[bestSquare].image = onTopofCell[self.selectedCircle].image;
                
                if (ceil(bestSquare / 8) == 0) {
                    if (onTopofCell[bestSquare].image != [UIImage imageNamed:@"WhiteCrown.png"]) {
                        onTopofCell[bestSquare].image = [UIImage imageNamed:@"WhiteCrown.png"];
                        player1Checkers--;
                        player1CrownedCheckers++;
                    }
                }
            
                onTopofCell[self.selectedCircle].image = nil;
                
            } else if (currentMove == 1 && (onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"RedCrown.png"] ||
                                            onTopofCell[self.selectedCircle].image == [UIImage imageNamed:@"RedCheckr.png"])) {
                
                onTopofCell[self.selectedCircle].center = gridCell[self.selectedCircle].center;
                onTopofCell[bestSquare].image = onTopofCell[self.selectedCircle].image;
                
                if (ceil(bestSquare / 8) == 7) {
                    if (onTopofCell[bestSquare].image != [UIImage imageNamed:@"RedCrown.png"]) {
                        onTopofCell[bestSquare].image = [UIImage imageNamed:@"RedCrown.png"];
                        player2Checkers--;
                        player2CrownedCheckers++;
                    }
                }
            
                onTopofCell[self.selectedCircle].image = nil;
                
            } else {
                onTopofCell[self.selectedCircle].center = gridCell[self.selectedCircle].center;
                UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                                   message:@"Not Your Turn!"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Continue"
                                                         otherButtonTitles:nil];
                [theAlert show];
                currentMove = (currentMove - 1) % 2;
            }
            
            currentMove = (currentMove + 1) % 2;
            
        } else {
            onTopofCell[self.selectedCircle].center = gridCell[self.selectedCircle].center;
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                               message:@"Illegal Move!"
                                                              delegate:self
                                                     cancelButtonTitle:@"Continue"
                                                     otherButtonTitles:nil];
            [theAlert show];
        }
    }
    
    if ((player1Checkers + player1CrownedCheckers) == 0) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                           message:@"Red has won!"
                                                          delegate:self
                                                 cancelButtonTitle:@"Restart Game"
                                                 otherButtonTitles:nil];
        [theAlert show];
    } else if ((player2Checkers + player2CrownedCheckers) == 0) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                           message:@"White has won!"
                                                          delegate:self
                                                 cancelButtonTitle:@"Restart Game"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
}

- (void)takePiece:(int)bestSquare withPiece:(int)selectedPiece {
    if (currentMove == 0) {
        if (onTopofCell[self.selectedCircle + (distance/2)].image == [UIImage imageNamed:@"RedCrown.png"]) {
            onTopofCell[self.selectedCircle + (distance/2)].image = nil;
            player2CrownedCheckers--;
        } else if (onTopofCell[self.selectedCircle + (distance/2)].image == [UIImage imageNamed:@"RedCheckr.png"]) {
            onTopofCell[self.selectedCircle + (distance/2)].image = nil;
            player2CrownedCheckers--;
        }
    } else if (currentMove == 1) {
        if (onTopofCell[self.selectedCircle + (distance/2)].image == [UIImage imageNamed:@"WhiteCheckr.png"]) {
            onTopofCell[self.selectedCircle + (distance/2)].image = nil;
            player1Checkers--;
        } else if (onTopofCell[self.selectedCircle + (distance/2)].image == [UIImage imageNamed:@"WhiteCrown.png"]) {
            onTopofCell[self.selectedCircle + (distance/2)].image = nil;
            player1CrownedCheckers--;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
