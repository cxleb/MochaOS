using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MochaFSTool
{
    class formater
    {
        public static byte[] MBR;

        public static void FormatDisk(MochaFSDisk disk)
        {
            // Create the MBR
            MBR = new byte[36];

            // Set to Zero
            for (int i = 0; i < 36; i++)
                MBR[i] = 0x00;

            // Magic
            MBR[0] = 0x4D;
            MBR[1] = 0x46;
            MBR[2] = 0x53;
            MBR[3] = 0x31;

            // Flags
            MBR[4] = 0x01;

            // Version
            MBR[5] = 0x01;

            // Bytes Per Block
            MBR[6] = (byte)(disk.bytesPerBlock & 0xff);
            MBR[7] = (byte)((disk.bytesPerBlock >> 8) & 0xff);

            // Total Blocks
            MBR[8] = (byte)(disk.TotalBlocks & 0xff);
            MBR[9] = (byte)((disk.TotalBlocks >> 8) & 0xff);
            MBR[10] = (byte)((disk.TotalBlocks >> 16) & 0xff);
            MBR[11] = (byte)((disk.TotalBlocks >> 24) & 0xff);
            MBR[12] = (byte)((disk.TotalBlocks >> 32) & 0xff);
            MBR[13] = (byte)((disk.TotalBlocks >> 40) & 0xff);
            MBR[14] = (byte)((disk.TotalBlocks >> 48) & 0xff);
            MBR[15] = (byte)((disk.TotalBlocks >> 56) & 0xff);

            //Table Size
            MBR[16] = (byte)(disk.sizeOfFileTable & 0xff); ;
            MBR[17] = (byte)((disk.sizeOfFileTable >> 8) & 0xff);
            MBR[18] = (byte)((disk.sizeOfFileTable >> 16) & 0xff);
            MBR[19] = (byte)((disk.sizeOfFileTable >> 24) & 0xff);
            
            // Volume Label
            MBR[20] = (byte)'M';
            MBR[21] = (byte)'o';
            MBR[22] = (byte)'c';
            MBR[23] = (byte)'h';
            MBR[24] = (byte)'a';
            MBR[25] = (byte)'O';
            MBR[26] = (byte)'S';
            // 27
            // 28
            // 29
            // 30
            // 31
            // 32
            // 33
            // 34
            // 35
        }

    }
}
