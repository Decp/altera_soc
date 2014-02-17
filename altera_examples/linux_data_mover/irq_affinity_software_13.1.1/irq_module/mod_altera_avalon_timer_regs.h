/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2003 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
******************************************************************************/

#ifndef __ALTERA_AVALON_TIMER_REGS_H__
#define __ALTERA_AVALON_TIMER_REGS_H__

/* STATUS register */
#define ALTERA_AVALON_TIMER_STATUS_REG              0
#define ALTERA_AVALON_TIMER_STATUS_TO_MSK           (0x1)
#define ALTERA_AVALON_TIMER_STATUS_TO_OFST          (0)
#define ALTERA_AVALON_TIMER_STATUS_RUN_MSK          (0x2)
#define ALTERA_AVALON_TIMER_STATUS_RUN_OFST         (1)

/* CONTROL register */
#define ALTERA_AVALON_TIMER_CONTROL_REG             1
#define ALTERA_AVALON_TIMER_CONTROL_ITO_MSK         (0x1)
#define ALTERA_AVALON_TIMER_CONTROL_ITO_OFST        (0)
#define ALTERA_AVALON_TIMER_CONTROL_CONT_MSK        (0x2)
#define ALTERA_AVALON_TIMER_CONTROL_CONT_OFST       (1)
#define ALTERA_AVALON_TIMER_CONTROL_START_MSK       (0x4)
#define ALTERA_AVALON_TIMER_CONTROL_START_OFST      (2)
#define ALTERA_AVALON_TIMER_CONTROL_STOP_MSK        (0x8)
#define ALTERA_AVALON_TIMER_CONTROL_STOP_OFST       (3)

/* Period and SnapShot Register for COUNTER_SIZE = 32 */
/*----------------------------------------------------*/
/* PERIODL register */
#define ALTERA_AVALON_TIMER_PERIODL_REG             2
#define ALTERA_AVALON_TIMER_PERIODL_MSK             (0xFFFF)
#define ALTERA_AVALON_TIMER_PERIODL_OFST            (0)

/* PERIODH register */
#define ALTERA_AVALON_TIMER_PERIODH_REG             3
#define ALTERA_AVALON_TIMER_PERIODH_MSK             (0xFFFF)
#define ALTERA_AVALON_TIMER_PERIODH_OFST            (0)

/* SNAPL register */
#define ALTERA_AVALON_TIMER_SNAPL_REG               4
#define ALTERA_AVALON_TIMER_SNAPL_MSK               (0xFFFF)
#define ALTERA_AVALON_TIMER_SNAPL_OFST              (0)

/* SNAPH register */
#define ALTERA_AVALON_TIMER_SNAPH_REG               5
#define ALTERA_AVALON_TIMER_SNAPH_MSK               (0xFFFF)
#define ALTERA_AVALON_TIMER_SNAPH_OFST              (0)

/* Period and SnapShot Register for COUNTER_SIZE = 64 */
/*----------------------------------------------------*/
/* PERIOD_0 register */
#define ALTERA_AVALON_TIMER_PERIOD_0_REG             2
#define ALTERA_AVALON_TIMER_PERIOD_0_MSK             (0xFFFF)
#define ALTERA_AVALON_TIMER_PERIOD_0_OFST            (0)

/* PERIOD_1 register */
#define ALTERA_AVALON_TIMER_PERIOD_1_REG             3
#define ALTERA_AVALON_TIMER_PERIOD_1_MSK             (0xFFFF)
#define ALTERA_AVALON_TIMER_PERIOD_1_OFST            (0)

/* PERIOD_2 register */
#define ALTERA_AVALON_TIMER_PERIOD_2_REG             4
#define ALTERA_AVALON_TIMER_PERIOD_2_MSK             (0xFFFF)
#define ALTERA_AVALON_TIMER_PERIOD_2_OFST            (0)

/* PERIOD_3 register */
#define ALTERA_AVALON_TIMER_PERIOD_3_REG             5
#define ALTERA_AVALON_TIMER_PERIOD_3_MSK             (0xFFFF)
#define ALTERA_AVALON_TIMER_PERIOD_3_OFST            (0)

/* SNAP_0 register */
#define ALTERA_AVALON_TIMER_SNAP_0_REG               6
#define ALTERA_AVALON_TIMER_SNAP_0_MSK               (0xFFFF)
#define ALTERA_AVALON_TIMER_SNAP_0_OFST              (0)

/* SNAP_1 register */
#define ALTERA_AVALON_TIMER_SNAP_1_REG               7
#define ALTERA_AVALON_TIMER_SNAP_1_MSK               (0xFFFF)
#define ALTERA_AVALON_TIMER_SNAP_1_OFST              (0)

/* SNAP_2 register */
#define ALTERA_AVALON_TIMER_SNAP_2_REG               8
#define ALTERA_AVALON_TIMER_SNAP_2_MSK               (0xFFFF)
#define ALTERA_AVALON_TIMER_SNAP_2_OFST              (0)

/* SNAP_3 register */
#define ALTERA_AVALON_TIMER_SNAP_3_REG               9
#define ALTERA_AVALON_TIMER_SNAP_3_MSK               (0xFFFF)
#define ALTERA_AVALON_TIMER_SNAP_3_OFST              (0)

#endif /* __ALTERA_AVALON_TIMER_REGS_H__ */
