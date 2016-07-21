#define PRESENT 1
float const DIST_BETWEEN_BOT_AND_WALL = 7.6;

int const MILI_TO_BEEP_FOR = 2000;
int const FREQUENCY = 300;

// CHANGE THESE IF ANYTHING MECHANICAL. MAKE SURE YOU TEST THESE
int const SPEED_ON_MOTOR_DIF = 10;
float const UNCERTAINTY_STRAIGHT = 23;
float const UNCERTAINTY_ROT = 27;

// Movement Variabels defined
float const ONE_ROTATION = 360 + UNCERTAINTY_STRAIGHT;
float const QUARTER_ROTATION = 180 + UNCERTAINTY_ROT;


float const DRIVE_GEAR_RATIO = 5;
float const DIAMETER_OF_WHEEL = 5.5; // cm
float const CIRCUMFERENCE_OF_WHEEL = PI * DIAMETER_OF_WHEEL;

// Speed Variable
int const FORWARD = -100;
int const BACKWARD = -FORWARD;

int entered[MAZE_WIDTH*MAZE_HEIGHT];
int lastEnteredIdx = 0;

// MISC Constants
int const MILLISECS_TO_DRIVE_INTO_WALL = 2000;

// Call functions
void goFwdCell(int direction);
int Turn90CW(int direction);
int Turn90CCW(int direction);
int uTurn(int direction);
int MovementWithSensor(int direction);
void reverseDirection();
void deleteDuplicates();
void goingBackFastestRoute(int direction);

task main(){

// Assigning walls [row][col]
	for (int c = 0; c < MAZE_WIDTH; c++){
		Maze[0][c].SWall = PRESENT;
		Maze[LAST_MAZE_HEIGHT_INDEX][c].NWall = PRESENT;
	}

	for (int r = 0; r < MAZE_HEIGHT; r++){
		Maze[r][0].WWall = PRESENT;
		Maze[r][LAST_MAZE_WIDTH_INDEX].EWall = PRESENT;

	}

	//direction = Turn90CW(direction);
	//goFwdCell();
	/*
	goFwdCell();
	Turn90CW();
	UTurn();
	goFwdCell();
	Turn90CCW();

	Turn90CW();
	*/



	while(currentRow != END_ROW && currentCol != END_COL){
		direction = MovementWithSensor(direction);
		entered[lastEnteredIdx] = direction;
		lastEnteredIdx++;
	}

	//playImmediateTone(FREQUENCY, MILI_TO_BEEP_FOR);

	/*
  deleteDuplicates();
  reverseDirection();
  goingBackFastestRoute(direction);*/
}

void deleteDuplicates(){
	for(int idx = 0; idx < lastEnteredIdx; idx++){
			if(abs(entered[idx] - entered[idx + 1]) == 2){
				entered[idx] = '\0';
				entered[idx + 1] = '\0';
				idx = 0;
			}
	}

}

void reverseDirection(){
	for(int idx = 0; idx < lastEnteredIdx; idx++){
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

void goingBackFastestRoute(int direction){
	for(int idx = lastEnteredIdx; idx >= 0; idx--){
		// TODO: MAKE IT FAST. TURN WITH FASTEST SOLUTION
		if(entered[idx]){
			while(direction != entered[idx]){
				direction = Turn90CW(direction);
		  }
	  }
  }
}

void goFwdCell(int direction){
	moveMotorTarget(leftDrive, (SIZE_OF_ONE_CELL / CIRCUMFERENCE_OF_WHEEL)*DRIVE_GEAR_RATIO * ONE_ROTATION, FORWARD);
	moveMotorTarget(rightDrive, (SIZE_OF_ONE_CELL / CIRCUMFERENCE_OF_WHEEL)*DRIVE_GEAR_RATIO * ONE_ROTATION, FORWARD + SPEED_ON_MOTOR_DIF);
	repeatUntil(!getMotorRunning(leftDrive) && !getMotorRunning(rightDrive)){

	}

	if (direction == NORTH){
		currentRow++;
	}
	else if (direction == SOUTH){
		currentRow--;
	}
	else if (direction == EAST){
		currentCol++;
	}
	else if (direction == WEST){
		currentCol--;
	}

}

int Turn90CCW(int direction){
	moveMotorTarget(leftDrive, QUARTER_ROTATION * DRIVE_GEAR_RATIO, BACKWARD);
	moveMotorTarget(rightDrive, QUARTER_ROTATION * DRIVE_GEAR_RATIO, FORWARD);
	repeatUntil(!getMotorRunning(leftDrive) && !getMotorRunning(rightDrive)){

	}
	if(direction < 3){
		direction++;
	}
	else{
		direction = NORTH;
	}

	return direction;

}

int Turn90CW(int direction){
	moveMotorTarget(leftDrive, QUARTER_ROTATION * DRIVE_GEAR_RATIO, FORWARD);
	moveMotorTarget(rightDrive, QUARTER_ROTATION * DRIVE_GEAR_RATIO, BACKWARD);

	repeatUntil(!getMotorRunning(leftDrive) && !getMotorRunning(rightDrive)){

	}

	if(direction == 0){
		direction = 3;
	}
	else{
		direction--;
	}

	return direction;
}

int uTurn(int direction){
	direction = Turn90CW(direction);
	direction = Turn90CW(direction);
	return direction;
}

int thereIsWall(){
	if(getUSDistance(distance)<=DIST_BETWEEN_BOT_AND_WALL || getUSDistance(distance)==255){
		return 1;
	}

	return 0;
}

// Checking order, North(0), East(1), West(3) then South(2)
int MovementWithSensor(int direction){
	cell current;

	int backWall = 0;
	int enteringDirectionWall = thereIsWall();

	if(direction == NORTH && thereIsWall()){
		current.NWall = 1;
		enteringDirectionWall = 1;
	}
	else if(direction == SOUTH && thereIsWall()){
		current.SWall = 1;
		enteringDirectionWall = 1;
	}
	else if(direction == EAST && thereIsWall()){
		current.EWall = 1;
		enteringDirectionWall = 1;
	}
	else if(direction == WEST && thereIsWall()){
		current.WWall = 1;
		enteringDirectionWall = 1;
	}

	if(direction == NORTH && !thereIsWall()){
		current.NWall = 0;
	}
	else if(direction == SOUTH && !thereIsWall()){
		current.SWall = 0;
	}
	else if(direction == EAST && !thereIsWall()){
		current.EWall = 0;
	}
	else if(direction == WEST && !thereIsWall()){
		current.WWall = 0;
	}

	// turn to check if wall is right
	direction = Turn90CW(direction);

	if(!thereIsWall()){
		goFwdCell(direction);
		return direction;
	}

	if(thereIsWall() && !enteringDirectionWall){
		direction = Turn90CCW(direction);
		goFwdCell(direction);
		return direction;
	}

	direction = uTurn(direction);

	if(!thereIsWall()){
		goFwdCell(direction);
		return direction;
	}

  direction =	Turn90CCW(direction);
	goFwdCell(direction);

	return direction;
}

// If -1 is returned, that means that it didnt readjust and the direction is the same as it was before.
int readAdjust(int direction){

}
