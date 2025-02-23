/*
 * 作者：阳贻凡
 */
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Demo
{
    /// <summary>
    /// 程序主入口
    /// </summary>
    public class Main : MonoBehaviour
    {

        private void Awake()
        {
            LuaMgr.Instance.Init();
        }

        private void Start()
        {
            LuaMgr.Instance.DOLuaFile("Main");
        }
    }
}

