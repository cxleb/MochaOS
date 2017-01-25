using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace MochaFSTool
{
    class Program
    {
        static string installDirectory = @"C:\osdev\MochaOS\install";
        static byte[] MBR;

        static void writeDisk(MochaFSDisk disk, byte[] buffer, int block)
        {
            long write = (long) block * disk.bytesPerBlock;
            ((DiscUtils.Raw.Disk)disk.diskHandler).Content.Seek(write, SeekOrigin.Begin);
            ((DiscUtils.Raw.Disk)disk.diskHandler).Content.Write(buffer, 0, buffer.Length);
        }

        static void FormatDisk(MochaFSDisk disk)
        {
            // Create the MBR
            MBR = new byte[34];

            // Set to Zero
            for (int i = 0; i < 34; i++)
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
            MBR[16] = 0;
            MBR[17] = 0;

            // Volume Label
            MBR[18] = (byte) 'M';
            MBR[19] = (byte) 'o';
            MBR[20] = (byte) 'c';
            MBR[21] = (byte) 'h';
            MBR[22] = (byte) 'a';
            MBR[23] = (byte) 'O';
            MBR[24] = (byte) 'S';
            // 25
            // 26
            // 27
            // 28
            // 29
            // 30
            // 31
            // 32
            // 33
            Console.WriteLine("Made MBR");

        }

        static void InstallDisk(MochaFSDisk disk)
        {
            // Stage 1
            byte[] stage1Bytes = File.ReadAllBytes(installDirectory + @"\stage1.bin");

            Buffer.BlockCopy(MBR, 0, stage1Bytes, 3, 34);

            writeDisk(disk, stage1Bytes, 0);

            Console.WriteLine("Wrote MBR & Boot Sector");

            //Stage 2
            byte[] stage2Bytes = File.ReadAllBytes(installDirectory + @"\stage2.bin");

            writeDisk(disk, stage2Bytes, 1);

            Console.WriteLine("Wrote Stage2");

            // Other Files
        }

        static void Main(string[] args)
        {
            Console.WriteLine("MochaFS Disk Writing Tool\n");
            if (args.Length >= 1)
            {
                //installDirectory = args[0];
            }
            else
            {
                Console.WriteLine("No Directory Was Given, Using Current Directory");
            }

            ulong SizeOfHddMB = 16;
            ulong SizeOfHdd = SizeOfHddMB * 1024 * 1024;

            using (Stream file = File.Create(@"C:\osdev\MochaOS\disk.img"))
            {
                // Create Disc Handler
                DiscUtils.Raw.Disk discHandle = DiscUtils.Raw.Disk.Initialize(file, DiscUtils.Ownership.None, (long)SizeOfHdd);

                // Setup Virtual Disc
                MochaFSDisk disk = new MochaFSDisk();

                disk.bytesPerBlock = 512;
                disk.TotalBlocks = (long) SizeOfHdd / 512;

                disk.diskHandler = discHandle;

                //Format MBR
                FormatDisk(disk);

                // Install The OS to the disk
                InstallDisk(disk);

                discHandle.Dispose();

            }


        }
    }

    class MochaFSDisk
    {
        // disk info
        public short bytesPerBlock;

        public long TotalBlocks;

        //disk handler
        public object diskHandler;
    }
}
