/*
 *
 * Title: Line Follower
 * Author: Anjuchan and Wonchu
 *
 * We have to figure out which surface that we will be testing the robot
 * since the reflected brightness is different based on all different 
 * materials and places 
 *
 * PLEASE DO NOT ERASE 
 *
 * */
#pragma config(Sensor, S1,     lightSensor,    sensorEV3_Color)
#pragma config(Motor,  motorA,          rightDriveMotor, tmotorEV3_Large, PIDControl, driveRight, encoder)
#pragma config(Motor,  motorB,          leftDriveMotor, tmotorEV3_Large, PIDControl, driveLeft, encoder)
//*!!Code automatically generated by 'ROBOTC' configuration wizard               !!*//

#define SLOPE 0.5
#define baseSpeed -30
// #define True 1

task main()
{
	while(true){ 
		float currentLight = SensorValue[lightSensor];
		// fully black 3
		// half black 17
		// not on black 24
		float leftMotorSpeed;
		leftMotorSpeed = baseSpeed + SLOPE*(currentLight);
		setMotorSpeed(leftDriveMotor, leftMotorSpeed);

		float rightMotorSpeed;
  	    rightMotorSpeed = -(baseSpeed + SLOPE*(currentLight));
		setMotorSpeed(rightDriveMotor, rightMotorSpeed);
	}
}
