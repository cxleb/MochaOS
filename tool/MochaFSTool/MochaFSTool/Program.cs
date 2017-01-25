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
        public static string installDirectory = @"C:\osdev\MochaOS\install";
        public static ulong diskSize;
        public static int mediaType;

        static void InstallDisk(MochaFSDisk disk)
        {
            // Format Disk
            formater.FormatDisk(disk);

            // Stage 1
            byte[] stage1Bytes = File.ReadAllBytes(installDirectory + @"\stage1.bin");

            Buffer.BlockCopy(formater.MBR, 0, stage1Bytes, 3, 36);

            DiscTools.writeDisk(disk, stage1Bytes, 0, mediaType);

            Console.WriteLine("Wrote MBR");

            //Stage 2
            byte[] stage2Bytes = File.ReadAllBytes(installDirectory + @"\stage2.bin");

            DiscTools.writeDisk(disk, stage2Bytes, 1, mediaType);

            Console.WriteLine("Wrote Stage2");

            // Create the file list
            fileList.writeList();

            Console.WriteLine("Found " + fileList.list.Count + " Entries");

            // Make the File Table
            fileWriter.writeFileEntry(disk);

            Console.WriteLine("Wrote " + fileWriter.entryCounter + " Entries to FT");

            // Write Files to Disk
            byte[] _file;
            int fileCounter = 0;
            foreach (FileEntry file in fileList.list)
            {
                if (file.flags == 1)
                {
                    _file = File.ReadAllBytes(file.fullName);
                    long address = 17 + disk.sizeOfFileTable + file.address;
                    DiscTools.writeDisk(disk, _file, address, mediaType);
                    Console.WriteLine("Writing: " + new string(file.name) + "     Size: " + file.size + " Blocks");

                    fileCounter++;
                }


            }

            Console.WriteLine("Wrote " + fileCounter + " Files");
        }

        static void Main(string[] args)
        {
            Console.WriteLine("MochaFS Disk Writing Tool\n");
            if (args.Length >= 2)
            {
                //installDirectory = args[0];
                if(args[1] == "img")
                {
                    mediaType = 0;
                }
                else if ( args[1] == "vmdk" )
                {
                    mediaType = 1;
                }
                else
                {
                    mediaType = 0;
                }
                Console.WriteLine("Format: " + args[1]);

            }
            else
            {
                Console.WriteLine("Improper Line Arguments!");
                return;
            }

            
            ulong SizeOfHddMB = 16;
            ulong SizeOfHdd = SizeOfHddMB * 1024 * 1024;
            diskSize = SizeOfHdd;

            if (mediaType == 0)
            {

                using (Stream file = File.Create(@"C:\osdev\MochaOS\disk.img"))
                {
                    // Create Disc Handler
                    DiscUtils.Raw.Disk discHandle = DiscUtils.Raw.Disk.Initialize(file, DiscUtils.Ownership.None, (long)SizeOfHdd);

                    // Setup Virtual Disc
                    MochaFSDisk disk = new MochaFSDisk();

                    disk.bytesPerBlock = 512;
                    disk.TotalBlocks = (long)SizeOfHdd / 512;
                    disk.sizeOfFileTable = (uint)SizeOfHddMB * 16;

                    disk.diskHandler = discHandle;

                    // Tell how many blocks and the size of the FT
                    Console.WriteLine("Size of Disk: " + disk.TotalBlocks + " Blocks");
                    Console.WriteLine("Size of File Table: " + disk.sizeOfFileTable + " Blocks");

                    // Install The OS to the disk
                    InstallDisk(disk);

                    discHandle.Dispose();

                }

            }else if( mediaType == 1)
            {
                DiscUtils.Vmdk.Disk discHandle = DiscUtils.Vmdk.Disk.Initialize(@"C:\osdev\MochaOS\disk.vmdk", (long) SizeOfHdd, DiscUtils.Vmdk.DiskCreateType.MonolithicSparse);

                // Setup Virtual Disc
                MochaFSDisk disk = new MochaFSDisk();

                disk.bytesPerBlock = 512;
                disk.TotalBlocks = (long)SizeOfHdd / 512;
                disk.sizeOfFileTable = (uint)SizeOfHddMB * 16;

                disk.diskHandler = discHandle;

                // Install The OS to the disk
                InstallDisk(disk);

                discHandle.Dispose();

            }

            Console.WriteLine("Done!");

        }
    }
}
