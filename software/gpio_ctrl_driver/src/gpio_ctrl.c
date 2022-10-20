#include "gpio_ctrl.h" //"" are for local files
//#include <stdio.h> Dont use

int init_gpio(gpioCtrl *custom_gpio, u32 baseAddress)
{
	custom_gpio->baseAddress = baseAddress; //ptr accessing struct
	return 0;
}
void write_gpio(gpioCtrl *custom_gpio, u32 write_data)
{
	Xil_Out32(custom_gpio->baseAddress, write_data);
}
u32 read_gpio(gpioCtrl *custom_gpio)
{
	return Xil_In32(custom_gpio->baseAddress + 4); //because of offset to access the switches
	//Not Pointer addition above ^
}
