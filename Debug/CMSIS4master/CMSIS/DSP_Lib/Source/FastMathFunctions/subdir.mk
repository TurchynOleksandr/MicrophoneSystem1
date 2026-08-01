################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_f32.c \
../CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q15.c \
../CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q31.c \
../CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_f32.c \
../CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q15.c \
../CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q31.c \
../CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q15.c \
../CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q31.c 

OBJS += \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_f32.o \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q15.o \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q31.o \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_f32.o \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q15.o \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q31.o \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q15.o \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q31.o 

C_DEPS += \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_f32.d \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q15.d \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q31.d \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_f32.d \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q15.d \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q31.d \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q15.d \
./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q31.d 


# Each subdirectory must supply rules for building sources it contributes
CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/%.o CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/%.su CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/%.cyclo: ../CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/%.c CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE -DARM_MATH_CM4 -D__FPU_PRESENT=1 -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I"D:/STM32Projects/MicrophoneSystem1/CMSIS4master/CMSIS/Include" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-CMSIS4master-2f-CMSIS-2f-DSP_Lib-2f-Source-2f-FastMathFunctions

clean-CMSIS4master-2f-CMSIS-2f-DSP_Lib-2f-Source-2f-FastMathFunctions:
	-$(RM) ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_f32.cyclo ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_f32.d ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_f32.o ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_f32.su ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q15.cyclo ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q15.d ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q15.o ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q15.su ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q31.cyclo ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q31.d ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q31.o ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_cos_q31.su ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_f32.cyclo ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_f32.d ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_f32.o ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_f32.su ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q15.cyclo ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q15.d ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q15.o ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q15.su ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q31.cyclo ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q31.d ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q31.o ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sin_q31.su ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q15.cyclo ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q15.d ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q15.o ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q15.su ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q31.cyclo ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q31.d ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q31.o ./CMSIS4master/CMSIS/DSP_Lib/Source/FastMathFunctions/arm_sqrt_q31.su

.PHONY: clean-CMSIS4master-2f-CMSIS-2f-DSP_Lib-2f-Source-2f-FastMathFunctions

