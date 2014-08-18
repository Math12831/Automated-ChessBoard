// Checkers.h
// Version 1.3
// Includes basic function declerations
// These functions can be called by the player and the AI only.

#define NUM_OF_ROWS 8
#define NUM_OF_COLUMNS 8

// Possible pieces on a square of the board
#define NO_PIECE 0
#define BLACK_CHECKER 1
#define BLACK_CROWNED_CHECKER 2
#define WHITE_CHECKER 3
#define WHITE_CROWNED_CHECKER 4

// Action codes
#define MOVE_FORWARD_LEFT 0
#define MOVE_FORWARD_RIGHT 1
#define MOVE_BACKWARD_LEFT 2
#define MOVE_BACKWARD_RIGHT 3

// Players - maximum and minimum of 2
#define NONE 0
#define PLAYER_1 1
#define PLAYER_2 2

#define TRUE 1
#define FALSE 0

// The game structure

typedef struct _game * Game;
typedef struct _action * Action;
typedef struct _player * Player;

typedef struct _game {
    int currentTurn;
    int checkersBoard[NUM_OF_ROWS][NUM_OF_COLUMNS];
    Player player1;
    Player player2;
} game;

// The player structure
typedef struct _player {
    int checkers;
    int crownedCheckers;
} player;

// Simple action structure - may include more items later for chess
typedef struct _action {
    int actionCode;
} action;

// Begin a-new!
Game newGame (int gameNumber);

// Game over. Literally.
void disposeGame (Game g);

// Make a move!
void makeMove (Game g, Action a, int row, int col);

// Who is currently winning the game?
int getMostCheckers (Game g);

// How many turns have we played?
int getMoveNumber (Game g);

// Is it really your turn?
int getWhoseMove (Game g);

// Is there a piece on this square? If so, which one?
int getPiece (Game g, int row, int col);

// Hm. How many normal checkers do I have?
int getCheckers (Game g, int player);

// Okay. Now, how many crowned checkers do I have?
int getCrownedCheckers (Game g, int player);

// This is a big one. It will require me to find out a few things about the game.
// Basically, is the move you have specified legal or illegal?
int isLegalMove (Game g, Action a, int row, int col, int player);

// Enjoy!
