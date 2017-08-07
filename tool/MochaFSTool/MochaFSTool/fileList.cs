using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace MochaFSTool
{
    class fileList
    {
        public static List<FileEntry> list;
        public static int dirCount = 0;
        public static int fileCount = 0;

        public static void writeList()
        {
            list = new List<FileEntry>();
            string[] files = Directory.GetFiles(config.dir+config.loadPath, "*.*", SearchOption.AllDirectories);
            string[] folders = Directory.GetDirectories(config.dir+config.loadPath, "*", SearchOption.AllDirectories);

            uint directoryCounter = 1;
            DirectoryInfo dinfo;
            string[] test = Program.installDirectory.Split('\\');
            string MajorDir = test[test.Length - 1];

            foreach (string folder in folders)
            {
                dinfo = new DirectoryInfo(folder);
                FileEntry entry = new FileEntry();

                entry.size = directoryCounter++;
                entry.flags = 2;

                bool found = false;
                if (dinfo.Parent.Name != MajorDir)
                {
                    foreach (FileEntry en in list)
                    {
                        if (en.flags == 2)
                        {
                            if (compareStringPaddedCharA(dinfo.Parent.Name, en.name))
                            {
                                entry.dir = en.size;
                                found = true;
                            }
                        }
                    }
                    if (!found)
                    {
                        entry.dir = 0;
                        Console.WriteLine("Could not find directory");
                    }
                }
                else
                {
                    entry.dir = 0;
                }
                entry.name = to15bytearray(dinfo.Name);

                list.Add(entry);
                dirCount++;
            }

            FileInfo info;
            foreach (string file in files)
            {
                info = new FileInfo(file);
                if (info.Name != config.bootsector && info.Name != config.reservedFile)
                {
                    FileEntry entry = new FileEntry();

                    entry.name = to15bytearray(info.Name);

                    if (info.Length < (long)4 * 1024 * 1024 * 1024)
                    {
                        entry.size = (uint)Math.Ceiling((decimal)info.Length / 512); // return size in blocks
                    }
                    else if ((ulong)info.Length > Program.diskSize)
                    {
                        Console.WriteLine("File To Big! " + entry.name);
                    }
                    else
                    {
                        Console.WriteLine("File To Big! " + entry.name);
                    }

                    entry.fullName = info.FullName;
                    entry.flags = 1;

                    string parent = info.Directory.Name;
                    bool found = false;
                    if (parent != MajorDir)
                    {
                        foreach (FileEntry lfile in list)
                        {
                            if (lfile.flags == 2)
                            {
                                string testParent = new string(lfile.name);
                                if (compareStringPaddedCharA(parent, lfile.name))
                                {
                                    entry.dir = lfile.size;
                                    found = true;
                                }
                            }
                        }
                        if (!found)
                        {
                            Console.WriteLine("Could Not Find Directory For File!");
                            entry.dir = 0;
                        }
                    }

                    list.Add(entry);
                    fileCount++;
                }
                

            }
        }

        public static char[] to15bytearray(string name)
        {
            char[] array = name.ToArray<char>();
            int length = array.Length;
            char[] newarray = new char[15];

            for(int i = 0; i < 15; i++)
            {
                if(i >= length)
                {
                    newarray[i] = (char)0;
                }
                else
                {
                    newarray[i] = array[i];
                }
            }
            

            return newarray;
        }

        public static bool compareStringPaddedCharA(string str, char[] array)
        {
            char[] compare = str.ToArray<char>();
            int length1 = array.Length;
            int length2 = compare.Length;

            for (int i = 0; i < length1; i++)
            {
                if(i > length2)
                {
                    return false;
                }

                if(array[i] == 0)
                {
                    return true;
                }

                if(array[i] != compare[i])
                {
                    return false;
                }
            }
            return true;
        }
    }
}
