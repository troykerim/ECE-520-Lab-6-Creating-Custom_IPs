#include "gpio_ctrl.h"
#include "xparameters.h"
int main()
{
	gpioCtrl gpio_ins; //instance, points to the header we added
	init_gpio(&gpio_ins, XPAR_GPIO_CTRL_IP_0_S00_AXI_BASEADDR);

	//Do not hardcode base address from Vivado!
	//Use xparameters.h, look for S00_ and you will find 0x43C00000
	//Copy the base name not the number!

	while(1)
	{
		u32 switches = read_gpio(&gpio_ins);
		write_gpio(&gpio_ins, switches);
	}
	return 0;
}
