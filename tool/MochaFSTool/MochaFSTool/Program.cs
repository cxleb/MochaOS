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
            byte[] stage1Bytes = File.ReadAllBytes(config.dir + config.bootsector);

            Buffer.BlockCopy(formater.MBR, 0, stage1Bytes, 3, 36);

            DiscTools.writeDisk(disk, stage1Bytes, 0, mediaType);

            Console.WriteLine("Wrote MBR");

            //Stage 2
            byte[] stage2Bytes = File.ReadAllBytes(config.dir + config.reservedFile);

            DiscTools.writeDisk(disk, stage2Bytes, 1, mediaType);

            Console.WriteLine("Wrote Reserved File");

            // Create the file list
            fileList.writeList();

            Console.WriteLine("Found " + fileList.fileCount + " File Entries and " + fileList.dirCount + " Directory Entries");

            // Make the File Table
            fileWriter.writeFileEntry(disk);

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

            Console.WriteLine("Wrote " + fileCounter + " File(s)");
        }

        static void Main(string[] args)
        {
            Console.WriteLine("MochaFS Disk Writing Tool\n");
            if (args.Length >= 1)
            {
                config.loadConfig( args[0]);
                Console.WriteLine("Output Media: " + config.media);
                if(config.media == "img")
                {
                    mediaType = 0;
                }
                else if ( config.media == "vmdk" )
                {
                    mediaType = 1;
                }
                else
                {
                    mediaType = 0;
                }
            }
            else
            {
                Console.WriteLine("Improper Line Arguments!");
                return;
            }

            
            ulong SizeOfHddMB = (ulong)config.sizeHdd;
            ulong SizeOfHdd = SizeOfHddMB * 1024 * 1024;
            diskSize = SizeOfHdd;

            if (mediaType == 0)
            {

                using (Stream file = File.Create(config.dir + config.result))
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
                DiscUtils.Vmdk.Disk discHandle = DiscUtils.Vmdk.Disk.Initialize(config.dir+config.result, (long) SizeOfHdd, DiscUtils.Vmdk.DiskCreateType.MonolithicSparse);

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
