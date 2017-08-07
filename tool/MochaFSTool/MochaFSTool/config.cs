using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
namespace MochaFSTool
{
    class config
    {
        public static int sizeHdd = 16;
        public static string bootsector = "boot";
        public static string reservedFile = "resvered";
        public static string loadPath = "loadpath";
        public static string media = "img";
        public static string result = "result";
        public static string dir = "";

        public static void loadConfig(string path)
        {
            dir = Path.GetDirectoryName(Path.GetFullPath(path)) + @"\";
            StreamReader file = new StreamReader(path);
            while (!file.EndOfStream)
            {
                string line = file.ReadLine();
                string[] split = line.Split('=');
                if(split[0] == "sizehdd")
                {
                    sizeHdd = Convert.ToInt32(split[1]);
                }
                else if (split[0] == "bootsector")
                {
                    bootsector = split[1];
                }
                else if (split[0] == "reservedfile")
                {
                    reservedFile = split[1];
                }
                else if (split[0] == "loadpath")
                {
                    loadPath = split[1];
                }
                else if (split[0] == "media")
                {
                    media = split[1];
                }
                else if (split[0] == "result")
                {
                    result = split[1];
                }
            }
        }
    }
}
