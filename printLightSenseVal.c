#pragma config(Sensor, S1,     light,          sensorEV3_Color, modeEV3Color_RGB_Raw)
//*!!Code automatically generated by 'ROBOTC' configuration wizard               !!*//

task main()
{
	while(1){
			displayCenteredTextLine(4, "%d", SensorValue[S1]);
      delay(300);
      eraseDisplay();
	}


}