/*
 * 作者：阳贻凡
 */
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using XLua;

namespace Demo
{
    /// <summary>
    /// Lua解析器管理
    /// </summary>
    public class LuaMgr
    {
        #region 单例
        private static LuaMgr instance;
        public static LuaMgr Instance
        {
            get 
            { 
                if (instance == null)
                {
                    instance = new LuaMgr();
                }
                return instance; 
            } 
        }
        private LuaMgr() { }
        #endregion

        //本地lua脚本文件夹
        private string luaPath = Application.dataPath + "/Lua/";
        //所有lua文件路径
        private string[] filePaths = null; 
        //Lua解析器
        private LuaEnv luaEnv;

        //全局变量表
        public LuaTable Global
        {
            get
            {
                if (luaEnv == null)
                {
                    Debug.Log("没有初始化解析器，无法得到全局变量表");
                    return null;
                }
                return luaEnv.Global;
            }
        }

        /// <summary>
        /// 初始化解析器
        /// </summary>
        public void Init()
        {
            if (luaEnv != null)
            {
                return;
            }

            luaEnv = new LuaEnv();
            //设置自定义加载逻辑
            luaEnv.AddLoader(CustomLoader);
        }

        //加载对应文件夹下的lua脚本
        //private byte[] CustomLoader(ref string fileName)
        //{
        //    byte[] data = null;

        //    string path = luaPath + fileName + ".lua";

        //    if (File.Exists(path))
        //    {
        //        data = File.ReadAllBytes(path);
        //    }
        //    else
        //    {
        //        Debug.Log(path + "文件不存在");
        //    }

        //    return data;

        //}

        // 加载指定文件夹及其所有子文件夹下的lua脚本
        private byte[] CustomLoader(ref string fileName)
        {
            byte[] data = null;

            // 使用通配符搜索所有.lua文件，包括子文件夹
            if (filePaths == null)
                filePaths = Directory.GetFiles(luaPath, "*.lua", SearchOption.AllDirectories);

            foreach (string filePath in filePaths)
            {
                // 获取luaFileName
                string luaFileName = Path.GetFileNameWithoutExtension(filePath);
                //Debug.Log(luaFileName);
                if (luaFileName == fileName)
                {
                    data = File.ReadAllBytes(filePath);
                    break;
                }
            }

            //if (data == null)
            //{
            //    Debug.Log("[LuaMgr] 文件不存在: " + fileName + ".lua");
            //}

            return data;
        }

        /// <summary>
        /// 执行lua脚本
        /// </summary>
        /// <param name="fileName">不带后缀名</param>
        public void DOLuaFile(string fileName)
        {
            if (luaEnv == null)
            {
                Debug.Log("没有初始化解析器，脚本名为" + fileName);
                return;
            }

            luaEnv.DoString("require\'" + fileName + "\'");
        }

        /// <summary>
        /// 垃圾回收
        /// </summary>
        public void GC()
        {
            if (luaEnv == null)
            {
                Debug.Log("没有初始化解析器，无法垃圾回收");
                return;
            }
            luaEnv.Tick();
        }

        /// <summary>
        /// 销毁解析器
        /// </summary>
        public void Dispose()
        {
            if (luaEnv == null)
            {
                Debug.Log("没有初始化解析器，无法销毁");
                return;
            }
            luaEnv.Dispose();
        }
    }
}
