using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MochaFSTool
{
    class DiscTools
    {
        public static void writeDisk(MochaFSDisk disk, byte[] buffer, long block, int mediaType)
        {
            long write = block * disk.bytesPerBlock;
            if (mediaType == 0)
            {
                ((DiscUtils.Raw.Disk)disk.diskHandler).Content.Seek(write, SeekOrigin.Begin);
                ((DiscUtils.Raw.Disk)disk.diskHandler).Content.Write(buffer, 0, buffer.Length);
            }
            else if (mediaType == 1)
            {
                ((DiscUtils.Vmdk.Disk)disk.diskHandler).Content.Seek(write, SeekOrigin.Begin);
                ((DiscUtils.Vmdk.Disk)disk.diskHandler).Content.Write(buffer, 0, buffer.Length);
            }
        }

        public static void writeDisk(MochaFSDisk disk, byte[] buffer, long block, int byteOffset, int mediaType)
        {
            long write = (block * disk.bytesPerBlock ) + byteOffset;
            if (mediaType == 0)
            {
                ((DiscUtils.Raw.Disk)disk.diskHandler).Content.Seek(write, SeekOrigin.Begin);
                ((DiscUtils.Raw.Disk)disk.diskHandler).Content.Write(buffer, 0, buffer.Length);
            }
            else if (mediaType == 1)
            {
                ((DiscUtils.Vmdk.Disk)disk.diskHandler).Content.Seek(write, SeekOrigin.Begin);
                ((DiscUtils.Vmdk.Disk)disk.diskHandler).Content.Write(buffer, 0, buffer.Length);
            }
        }
    }
}
