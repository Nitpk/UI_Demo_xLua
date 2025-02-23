/*
 * 作者：阳贻凡
 */
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UIFramework
{
    /// <summary>
    /// 对象池管理器
    /// </summary>
	public class PoolMgr
	{
        #region 单例
        private static PoolMgr instance;
        public static PoolMgr Instance
        {
            get
            {
                if(instance == null)
                {
                    instance = new PoolMgr();
                }
                return instance;
            }
        }
        private PoolMgr() { }
        #endregion
        //缓存池字典
        private Dictionary<string, BasePoolDataClass> poolClassDic = new Dictionary<string, BasePoolDataClass>();


        /// <summary>
        /// 得到对象
        /// </summary>
        /// <typeparam name="T">数据或逻辑类的类型</typeparam>
        /// <param name="nameSpace">类型的命名空间</param>
        /// <param name="typeName">对于泛型类，需要用这个来进行区分字典的键</param>
        /// <returns></returns>
        public T GetPoolData<T>(string nameSpace = "", string typeName = "") where T : class, IPoolData, new()
        {
            string key = nameSpace + "_" + typeof(T).Name + "_" + typeName;

            T result;

            //如果字典中不存在  直接创建对应的空池 并加入字典
            if (!poolClassDic.ContainsKey(key))
                poolClassDic.Add(key, new PoolDataClass<T>());

            //获得对应的池
            PoolDataClass<T> poolDataClass = poolClassDic[key] as PoolDataClass<T>;

            if (poolDataClass.leisureList.Count > 0)
            {//如果有空闲对象，直接取出
                result = poolDataClass.leisureList.Pop();
            }
            else
            {//如果没有空闲对象
                //实例化一个新对象
                result = new T();
            }

            return result;
        }

        /// <summary>
        /// 放入对象
        /// </summary>
        /// <typeparam name="T">类型</typeparam>
        /// <param name="data">对象</param>
        /// <param name="typeName">对于泛型类，需要用这个来进行区分字典的键</param>
        public void PushPoolData<T>(T data, string nameSpace = "", string typeName = "") where T : class, IPoolData
        {
            string key = nameSpace + "_" + typeof(T).Name + "_" + typeName;

            if (poolClassDic.ContainsKey(key))
            {//如果字典中存在

                //重置对象数据
                data.ResetData();

                //存入
                (poolClassDic[key] as PoolDataClass<T>).leisureList.Push(data);
            }
        }

        /// <summary>
        /// 清空所有缓存池
        /// </summary>
        public void Clear()
        {
            poolClassDic.Clear();
        }
    }
    /// <summary>
    /// 逻辑数据类的池基类
    /// </summary>
    public abstract class BasePoolDataClass { }

    /// <summary>
    /// 逻辑数据类的池
    /// </summary>
    public class PoolDataClass<T> : BasePoolDataClass where T : class, IPoolData
    {
        /// <summary>
        /// 空闲对象的栈
        /// </summary>
        public Stack<T> leisureList = new Stack<T>();
    }
    /// <summary>
    /// 非继承Mono的对象接口
    /// </summary>
    public interface IPoolData
    {
        void ResetData();
    }
}