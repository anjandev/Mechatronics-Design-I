#define RIGHT_MAX 180

task main()
{
	// drawEllipse(Left, Top, Right, Bottom);

	int Left=0;
	int Right =5;

	while(1){
		while(Right < RIGHT_MAX){
			drawEllipse(Left, 5, Right, 0);
			sleep(200);
			eraseDisplay();
			Left++;
			Right++;
		}

		while(Left > 0){
			drawEllipse(Left, 5, Right, 0);
			sleep(200);
			eraseDisplay();
			Left--;
			Right--;
		}
	}
}