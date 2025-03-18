/*
 * 作者：阳贻凡
 */
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Demo
{
    /// <summary>
    /// 程序主入口，同时也是一个单例，可以负责所有Lua和C#的交互
    /// </summary>
    [XLua.LuaCallCSharp]
    public class Main : MonoBehaviour
    {
        #region 单例
        private static Main instance;

        public static Main Instance{
            get{
                return instance;
            }
        }
        #endregion



        private void Awake()
        {   
            if(instance != null){
                //不允许重复创建
                Destroy(this);
                return;
            }

            instance = this;
            DontDestroyOnLoad(this);

            LuaMgr.Instance.Init();
        }

        private void Start()
        {
            LuaMgr.Instance.DOLuaFile("Main");
        }
    }

}

