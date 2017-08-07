using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace MochaFSTool
{
    class fileWriter
    {
        public static long fileAddressOffset = 0;
        public static int fileEntryOffset = 0;

        public static void writeFileEntry(MochaFSDisk disk)
        {
            // set the ft up
            byte[] entries = new byte[disk.sizeOfFileTable * 512];

            foreach(FileEntry file in fileList.list)
            {
                // Write Name first
                entries[fileEntryOffset + 0] = (byte)file.name[0];
                entries[fileEntryOffset + 1] = (byte)file.name[1];
                entries[fileEntryOffset + 2] = (byte)file.name[2];
                entries[fileEntryOffset + 3] = (byte)file.name[3];
                entries[fileEntryOffset + 4] = (byte)file.name[4];
                entries[fileEntryOffset + 5] = (byte)file.name[5];
                entries[fileEntryOffset + 6] = (byte)file.name[6];
                entries[fileEntryOffset + 7] = (byte)file.name[7];
                entries[fileEntryOffset + 8] = (byte)file.name[8];
                entries[fileEntryOffset + 9] = (byte)file.name[9];
                entries[fileEntryOffset + 10] = (byte)file.name[10];
                entries[fileEntryOffset + 11] = (byte)file.name[11];
                entries[fileEntryOffset + 12] = (byte)file.name[12];
                entries[fileEntryOffset + 13] = (byte)file.name[13];
                entries[fileEntryOffset + 14] = (byte)file.name[14];

                // Then flags
                entries[fileEntryOffset + 15] = (byte)file.flags;

                // set the files address with the counter
                file.address = fileAddressOffset;
                
                // Address
                entries[fileEntryOffset + 16] = (byte)((file.address) & 0xff);
                entries[fileEntryOffset + 17] = (byte)((file.address >> 8) & 0xff);
                entries[fileEntryOffset + 18] = (byte)((file.address >> 16) & 0xff);
                entries[fileEntryOffset + 19] = (byte)((file.address >> 24) & 0xff);
                entries[fileEntryOffset + 20] = (byte)((file.address >> 32) & 0xff);
                entries[fileEntryOffset + 21] = (byte)((file.address >> 40) & 0xff);
                entries[fileEntryOffset + 22] = (byte)((file.address >> 48) & 0xff);
                entries[fileEntryOffset + 23] = (byte)((file.address >> 56) & 0xff);

                // Add the size to the counter
                if (file.flags == 1)
                {
                    fileAddressOffset += file.size;
                }

                // Size
                entries[fileEntryOffset + 24] = (byte)((file.size) & 0xff);
                entries[fileEntryOffset + 25] = (byte)((file.size >> 8) & 0xff);
                entries[fileEntryOffset + 26] = (byte)((file.size >> 16) & 0xff);
                entries[fileEntryOffset + 27] = (byte)((file.size >> 24) & 0xff);

                // Dir
                entries[fileEntryOffset + 28] = (byte)((file.dir) & 0xff);
                entries[fileEntryOffset + 29] = (byte)((file.dir >> 8) & 0xff);
                entries[fileEntryOffset + 30] = (byte)((file.dir >> 16) & 0xff);
                entries[fileEntryOffset + 31] = (byte)((file.dir >> 24) & 0xff);

                // add 32 to the offset to get to the next entry
                fileEntryOffset += 32;

            }

            DiscTools.writeDisk(disk, entries, 17, Program.mediaType);
        }
    }
}
