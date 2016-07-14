typedef struct{
    int NWall;
    int SWall;
    int EWall;
    int WWall;
    char Visited;
}cell;

int const MAZE_WIDTH = 4;
int const MAZE_HEIGHT = 6;

cell Maze[MAZE_WIDTH][MAZE_HEIGHT];

task main(){

    for (int c = 0; c < MAZE_WIDTH; c++){
        Maze[0][c].SWall = 1;
        Maze[MAZE_HEIGHT - 1][c].NWall = 1;
    }

    for (int r = 0; r < MAZE_HEIGHT; r++){
        Maze[r][0].WWall = 1;
        Maze[r][MAZE_WIDTH - 1].EWall = 1;

    }
    // check accuracy
    goFwdCell();
    goFwdCell();
    Turn90CW();
    goFwdCell();

}

void goFwdCell(){


}

void Turn90CW(){
    
}

void Turn90CCW(){

}

void UTurn(){
    Turn90CW();
    Turn90CW();
}
