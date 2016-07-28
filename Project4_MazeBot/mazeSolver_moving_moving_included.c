#pragma config(Sensor, S1,     distance,       sensorEV3_Ultrasonic)
#pragma config(Motor,  motorA,          leftDrive,     tmotorEV3_Large, PIDControl, driveLeft, encoder)
#pragma config(Motor,  motorD,          rightDrive,    tmotorEV3_Large, PIDControl, driveRight, encoder)
//*!!Code automatically generated by 'ROBOTC' configuration wizard               !!*//

#define PRESENT 1
#define UNKNOWN 2

float const DIST_BETWEEN_BOT_AND_WALL = 7.6;
// Define directions using numbers
#define NORTH 0
#define EAST 1
#define SOUTH 2
#define WEST 3

typedef struct{
	int NWall;
	int SWall;
	int EWall;
	int WWall;
	int Visited;
	int entryDir;
}cell;

// ZERO INDEXED
int const START_ROW = 3;
int const START_COL = 0;
int const END_ROW = 0;
int const END_COL = 0;

int currentRow = START_ROW;
int currentCol = START_COL;

int const MILI_TO_BEEP_FOR = 200;
int const FREQUENCY = 300;

// CHANGE THESE IF ANYTHING MECHANICAL. MAKE SURE YOU TEST THESE
float const UNCERTAINTY_STRAIGHT = 19;
float const UNCERTAINTY_ROT = 27;

// Movement Variabels defined
float const ONE_ROTATION = 360 + UNCERTAINTY_STRAIGHT;
float const QUARTER_ROTATION = 180 + UNCERTAINTY_ROT;


float const SIZE_OF_ONE_CELL = 22.5425; //cm
float const DRIVE_GEAR_RATIO = 5;
float const DIAMETER_OF_WHEEL = 5.5; // cm
float const CIRCUMFERENCE_OF_WHEEL = PI * DIAMETER_OF_WHEEL;

// Speed Variable
int const FORWARD = -100;
int const BACKWARD = -FORWARD;

// MAZE VARIABLES
int const MAZE_WIDTH = 6;
int const MAZE_HEIGHT = 4;
int const LAST_MAZE_HEIGHT_INDEX = MAZE_HEIGHT - 1;
int const LAST_MAZE_WIDTH_INDEX = MAZE_WIDTH - 1;
cell Maze[MAZE_HEIGHT][MAZE_WIDTH];

int entered[MAZE_WIDTH*MAZE_HEIGHT*4];
int lastEnteredIdx = 0;

#define SCREEN_HEIGHT 127
//177
#define	SCREEN_WIDTH 177
#define CELL_HEIGHT	(SCREEN_HEIGHT / MAZE_HEIGHT)
#define CELL_WIDTH (SCREEN_HEIGHT / MAZE_WIDTH)

#define CELL_HEIGHT_MIDDLE (CELL_HEIGHT / 2)
#define CELL_WIDTH_MIDDLE (CELL_WIDTH / 2)

// MISC Constants
int const MILLISECS_TO_DRIVE_INTO_WALL = 1000;

// Call functions
void goFwdCell(int direction);
int Turn90CW(int direction);
int Turn90CCW(int direction);
int MovementWithSensor(int direction);
void reverseDirection();
void deleteDuplicates();
int goingBackFastestRoute(int direction);
void drawInfo(int direction);
void reAdjust(int direction);

int const CELLS_TO_READJUST_AFTER = 5;
int timesForwardWithoutReadjust = 0;



void drawInfo(int direction){
	//drawRect(Left, Top, Right, Bottom);
	eraseDisplay();

	for(int r = 0; r < MAZE_HEIGHT; r++){
		for(int c = 0; c < MAZE_WIDTH; c++){

			if(Maze[r][c].SWall == PRESENT){
				drawLine(c*CELL_WIDTH,r*CELL_HEIGHT,c*CELL_WIDTH + CELL_WIDTH,r*CELL_HEIGHT);
			}
			if(Maze[r][c].NWall == PRESENT){
				drawLine(c*CELL_WIDTH,r*CELL_HEIGHT + CELL_HEIGHT,c*CELL_WIDTH + CELL_WIDTH,r*CELL_HEIGHT + CELL_HEIGHT);
			}
			if(Maze[r][c].WWall == PRESENT){
				drawLine(c*CELL_WIDTH,r*CELL_HEIGHT,c*CELL_WIDTH, r*CELL_HEIGHT + CELL_HEIGHT);
			}
			if(Maze[r][c].EWall == PRESENT){
				drawLine(c*CELL_WIDTH + CELL_WIDTH,r*CELL_HEIGHT,c*CELL_WIDTH + CELL_WIDTH, r*CELL_HEIGHT + CELL_HEIGHT);
			}

		}
	}

	if(direction == NORTH){
		displayBigStringAt(currentCol*CELL_WIDTH + CELL_WIDTH_MIDDLE, currentRow*CELL_HEIGHT + CELL_HEIGHT_MIDDLE, "^");
	}
	else if(direction == EAST){
		displayBigStringAt(currentCol*CELL_WIDTH + CELL_WIDTH_MIDDLE, currentRow*CELL_HEIGHT + CELL_HEIGHT_MIDDLE, ">");
	}
	else if(direction == WEST){
		displayBigStringAt(currentCol*CELL_WIDTH + CELL_WIDTH_MIDDLE, currentRow*CELL_HEIGHT + CELL_HEIGHT_MIDDLE, "<");
	}
	else if(direction == SOUTH){
		displayBigStringAt(currentCol*CELL_WIDTH + CELL_WIDTH_MIDDLE, currentRow*CELL_HEIGHT + CELL_HEIGHT_MIDDLE, "v");
	}



}

task main(){
	
	for (int c = 0; c < MAZE_WIDTH; c++){
		for (int r = 0; r < MAZE_HEIGHT; r++){
			Maze[r][c].Visited = false;
			Maze[r][c].NWall = UNKNOWN;
			Maze[r][c].SWall = UNKNOWN;
			Maze[r][c].EWall = UNKNOWN;
			Maze[r][c].WWall = UNKNOWN;
		}
	}

	// Assigning walls [row][col]
	for (int c = 0; c < MAZE_WIDTH; c++){
		Maze[0][c].SWall = PRESENT;
		Maze[LAST_MAZE_HEIGHT_INDEX][c].NWall = PRESENT;
	}

	for (int r = 0; r < MAZE_HEIGHT; r++){
		Maze[r][0].WWall = PRESENT;
		Maze[r][LAST_MAZE_WIDTH_INDEX].EWall = PRESENT;

	}
	
	int direction = NORTH;
	
	Maze[currentRow][currentCol].entryDir = direction;
	Maze[currentRow][currentCol].Visited = true;

	while(currentRow != END_ROW || currentCol != END_COL){
		direction = MovementWithSensor(direction);
		entered[lastEnteredIdx] = direction;
		lastEnteredIdx++;
	}

	playTone(FREQUENCY, MILI_TO_BEEP_FOR);


	deleteDuplicates();

	sleep(MILI_TO_BEEP_FOR * 10);

	reverseDirection();	
	direction = goingBackFastestRoute(direction);

	drawInfo(direction);
	sleep(30000);
	
}



void deleteDuplicates(){
	int idx = -1;

	while(idx < lastEnteredIdx){
		idx++;

		if(abs(entered[idx] - entered[idx + 1]) == 2){
			for(int moveOGTo = idx; moveOGTo <= lastEnteredIdx - 2; moveOGTo++){
				entered[moveOGTo] = entered[moveOGTo + 2];
			}

			lastEnteredIdx = lastEnteredIdx - 2;
			idx = -1;
		}

	}
}

void reverseDirection(){
	for(int idx = 0; idx <= lastEnteredIdx; idx++){
		if(entered[idx]==EAST){
			entered[idx] = WEST;
		}
		else if(entered[idx]==SOUTH){
			entered[idx] = NORTH;
		}
		else if(entered[idx]==WEST){
			entered[idx] = EAST;
		}
		else if(entered[idx]==NORTH){
			entered[idx] = SOUTH;
		}
	}
}

int goingBackFastestRoute(int direction){

	for(int idx = lastEnteredIdx - 1; idx >= 0; idx--){
		int turnNum = entered[idx] - direction;

		if(abs(turnNum) == 2){
			direction = Turn90CW(direction);
			direction = Turn90CW(direction);
		}
		else if(turnNum == 3){
			direction = Turn90CCW(direction);
		}
		else if(turnNum == -3){
			direction = Turn90CW(direction);
		}
		else if(turnNum == 1){
			direction = Turn90CW(direction);
		}
		else if(turnNum == -1){
			direction = Turn90CCW(direction);
		}

		goFwdCell(direction);

	}

	return direction;
}

void goFwdCell(int direction){
	setMotorSyncEncoder(leftDrive, rightDrive, 0, (SIZE_OF_ONE_CELL / CIRCUMFERENCE_OF_WHEEL)*DRIVE_GEAR_RATIO * ONE_ROTATION, FORWARD);
  
	repeatUntil(!getMotorRunning(leftDrive) && !getMotorRunning(rightDrive)){

	}
	if (direction == NORTH){
		Maze[currentRow][currentCol].NWall = false;
		currentRow++;
		Maze[currentRow][currentCol].SWall = false;
	}
	else if (direction == SOUTH){
		Maze[currentRow][currentCol].SWall = false;
		currentRow--;
		Maze[currentRow][currentCol].NWall = false;
	}
	else if (direction == EAST){
		Maze[currentRow][currentCol].EWall = false;
		currentCol++;
		Maze[currentRow][currentCol].WWall = false;
	}
	else if (direction == WEST){
		Maze[currentRow][currentCol].WWall = false;
		currentCol--;
		Maze[currentRow][currentCol].EWall = false;
	}

	Maze[currentRow][currentCol].entryDir = direction;
	Maze[currentRow][currentCol].Visited = true;

	timesForwardWithoutReadjust++;
}

int Turn90CCW(int direction){
	setMotorSyncEncoder(leftDrive, rightDrive, -100, QUARTER_ROTATION * DRIVE_GEAR_RATIO, FORWARD);
	
	repeatUntil(!getMotorRunning(leftDrive) && !getMotorRunning(rightDrive)){

	}
	if(direction == 0){
		direction = 3;
	}
	else{
		direction--;
	}
	drawInfo(direction);
	return direction;

}

int Turn90CW(int direction){
	setMotorSyncEncoder(leftDrive, rightDrive, 100, QUARTER_ROTATION * DRIVE_GEAR_RATIO, FORWARD);	

	repeatUntil(!getMotorRunning(leftDrive) && !getMotorRunning(rightDrive)){

	}

	if(direction < 3){
		direction++;
	}
	else{
		direction = NORTH;
	}
	drawInfo(direction);
	return direction;
}

int thereIsWall(){
	if(getUSDistance(distance)<=DIST_BETWEEN_BOT_AND_WALL || getUSDistance(distance)==255){
		return 1;
	}

	return 0;
}


void writeWall(int direction){
	if(direction == NORTH && thereIsWall()){
		Maze[currentRow][currentCol].NWall = PRESENT;
		if(currentRow + 1 <= LAST_MAZE_HEIGHT_INDEX){
			Maze[currentRow + 1][currentCol].SWall = PRESENT;
		}
	}
	else if(direction == SOUTH && thereIsWall()){
		Maze[currentRow][currentCol].SWall = PRESENT;
		if(currentRow - 1 >= 0){
			Maze[currentRow - 1][currentCol].NWall = PRESENT;
		}
	}
	else if(direction == EAST && thereIsWall()){
		Maze[currentRow][currentCol].EWall = PRESENT;
		if(currentCol + 1 <= LAST_MAZE_WIDTH_INDEX){
			Maze[currentRow][currentCol + 1].WWall = PRESENT;
		}
	}
	else if(direction == WEST && thereIsWall()){
		Maze[currentRow][currentCol].WWall = PRESENT;
		if(currentCol - 1 >= 0){
			Maze[currentRow][currentCol - 1].EWall = PRESENT;
		}
	}
}


// Checking order, North(0), East(1), West(3) then South(2)
int MovementWithSensor(int direction){
	

	int enteringDirectionWall = thereIsWall();
	writeWall(direction);

	// turn to check if wall is right
	direction = Turn90CW(direction);
	writeWall(direction);
	if(!thereIsWall()){
		goFwdCell(direction);
		return direction;
	}
	
	if(thereIsWall() && enteringDirectionWall){
		reAdjust(direction);	
	}
	
	if(thereIsWall() && !enteringDirectionWall){
		direction = Turn90CCW(direction);
		goFwdCell(direction);
		return direction;
	}

	direction = Turn90CW(direction);
	direction = Turn90CW(direction);
	writeWall(direction);

	if(!thereIsWall()){
		goFwdCell(direction);
		return direction;
	}

	direction =	Turn90CCW(direction);
	goFwdCell(direction);

	return direction;
}


void reAdjust(int direction){
	if(timesForwardWithoutReadjust >=  CELLS_TO_READJUST_AFTER){

		direction = Turn90CCW(direction);

		motor[rightDrive] = FORWARD;
		motor[leftDrive] = FORWARD;
		sleep(MILLISECS_TO_DRIVE_INTO_WALL);

		setMotorSyncEncoder(leftDrive, rightDrive, 0, ((SIZE_OF_ONE_CELL / CIRCUMFERENCE_OF_WHEEL)*DRIVE_GEAR_RATIO * ONE_ROTATION)/7, BACKWARD);
		
		repeatUntil(!getMotorRunning(leftDrive) && !getMotorRunning(rightDrive)){

		}

		Turn90CW(direction);

		motor[rightDrive] = FORWARD;
		motor[leftDrive] = FORWARD;
		sleep(MILLISECS_TO_DRIVE_INTO_WALL);

		setMotorSyncEncoder(leftDrive, rightDrive, 0, ((SIZE_OF_ONE_CELL / CIRCUMFERENCE_OF_WHEEL)*DRIVE_GEAR_RATIO * ONE_ROTATION)/7, BACKWARD);
		
		repeatUntil(!getMotorRunning(leftDrive) && !getMotorRunning(rightDrive)){

		}

		timesForwardWithoutReadjust = 0;

	}
}