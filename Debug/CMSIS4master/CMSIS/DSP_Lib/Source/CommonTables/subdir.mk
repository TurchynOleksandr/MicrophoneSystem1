################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_common_tables.c \
../CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_const_structs.c 

OBJS += \
./CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_common_tables.o \
./CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_const_structs.o 

C_DEPS += \
./CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_common_tables.d \
./CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_const_structs.d 


# Each subdirectory must supply rules for building sources it contributes
CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/%.o CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/%.su CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/%.cyclo: ../CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/%.c CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE -DARM_MATH_CM4 -D__FPU_PRESENT=1 -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I"D:/STM32Projects/MicrophoneSystem1/CMSIS4master/CMSIS/Include" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-CMSIS4master-2f-CMSIS-2f-DSP_Lib-2f-Source-2f-CommonTables

clean-CMSIS4master-2f-CMSIS-2f-DSP_Lib-2f-Source-2f-CommonTables:
	-$(RM) ./CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_common_tables.cyclo ./CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_common_tables.d ./CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_common_tables.o ./CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_common_tables.su ./CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_const_structs.cyclo ./CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_const_structs.d ./CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_const_structs.o ./CMSIS4master/CMSIS/DSP_Lib/Source/CommonTables/arm_const_structs.su

.PHONY: clean-CMSIS4master-2f-CMSIS-2f-DSP_Lib-2f-Source-2f-CommonTables

