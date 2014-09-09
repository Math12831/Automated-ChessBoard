// Checkers.c
// Version 1.1
// Basic definitions for each function
// Includes isLegal function

#include <stdio.h>
#include <stdlib.h>
#include "Checkers.h"

-(void) moveChecks (Game g, Action a, NSInteger row, NSInteger col, NSInteger player);

Game newGame (NSInteger gameNumber) {
    // Allocation of the game in memory
    Game g = malloc(sizeof(game));
    
    // Initialisation of variables
    g->currentTurn = 1;
    g->checkersBoard = {{BLACK_CHECKER, NO_PIECE, BLACK_CHECKER, NO_PIECE, BLACK_CHECKER, NO_PIECE, BLACK_CHECKER, NO_PIECE},
        {NO_PIECE, BLACK_CHECKER, NO_PIECE, BLACK_CHECKER, NO_PIECE, BLACK_CHECKER, NO_PIECE, BLACK_CHECKER},
        {BLACK_CHECKER, NO_PIECE, BLACK_CHECKER, NO_PIECE, BLACK_CHECKER, NO_PIECE, BLACK_CHECKER, NO_PIECE},
        {NO_PIECE, NO_PIECE, NO_PIECE, NO_PIECE, NO_PIECE, NO_PIECE, NO_PIECE, NO_PIECE},
        {NO_PIECE, NO_PIECE, NO_PIECE, NO_PIECE, NO_PIECE, NO_PIECE, NO_PIECE, NO_PIECE},
        {WHITE_CHECKER, NO_PIECE, WHITE_CHECKER, NO_PIECE, WHITE_CHECKER, NO_PIECE, WHITE_CHECKER, NO_PIECE},
        {NO_PIECE, WHITE_CHECKER, NO_PIECE, WHITE_CHECKER, NO_PIECE, WHITE_CHECKER, NO_PIECE, WHITE_CHECKER},
        {WHITE_CHECKER, NO_PIECE, WHITE_CHECKER, NO_PIECE, WHITE_CHECKER, NO_PIECE, WHITE_CHECKER, NO_PIECE}};
    
    // Initialising the players
    
    g->player1->checkers = 0;
    g->player1->crownedCheckers = 0;
    g->player2->checkers = 0;
    g->player2->crownedCheckers = 0;
    
    return g;
}

-(void) disposeGame (Game g) {
    // The memory has been erased!
    // The game never happened...
    free(g);
}

-(NSInteger) isLegalMove (Game g, Action a, NSInteger row, NSInteger col, NSInteger player) {
    // Can the move be played?
    NSInteger ans = 1;
    
    if ((g->checkersBoard[row][col] == BLACK_CHECKER && player == 2) || (g->checkersBoard[row][col] == BLACK_CROWNED_CHECKER && player == 2) ||
        (g->checkersBoard[row][col] == WHITE_CROWNED_CHECKER && player == 1) || (g->checkersBoard[row][col] == WHITE_CHECKER && player == 1)) {
        if (a->actionCode == MOVE_BACKWARD_LEFT) {
            if (row == 0 || col == 0) {
                ans = 0;
            } else {
                if ((g->checkersBoard[row - 1][col - 1] == BLACK_CHECKER && player == 2) || (g->checkersBoard[row - 1][col - 1] == BLACK_CROWNED_CHECKER && player == 2) ||
                    (g->checkersBoard[row - 1][col - 1] == WHITE_CROWNED_CHECKER && player == 1) || (g->checkersBoard[row - 1][col - 1] == WHITE_CHECKER && player == 1)) {
                    ans = 0;
                }
            }
        } else if (a->actionCode == MOVE_BACKWARD_RIGHT) {
            if (row == (NUM_OF_ROWS - 1) || col == 0) {
                ans = 0;
            } else {
                if ((g->checkersBoard[row + 1][col - 1] == BLACK_CHECKER && player == 2) || (g->checkersBoard[row + 1][col - 1] == BLACK_CROWNED_CHECKER && player == 2) ||
                    (g->checkersBoard[row + 1][col - 1] == WHITE_CROWNED_CHECKER && player == 1) || (g->checkersBoard[row + 1][col - 1] == WHITE_CHECKER && player == 1)) {
                    ans = 0;
                }
            }
        } else if (a->actionCode == MOVE_FORWARD_LEFT) {
            if (row == 0 || col == (NUM_OF_COLUMNS - 1)) {
                ans = 0;
            } else {
                if ((g->checkersBoard[row - 1][col + 1] == BLACK_CHECKER && player == 2) || (g->checkersBoard[row - 1][col + 1] == BLACK_CROWNED_CHECKER && player == 2) ||
                    (g->checkersBoard[row - 1][col + 1] == WHITE_CROWNED_CHECKER && player == 1) || (g->checkersBoard[row - 1][col + 1] == WHITE_CHECKER && player == 1)) {
                    ans = 0;
                }
            }
        } else if (a->actionCode == MOVE_FORWARD_RIGHT) {
            if (row == (NUM_OF_ROWS - 1) || col == (NUM_OF_COLUMNS - 1)) {
                ans = 0;
            } else {
                if ((g->checkersBoard[row + 1][col + 1] == BLACK_CHECKER && player == 2) || (g->checkersBoard[row + 1][col + 1] == BLACK_CROWNED_CHECKER && player == 2) ||
                    (g->checkersBoard[row + 1][col + 1] == WHITE_CROWNED_CHECKER && player == 1) || (g->checkersBoard[row + 1][col + 1] == WHITE_CHECKER && player == 1)) {
                    ans = 0;
                }
            }
        }
    }
    
    return ans;
}

-(void) moveChecks (Game g, Action a, NSInteger row, NSInteger col, NSInteger player) {
    NSInteger rowChange;
    NSInteger colChange;
    if (a->actionCode == MOVE_BACKWARD_LEFT) {
        rowChange = -1;
        colChange = -1;
    } else if (a->actionCode == MOVE_BACKWARD_RIGHT) {
        rowChange = 1;
        colChange = -1;
    } else if (a->actionCode == MOVE_FORWARD_LEFT) {
        rowChange = -1;
        colChange = 1;
    } else if (a->actionCode == MOVE_FORWARD_RIGHT) {
        rowChange = 1;
        colChange = 1;
    }
    if (g->checkersBoard[row + rowChange][col + colChange] == BLACK_CHECKER && player == 1) {
        g->checkersBoard[row + rowChange][col + colChange] = NO_PIECE;
        g->player2->checkers -= 1;
    } else if (g->checkersBoard[row + rowChange][col + colChange] == BLACK_CROWNED_CHECKER && player == 1) {
        g->checkersBoard[row + rowChange][col + colChange] = NO_PIECE;
        g->player2->crownedCheckers -= 1;
    } else if (g->checkersBoard[row + rowChange][col + colChange] == WHITE_CHECKER && player == 2) {
        g->checkersBoard[row + rowChange][col + colChange] = NO_PIECE;
        g->player1->checkers -= 1;
    } else if (g->checkersBoard[row + rowChange][col + colChange] == WHITE_CROWNED_CHECKER && player == 2) {
        g->checkersBoard[row + rowChange][col + colChange] = NO_PIECE;
        g->player1->crownedCheckers -= 1;
    }
}

-(void) makeMove (Game g, Action a, NSInteger row, NSInteger col) {
    NSInteger player;
    if (g->checkersBoard[row][col] == BLACK_CHECKER || g->checkersBoard[row][col] == BLACK_CROWNED_CHECKER) {
        player = 2;
    } else if (g->checkersBoard[row][col] == WHITE_CHECKER || g->checkersBoard[row][col] == WHITE_CROWNED_CHECKER) {
        player = 1;
    }
    if (isLegalMove(g, a, row, col, player) == 1) {
        if (a->actionCode == MOVE_BACKWARD_LEFT) {
            g->checkersBoard[row - 2][col - 2] = g->checkersBoard[row][col];
            g->checkersBoard[row][col] = NO_PIECE;
            moveChecks (g, a, row, col, player);
        } else if (a->actionCode == MOVE_BACKWARD_RIGHT) {
            g->checkersBoard[row - 2][col + 2] = g->checkersBoard[row][col];
            g->checkersBoard[row][col] = NO_PIECE;
            moveChecks (g, a, row, col, player);
        } else if (a->actionCode == MOVE_FORWARD_LEFT) {
            g->checkersBoard[row + 2][col - 2] = g->checkersBoard[row][col];
            g->checkersBoard[row][col] = NO_PIECE;
            moveChecks (g, a, row, col, player);
        } else if (a->actionCode == MOVE_FORWARD_RIGHT) {
            g->checkersBoard[row + 2][col + 2] = g->checkersBoard[row][col];
            g->checkersBoard[row][col] = NO_PIECE;
            moveChecks (g, a, row, col, player);
        }
    }
}

-(NSInteger) getMostCheckers (Game g) {
    NSInteger answer;
    if (g->player1->checkers > g->player2->checkers) {
        answer = PLAYER_1;
    } else if (g->player2->checkers > g->player1->checkers) {
        answer = PLAYER_2;
    } else {
        answer = NONE;
    }
    return answer;
}

-(NSInteger) getMoveNumber (Game g) {
    return g->currentTurn;
}

-(NSInteger) getWhoseMove (Game g) {
    return (g->currentTurn % 2);
}

-(NSInteger) getPiece (Game g, NSInteger row, NSInteger col) {
    return g->checkersBoard[row][col];
}

-(NSInteger) getCheckers (Game g, NSInteger player) {
    NSInteger answer;
    if (player == 1) {
        answer = g->player1->checkers;
    } else {
        answer = g->player2->checkers;
    }
    return answer;
}

NSInteger getCrownedCheckers (Game g, NSInteger player) {
    NSInteger answer;
    if (player == 1) {
        answer = g->player1->crownedCheckers;
    } else {
        answer = g->player2->crownedCheckers;
    }
    return answer;
}
