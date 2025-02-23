using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class GenerateLuaAB : Editor
{   
    //lua源文件路径
    private static string source = Application.dataPath+"/Lua/";
    //lua.txt生成路径
    private static string path = Application.dataPath+"/LuaAB/";

    [MenuItem("XLua/GenerateLuaAB")]
    public static void CreateLuaAB(){
        
        if(Directory.Exists(source)){
            //源文件路径存在,得到所有文件名
            DirectoryInfo dir = new DirectoryInfo(source);
            FileSystemInfo[] systemInfos =  dir.GetFileSystemInfos();

            //判断生成路径是否存在,清空
            if(Directory.Exists(path)){
                Directory.Delete(path,true);
            }
            Directory.CreateDirectory(path);

            List<string> list = new List<string>();
            string file;
            foreach(FileSystemInfo info in systemInfos)
            {   
                if(info is FileInfo && info.Name.Substring(info.Name.Length - 4) == ".lua"){
                    file = path+info.Name+".txt";
                    File.Copy(info.FullName,file);
                    list.Add(file);
                }
            }
            //刷新
            AssetDatabase.Refresh();
        }

    }
}
