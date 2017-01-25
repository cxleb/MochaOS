using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MochaFSTool
{
    class MochaFSDisk
    {
        // disk info
        public short bytesPerBlock;

        public long TotalBlocks;

        public uint sizeOfFileTable;

        //disk handler
        public object diskHandler;
    }

    class FileEntry
    {
        public string fullName;

        public byte flags;
        public long address;
        public uint size;
        public char[] name = new char[15];
        public uint dir;
    }
}
