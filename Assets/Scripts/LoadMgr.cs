/*
 * 作者：阳贻凡
 */
using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Events;

namespace Demo
{
    /// <summary>
    /// 资源加载类，同步模拟异步
    /// 是一个省略版本，只是为了模拟一下异步加载
    /// 没有做加载资源的缓存，
    /// 也没有处理多个异步加载同一个资源、异步途中取消加载和加载失败等情况的处理。
    /// </summary>
    [XLua.LuaCallCSharp]
    public class LoadMgr{
        #region 单例
        private static LoadMgr instance;

        public static LoadMgr Instance{
            get{
                if(instance == null)
                {
                    instance = new LoadMgr();
                }
                return instance;
            }
        }

        private LoadMgr(){ }
        #endregion
        //等待时间
        private WaitForSeconds wait = new WaitForSeconds(1f);

        /// <summary>
        /// 模拟异步加载资源
        /// </summary>
        public void LoadAsync(string assetPath,Type assetType,UnityAction<UnityEngine.Object> callBack){
            Main.Instance.StartCoroutine(C_Load(assetPath,assetType,callBack));
        }

        public IEnumerator C_Load(string assetPath,Type assetType,UnityAction<UnityEngine.Object> callBack){

            //同步加载
            UnityEngine.Object asset =  Resources.Load(assetPath,assetType);

            Debug.Log("模拟异步加载"+assetPath);

            //等待时间模拟异步加载
            yield return wait;

            Debug.Log(assetPath+"加载完成");
            
            //加载完成，执行回调
            callBack?.Invoke(asset);

        }
        
    }
}